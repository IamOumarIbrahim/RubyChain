# src/main.rb
# ==============================================================================
# RubyChain - Main Application Server (WEBrick + SQLite3 + Dual HTTP/HTTPS)
# ==============================================================================
# Single-command startup for CodeNova 2026:
#   ruby src/main.rb
#
# Provides both:
# 1. HTTP Server (Port 4567) - Standard web access
# 2. HTTPS Server (Port 8443) - Secure context with self-signed SSL certificate,
#    which unlocks the live camera feed in iPhone Safari!
# ==============================================================================

require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'
require 'socket'
require_relative 'db'
require_relative 'certifier'
require_relative 'exporter'
require_relative 'carrier'
require_relative 'customs'
require_relative 'retailer'
require_relative 'recall'

# Helper to find local LAN IP for easy iPhone testing
def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
  UDPSocket.open do |s|
    s.connect '8.8.8.8', 1
    s.addr.last
  end
rescue
  '127.0.0.1'
ensure
  Socket.do_not_reverse_lookup = orig
end

HTTP_PORT = (ENV['PORT'] || 4567).to_i
HTTPS_PORT = (ENV['HTTPS_PORT'] || 8443).to_i
PUBLIC_DIR = File.expand_path('../../public', __FILE__)
ASSETS_DIR = File.expand_path('../../assets', __FILE__)

# Helper: Parse JSON Body from WEBrick Request
def parse_json(req)
  JSON.parse(req.body || '{}')
rescue
  {}
end

# Helper: Clean string and ensure UTF-8 encoding for SQLite
def clean_str(val)
  (val || '').to_s.force_encoding('UTF-8').strip
end

# Helper: Respond with JSON
def respond_json(res, hash, status = 200)
  res.status = status
  res['Content-Type'] = 'application/json'
  res['Access-Control-Allow-Origin'] = '*'
  res['Access-Control-Allow-Headers'] = 'Content-Type'
  res.body = JSON.generate(hash)
end

# Generates an in-memory self-signed certificate for local HTTPS / iPhone WebRTC
def generate_self_signed_cert
  pkey = OpenSSL::PKey::RSA.new(2048)
  cert = OpenSSL::X509::Certificate.new
  cert.version = 2
  cert.serial = 1
  cert.subject = OpenSSL::X509::Name.parse('/CN=RubyChain/O=CodeNova')
  cert.issuer = cert.subject
  cert.public_key = pkey.public_key
  cert.not_before = Time.now - 3600
  cert.not_after = Time.now + (365 * 24 * 3600)
  cert.sign(pkey, OpenSSL::Digest::SHA256.new)
  [cert, pkey]
end

