# CodeNova 2026: Round 2 & 3 Execution Playbook

This document preserves the tactical execution playbook, use cases, deliverables tracker, and pitch cue sheet for **Round 2 (Build Sprint)** and **Round 3 (Pitching & Judgement)** after passing Round 1.

---

## Target Solution Blueprints (Considered Use Cases)

The team is prepared to execute across three primary candidates, chosen based on technical upside vs. 3-hour feasibility:

---

### Candidate 1 (Primary Target): Use Case #4 — Trade & Supply Chain
**"Provenance as a Credential Chain"**  
*Strategy: Hardest Contribution / Highest Technical Score Upside (25 pts Technical + 15 pts Innovation)*

1. **Architecture Flow (Chained Handoffs):**
   ```
   [Certifier / Issuer] 
           │ (Issues Origin Credential)
           ▼
   [Exporter / Holder] 
           │ (Presents Origin Credential)
           ▼
   [Carrier / Verifier & Issuer] 
           │ (Issues Custody Credential)
           ▼
   [Customs / Verifier & Issuer] 
           │ (Issues Clearance Credential)
           ▼
   [Retailer / Final Verifier & Shelf QR]
   ```

2. **3-Hour Build Sprint Strategy (The 3-Link Slice):**
   - **Pre-seed Link 1:** Pre-generate Certifier origin credential prior to sprint start to conserve time.
   - **Build Link 2:** Carrier verify origin + issue custody credential (`temp_threshold_maintained: true`).
   - **Build Link 3:** Retailer verification page + consumer-facing shelf QR code.

3. **Schema Specifications:**
   - `OriginCredential`:
     - `batch_id`: Unique batch string (e.g. `BATCH-COFFEE-2026-X8`)
     - `product_name`: String (e.g. `Organic Arabica Coffee`)
     - `origin_region`: String (e.g. `Sidama, Ethiopia`)
     - `certifier_name`: String
     - `issue_date`: ISO-8601 timestamp
     - `revocation_enabled`: `true` *(required for batch recall)*
   - `CustodyCredential`:
     - `batch_id`: Matching batch string
     - `carrier_name`: String
     - `cold_chain_temp_celsius`: Number
     - `handoff_timestamp`: ISO-8601 timestamp
     - `verified_origin_hash`: Cryptographic reference to Origin Credential

4. **Concrete Component Deliverables:**
   - [ ] **Certifier / Recall Console:** Dashboard showing active batches with a one-click "Trigger Batch Recall / Revoke" button.
   - [ ] **Supply Chain Handoff Desk:** Carrier custody verify-and-issue portal.
   - [ ] **Retailer Shelf Verification View:** Customer/Auditor QR scanner displaying full provenance chain: `ORIGIN VERIFIED` → `COLD CHAIN VERIFIED` → `RELEASED`.
   - [ ] **Live Demo Climax:** Scan shelf QR showing all-green provenance; trigger Certifier recall button; live re-scan immediately flashes red `BATCH RECALLED / DO NOT SELL`.

---

### Candidate 2 (Alternative): Use Case #5 — Logistics & Shipment Coordination
**"The Shipment That Keeps Everyone Waiting"**  
*Strategy: Balanced Delivery / High Real-World Relevance & Intuitive UX (15 pts Functionality + 10 pts UX)*

1. **Architecture Flow:**
   ```
   [Shipper / Issuer] 
           │ (Issues Shipment Dispatch Credential)
           ▼
   [Logistics Provider / Hub Verifier & Updater] 
           │ (Issues Handoff / Status Update Credential)
           ▼
   [Carrier & Warehouse / Verifier]
           │
           ▼
   [Consignee / Delivery Partner Verifier]
   ```

2. **3-Hour Build Sprint Strategy:**
   - 3-link handoff: Shipper dispatch → Hub warehouse transit → Last-mile carrier.
   - Focus on live status propagation: `Scheduled` → `In Transit` → `Delayed` → `Delivered`.

3. **Schema Specifications:**
   - `ShipmentDispatchCredential`:
     - `tracking_id`: Unique shipment identifier (e.g. `SHIP-DXB-8821`)
     - `shipper_name`: String
     - `origin_hub`: String
     - `destination_hub`: String
     - `scheduled_eta`: ISO-8601 timestamp
     - `status`: String (`SCHEDULED`)
   - `ShipmentStatusCredential`:
     - `tracking_id`: Matching identifier
     - `reporting_node`: String (e.g. `Jebel Ali Gateway Hub`)
     - `current_status`: String (`ON_SCHEDULE` | `DELAYED` | `ARRIVED`)
     - `delay_reason`: String (optional)
     - `revised_eta`: ISO-8601 timestamp

