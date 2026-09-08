# src/db.rb - Database & Seed Engine (Streamlined for 3-Hour Build)
require 'sqlite3'
require 'digest'

class RubyChainDB
  DB_FILE = File.expand_path('../../rubychain.db', __FILE__)

  def self.connection
    @db ||= begin
      db = SQLite3::Database.new(DB_FILE)
      db.results_as_hash = true
      db
    end
  end

  def self.setup!
    db = connection
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL
      );
      CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        recalled INTEGER DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER REFERENCES items(id),
        milestone TEXT NOT NULL,
        issued_by_user_id INTEGER,
        signature_hash TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
      CREATE TABLE IF NOT EXISTS recalls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER REFERENCES items(id),
        issued_by_user_id INTEGER,
        reason TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    SQL
    seed_defaults!
  end

  def self.hash_password(pwd)
    Digest::SHA256.hexdigest("rubychain_salt_#{pwd}")
  end

  def self.seed_defaults!
    db = connection
    # Pre-seed standard accounts
    %w[certifier exporter carrier customs retailer].each do |role|
      next if db.execute('SELECT 1 FROM users WHERE username = ?', [role]).any?
      db.execute('INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)',
                 [role, hash_password('password123'), role])
    end

    # Pre-seed Coffee Lot #402 & Compliant Control Lot #403
    [
      ['5901234123457', 'Highland Arabica Coffee (Lot #402)'],
      ['5901234123458', 'Highland Yirgacheffe Coffee (Lot #403)']
    ].each do |code, name|
      unless db.execute('SELECT 1 FROM items WHERE barcode = ?', [code]).any?
        db.execute('INSERT INTO items (barcode, name, recalled) VALUES (?, ?, 0)', [code, name])
      end
    end
  end

  def self.reset_demo_item!(barcode = nil)
    db = connection
    codes = barcode ? [barcode] : ['5901234123457', '5901234123458']
    codes.each do |code|
      item = db.execute('SELECT id FROM items WHERE barcode = ?', [code]).first
      next unless item
      db.execute('DELETE FROM credentials WHERE item_id = ?', [item['id']])
      db.execute('DELETE FROM recalls WHERE item_id = ?', [item['id']])
      db.execute('UPDATE items SET recalled = 0 WHERE id = ?', [item['id']])
    end
  end

  def self.verify_chain_integrity(barcode)
    db = connection
    item = db.execute('SELECT * FROM items WHERE barcode = ?', [barcode]).first
    return { valid: false, error: 'Item not found' } unless item

    creds = db.execute('SELECT * FROM credentials WHERE item_id = ? ORDER BY id ASC', [item['id']])
    return { valid: true, count: 0 } if creds.empty?

    prev_hash = nil
    creds.each do |c|
      expected = case c['milestone']
                 when 'origin_proof'
                   Digest::SHA256.hexdigest("ORIGIN:#{item['id']}:#{barcode}|#{c['issued_by_user_id']}")
                 when 'transit_proof'
                   Digest::SHA256.hexdigest("PREV:#{prev_hash}|TRANSIT|#{c['issued_by_user_id']}")
                 when 'border_proof'
                   Digest::SHA256.hexdigest("PREV:#{prev_hash}|BORDER|#{c['issued_by_user_id']}")
                 when 'shelf_proof'
                   Digest::SHA256.hexdigest("PREV:#{prev_hash}|SHELF|#{c['issued_by_user_id']}")
                 end

      if expected && c['signature_hash'] != expected
        return {
          valid: false,
          tampered: true,
          milestone: c['milestone'],
          expected_hash: expected,
          actual_hash: c['signature_hash']
        }
      end
      prev_hash = c['signature_hash']
    end

    { valid: true, tampered: false, count: creds.size }
  end

  def self.simulate_tamper!(barcode)
    db = connection
    item = db.execute('SELECT id FROM items WHERE barcode = ?', [barcode]).first
    return false unless item
    cred = db.execute('SELECT id, signature_hash FROM credentials WHERE item_id = ? ORDER BY id ASC LIMIT 1', [item['id']]).first
    return false unless cred
    db.execute('UPDATE credentials SET signature_hash = ? WHERE id = ?',
               ['TAMPERED_SIG_' + cred['signature_hash'][0..15], cred['id']])
    true
  end
end
