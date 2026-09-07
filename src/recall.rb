# src/recall.rb - Instant Circuit Breaker
require_relative 'db'

class RecallProcedure
  def self.trigger_recall(barcode, user_id, reason = 'Quality failure')
    db = RubyChainDB.connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { success: false, error: 'Item not found' } unless item

    db.execute('UPDATE items SET recalled = 1 WHERE id = ?', [item['id']])
    db.execute('INSERT INTO recalls (item_id, issued_by_user_id, reason) VALUES (?, ?, ?)',
               [item['id'], user_id, reason])
    { success: true, message: 'RECALL BROADCAST: Chain broken!' }
  end

  def self.recalled?(barcode)
    item = RubyChainDB.connection.execute('SELECT recalled FROM items WHERE barcode = ?', [barcode]).first
    item && item['recalled'] == 1
  end
end
