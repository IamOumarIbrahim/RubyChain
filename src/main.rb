# src/main.rb
# ==============================================================================
# RubyChain - Main Application Server (WEBrick + SQLite3)
# ==============================================================================
# Single-command startup for CodeNova 2026:
#   ruby src/main.rb
#
# Low-abstraction, crystal-clear architecture designed so any developer can
# understand and recreate the system from scratch within a 3-hour hackathon.
# ==============================================================================

require 'webrick'
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

PORT = (ENV['PORT'] || 4567).to_i
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

# Factory method to build WEBrick server and mount routes
def create_server(port = PORT, log_device = $stdout)
  # Ensure database is set up and pre-seeded
  RubyChainDB.setup!

  server = WEBrick::HTTPServer.new(
    Port: port,
    BindAddress: '0.0.0.0', # Allows iPhone & LAN access
    Logger: WEBrick::Log.new(log_device, WEBrick::Log::INFO),
    AccessLog: [] # Minimal terminal clutter
  )

  # ----------------------------------------------------------------------------
  # API Endpoints
  # ----------------------------------------------------------------------------

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
    # Chain is BROKEN if item is recalled, or if expected upstream credentials are missing
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

  # ----------------------------------------------------------------------------
  # Static Files & Asset Handlers
  # ----------------------------------------------------------------------------
  server.mount '/', WEBrick::HTTPServlet::FileHandler, PUBLIC_DIR
  server.mount '/assets', WEBrick::HTTPServlet::FileHandler, ASSETS_DIR

  server
end

if __FILE__ == $0
  server = create_server(PORT)
  lan_ip = local_ip

  trap('INT')  { server.shutdown }
  trap('TERM') { server.shutdown }

  puts "===================================================================="
  puts "  💎 RubyChain Web Server Active (CodeNova 2026)"
  puts "===================================================================="
  puts "  -> Local Desktop:   http://localhost:#{PORT}"
  puts "  -> iPhone / Safari: http://#{lan_ip}:#{PORT}"
  puts "  -> Print Sheet:     http://#{lan_ip}:#{PORT}/assets/demo_barcodes/print_sheet.html"
  puts "===================================================================="
  puts "  Press Ctrl+C to stop the server."
  puts "===================================================================="
  server.start
end
