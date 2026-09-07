# src/customs.rb
# ==============================================================================
# Node 3: Customs Clearance Authority
# ==============================================================================
# Role: Checks TWO passes at once (Certifier origin_proof and Exporter/Carrier transit_proof)
# before letting the goods cross the international border.
# Action: Verify dual passes -> Issue border_proof (Customs clearance pass).
# ==============================================================================

require_relative 'db'
require_relative 'certifier'
require 'digest'

class CustomsNode
  # Verifies dual passes before clearance
  def self.verify(barcode)
    db = RubyChainDB.connection

    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { valid: false, error: 'Item not registered in system' } unless item

    if item['recalled'] == 1
      return { valid: false, error: 'Customs HOLD: Shipment is RECALLED!' }
    end

    # Pass 1: Certifier Origin
    origin_cred = CertifierNode.verify(item['id'])
    unless origin_cred
      return { valid: false, error: 'Border clearance denied: Origin credential missing' }
    end

    # Pass 2: Exporter / Carrier Transit
    transit_cred = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'transit_proof'",
      [item['id']]
    ).first
    unless transit_cred
      return { valid: false, error: 'Border clearance denied: Transit custody credential missing' }
    end

    { valid: true, item: item, origin: origin_cred, transit: transit_cred }
  end

  # Verifies dual passes and issues border_proof
  def self.verify_and_issue(barcode, user_id)
    check = verify(barcode)
    return { success: false, error: check[:error] } unless check[:valid]

    item = check[:item]
    transit_cred = check[:transit]
    db = RubyChainDB.connection

    # Check if border_proof already issued
    existing = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'border_proof'",
      [item['id']]
    ).first

    if existing
      return { success: true, message: 'Border clearance pass already issued', credential: existing }
    end

    # Cryptographic chained signature: hashes previous transit signature to preserve chain continuity
    payload = "PREV:#{transit_cred['signature_hash']}|ITEM:#{item['id']}|MILESTONE:border_proof|ISSUER:#{user_id}"
    signature = Digest::SHA256.hexdigest(payload)

    db.execute(
      'INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
      [item['id'], 'border_proof', user_id, signature]
    )

    cred_id = db.last_insert_row_id
    cred = db.execute('SELECT * FROM credentials WHERE id = ?', [cred_id]).first

    { success: true, message: 'Border clearance pass issued successfully', credential: cred }
  end
end
