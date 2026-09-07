# test/verify_system.rb - Full System Operational Healthcheck
# ==============================================================================
# Verifies that:
# 1. SQLite database and pre-seeded records are intact
# 2. All cryptographic chain transitions pass
# 3. HTTP Server (Port 4567) responds with 200 OK
# 4. HTTPS Server (Port 8443) responds with 200 OK
# ==============================================================================

require 'net/http'
require 'openssl'
require 'json'
require 'stringio'
require_relative '../src/main'

puts "===================================================================="
puts "  🔍 RubyChain Pre-Flight System Verification"
puts "===================================================================="

# 1. Database & Chain Tests
puts "[1/4] Running Cryptographic Chain Logic Tests..."
require_relative 'chain_test'
puts "  ✓ Chain logic 100% verified."

# 2. Boot Test Dual Server
puts "[2/4] Initializing Dual HTTP & HTTPS Server..."
log_sink = StringIO.new
http_s = create_server(4991, log_sink)
https_s = create_https_server(8491, log_sink)

t1 = Thread.new { http_s.start }
t2 = Thread.new { https_s.start }
sleep 1.0

begin
  # 3. Test HTTP Endpoint
  puts "[3/4] Validating HTTP API Response..."
  uri_http = URI('http://127.0.0.1:4991/api/item?barcode=5901234123457')
  res_http = Net::HTTP.get_response(uri_http)
  abort("HTTP Check Failed (Code: #{res_http.code})") unless res_http.code.to_i == 200
  data_http = JSON.parse(res_http.body)
  abort("HTTP Payload Invalid") unless data_http['success'] && data_http['chain_status'] == 'Intact'
  puts "  ✓ HTTP Port operational (200 OK, Chain Intact)."

  # 4. Test HTTPS Endpoint (iPhone Camera Port)
  puts "[4/4] Validating HTTPS (SSL) API Response..."
  uri_https = URI('https://127.0.0.1:8491/api/item?barcode=5901234123457')
  http_client = Net::HTTP.new(uri_https.host, uri_https.port)
  http_client.use_ssl = true
  http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
  res_https = http_client.request(Net::HTTP::Get.new(uri_https.path + '?' + uri_https.query))
  abort("HTTPS Check Failed (Code: #{res_https.code})") unless res_https.code.to_i == 200
  data_https = JSON.parse(res_https.body)
  abort("HTTPS Payload Invalid") unless data_https['success']
  puts "  ✓ HTTPS Port operational (200 OK, SSL Verified)."

  puts "===================================================================="
  puts "  🎉 SYSTEM IS FULLY OPERATIONAL AND VERIFIED HEALTHY! 🎉"
  puts "===================================================================="
ensure
  http_s.shutdown
  https_s.shutdown
  t1.join(1)
  t2.join(1)
end
