# src/retailer.rb
# ==============================================================================
# Node 4: Retailer (Supermarket / Coffee Shop Shelf)
# ==============================================================================
# Role: Checks that ALL THREE past passes (origin_proof, transit_proof, border_proof)
# are approved and NO recall exists before offering the product for sale to consumers.
# Action: Verify full chain -> Issue shelf_proof.
# ==============================================================================

require_relative 'db'
require_relative 'certifier'
require 'digest'

class RetailerNode
  # Verifies that all 3 prior passes exist and that the item is safe (not recalled)
  def self.verify(barcode)
    db = RubyChainDB.connection

    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { valid: false, error: 'Item not registered in system' } unless item

    if item['recalled'] == 1
      return { valid: false, error: 'RETAIL SALE BLOCKED: Batch has been RECALLED!' }
    end

    # Pass 1: Certifier Origin
    origin_cred = CertifierNode.verify(item['id'])
    unless origin_cred
      return { valid: false, error: 'Shelf verification failed: Origin pass missing' }
    end

    # Pass 2: Exporter / Carrier Transit
    transit_cred = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'transit_proof'",
      [item['id']]
    ).first
    unless transit_cred
      return { valid: false, error: 'Shelf verification failed: Transit custody pass missing' }
    end

    # Pass 3: Customs Clearance
    border_cred = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'border_proof'",
      [item['id']]
    ).first
    unless border_cred
      return { valid: false, error: 'Shelf verification failed: Customs border pass missing' }
    end

    {
      valid: true,
      item: item,
      origin: origin_cred,
      transit: transit_cred,
      border: border_cred
    }
  end

  # Verifies full 3-step chain and issues shelf_proof
  def self.verify_and_issue(barcode, user_id)
    check = verify(barcode)
    return { success: false, error: check[:error] } unless check[:valid]

    item = check[:item]
    border_cred = check[:border]
    db = RubyChainDB.connection

    # Check if shelf_proof already issued
    existing = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'shelf_proof'",
      [item['id']]
    ).first

    if existing
      return { success: true, message: 'Shelf pass already verified and active', credential: existing }
    end

    # Chained signature linking back to border clearance
    payload = "PREV:#{border_cred['signature_hash']}|ITEM:#{item['id']}|MILESTONE:shelf_proof|ISSUER:#{user_id}"
    signature = Digest::SHA256.hexdigest(payload)

    db.execute(
      'INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
      [item['id'], 'shelf_proof', user_id, signature]
    )

    cred_id = db.last_insert_row_id
    cred = db.execute('SELECT * FROM credentials WHERE id = ?', [cred_id]).first

    { success: true, message: 'Product fully verified and placed on shelf for sale', credential: cred }
  end
end
