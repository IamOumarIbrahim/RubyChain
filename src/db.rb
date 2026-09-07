# src/db.rb
# ==============================================================================
# RubyChain Database Module (SQLite3)
# ==============================================================================
# This file sets up the SQLite database and tables as specified in docs/schemas.xlsx.
# Code is intentionally kept at low abstraction with clear comments so anyone can
# easily understand and recreate it during a 3-hour hackathon build sprint.
# ==============================================================================

require 'sqlite3'
require 'digest'
require 'fileutils'

class RubyChainDB
  DB_FILE = File.expand_path('../../rubychain.db', __FILE__)

  # Returns an open connection to the SQLite database
  def self.connection
    @db ||= begin
      db = SQLite3::Database.new(DB_FILE)
      db.results_as_hash = true
      db.execute('PRAGMA foreign_keys = ON;')
      db
    end
  end

  # Initializes tables and seeds baseline data
  def self.setup!
    db = connection

    # 1. USERS TABLE (from docs/schemas.xlsx)
    # Roles: 'certifier' (hard-coded origin), 'exporter', 'carrier', 'customs', 'retailer'
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    SQL

    # 2. ITEMS TABLE (from docs/schemas.xlsx)
    # Represents product shipments tracked along the chain
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        recalled INTEGER DEFAULT 0, -- 0 for false (safe), 1 for true (recalled)
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    SQL

    # 3. CREDENTIALS TABLE (from docs/schemas.xlsx)
    # Milestones: 'origin_proof', 'transit_proof', 'border_proof', 'shelf_proof'
    # signature_hash: SHA-256 cryptographic seal linking item, milestone, and issuer
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
        milestone TEXT NOT NULL,
        issued_by_user_id INTEGER NOT NULL REFERENCES users(user_id),
        signature_hash TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    SQL

    # 4. RECALL TABLE (from docs/schemas.xlsx)
    # Records batch recall alerts that break the chain
    db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS recalls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL REFERENCES items(id) ON DELETE CASCADE,
        issued_by_user_id INTEGER NOT NULL REFERENCES users(user_id),
        reason TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    SQL

    # Seed baseline users and coffee batch
    seed_defaults!
  end

  # Simple SHA-256 password hashing for low-abstraction hackathon clarity
  def self.hash_password(plain_password)
    Digest::SHA256.hexdigest("rubychain_salt_#{plain_password}")
  end

  # Pre-seeds default competition roles and the initial origin certification
  def self.seed_defaults!
    db = connection

    # Pre-seed standard participant accounts
    default_users = [
      { username: 'certifier', password: 'password123', role: 'certifier' },
      { username: 'exporter',  password: 'password123', role: 'exporter' },
      { username: 'carrier',   password: 'password123', role: 'carrier' },
      { username: 'customs',   password: 'password123', role: 'customs' },
      { username: 'retailer',  password: 'password123', role: 'retailer' }
    ]

    default_users.each do |u|
      existing = db.execute('SELECT user_id FROM users WHERE username = ?', [u[:username]]).first
      unless existing
        pwd_hash = hash_password(u[:password])
        db.execute('INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)',
                   [u[:username], pwd_hash, u[:role]])
      end
    end

    # Pre-seed demo coffee item: barcode 5901234123457 (from the UI mockup)
    sample_barcode = '5901234123457'
    item = db.execute('SELECT id FROM items WHERE barcode = ?', [sample_barcode]).first
    unless item
      db.execute('INSERT INTO items (barcode, name, recalled) VALUES (?, ?, 0)',
                 [sample_barcode, 'Highland Arabica Coffee Beans (Lot #402)'])
      item_id = db.last_insert_row_id

      # Per the competition rules (docs/use_cases.txt & README.md):
      # "Certifier (pre-seeded before clock starts) -> exporter -> carrier -> customs -> retailer"
      # The certifier has already issued the origin_proof credential!
      certifier_user = db.execute("SELECT user_id FROM users WHERE role = 'certifier'").first
      certifier_id = certifier_user ? certifier_user['user_id'] : 1

      # Cryptographic root signature for origin_proof
      root_payload = "ITEM:#{item_id}|BARCODE:#{sample_barcode}|MILESTONE:origin_proof|ISSUER:#{certifier_id}"
      root_sig = Digest::SHA256.hexdigest(root_payload)

      db.execute('INSERT INTO credentials (item_id, milestone, issued_by_user_id, signature_hash) VALUES (?, ?, ?, ?)',
                 [item_id, 'origin_proof', certifier_id, root_sig])
    end
  end

  # Resets the demo item back to pre-seeded state (origin_proof only, not recalled)
  # Extremely useful for repetitive pitch presentations and judge demos!
  def self.reset_demo_item!(barcode = '5901234123457')
    db = connection
    item = db.execute('SELECT id FROM items WHERE barcode = ?', [barcode]).first
    return unless item

    item_id = item['id']
    # Clear downstream credentials (keep only origin_proof)
    db.execute("DELETE FROM credentials WHERE item_id = ? AND milestone != 'origin_proof'", [item_id])
    # Clear recall records
    db.execute('DELETE FROM recalls WHERE item_id = ?', [item_id])
    # Reset recalled flag
    db.execute('UPDATE items SET recalled = 0 WHERE id = ?', [item_id])
  end
end
