# Technical Implementation & IDS Integration (25 Points)

## 1. System Architecture
RubyChain is engineered as a clean, low-abstraction web application powered by **Ruby (v4.0.6)**, **SQLite3**, and **WEBrick**, completely free of cumbersome framework boilerplate.

```text
┌─────────────────────────────────────────────────────────────┐
│                    Mobile Web Interface                     │
│    (iPhone Safari / Responsive Web: HTML5, CSS3, jsQR)      │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTPS / JSON REST API
┌──────────────────────────────▼──────────────────────────────┐
│                  WEBrick Server (src/main.rb)               │
│          Routing, JSON Parsing, Static Asset Delivery       │
└──────────────────────────────┬──────────────────────────────┘
                               │
       ┌───────────────────────┼───────────────────────┐
       ▼                       ▼                       ▼
┌──────────────┐       ┌──────────────┐       ┌────────────────┐
│  Auth Engine │       │ Chain Engine │       │ Recall Manager │
│  (Pass-hash) │       │ (Verify/Iss) │       │ (CircuitBreak) │
└──────┬───────┘       └───────┬──────┘       └───────┬────────┘
       │                       │                      │
       └───────────────────────┼──────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 SQLite3 Database (rubychain.db)             │
│            users  •  items  •  credentials  •  recalls      │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Database Schema (Adhering to `docs/schemas.xlsx`)

### `users`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `user_id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique user identifier |
| `username` | TEXT | UNIQUE, NOT NULL | Login handle (e.g. `carrier`, `retailer`) |
| `password_hash`| TEXT | NOT NULL | Salted SHA-256 hash |
| `role` | TEXT | NOT NULL | `certifier`, `exporter`, `carrier`, `customs`, `retailer` |
| `created_at` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Registration timestamp |

### `items`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Internal item index |
| `barcode` | TEXT | UNIQUE, NOT NULL | GTIN barcode string (e.g. `5901234123457`) |
| `name` | TEXT | NOT NULL | Product description (e.g. Arabica Lot #402) |
| `recalled` | INTEGER | DEFAULT 0 | 0 = Safe/Intact, 1 = Recalled/Broken |
| `created_at` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Registration timestamp |

### `credentials`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Credential identifier |
| `item_id` | INTEGER | REFERENCES items(id) | Target shipment batch |
| `milestone` | TEXT | NOT NULL | `origin_proof`, `transit_proof`, `border_proof`, `shelf_proof` |
| `issued_by_user_id`| INTEGER | REFERENCES users(user_id) | Signing actor |
| `signature_hash` | TEXT | NOT NULL | SHA-256 cryptographic proof |
| `created_at` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Issuance timestamp |

### `recalls`
| Column | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | INTEGER | PRIMARY KEY AUTOINCREMENT | Audit log identifier |
| `item_id` | INTEGER | REFERENCES items(id) | Target shipment batch |
| `issued_by_user_id`| INTEGER | REFERENCES users(user_id) | Revoking authority |
| `reason` | TEXT | NULLABLE | Detailed justification |
| `created_at` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Revocation timestamp |

---

## 3. Cryptographic Chain Mechanics
Every stage of the supply chain validates the mathematical signature of the previous milestone before signing its own:

1. **Certifier Root (`origin_proof`):**
   $$\text{Hash}_0 = \text{SHA256}(\text{"ITEM:"} + \text{id} + \text{"|BARCODE:"} + \text{code} + \text{"|MILESTONE:origin\_proof|ISSUER:"} + \text{uid}_0)$$
2. **Exporter Custody (`transit_proof`):**
   $$\text{Hash}_1 = \text{SHA256}(\text{"PREV:"} + \text{Hash}_0 + \text{"|ITEM:"} + \text{id} + \text{"|MILESTONE:transit\_proof|ISSUER:"} + \text{uid}_1)$$
3. **Customs Clearance (`border_proof`):**
   $$\text{Hash}_2 = \text{SHA256}(\text{"PREV:"} + \text{Hash}_1 + \text{"|ITEM:"} + \text{id} + \text{"|MILESTONE:border\_proof|ISSUER:"} + \text{uid}_2)$$
4. **Retailer Shelf (`shelf_proof`):**
   $$\text{Hash}_3 = \text{SHA256}(\text{"PREV:"} + \text{Hash}_2 + \text{"|ITEM:"} + \text{id} + \text{"|MILESTONE:shelf\_proof|ISSUER:"} + \text{uid}_3)$$

If any parameter or prior certificate is tampered with, the cryptographic link fails validation immediately.

---

## 4. IDS Integration (Digital Identity Stack)
RubyChain maps directly to the core tenets of the **Identity Digital Stack (IDS)**:
* **Decentralized Verifiable Credentials (W3C VC):** The Certifier acts as the Issuer; the shipment container acts as the Subject/Holder; Exporter, Customs, and Retailer act as Verifiers and subsequent Sub-Issuers.
* **Trust Registry & Schema Definition:** Milestones are strictly typed against schemas specified in `docs/schemas.xlsx`.
* **Zero-Knowledge Principle & Need-to-Know:** Customs clears the border by verifying transit compliance without needing to expose private financial contracts between the exporter and foreign buyer.
* **Instant Revocation:** Utilizes active status lists equivalent to the IDS Revocation Registry standard.

---

## 5. 3-Hour Hackathon Feasibility
Why this technical architecture scores maximum points:
1. **Single Language (Pure Ruby):** No context switching between languages, build tools, or complex transpilations.
2. **Standard Library Leverage:** Uses Ruby's built-in `webrick`, `digest`, and `json`, plus the official `sqlite3` gem.
3. **Zero Configuration Deployment:** Zero Docker overhead; starts instantly on Windows, macOS, or Linux.