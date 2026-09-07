# src/carrier.rb
# ==============================================================================
# Node 2: Carrier (Shipping Line / Freight Forwarder)
# ==============================================================================
# Role: Verifies the paperwork and origin/transit credentials before loading boxes
# onto the ship or aircraft. Attests carrier custody handover.
# ==============================================================================

require_relative 'db'
require_relative 'certifier'
require_relative 'exporter'
require 'digest'

class CarrierNode
  # Verifies that both certifier origin and exporter transit custody exist
  def self.verify(barcode)
    db = RubyChainDB.connection

    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { valid: false, error: 'Item not registered in system' } unless item

    if item['recalled'] == 1
      return { valid: false, error: 'Cannot load for freight: Batch is RECALLED!' }
    end

    origin_cred = CertifierNode.verify(item['id'])
    unless origin_cred
      return { valid: false, error: 'Certifier origin credential missing' }
    end

    transit_cred = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'transit_proof'",
      [item['id']]
    ).first
    unless transit_cred
      return { valid: false, error: 'Exporter transit pass missing. Custody not transferred.' }
    end

    { valid: true, item: item, origin: origin_cred, transit: transit_cred }
  end

  # Verifies and confirms carrier freight acceptance
  def self.verify_and_issue(barcode, user_id)
    check = verify(barcode)
    return { success: false, error: check[:error] } unless check[:valid]

    item = check[:item]
    db = RubyChainDB.connection

    # If carrier acts as intermediary attestation or reaffirms transit custody
    { success: true, message: 'Carrier verified custody and freight manifest successfully', item: item }
  end
end