# Mounts all API and static file routes on a WEBrick server instance
def mount_routes(server)
  # 1. User Authentication (Login)
  server.mount_proc '/api/auth/login' do |req, res|
    if req.request_method == 'POST'
      data = parse_json(req)
      username = clean_str(data['username'])
      password = clean_str(data['password'])
      role = clean_str(data['role'])

      db = RubyChainDB.connection
      user = db.execute('SELECT * FROM users WHERE username = ?', [username]).first

      if user && user['password_hash'] == RubyChainDB.hash_password(password)
        respond_json(res, { success: true, user: { user_id: user['user_id'], username: user['username'], role: user['role'] } })
      else
        respond_json(res, { success: false, error: 'Invalid username or password' }, 401)
      end
    else
      res.status = 405
    end
  end

  # 2. User Registration (Signup)
  server.mount_proc '/api/auth/signup' do |req, res|
    if req.request_method == 'POST'
      data = parse_json(req)
      username = clean_str(data['username'])
      password = clean_str(data['password'])
      role = clean_str(data['role'] || 'retailer')

      if username.empty? || password.empty?
        respond_json(res, { success: false, error: 'Username and password required' }, 400)
        next
      end

      db = RubyChainDB.connection
      existing = db.execute('SELECT user_id FROM users WHERE username = ?', [username]).first
      if existing
        respond_json(res, { success: false, error: 'Username already exists' }, 409)
        next
      end

      pwd_hash = RubyChainDB.hash_password(password)
      db.execute('INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)', [username, pwd_hash, role])
      new_id = db.last_insert_row_id
      respond_json(res, { success: true, user: { user_id: new_id, username: username, role: role } })
    else
      res.status = 405
    end
  end

  # 3. Item & Chain Status Lookup
  server.mount_proc '/api/item' do |req, res|
    barcode = clean_str(req.query['barcode'])
    barcode = '5901234123457' if barcode.empty?
    db = RubyChainDB.connection

    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    unless item
      respond_json(res, { success: false, error: 'Item not found' }, 404)
      next
    end

    # Fetch all credentials for this item
    creds = db.execute('SELECT * FROM credentials WHERE item_id = ? ORDER BY id ASC', [item['id']])
    cred_map = {}
    creds.each { |c| cred_map[c['milestone']] = c }

    # Fetch recall records
    recalls = db.execute('SELECT * FROM recalls WHERE item_id = ? ORDER BY id DESC', [item['id']])

    # Determine overall chain status
    is_broken = (item['recalled'] == 1) || recalls.any?
    chain_status = is_broken ? 'Broken' : 'Intact'

    respond_json(res, {
      success: true,
      item: item,
      chain_status: chain_status,
      credentials: {
        origin: {
          verified: !cred_map['origin_proof'].nil? && !is_broken,
          record: cred_map['origin_proof']
        },
        transit: {
          verified: !cred_map['transit_proof'].nil? && !is_broken,
          record: cred_map['transit_proof']
        },
        border: {
          verified: !cred_map['border_proof'].nil? && !is_broken,
          record: cred_map['border_proof']
        },
        shelf: {
          verified: !cred_map['shelf_proof'].nil? && !is_broken,
          record: cred_map['shelf_proof']
        }
      },
      recalls: recalls
    })
  end

  # 4. Action: Verify & Issue Credential
  server.mount_proc '/api/action/verify_issue' do |req, res|
    if req.request_method == 'POST'
      data = parse_json(req)
      barcode = clean_str(data['barcode'])
      barcode = '5901234123457' if barcode.empty?
      user_id = data['user_id'].to_i
      role = clean_str(data['role']).downcase

      result = case role
               when 'certifier'
                 CertifierNode.issue_origin_proof(barcode, user_id)
               when 'exporter'
                 ExporterNode.verify_and_issue(barcode, user_id)
               when 'carrier'
                 CarrierNode.verify_and_issue(barcode, user_id)
               when 'customs'
                 CustomsNode.verify_and_issue(barcode, user_id)
               when 'retailer'
                 RetailerNode.verify_and_issue(barcode, user_id)
               else
                 { success: false, error: "Unknown role: #{role}" }
               end

      respond_json(res, result, result[:success] ? 200 : 400)
    else
      res.status = 405
    end
  end

  # 5. Action: Trigger Instant Recall (Circuit Breaker)
  server.mount_proc '/api/action/recall' do |req, res|
    if req.request_method == 'POST'
      data = parse_json(req)
      barcode = clean_str(data['barcode'])
      barcode = '5901234123457' if barcode.empty?
      user_id = data['user_id'].to_i
      reason = clean_str(data['reason'])
      reason = 'Critical contamination / regulatory recall' if reason.empty?

      result = RecallProcedure.trigger_recall(barcode, user_id, reason)
      respond_json(res, result, result[:success] ? 200 : 400)
    else
      res.status = 405
    end
  end

  # 6. Reset Demo Batch
  server.mount_proc '/api/reset_demo' do |req, res|
    if req.request_method == 'POST'
      data = parse_json(req)
      barcode = clean_str(data['barcode'])
      barcode = '5901234123457' if barcode.empty?
      RubyChainDB.reset_demo_item!(barcode)
      respond_json(res, { success: true, message: 'Demo batch reset to initial clean state' })
    else
      res.status = 405
    end
  end

  # 7. Static Files & Asset Handlers
  server.mount '/', WEBrick::HTTPServlet::FileHandler, PUBLIC_DIR
  server.mount '/assets', WEBrick::HTTPServlet::FileHandler, ASSETS_DIR
end

# Factory method for HTTP Server
def create_server(port = HTTP_PORT, log_device = $stdout)
  RubyChainDB.setup!
  server = WEBrick::HTTPServer.new(
    Port: port,
    BindAddress: '0.0.0.0',
    Logger: WEBrick::Log.new(log_device, WEBrick::Log::INFO),
    AccessLog: []
  )
  mount_routes(server)
  server
end

# Factory method for HTTPS Server (Enables iPhone Safari Camera)
def create_https_server(port = HTTPS_PORT, log_device = $stdout)
  RubyChainDB.setup!
  cert, pkey = generate_self_signed_cert

  server = WEBrick::HTTPServer.new(
    Port: port,
    BindAddress: '0.0.0.0',
    SSLEnable: true,
    SSLCertificate: cert,
    SSLPrivateKey: pkey,
    Logger: WEBrick::Log.new(log_device, WEBrick::Log::INFO),
    AccessLog: []
  )
  mount_routes(server)
  server
end

# Standalone Dual-Server Execution
if __FILE__ == $0
  lan_ip = local_ip
  http_server = create_server(HTTP_PORT)
  https_server = create_https_server(HTTPS_PORT)

  trap('INT')  { http_server.shutdown; https_server.shutdown }
  trap('TERM') { http_server.shutdown; https_server.shutdown }

  puts "===================================================================="
  puts "  💎 RubyChain v1.1 Web Server Active (CodeNova 2026)"
  puts "===================================================================="
  puts "  -> Desktop / Local:     http://localhost:#{HTTP_PORT}"
  puts "  -> iPhone Safari HTTP:  http://#{lan_ip}:#{HTTP_PORT}"
  puts "  -> iPhone Camera HTTPS: https://#{lan_ip}:#{HTTPS_PORT}"
  puts "     *(NOTE: HTTPS is required by iOS Safari for live camera video!)*"
  puts "  -> Printable Package:   http://#{lan_ip}:#{HTTP_PORT}/assets/demo_barcodes/print_sheet.html"
  puts "===================================================================="
  puts "  Both HTTP (#{HTTP_PORT}) and HTTPS (#{HTTPS_PORT}) are now running."
  puts "  Press Ctrl+C to stop the servers."
  puts "===================================================================="

  t_http = Thread.new { http_server.start }
  t_https = Thread.new { https_server.start }

  t_http.join
  t_https.join
end
