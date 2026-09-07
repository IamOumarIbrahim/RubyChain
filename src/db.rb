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
        recalled INTEGER DEFAULT 0
      );
      CREATE TABLE IF NOT EXISTS credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER REFERENCES items(id),
        milestone TEXT NOT NULL,
        issued_by_user_id INTEGER,
        signature_hash TEXT NOT NULL
      );
      CREATE TABLE IF NOT EXISTS recalls (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER REFERENCES items(id),
        issued_by_user_id INTEGER,
        reason TEXT
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

    # Pre-seed Coffee Lot #402 without credentials so Certifier initiates the chain live!
    barcode = '5901234123457'
    unless db.execute('SELECT 1 FROM items WHERE barcode = ?', [barcode]).any?
      db.execute('INSERT INTO items (barcode, name, recalled) VALUES (?, ?, 0)',
                 [barcode, 'Highland Arabica Coffee (Lot #402)'])
    end
  end

  def self.reset_demo_item!(barcode = '5901234123457')
    db = connection
    item = db.execute('SELECT id FROM items WHERE barcode = ?', [barcode]).first
    return unless item
    db.execute('DELETE FROM credentials WHERE item_id = ?', [item['id']])
    db.execute('DELETE FROM recalls WHERE item_id = ?', [item['id']])
    db.execute('UPDATE items SET recalled = 0 WHERE id = ?', [item['id']])
  end
end
