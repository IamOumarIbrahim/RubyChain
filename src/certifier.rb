# src/certifier.rb - Pre-seeded Origin Authority
require_relative 'db'
require 'digest'

class CertifierNode
  def self.issue_origin_proof(barcode, user_id = 1)
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { success: false, error: 'Item not found' } unless item

    existing = db.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'origin_proof'", [item['id']]).first
    return { success: true, credential: existing } if existing

    sig = Digest::SHA256.hexdigest("ORIGIN:#{item['id']}:#{barcode}")
    db.execute('INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
               [item['id'], 'origin_proof', user_id, sig])
    { success: true, credential: db.execute('SELECT * FROM credentials WHERE id = ?', [db.last_insert_row_id]).first }
  end

  def self.verify(item_id)
    RubyChainDB.connection.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'origin_proof'", [item_id]).first
  end
end
