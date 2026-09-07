# src/certifier.rb - Node 0: Origin Certifier Authority
require_relative 'db'
require 'digest'

class CertifierNode
  def self.issue_origin_proof(barcode, user_id = 1)
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    unless item
      db.execute('INSERT INTO items (barcode, name, recalled) VALUES (?, ?, 0)',
                 [barcode, "Certified Lot [#{barcode}]"])
      item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    end
    return { success: false, error: 'Batch RECALLED' } if item['recalled'] == 1

    existing = db.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'origin_proof'", [item['id']]).first
    return { success: true, message: 'Origin already certified', credential: existing } if existing

    sig = Digest::SHA256.hexdigest("ORIGIN:#{item['id']}:#{barcode}|#{user_id}")
    db.execute('INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
               [item['id'], 'origin_proof', user_id, sig])
    { success: true, message: 'Certifier verified origin & issued pass!', credential: db.execute('SELECT * FROM credentials WHERE id = ?', [db.last_insert_row_id]).first }
  end

  def self.verify(item_id)
    RubyChainDB.connection.execute("SELECT * FROM credentials WHERE item_id = ? AND milestone = 'origin_proof'", [item_id]).first
  end
end
