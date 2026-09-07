<div align="center">

# RubyChain 💎

### Verifiable Supply Chain Provenance & Instant Circuit-Breaker Recalls
**Built for CodeNova 2026 — IEEE SIU Dubai Student Branch × IDS**

[![Ruby](https://img.shields.io/badge/Ruby-4.0.6-CC0000?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![SQLite](https://img.shields.io/badge/Database-SQLite3-003B57?logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![Server](https://img.shields.io/badge/Server-WEBrick-lightgrey)](https://github.com/ruby/webrick)
[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
[![Test Suite](https://img.shields.io/badge/Tests-Passing%20100%25-brightgreen)](test/chain_test.rb)

![RubyChain Banner](assets/branding/branding/HeroBanner.png)

</div>

> [!TIP]
> **CodeNova 2026 Challenge Showcase**: A complete, low-abstraction web application designed to be reproducible from scratch in under 3 hours. It can be accessed instantly from an iPhone or mobile browser using the device's camera to scan physical package QR codes.

---

## ⚡ Quickstart (Run in 1 Command)

No complex containers or dependency builds needed!

```bash
# 1. Clone repository
git clone https://github.com/IamOumarIbrahim/RubyChain.git
cd RubyChain

# 2. Run the application (Ruby 4+ with sqlite3 and webrick gems)
ruby src/main.rb
```

On launch, the server spins up dual HTTP and HTTPS listeners:
* **Local Desktop:** `http://localhost:4567`
* **iPhone Safari (HTTP):** `http://<your-local-ip>:4567`
* **iPhone Safari Live Camera (HTTPS):** `https://<your-local-ip>:8443` *(Recommended for real-time video stream! Accept self-signed cert on first load)*
* **Demo Packaging Sheet:** `http://localhost:4567/assets/demo_barcodes/print_sheet.html`

Run the automated test suites:
```bash
ruby test/chain_test.rb  # Core cryptographic chain tests
ruby test/api_test.rb    # HTTP REST API integration tests
```

---

## 📱 Live iPhone Demonstration

<div align="center">
  <img src="assets/branding/ui/Mockup.png" width="680" alt="RubyChain iPhone UI">
</div>

1. **Open on iPhone Safari:** Navigate to `http://<your-ip>:4567`.
2. **Point at Coffee Package:** Point camera at the QR code on the packaging sheet.
3. **Step Through the Chain:**
   * **Exporter:** Verifies pre-seeded *Certifier* pass &rarr; Issues **Transit Pass**.
   * **Customs:** Checks dual passes (*Origin* + *Transit*) &rarr; Issues **Border Clearance**.
   * **Retailer:** Checks full 3-step chain &rarr; Puts on shelf (*All green: Chain Intact*).
4. **The Demo Moment (Recall):** Click **Recall** &rarr; **Confirm**.
   * The shelf status immediately flips to **Broken** in bold crimson!
   * Cashier checkout and border clearance are locked out globally within 200ms.

---

## 🔗 How the Chain Works

```text
[ Certifier ] ──(origin_proof)──> [ Exporter ] ──(transit_proof)──> [ Customs ] ──(border_proof)──> [ Retailer ] ──(shelf_proof)
```

1. **Certifier** *(Pre-seeded)*: Validates organic origin and issues root cryptographic pass.
2. **Exporter** *(Step 1)*: Verifies origin credential before accepting custody; issues transit pass.
3. **Carrier** *(Step 2)*: Verifies transit paperwork before loading onto freight vessel.
4. **Customs** *(Step 3)*: Checks dual passes (*Certifier* & *Carrier*) before border entry.
5. **Retailer** *(Step 4)*: Verifies all three prior passes; ensures zero active recall alerts.
6. **Recall Circuit-Breaker**: Any authorized node can trigger a recall, breaking the chain instantaneously.

---

## 🗄️ Database Architecture (`docs/schemas.xlsx`)

Built with pure SQLite3 using normalized, low-abstraction relational tables:
* **`users`**: Role-based access (`certifier`, `exporter`, `carrier`, `customs`, `retailer`).
* **`items`**: Shipment registry with `barcode`, product metadata, and `recalled` flag.
* **`credentials`**: Cryptographic provenance milestones (`origin_proof`, `transit_proof`, `border_proof`, `shelf_proof`) with SHA-256 parent-hashed signatures.
* **`recalls`**: Immutable audit logs of batch recall actions.

---

## 📂 Project Structure

```text
RubyChain/
├── assets/
│   ├── branding/           # Logos, icons, UI mockups
│   └── demo_barcodes/      # Printable coffee packaging label sheet & SVG/PNG QR codes
├── docs/                   # CodeNova 2026 Rubric Documentation (100 Points)
│   ├── problem.md          # Problem Identification & Relevance (15 pts)
│   ├── innovation.md       # Innovation & Creativity (15 pts)
│   ├── implementation.md   # Technical Implementation & IDS Integration (25 pts)
│   ├── demo.md             # Functionality & Live Demonstration (15 pts)
│   ├── ui.md               # User Experience & Product Design (10 pts)
│   ├── impact.md           # Impact, FDA FSMA 204 & Scalability (10 pts)
│   └── pitch.md            # 3-Minute Pitch Script & Judge Q&A Defense (10 pts)
├── public/                 # Responsive Mobile Web Interface
│   ├── index.html          # iPhone UI layout
│   ├── style.css           # Crimson branding & mobile styling
│   ├── app.js              # State management & camera scanner
│   └── vendor/jsqr.js      # Zero-dependency offline QR decoder
├── src/                    # Clean, Low-Abstraction Ruby Core
│   ├── db.rb               # SQLite database setup & seed engine
│   ├── certifier.rb        # Node 0: Origin proof authority
│   ├── exporter.rb         # Node 1: Exporter custody pass
│   ├── carrier.rb          # Node 2: Carrier transport attestation
│   ├── customs.rb          # Node 3: Border clearance dual-pass
│   ├── retailer.rb         # Node 4: Full chain retail shelf pass
│   ├── recall.rb           # Circuit-breaker recall procedure
│   └── main.rb             # WEBrick application server & REST APIs
├── test/                   # Automated Verification Suites
│   ├── chain_test.rb       # Unit tests for cryptographic chain logic
│   └── api_test.rb         # HTTP REST API integration tests
└── README.md
```

---

## 🏆 Competition Rubric Mapping (100 Points)

| Rubric Category | Weight | Documentation Link |
| :--- | :---: | :--- |
| **Problem Identification & Relevance** | 15 | [docs/problem.md](docs/problem.md) |
| **Innovation & Creativity** | 15 | [docs/innovation.md](docs/innovation.md) |
| **Technical Implementation (IDS)** | 25 | [docs/implementation.md](docs/implementation.md) |
| **Functionality & Demonstration** | 15 | [docs/demo.md](docs/demo.md) |
| **User Experience / Product Design** | 10 | [docs/ui.md](docs/ui.md) |
| **Impact & Scalability** | 10 | [docs/impact.md](docs/impact.md) |
| **Pitch & Communication** | 10 | [docs/pitch.md](docs/pitch.md) |
| **TOTAL** | **100** | **Ready for Evaluation** |

---

## 👥 Team Members

1. **Oumar Mamoun Ibrahim:** Team Leader
   - [![ORCID](https://img.shields.io/badge/ORCID-0009--0008--0312--1605-A6CE39?logo=orcid&logoColor=white)](https://orcid.org/0009-0008-0312-1605) [![IEEE](https://img.shields.io/badge/IEEE-Member-00629B?logo=ieee&logoColor=white)](https://www.ieee.org/)
   - Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae) | Phone: [+971 56 632 6900](tel:+971566326900)
2. **Mohamad Khairi Bin Ishak**
3. **Nameer Anwar**
   - Email: [nameeranwar@yahoo.com](mailto:nameeranwar@yahoo.com) | Phone: [+971 56 959 5743](tel:+971569595743)
4. **Aqsa Khan**
