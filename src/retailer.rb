# src/retailer.rb - Node 4: Full Chain Retail Shelf Verification
require_relative 'db'
require 'digest'

class RetailerNode
  def self.verify(barcode)
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { valid: false, error: 'Item not found' } unless item
    return { valid: false, error: 'RETAIL BLOCKED: Batch has been RECALLED!' } if item['recalled'] == 1

    origin = db.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'origin_proof'", [item['id']]).first
    transit = db.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'transit_proof'", [item['id']]).first
    border = db.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'border_proof'", [item['id']]).first
    return { valid: false, error: 'Chain incomplete' } unless origin && transit && border

    integrity = RubyChainDB.verify_chain_integrity(barcode)
    return { valid: false, error: "TAMPER DETECTED: Hash mismatch at #{integrity[:milestone]}" } unless integrity[:valid]

    { valid: true, item: item, prev: border }
  end

  def self.verify_and_issue(barcode, user_id)
    check = verify(barcode)
    return { success: false, error: check[:error] } unless check[:valid]

    db = RubyChainDB.connection
    item = check[:item]
    existing = db.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'shelf_proof'", [item['id']]).first
    return { success: true, credential: existing } if existing

    sig = Digest::SHA256.hexdigest("PREV:#{check[:prev]['signature_hash']}|SHELF|#{user_id}")
    db.execute('INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
               [item['id'], 'shelf_proof', user_id, sig])
    { success: true, message: 'Product fully verified and placed on shelf for sale', credential: db.execute('SELECT * FROM credentials WHERE id = ?', [db.last_insert_row_id]).first }
  end
end
