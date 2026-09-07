# test/chain_test.rb
# ==============================================================================
# RubyChain Automated Verification Test Suite
# ==============================================================================
# Runs tests covering:
# 1. Database seeding & Certifier origin_proof
# 2. Exporter verification & transit_proof issuance
# 3. Carrier custody verification
# 4. Customs dual-pass verification & border_proof issuance
# 5. Retailer full chain verification & shelf_proof issuance
# 6. Circuit-breaker recall: instant chain break & downstream blocking
# 7. Demo reset capability
# ==============================================================================

require_relative '../src/db'
require_relative '../src/certifier'
require_relative '../src/exporter'
require_relative '../src/carrier'
require_relative '../src/customs'
require_relative '../src/retailer'
require_relative '../src/recall'

RubyChainDB.setup!

barcode = '5901234123457'

puts "=== 1. Testing Reset to Clean Baseline ==="
RubyChainDB.reset_demo_item!(barcode)
item_status = RubyChainDB.connection.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
abort("Test 1 Failed: Item not found") unless item_status
abort("Test 1 Failed: Item should not be recalled") unless item_status['recalled'] == 0
puts "✓ Reset baseline clean."

puts "\n=== 2. Testing Certifier Live Origin Proof Issuance ==="
origin_res = CertifierNode.issue_origin_proof(barcode, 1)
abort("Test 2 Failed: Certifier issue failed: #{origin_res[:error]}") unless origin_res[:success]
origin_check = CertifierNode.verify(item_status['id'])
abort("Test 2 Failed: Origin proof missing after issuance") unless origin_check
abort("Test 2 Failed: Signature hash empty") if origin_check['signature_hash'].to_s.empty?
puts "✓ Certifier issued origin_proof: #{origin_check['signature_hash'][0..15]}..."

puts "\n=== 3. Testing Exporter Verification & Issuance ==="
exp_result = ExporterNode.verify_and_issue(barcode, 2)
abort("Test 3 Failed: Exporter issue failed: #{exp_result[:error]}") unless exp_result[:success]
puts "✓ Exporter issued transit_proof: #{exp_result[:credential]['signature_hash'][0..15]}..."

puts "\n=== 4. Testing Carrier Custody Verification ==="
carrier_result = CarrierNode.verify(barcode)
abort("Test 4 Failed: Carrier verify failed: #{carrier_result[:error]}") unless carrier_result[:valid]
puts "✓ Carrier verified origin + transit successfully."

puts "\n=== 5. Testing Customs Dual-Pass Verification & Issuance ==="
customs_result = CustomsNode.verify_and_issue(barcode, 4)
abort("Test 5 Failed: Customs issue failed: #{customs_result[:error]}") unless customs_result[:success]
puts "✓ Customs issued border_proof: #{customs_result[:credential]['signature_hash'][0..15]}..."

puts "\n=== 6. Testing Retailer Full Chain Verification & Shelf Issuance ==="
retailer_result = RetailerNode.verify_and_issue(barcode, 5)
abort("Test 6 Failed: Retailer issue failed: #{retailer_result[:error]}") unless retailer_result[:success]
puts "✓ Retailer verified complete 3-step chain and issued shelf_proof."

puts "\n=== 7. Testing Recall Circuit-Breaker ==="
recall_result = RecallProcedure.trigger_recall(barcode, 5, 'E. coli outbreak detected in batch')
abort("Test 7 Failed: Recall failed: #{recall_result[:error]}") unless recall_result[:success]
abort("Test 7 Failed: Item should be recalled") unless RecallProcedure.recalled?(barcode)
puts "✓ Recall triggered: item flagged as recalled."

# Downstream checks should now all fail immediately!
exp_fail = ExporterNode.verify(barcode)
abort("Test 7 Failed: Exporter verify should fail on recalled item") if exp_fail[:valid]

customs_fail = CustomsNode.verify(barcode)
abort("Test 7 Failed: Customs verify should fail on recalled item") if customs_fail[:valid]

retailer_fail = RetailerNode.verify(barcode)
abort("Test 7 Failed: Retailer verify should fail on recalled item") if retailer_fail[:valid]

puts "✓ All nodes blocked instantly by circuit breaker on recalled item!"

puts "\n=== 8. Resetting for Live Demo ==="
RubyChainDB.reset_demo_item!(barcode)
abort("Test 8 Failed: Reset failed") if RecallProcedure.recalled?(barcode)
puts "✓ Reset restored item to pre-seeded clean state."

puts "\n🎉 ALL AUTOMATED CHAIN TESTS PASSED SUCCESSFULLY! 🎉"