4. **Concrete Component Deliverables:**
   - [ ] **Shipper Dispatch Portal:** Issues verifiable shipment credentials on cargo booking.
   - [ ] **Transit Node Console:** Logistics checkpoint reporting dynamic status changes.
   - [ ] **Multi-Partner Unified Dashboard:** Real-time dashboard listening to updates across all stakeholders.
   - [ ] **Live Demo Climax:** Change status from `On Schedule` to `Delayed` at Hub checkpoint; downstream partners receive verified cryptographic alert instantly without email/phone latency.

---

### Candidate 3 (Fallback): Use Case #2 — Business Identity for Banks
**"The Six-Week Onboarding, in Six Seconds"**  
*Strategy: Fastest Execution / Guaranteed Completion under Time Pressure (Chained Issuance Benchmark)*

1. **Architecture Flow:**
   ```
   [Licensing Authority / Issuer] 
           │ (Issues Registered Business Credential)
           ▼
   [Corporate Wallet / Holder] 
           │ (Presents Registered Business Credential)
           ▼
   [Bank / Verifier & Secondary Issuer] 
           │ (Verifies License -> Issues Verified Corporate Account Credential)
           ▼
   [Supplier / Processor / Final Verifier] (Extends Net-30 terms based on bank attestation)
   ```

2. **3-Hour Build Sprint Strategy:**
   - 3 tenants, 2 schemas, 2 issuances, 2 verifications.
   - Business represented by holder web wallet.

3. **Schema Specifications:**
   - `BusinessLicenseCredential`:
     - `trade_license_no`: String
     - `company_name`: String
     - `jurisdiction`: String
     - `activity_type`: String
     - `issue_date`: ISO-8601 timestamp
   - `CorporateBankAccountCredential`:
     - `trade_license_no`: String
     - `bank_name`: String
     - `iban`: String
     - `kyb_status`: String (`VERIFIED`)
     - `credit_tier`: String (`TIER_1`)
     - `attestation_date`: ISO-8601 timestamp

4. **Concrete Component Deliverables:**
   - [ ] **Licensing Authority Portal:** Issues trade license credential.
   - [ ] **Corporate Wallet:** Holds license & bank credentials.
   - [ ] **Bank Onboarding Desk:** One-click license verification + auto-issue corporate account credential.
   - [ ] **Supplier Credit Portal:** Verifies bank attestation and approves net-30 terms instantly.
   - [ ] **Live Demo Climax:** Supplier approves credit line in 5 seconds having never inspected the raw trade license.

---

### Candidate 4 (Archived Reference): Use Case #3 — Cross-Border Professional Licensing
**"The Nurse Who Cannot Work"**  
*Strategy: Single-Credential with Instant Revocation Registry*

1. **Architecture Flow:**
   Regulator (Issuer / Revoker) → Professional Wallet (Holder) → Employer Portal (Verifier).

2. **Schema Specification:**
   - `practitioner_id`: Unique license string
   - `practitioner_name`: Full legal name
   - `profession`: e.g., "Registered Nurse (RN)"
   - `issuing_authority`: e.g., "Health Regulators Authority"
   - `issue_date`: ISO-8601 timestamp
   - `revocation_enabled`: `true` *(non-negotiable: must be enabled at definition creation)*

3. **Concrete Component Deliverables:**
   - [ ] **Regulator Portal:** Dashboard to issue license credentials and a one-click "Revoke License" action.
   - [ ] **Professional Wallet:** Mobile/web holder interface displaying active verifiable credential.
   - [ ] **Employer Verifier Portal:** Verification desk requesting proof; renders real-time badges: `VERIFIED` vs `DENIED`.

---

## 3-Hour Build Sprint: Execution Playbook (180-Minute Time Slots)

The 3-hour development sprint accommodates all 10 required competition activities across structured time slots:

