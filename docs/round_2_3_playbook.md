# CodeNova 2026: Round 2 & 3 Execution Playbook

This document outlines the tactical execution plan, technical blueprint, deliverables tracker, and pitch cue sheet for **Round 2 (Build Sprint)** and **Round 3 (Pitching & Judgement)**.

---

## Finalized Solution Blueprint: Use Case #4 — Trade & Supply Chain
### *"Provenance as a Credential Chain: Solving the Food Recall Crisis"*
**Strategy:** Hardest Technical Contribution / Highest Score Upside (25 pts Technical + 15 pts Innovation)

### Problem Context & Motivation
- **The FDA Recall Spike:** In August 2026 alone, the FDA issued 26 food recall notices for severe bacterial risks (*Salmonella*, *Listeria*, *E. coli*), with *Salmonella* warnings jumping sixfold.
- **The Category Avoidance Crisis:** According to a national GS1 US survey reported by [Fortune](https://fortune.com/2026/09/02/food-recalls-fda-americans-avoid-food-categories/):
  - **94% of Americans** are concerned about recall frequency.
  - **67% of consumers avoid buying an entire food category** (e.g. boycotting all eggs or all produce) after a single recall alert.
  - **59% discard safe food** even when their state is unaffected, because package lot codes are unreadable or confusing.
  - **66% hesitate** to purchase the brand again.
- **Why This Happens:** As GS1 US stated, *"Consumers are making a category-level decision about a product-level problem."* Middlemen, batch mixing, and repacking disconnect origin data from physical goods. Furthermore, Congress delayed enforcement of the FDA’s Food Traceability Rule to **July 2028**, leaving an urgent gap.
- **Our Fix:** Replace slow paperwork with an unbroken chain of **Verifiable Credentials (VCs)** on the Digital Identity Stack (IDS), featuring selective, instant batch revocation.

---

### 1. Architecture Flow (Chained Handoffs)

```
[Food Safety Certifier / Issuer] 
        │ (Issues Origin Credential with Revocation Enabled)
        ▼
[Exporter / Farm / Holder] 
        │ (Presents Origin Credential)
        ▼
[Carrier / Verifier & Issuer] 
        │ (Verifies Origin + Issues Cold-Chain Custody Credential)
        ▼
[Customs / Verifier & Issuer] 
        │ (Issues Port Clearance Credential)
        ▼
[Retailer Shelf & Consumer QR Code / Verifier]
        │ (Scans QR: displays verified origin, temperature logs, and safety status)
```

---

## 2. Sprint Engineering Philosophy: The Reusable Credential Engine
### *Pre-Built Platform vs. 3-Hour Sprint Configuration*

The core engineering strategy is to treat the competition software not as ad-hoc code written under 180-minute pressure, but as a **reusable, configurable credential workflow engine**.

#### The Core Engine Abstraction
The generic platform understands universal digital identity primitives:
```
[Organization / Node] ──> [Credential Definition] ──> [Issuance] ──> [Verification] ──> [Chained Issuance] ──> [Instant Revocation]
```

On competition day, we do not spend time inventing boilerplate software or scaffolding databases. We spend the 3 hours **instantiating the requested product configuration**:
```
[Certifier Node] ──> [Origin Credential] ──> [Exporter / Farm] ──> [Custody Credential] ──> [Carrier] ──> [Retailer Shelf QR]
```

#### Implementation Division: Engine vs. Configuration

| Phase | Capabilities & Scope | Specific Assets & Components |
| :--- | :--- | :--- |
| **Already Built Before CodeNova**<br>*(The Reusable Platform Engine)* | Complete web infrastructure, cryptographic plumbing, and generic workflows prepared prior to sprint kickoff. | • Full Ruby on Rails application scaffolding<br>• Database models & migrations (ActiveRecord + SQLite)<br>• Universal Credential Issuance service layer<br>• Cryptographic Verification engine<br>• Revocation registry integration (`BitstringStatusList`)<br>• Chained provenance tracking & graph visualizer<br>• Dynamic 2D QR generation & camera scanning flow<br>• Role-based authentication (`Certifier`, `Carrier`, `Retailer`)<br>• Polished Hotwire Turbo Streams UI & dashboards<br>• Demo data seeding engine & scenario loader<br>• IDS Sandbox REST client & webhook receiver<br>• Deployment scripts, error handling, & baseline tests |
| **Configured During the 3 Hours**<br>*(Scenario Instantiation & Pitch)* | Adapting the pre-built engine to the exact competition challenge statement. | • CodeNova-specific Trade & Food Safety scenario<br>• The required 3-link handoff chain<br>• Scenario-specific credential fields (`cold_chain_temp`, `farm_gln`)<br>• Realistic domain branding, packaging copy, & assets<br>• Challenge-specific IDS API sandbox parameters<br>• End-to-end dry run verification & edge case check<br>• Pitch slide alignment & live demo staging |

---

## 3. 3-Hour Build Sprint Strategy (The 3-Link Slice)

- **Pre-seed Link 1:** Pre-generate the Certifier origin credential before sprint start to save development time.
- **Build Link 2:** Carrier custody portal to verify the origin credential and issue a custody credential (`cold_chain_maintained: true`).
- **Build Link 3:** Retailer verification dashboard and consumer-facing shelf QR code.

---

## 4. Schema Specifications

- **`OriginCredential`**:
  - `batch_id`: Unique batch string (e.g., `BATCH-PRODUCE-2026-X8`)
  - `product_name`: String (e.g., `Organic Romaine Lettuce`)
  - `origin_farm`: String (e.g., `Salinas Valley Farm #4`)
  - `certifier_name`: String (e.g., `Food Safety Authority`)
  - `harvest_date`: ISO-8601 timestamp
  - `revocation_enabled`: `true` *(required for instant batch recall)*

- **`CustodyCredential`**:
  - `batch_id`: Matching batch string
  - `carrier_name`: String
  - `cold_chain_temp_celsius`: Number
  - `handoff_timestamp`: ISO-8601 timestamp
  - `verified_origin_hash`: Cryptographic hash reference to `OriginCredential`

---

## 5. Concrete Component Deliverables

- [ ] **Certifier / Recall Console:** Web dashboard listing active food batches with a single-click "Trigger Batch Recall / Revoke" button.
- [ ] **Supply Chain Handoff Desk:** Carrier portal to verify origin credentials and issue custody credentials.
- [ ] **Retailer Shelf Verification View:** Mobile-friendly QR scanner page displaying the full provenance chain: `ORIGIN VERIFIED` → `COLD CHAIN VERIFIED` → `SAFE TO CONSUME`.
- [ ] **Live Demo Climax:** Scan shelf QR showing all-green status; click the Certifier recall button; the customer screen instantly flips to bright red `BATCH RECALLED / DO NOT SELL`.

---

## 6. 3-Hour Build Sprint: 180-Minute Execution Schedule

The 3-hour development sprint covers all 10 competition activities across structured time slots:

| Time Slot | Phase & Activities | Focus & Key Deliverables | Owner Lead |
| :---: | :--- | :--- | :--- |
| **00:00 – 00:20**<br>*(20 min)* | **1. Challenge Understanding & Scoping**<br>• Understanding challenge<br>• Brainstorming<br>• Research | Review the problem statement, confirm finalized scope (Use Case #4: Trade & Food Supply Chain Provenance), check IDS Sandbox docs, and align technical setup. | Oumar (PM) & Mohamad Khairi (Docs) |
| **00:20 – 00:45**<br>*(25 min)* | **2. Product Design**<br>• Product design & architecture<br>• Schema modeling | Finalize credential schemas (`OriginCredential`, `CustodyCredential`) and sketch UI wireframes for Certifier, Carrier, and Shelf QR views. | Mohamad Khairi (Docs) |
| **00:45 – 01:45**<br>*(60 min)* | **3. Core Development**<br>• Coding & development<br>• Platform integration | Spin up pre-built **Ruby on Rails** scaffolding, connect IDS issuance & verification APIs via HTTP client (`Faraday`/`Net::HTTP`), and build real-time reactive views via Hotwire Turbo. | Oumar (PM) |
| **01:45 – 02:15**<br>*(30 min)* | **4. Testing & Debugging**<br>• Testing<br>• Debugging | Run end-to-end flow: Issue Origin VC → Issue Custody VC → Scan QR (`VERIFIED`) → Click Revoke → Re-check status (`RECALLED / DO NOT SELL`). Fix latency and UI bugs. | Oumar (PM) & Mohamad Khairi (Docs) |
| **02:15 – 02:40**<br>*(25 min)* | **5. Documentation**<br>• Technical documentation<br>• Compliance declarations | Finalize technical README, architecture diagram, AI Usage Declaration, and Security/Privacy Declaration; push clean commit to GitHub. | Mohamad Khairi (Docs) |
| **02:40 – 03:00**<br>*(20 min)* | **6. Submission & Pitch Prep**<br>• Final submission<br>• Pitch rehearsal | **Submit all 11 required deliverables before the official deadline** to avoid point deductions; stage live demo screens and rehearse the 3-minute pitch. | Team (Oumar & Mohamad Khairi) |

---

## 7. Round 2 Deliverables Tracker (11 Required Items)

Before the 3-hour deadline, submit all required materials through the organizers' submission portal:

- [ ] 1. **Project / Product Name:** Chosen solution title. *(Owner: Oumar — Project Manager)*
- [ ] 2. **Team Name:** Registered team identifier. *(Owner: Oumar — Project Manager)*
- [ ] 3. **Problem Statement:** Concise summary of FDA food recall panic, category avoidance, and lack of batch-level provenance. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 4. **Solution Description:** Clear explanation of verifiable credentials and instant revocation. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 5. **Prototype / Product Link or File:** Deployed Rails app or easy local run instructions. *(Owner: Oumar — Project Manager)*
- [ ] 6. **Source Code / Repository:** Clean GitHub repository with straightforward setup steps. *(Owner: Oumar — Project Manager)*
- [x] 7. **README or Technical Documentation:** Complete architecture diagram, schema models, and API specifications documented in [docs/technical_documentation.md](file:///c:/Dev/repos/Public%20repos/codenova/docs/technical_documentation.md). *(Owner: Mohamad Khairi — Documentation Lead)*
- [x] 8. **Technology Stack:** Fully documented component-to-tech mapping (Rails + Hotwire + SQLite + Faraday + RQRCode) in [README.md](file:///c:/Dev/repos/Public%20repos/codenova/README.md) and [docs/technical_documentation.md](file:///c:/Dev/repos/Public%20repos/codenova/docs/technical_documentation.md). *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 9. **AI Usage Declaration:** Clear declaration detailing AI tools, prompts, modifications, and human validation. *(Owner: Oumar — Project Manager)*
- [ ] 10. **Security & Privacy Declaration:** Statement ensuring no sensitive PII leakage. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 11. **Additional Materials:** Pitch slide deck and backup 60–90 second demo screen recording. *(Owner: Team)*

> [!IMPORTANT]
> **The submission deadline is absolute.** Submissions received after the official deadline may face point deductions or disqualification. Do not wait until the final minutes to upload files.

---

## 8. Round 3: Pitch Execution Cue Sheet (3–5 Minutes)

Focus on the live functional demo rather than static slides:

| Time | Section | What to Say | What to Show |
| :--- | :--- | :--- | :--- |
| **0:00 – 0:45** | **The Problem** | FDA food recalls are surging (26 in August 2026). 94% of Americans worry about food safety, and 67% avoid entire food categories because paper records can't prove which batch is clean. | Title slide with Fortune article stats and category avoidance impact. |
| **0:45 – 01:15** | **The Solution** | Digital Identity Stack (IDS) with Verifiable Credentials. Every batch has cryptographic origin and cold-chain proof with a real-time revocation registry. | Architecture flow diagram (Certifier → Carrier → Retailer QR). |
| **01:15 – 02:30** | **The Live Demo** | 1. Certifier issues batch credential.<br>2. Carrier logs verified cold custody.<br>3. Shopper scans shelf QR code -> `ORIGIN & COLD CHAIN VERIFIED`.<br>4. Certifier clicks **Recall Batch**.<br>5. Shopper screen immediately flips to **`BATCH RECALLED / DO NOT SELL`**. | Live split-screen demo with phone view and certifier console. |
| **02:30 – 03:00** | **Impact & Close** | Prevents blind consumer panic, saves safe food from being discarded, protects public health, and restores trust in grocers. | Impact metrics, enterprise scalability, and Q&A transition. |

---

## 9. Judging Rubric (100 Points Total)

| Criteria | Weight | Focus Areas |
| :--- | :---: | :--- |
| **Technical Implementation (of IDS)** | **25 pts** | Technical quality, architecture design, proper IDS API integration, and handling complexity. |
| **Problem Identification & Relevance** | **15 pts** | Clear definition and real-world significance of the food recall problem. |
| **Innovation & Creativity** | **15 pts** | Creative approach and differentiation from conventional paper/centralized databases. |
| **Functionality & Demonstration** | **15 pts** | Complete working prototype, reliable live demo, and error handling. |
| **User Experience / Product Design** | **10 pts** | Clean UI, intuitive user journey, and clear status badges. |
| **Impact & Scalability** | **10 pts** | Real-world viability, economic impact, and supply chain scalability. |
| **Pitch & Communication** | **10 pts** | Clear explanation, confident delivery, good pacing, and effective Q&A handling. |

> [!NOTE]
> **Tie-Breaker Order:** (1) Highest Technical Implementation → (2) Highest Innovation & Creativity → (3) Highest Functionality & Demonstration → (4) Judges' Deliberation.
