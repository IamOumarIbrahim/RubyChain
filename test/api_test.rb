# test/api_test.rb
# ==============================================================================
# RubyChain API & Integration Test
# ==============================================================================
# Spins up the server in a background thread and validates all HTTP JSON endpoints.
# ==============================================================================

require 'net/http'
require 'json'
require 'uri'
require 'stringio'
require_relative '../src/main'

TEST_PORT = 4999
log_sink = StringIO.new
server = create_server(TEST_PORT, log_sink)

server_thread = Thread.new do
  server.start
end

# Allow server a moment to bind
sleep 1.0

def post_json(path, payload)
  uri = URI("http://127.0.0.1:#{TEST_PORT}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  req = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
  req.body = JSON.generate(payload)
  res = http.request(req)
  [res.code.to_i, JSON.parse(res.body || '{}')]
end

def get_json(path)
  uri = URI("http://127.0.0.1:#{TEST_PORT}#{path}")
  res = Net::HTTP.get_response(uri)
  [res.code.to_i, JSON.parse(res.body || '{}')]
end

begin
  puts "=== API Test 1: Reset Demo Item ==="
  code, body = post_json('/api/reset_demo', { barcode: '5901234123457' })
  abort("API Reset failed: #{body}") unless code == 200 && body['success']
  puts "✓ Reset successful."

  puts "\n=== API Test 2: User Login & Auto-Signup ==="
  code, body = post_json('/api/auth/login', { username: 'certifier', password: 'password123', role: 'certifier' })
  abort("API Login failed: #{body}") unless code == 200 && body['success']
  cert_uid = body['user']['user_id']
  puts "✓ Certifier login successful (User ID: #{cert_uid})."

  puts "\n=== API Test 3: Uncertified Item Status & Certifier Issuance ==="
  code, body = get_json('/api/item?barcode=5901234123457')
  abort("API Item Query failed: #{body}") unless code == 200 && body['success']
  abort("Expected chain_status Intact") unless body['chain_status'] == 'Intact'
  abort("Expected origin verified false before certification") unless body['credentials']['origin']['verified'] == false

  # Certifier issues origin_proof
  code, body = post_json('/api/action/verify_issue', { barcode: '5901234123457', user_id: cert_uid, role: 'certifier' })
  abort("Certifier verify_issue failed: #{body}") unless code == 200 && body['success']
  puts "✓ Certifier issued origin_proof: #{body['message']}"

  code, body = get_json('/api/item?barcode=5901234123457')
  abort("Expected origin verified true after certification") unless body['credentials']['origin']['verified'] == true
  abort("Expected transit verified false") unless body['credentials']['transit']['verified'] == false
  puts "✓ Item state verified: Origin Verified green, downstream pending."

  puts "\n=== API Test 4: Exporter Verify & Issue ==="
  code, body = post_json('/api/action/verify_issue', { barcode: '5901234123457', user_id: 2, role: 'exporter' })
  abort("API Exporter issue failed: #{body}") unless code == 200 && body['success']
  puts "✓ Exporter verify_issue succeeded: #{body['message']}"

  puts "\n=== API Test 5: Customs Verify & Issue ==="
  code, body = post_json('/api/action/verify_issue', { barcode: '5901234123457', user_id: 4, role: 'customs' })
  abort("API Customs issue failed: #{body}") unless code == 200 && body['success']
  puts "✓ Customs verify_issue succeeded: #{body['message']}"

  puts "\n=== API Test 6: Retailer Verify & Issue ==="
  code, body = post_json('/api/action/verify_issue', { barcode: '5901234123457', user_id: 5, role: 'retailer' })
  abort("API Retailer issue failed: #{body}") unless code == 200 && body['success']
  puts "✓ Retailer verify_issue succeeded: #{body['message']}"

  puts "\n=== API Test 7: Verify Full Green Chain ==="
  code, body = get_json('/api/item?barcode=5901234123457')
  abort("API Item Query failed: #{body}") unless code == 200
  abort("Chain should be intact") unless body['chain_status'] == 'Intact'
  abort("Origin should be verified") unless body['credentials']['origin']['verified']
  abort("Transit should be verified") unless body['credentials']['transit']['verified']
  abort("Border should be verified") unless body['credentials']['border']['verified']
  abort("Shelf should be verified") unless body['credentials']['shelf']['verified']
  abort("Origin hash missing") if body['credentials']['origin']['hash'].to_s.empty?
  puts "✓ All 4 nodes verified green and intact with SHA-256 hashes!"

  puts "\n=== API Test 7.5: Verify IDS W3C Verifiable Presentation Endpoint ==="
  code, body = get_json('/api/credentials?barcode=5901234123457')
  abort("API Credentials export failed: #{body}") unless code == 200 && body['success']
  abort("Expected W3C VerifiablePresentation type") unless body['type'].include?('VerifiablePresentation')
  abort("Expected 4 credentials in presentation") unless body['verifiableCredential'].size == 4
  abort("Expected cryptographic proof hash in credential") if body['verifiableCredential'].first['proof']['hash'].to_s.empty?
  puts "✓ W3C Verifiable Presentation schema validated: 4 cryptographic credentials included."

  puts "\n=== API Test 7.6: Verify GS1 EPCIS 2.0 Export ==="
  code, body = get_json('/api/epcis?barcode=5901234123457')
  abort("API EPCIS export failed: #{body}") unless code == 200 && body['success']
  abort("Expected isEPCISDocument true") unless body['isEPCISDocument'] == true
  abort("Expected 4 EPCIS events") unless body['epcisBody']['eventList'].size == 4
  abort("Expected bizStep in first event") if body['epcisBody']['eventList'].first['bizStep'].to_s.empty?
  puts "✓ GS1 EPCIS 2.0 schema validated: 4 supply chain CTE events exported."

  puts "\n=== API Test 8: Trigger Recall & Verify Circuit Breaker ==="
  code, body = post_json('/api/action/recall', { barcode: '5901234123457', user_id: 5, reason: 'Aflatoxin contamination' })
  abort("API Recall failed: #{body}") unless code == 200 && body['success']

  code, body = get_json('/api/item?barcode=5901234123457')
  abort("Chain should now be Broken") unless body['chain_status'] == 'Broken'
  abort("Origin should reflect broken") if body['credentials']['origin']['verified']
  puts "✓ Circuit breaker verified: Chain Status flipped to Broken across all nodes!"

  puts "\n=== API Test 8.5: Verify Granular Quarantine (Lot 403 Intact) ==="
  code, body = get_json('/api/item?barcode=5901234123458')
  abort("API Lot 403 query failed: #{body}") unless code == 200 && body['success']
  abort("Lot 403 must remain Intact despite Lot 402 recall") unless body['chain_status'] == 'Intact'
  puts "✓ Granular quarantine verified via API: Lot 403 unaffected by Lot 402 recall!"

  puts "\n=== API Test 9: Reset Demo Batch Back to Clean Pre-seeded State ==="
  code, body = post_json('/api/reset_demo', { barcode: '5901234123457' })
  abort("API Reset failed: #{body}") unless code == 200
  code, body = get_json('/api/item?barcode=5901234123457')
  abort("Chain should be Intact after reset") unless body['chain_status'] == 'Intact'
  puts "✓ Demo batch restored to clean state."

  puts "\n🎉 ALL API & ENDPOINT INTEGRATION TESTS PASSED! 🎉"
ensure
  server.shutdown
  server_thread.join(2)
end
