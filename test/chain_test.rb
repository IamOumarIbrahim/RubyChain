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

puts "\n=== 7.5 Testing Granular Isolation (Lot #403 Safe & Intact) ==="
control_barcode = '5901234123458'
abort("Test 7.5 Failed: Lot 403 should NOT be recalled") if RecallProcedure.recalled?(control_barcode)
puts "✓ Granular isolation verified: Lot 402 quarantined without affecting compliant Lot 403!"

puts "\n=== 7.6 Testing Cryptographic Tamper Detection & Fault Injection ==="
CertifierNode.issue_origin_proof(control_barcode, 1)
ExporterNode.verify_and_issue(control_barcode, 2)
pre_tamper = RubyChainDB.verify_chain_integrity(control_barcode)
abort("Test 7.6 Failed: Fresh chain should be valid") unless pre_tamper[:valid]

RubyChainDB.simulate_tamper!(control_barcode)
post_tamper = RubyChainDB.verify_chain_integrity(control_barcode)
abort("Test 7.6 Failed: Tamper should be detected!") if post_tamper[:valid]
abort("Test 7.6 Failed: Expected tampered true") unless post_tamper[:tampered]
puts "✓ Cryptographic fault injection caught at milestone: #{post_tamper[:milestone]}"

customs_tamper_check = CustomsNode.verify(control_barcode)
abort("Test 7.6 Failed: Customs should reject tampered upstream chain") if customs_tamper_check[:valid]
abort("Test 7.6 Failed: Error message should cite TAMPER DETECTED") unless customs_tamper_check[:error].include?('TAMPER DETECTED')
puts "✓ Customs node actively rejected tampered chain: #{customs_tamper_check[:error]}"

puts "\n=== 8. Resetting for Live Demo ==="
RubyChainDB.reset_demo_item!
abort("Test 8 Failed: Reset failed") if RecallProcedure.recalled?(barcode)
abort("Test 8 Failed: Reset failed for control") if RubyChainDB.connection.execute('SELECT COUNT(*) as c FROM credentials').first['c'] > 0
puts "✓ Reset restored item to pre-seeded clean state."

puts "\n🎉 ALL AUTOMATED CHAIN TESTS PASSED SUCCESSFULLY! 🎉"
