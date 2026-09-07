# src/exporter.rb
# ==============================================================================
# Node 1: Exporter
# ==============================================================================
# Role: Verifies the Certifier's origin pass before accepting custody of the coffee.
# Action: Verify origin_proof -> Issue transit_proof (Exporter custody pass).
# ==============================================================================

require_relative 'db'
require_relative 'certifier'
require 'digest'

class ExporterNode
  # Verifies prior requirements: item must not be recalled, and origin_proof must exist
  def self.verify(barcode)
    db = RubyChainDB.connection

    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { valid: false, error: 'Item not registered in system' } unless item

    if item['recalled'] == 1
      return { valid: false, error: 'Cannot export: Batch is RECALLED!' }
    end

    origin_cred = CertifierNode.verify(item['id'])
    unless origin_cred
      return { valid: false, error: 'Certifier origin pass missing or unverified' }
    end

    { valid: true, item: item, origin_credential: origin_cred }
  end

  # Verifies Certifier pass and issues transit_proof
  def self.verify_and_issue(barcode, user_id)
    check = verify(barcode)
    return { success: false, error: check[:error] } unless check[:valid]

    item = check[:item]
    origin_cred = check[:origin_credential]
    db = RubyChainDB.connection

    # Check if transit_proof already issued
    existing = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'transit_proof'",
      [item['id']]
    ).first

    if existing
      return { success: true, message: 'Transit pass already issued', credential: existing }
    end

    # Cryptographic chained hash (links back to origin proof signature)
    payload = "PREV:#{origin_cred['signature_hash']}|ITEM:#{item['id']}|MILESTONE:transit_proof|ISSUER:#{user_id}"
    signature = Digest::SHA256.hexdigest(payload)

    db.execute(
      'INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
      [item['id'], 'transit_proof', user_id, signature]
    )

    cred_id = db.last_insert_row_id
    cred = db.execute('SELECT * FROM credentials WHERE id = ?', [cred_id]).first

    { success: true, message: 'Exporter custody pass issued successfully', credential: cred }
  end
end
