# src/carrier.rb - Node 2: Carrier Custody Verification
require_relative 'db'

class CarrierNode
  def self.verify(barcode)
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { valid: false, error: 'Item not found' } unless item
    return { valid: false, error: 'Batch RECALLED' } if item['recalled'] == 1

    transit = db.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'transit_proof'", [item['id']]).first
    return { valid: false, error: 'Transit pass missing' } unless transit

    integrity = RubyChainDB.verify_chain_integrity(barcode)
    return { valid: false, error: "TAMPER DETECTED: Hash mismatch at #{integrity[:milestone]}" } unless integrity[:valid]

    { valid: true, item: item }
  end

  def self.verify_and_issue(barcode, user_id)
    check = verify(barcode)
    return { success: false, error: check[:error] } unless check[:valid]
    { success: true, message: 'Carrier verified custody and freight manifest successfully' }
  end
end
