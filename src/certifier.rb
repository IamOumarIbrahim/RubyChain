# src/certifier.rb
# ==============================================================================
# Node 0: Certifier (Pre-seeded Root Authority)
# ==============================================================================
# Role: Verifies the agricultural origin, organic, and fair-trade standards.
# Milestone: origin_proof
# As specified in the challenge, this is pre-seeded before the clock starts.
# ==============================================================================

require_relative 'db'
require 'digest'

class CertifierNode
  # Issues the initial origin credential for an item
  def self.issue_origin_proof(barcode, certifier_user_id = 1)
    db = RubyChainDB.connection

    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { success: false, error: 'Item not found' } unless item

    # Check if origin_proof already exists
    existing = db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'origin_proof'",
      [item['id']]
    ).first

    if existing
      return { success: true, message: 'Origin already certified', credential: existing }
    end

    # Cryptographic SHA-256 digital signature hash
    payload = "ITEM:#{item['id']}|BARCODE:#{barcode}|MILESTONE:origin_proof|ISSUER:#{certifier_user_id}"
    signature = Digest::SHA256.hexdigest(payload)

    db.execute(
      'INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
      [item['id'], 'origin_proof', certifier_user_id, signature]
    )

    cred_id = db.last_insert_row_id
    cred = db.execute('SELECT * FROM credentials WHERE id = ?', [cred_id]).first

    { success: true, message: 'Origin certified successfully', credential: cred }
  end

  # Verifies the origin credential
  def self.verify(item_id)
    db = RubyChainDB.connection
    db.execute(
      "SELECT * FROM credentials WHERE item_id = ? AND milestone = 'origin_proof'",
      [item_id]
    ).first
  end
end
