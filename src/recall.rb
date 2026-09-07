# src/recall.rb
# ==============================================================================
# Recall Procedure: Instant Circuit Breaker
# ==============================================================================
# "If a bad batch is recalled, the whole chain breaks instantly and stops future scans."
# When recalled, items.recalled is set to 1, and an immutable entry is added to recalls.
# Any subsequent verify or issue attempt along the chain is immediately blocked.
# ==============================================================================

require_relative 'db'

class RecallProcedure
  # Triggers an instant recall for a product batch by barcode
  def self.trigger_recall(barcode, user_id, reason = 'Contamination / Cold-chain compliance breach')
    db = RubyChainDB.connection

    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { success: false, error: 'Item not found in system' } unless item

    # Update item status to recalled
    db.execute('UPDATE items SET recalled = 1 WHERE id = ?', [item['id']])

    # Insert audit record into recalls table
    db.execute(
      'INSERT INTO recalls (item_id, issued_by_user_id, reason) VALUES (?, ?, ?)',
      [item['id'], user_id, reason]
    )

    recall_id = db.last_insert_row_id
    record = db.execute('SELECT * FROM recalls WHERE id = ?', [recall_id]).first

    {
      success: true,
      message: 'RECALL BROADCAST: Chain broken! Item flagged as recalled across all nodes.',
      recall_record: record
    }
  end

  # Checks if a barcode is recalled
  def self.recalled?(barcode)
    db = RubyChainDB.connection
    item = db.execute('SELECT recalled FROM items WHERE barcode = ?', [barcode]).first
    return false unless item
    item['recalled'] == 1
  end
end
