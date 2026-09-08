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
  # 1. Login (or Auto-Signup if new)
  server.mount_proc '/api/auth/login' do |req, res|
    d = parse_json(req)
    uname = clean_str(d['username'])
    pwd = clean_str(d['password'])
    role = clean_str(d['role'] || 'certifier')
    db = RubyChainDB.connection
    u = db.execute('SELECT * FROM users WHERE username = ?', [uname]).first
    if u
      if u['password_hash'] == RubyChainDB.hash_password(pwd)
        json_res(res, { success: true, user: { user_id: u['user_id'], username: u['username'], role: u['role'] } })
      else
        json_res(res, { success: false, error: 'Invalid password' }, 401)
      end
    elsif !uname.empty? && !pwd.empty?
      db.execute('INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)',
                 [uname, RubyChainDB.hash_password(pwd), role])
      json_res(res, { success: true, user: { user_id: db.last_insert_row_id, username: uname, role: role }, created: true })
    else
      json_res(res, { success: false, error: 'Username and password required' }, 400)
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
      integrity = RubyChainDB.verify_chain_integrity(code)
      tampered = !integrity[:valid]

      status = if broken
                 'Broken'
               elsif tampered
                 'Tampered'
               else
                 'Intact'
               end

      json_res(res, {
        success: true, item: item,
        chain_status: status,
        recalled: broken,
        tampered: tampered,
        tamper_details: tampered ? integrity : nil,
        credentials: {
          origin: { verified: !creds['origin_proof'].nil? && !broken && !tampered, hash: creds.dig('origin_proof', 'signature_hash') },
          transit: { verified: !creds['transit_proof'].nil? && !broken && !tampered, hash: creds.dig('transit_proof', 'signature_hash') },
          border: { verified: !creds['border_proof'].nil? && !broken && !tampered, hash: creds.dig('border_proof', 'signature_hash') },
          shelf: { verified: !creds['shelf_proof'].nil? && !broken && !tampered, hash: creds.dig('shelf_proof', 'signature_hash') }
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

  # 6.5. Cryptographic Fault Injection / Tamper Simulation
  server.mount_proc '/api/action/simulate_tamper' do |req, res|
    d = parse_json(req)
    code = clean_str(d['barcode'])
    code = '5901234123457' if code.empty?
    if RubyChainDB.simulate_tamper!(code)
      json_res(res, { success: true, message: 'Cryptographic fault injected! SHA-256 seal corrupted.' })
    else
      json_res(res, { success: false, error: 'No credentials present to tamper. Issue at least one milestone first.' }, 400)
    end
  end

  # 7. IDS W3C Verifiable Presentation Export
  server.mount_proc '/api/credentials' do |req, res|
    code = clean_str(req.query['barcode'])
    code = '5901234123457' if code.empty?
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [code]).first
    if item
      creds = db.execute('SELECT * FROM credentials WHERE item_id = ? ORDER BY id ASC', [item['id']])
      integrity = RubyChainDB.verify_chain_integrity(code)
      json_res(res, {
        success: true,
        '@context' => ['https://www.w3.org/2018/credentials/v1'],
        type: ['VerifiablePresentation', 'RubyChainProvenancePresentation'],
        barcode: code,
        verifiableCredential: creds.map do |c|
          {
            type: ['VerifiableCredential', c['milestone']],
            issuer: "did:rubychain:user:#{c['issued_by_user_id']}",
            issuanceDate: c['created_at'],
            credentialSubject: { id: "urn:gtin:#{code}", milestone: c['milestone'] },
            proof: { type: 'Sha256Signature2026', hash: c['signature_hash'] }
          }
        end,
        recalled: item['recalled'] == 1,
        tampered: !integrity[:valid],
        integrityCheck: integrity
      })
    else
      json_res(res, { success: false, error: 'Item not found' }, 404)
    end
  end

  # 8. GS1 EPCIS 2.0 Event Log Export (FDA FSMA Rule 204 Compliant)
  server.mount_proc '/api/epcis' do |req, res|
    code = clean_str(req.query['barcode'])
    code = '5901234123457' if code.empty?
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [code]).first
    if item
      creds = db.execute('SELECT * FROM credentials WHERE item_id = ? ORDER BY id ASC', [item['id']])
      broken = (item['recalled'] == 1)
      integrity = RubyChainDB.verify_chain_integrity(code)
      biz_map = {
        'origin_proof' => ['commissioning', 'urn:epcglobal:cbv:bizstep:commissioning', 'urn:epc:id:sgln:origin.farm.001'],
        'transit_proof' => ['shipping', 'urn:epcglobal:cbv:bizstep:shipping', 'urn:epc:id:sgln:exporter.port.002'],
        'border_proof' => ['receiving', 'urn:epcglobal:cbv:bizstep:receiving', 'urn:epc:id:sgln:customs.border.003'],
        'shelf_proof' => ['retail_selling', 'urn:epcglobal:cbv:bizstep:retail_selling', 'urn:epc:id:sgln:retailer.store.004']
      }
      events = creds.map do |c|
        step_info = biz_map[c['milestone']] || ['inspecting', 'urn:epcglobal:cbv:bizstep:inspecting', 'urn:epc:id:sgln:node.default']
        {
          type: 'ObjectEvent',
          eventTime: c['created_at'],
          epcList: ["urn:epc:id:sgtin:#{code}.001"],
          action: 'OBSERVE',
          bizStep: step_info[1],
          disposition: broken ? 'urn:epcglobal:cbv:disp:recalled' : (integrity[:valid] ? 'urn:epcglobal:cbv:disp:active' : 'urn:epcglobal:cbv:disp:tampered'),
          readPoint: { id: step_info[2] },
          proofHash: c['signature_hash']
        }
      end
      json_res(res, {
        success: true,
        isEPCISDocument: true,
        schemaVersion: '2.0',
        creationDate: Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ'),
        epcisBody: { eventList: events },
        recalled: broken,
        tampered: !integrity[:valid]
      })
    else
      json_res(res, { success: false, error: 'Item not found' }, 404)
    end
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
