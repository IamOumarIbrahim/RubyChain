# src/main.rb - Main HTTP & HTTPS Server (Streamlined for 3-Hour Build)
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

def local_ip
  Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }&.ip_address || '127.0.0.1'
end

HTTP_PORT  = (ENV['PORT'] || 4567).to_i
HTTPS_PORT = (ENV['HTTPS_PORT'] || 8443).to_i
PUBLIC_DIR = File.expand_path('../../public', __FILE__)
ASSETS_DIR = File.expand_path('../../assets', __FILE__)

def parse_json(req)
  JSON.parse(req.body || '{}')
rescue
  {}
end

def clean_str(val)
  (val || '').to_s.force_encoding('UTF-8').strip
end

def json_res(res, hash, status = 200)
  res.status = status
  res['Content-Type'] = 'application/json'
  res.body = JSON.generate(hash)
end

def generate_cert
  key = OpenSSL::PKey::RSA.new(2048)
  cert = OpenSSL::X509::Certificate.new
  cert.version = 2
  cert.serial = 1
  cert.subject = cert.issuer = OpenSSL::X509::Name.parse('/CN=RubyChain')
  cert.public_key = key.public_key
  cert.not_before = Time.now - 3600
  cert.not_after  = Time.now + (365 * 86400)
  cert.sign(key, OpenSSL::Digest::SHA256.new)
  [cert, key]
end

def mount_routes(server)
  # 1. Login
  server.mount_proc '/api/auth/login' do |req, res|
    d = parse_json(req)
    u = RubyChainDB.connection.execute('SELECT * FROM users WHERE username = ?', [clean_str(d['username'])]).first
    if u && u['password_hash'] == RubyChainDB.hash_password(clean_str(d['password']))
      json_res(res, { success: true, user: { user_id: u['user_id'], username: u['username'], role: u['role'] } })
    else
      json_res(res, { success: false, error: 'Invalid credentials' }, 401)
    end
  end

  # 2. Signup
  server.mount_proc '/api/auth/signup' do |req, res|
    d = parse_json(req)
    u, p, r = clean_str(d['username']), clean_str(d['password']), clean_str(d['role'] || 'retailer')
    db = RubyChainDB.connection
    if u.empty? || p.empty? || db.execute('SELECT 1 FROM users WHERE username = ?', [u]).any?
      json_res(res, { success: false, error: 'Username taken or empty' }, 400)
    else
      db.execute('INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)', [u, RubyChainDB.hash_password(p), r])
      json_res(res, { success: true, user: { user_id: db.last_insert_row_id, username: u, role: r } })
    end
  end

  # 3. Item Status Lookup
  server.mount_proc '/api/item' do |req, res|
    code = clean_str(req.query['barcode'])
    code = '5901234123457' if code.empty?
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [code]).first
    if item
      creds = db.execute('SELECT * FROM credentials WHERE item_id = ?', [item['id']]).to_h { |c| [c['milestone'], c] }
      broken = (item['recalled'] == 1)
      json_res(res, {
        success: true, item: item,
        chain_status: broken ? 'Broken' : 'Intact',
        credentials: {
          origin: { verified: !creds['origin_proof'].nil? && !broken },
          transit: { verified: !creds['transit_proof'].nil? && !broken },
          border: { verified: !creds['border_proof'].nil? && !broken },
          shelf: { verified: !creds['shelf_proof'].nil? && !broken }
        }
      })
    else
      json_res(res, { success: false, error: 'Item not found' }, 404)
    end
  end

  # 4. Verify & Issue
  server.mount_proc '/api/action/verify_issue' do |req, res|
    d = parse_json(req)
    code, uid, role = clean_str(d['barcode']), d['user_id'].to_i, clean_str(d['role']).downcase
    code = '5901234123457' if code.empty?
    result = case role
             when 'certifier' then CertifierNode.issue_origin_proof(code, uid)
             when 'exporter'  then ExporterNode.verify_and_issue(code, uid)
             when 'carrier'   then CarrierNode.verify_and_issue(code, uid)
             when 'customs'   then CustomsNode.verify_and_issue(code, uid)
             when 'retailer'  then RetailerNode.verify_and_issue(code, uid)
             else { success: false, error: "Unknown role: #{role}" }
             end
    json_res(res, result, result[:success] ? 200 : 400)
  end

  # 5. Recall
  server.mount_proc '/api/action/recall' do |req, res|
    d = parse_json(req)
    code = clean_str(d['barcode'])
    code = '5901234123457' if code.empty?
    result = RecallProcedure.trigger_recall(code, d['user_id'].to_i, clean_str(d['reason']))
    json_res(res, result, result[:success] ? 200 : 400)
  end

  # 6. Reset
  server.mount_proc '/api/reset_demo' do |req, res|
    d = parse_json(req)
    code = clean_str(d['barcode'])
    code = '5901234123457' if code.empty?
    RubyChainDB.reset_demo_item!(code)
    json_res(res, { success: true, message: 'Reset complete' })
  end

  # Static Files
  server.mount '/', WEBrick::HTTPServlet::FileHandler, PUBLIC_DIR
  server.mount '/assets', WEBrick::HTTPServlet::FileHandler, ASSETS_DIR
end

def create_server(port = HTTP_PORT, log = $stdout)
  RubyChainDB.setup!
  s = WEBrick::HTTPServer.new(Port: port, BindAddress: '0.0.0.0', Logger: WEBrick::Log.new(log, WEBrick::Log::INFO), AccessLog: [])
  mount_routes(s)
  s
end

def create_https_server(port = HTTPS_PORT, log = $stdout)
  RubyChainDB.setup!
  cert, key = generate_cert
  s = WEBrick::HTTPServer.new(Port: port, BindAddress: '0.0.0.0', SSLEnable: true, SSLCertificate: cert, SSLPrivateKey: key, Logger: WEBrick::Log.new(log, WEBrick::Log::INFO), AccessLog: [])
  mount_routes(s)
  s
end

if __FILE__ == $0
  ip = local_ip
  http_s = create_server(HTTP_PORT)
  https_s = create_https_server(HTTPS_PORT)

  trap('INT')  { http_s.shutdown; https_s.shutdown }
  trap('TERM') { http_s.shutdown; https_s.shutdown }

  puts "💎 RubyChain v2.0 (Streamlined for 3-Hour Build)"
  puts "-> HTTP:  http://#{ip}:#{HTTP_PORT}"
  puts "-> HTTPS: https://#{ip}:#{HTTPS_PORT} (iOS Live Camera)"
  
  t1 = Thread.new { http_s.start }
  t2 = Thread.new { https_s.start }
  t1.join
  t2.join
end