| Time Slot | Phase & Activities Covered | Operational Focus & Deliverables | Owner Lead |
| :---: | :--- | :--- | :--- |
| **00:00 – 00:20**<br>*(20 min)* | **1. Challenge Understanding & Scoping**<br>• Understanding the challenge<br>• Brainstorming<br>• Research | Review official problem statement, confirm selected candidate scope (Use Case #4, #5, or #2), consult IDS Sandbox documentation, and align technical constraints. | Oumar (PM) & Mohamad Khairi (Docs) |
| **00:20 – 00:45**<br>*(25 min)* | **2. Product Design**<br>• Product design & architecture<br>• Schema modeling | Finalize credential definition schema and sketch UI wireframes for Issuer, Holder, and Verifier screens. | Mohamad Khairi (Docs) |
| **00:45 – 01:45**<br>*(60 min)* | **3. Core Development**<br>• Coding / development<br>• Platform integration | Spin up pre-built **Ruby on Rails** scaffolding, integrate IDS issuance & verification APIs via HTTP client (`Faraday`/`Net::HTTP`), and build real-time reactive views via Hotwire Turbo. | Oumar (PM) |
| **01:45 – 02:15**<br>*(30 min)* | **4. Testing & Debugging**<br>• Testing<br>• Debugging | Execute end-to-end verification pass: Issue → Store in Wallet → Verify (`VERIFIED`) → Trigger State Change / Revocation → Re-verify (`RECALLED` / `DELAYED` / `DENIED`). Fix latency and runtime bugs. | Oumar (PM) & Mohamad Khairi (Docs) |
| **02:15 – 02:40**<br>*(25 min)* | **5. Documentation**<br>• Documentation<br>• Compliance declarations | Complete technical README, architecture breakdown, finalize AI Usage & Security/Privacy declarations, push clean commit to GitHub. | Mohamad Khairi (Docs) |
| **02:40 – 03:00**<br>*(20 min)* | **6. Submission & Pitch Preparation**<br>• Final submission<br>• Pitch preparation | **Submit all 11 required deliverables before the official deadline** (avoid late penalties); stage live demo screens and rehearse 3-min pitch flow. | Team (Oumar & Mohamad Khairi) |

---

## Round 2 Deliverables Tracker (11 Required Items)

Before the 3-hour deadline, every team must submit its final project through the submission mechanism specified by the organizers. The submission should contain, where applicable:

- [ ] 1. **Project / Product Name:** Chosen solution title. *(Owner: Oumar — Project Manager)*
- [ ] 2. **Team Name:** Registered team identifier. *(Owner: Oumar — Project Manager)*
- [ ] 3. **Problem Statement:** Concise summary of the addressed supply chain, logistics, or KYB friction. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 4. **Solution Description:** Technical summary of verifiable credential flow. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 5. **Prototype / Product Link or File:** Deployed Rails web interface or local executable instructions. *(Owner: Oumar — Project Manager)*
- [ ] 6. **Source Code / Repository:** Clean GitHub repository with setup instructions. *(Owner: Oumar — Project Manager)*
- [ ] 7. **README or Technical Documentation:** System architecture, component map, and API documentation. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 8. **Technology Stack:** Ruby on Rails (Ruby 4.0+), Hotwire (Turbo Streams / Stimulus) for live badge flips, SQLite/PostgreSQL, IDS Sandbox REST APIs *(Fallback: Python with FastAPI/Flask or C++ for standalone cryptographic modules)*. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 9. **AI Usage Declaration:** Pre-drafted declaration detailing AI tools, modifications, and validation. *(Owner: Oumar — Project Manager)*
- [ ] 10. **Security & Privacy Declaration:** Data handling statement ensuring no sensitive PII leakage. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 11. **Any additional materials requested by the organizers:** Pitch slides and backup 60-90s demo recording link. *(Owner: Team)*

> [!IMPORTANT]
> **The submission deadline is absolute.** Submissions received after the official deadline may be penalized with point deductions, considered incomplete, or disqualified by the organizing committee. Avoid waiting until the final minutes to submit.

---

## Round 3: Pitch Execution Cue Sheet (3–5 Minutes)

Prioritize the live functional demonstration over static slides:

| Elapsed Time | Section | Key Points to Cover | Screen State |
| :--- | :--- | :--- | :--- |
| **0:00 – 0:45** | **The Problem** | Relocating nurses/professionals face 9-month credential backlogs; paper certs cannot be revoked instantly across borders. | Title & Problem Slide |
| **0:45 – 01:15** | **The Solution** | Verifiable credentials on the Digital ID Stack with real-time cryptographic revocation registry. | Architecture Overview Slide |
| **01:15 – 02:30** | **The Live Demo** | 1. Regulator issues credential.<br>2. Candidate accepts in wallet.<br>3. Employer verifies instantly -> `VERIFIED`<br>4. Regulator clicks **Revoke**.<br>5. Employer re-checks -> badge flips to `DENIED`. | Live Split-Screen Demo |
| **02:30 – 03:00** | **Impact & Close** | Global portability, enterprise scalability, fraud prevention; transition to judges' Q&A. | Impact & Team Slide |

---

## Judging Rubric (100 Points Total)

| Criteria | Weight | Focus Areas |
| :--- | :---: | :--- |
| **Technical Implementation (of IDS)** | **25 pts** | Technical quality, system architecture, proper tool/API/IDS integration, execution complexity. |
| **Problem Identification & Relevance** | **15 pts** | Clarity, depth, and significance of the problem addressed. |
| **Innovation & Creativity** | **15 pts** | Originality of approach, creativity, differentiation from existing solutions. |
| **Functionality & Demonstration** | **15 pts** | Working completeness of prototype, reliable live demo, test coverage. |
| **User Experience / Product Design** | **10 pts** | Intuitive UX/UI, user journey clarity, accessibility. |
| **Impact & Scalability** | **10 pts** | Real-world viability, scalability, target market impact. |
| **Pitch & Communication** | **10 pts** | Clarity, pacing, time management, effective handling of Q&A. |

> [!NOTE]
> **Tie-Breaker Order:** (1) Highest Technical Implementation → (2) Highest Innovation & Creativity → (3) Highest Functionality & Demonstration → (4) Final Judges' Deliberation.
