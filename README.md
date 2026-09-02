# CodeNova 2026: The Code-to-Product Challenge

> **Organized by:** IEEE Symbiosis International University – Dubai Student Branch  
> **In Collaboration With:** IDS (International Digital Systems)

> [!TIP]
> **Registration Form**  
> [Submit your registration here](https://docs.google.com/forms/d/e/1FAIpQLSczWiVZIlIVd7nf-bivuWyLeuXc1LfHW_UJx3iR1PuMCTMXYA/viewform?pli=1)  
> *Note: Registration must be submitted by the Team Leader.*

> [!TIP]
> **Official Rulebook & Challenge Resources**  
> [Download official rulebook & use cases package](docs/rules.zip)

---

## Quick Status & Project Focus

- **Selected Challenge:** **Use Case #3 — Cross-Border Professional Licensing & Instant Revocation**
- **Core Value:** Eliminate multi-month licensing backlogs for relocating healthcare and technical professionals using verifiable credentials with cryptographic real-time revocation.
- **Key Demo Moment:** Instant status flip from ![Status: VERIFIED](https://img.shields.io/badge/Status-VERIFIED-2ea44f?style=flat-square) to ![Status: DENIED](https://img.shields.io/badge/Status-DENIED-d73a49?style=flat-square) upon live regulator revocation.
- **Current Phase:** ![Phase: Weekend 1 Scoping](https://img.shields.io/badge/Phase-Weekend_1_Scoping-0969da?style=flat-square) — Scoping, Environment Setup, and Schema Definition.

---

## Table of Contents
- [Quick Status & Project Focus](#quick-status--project-focus)
- [Target Solution Blueprint: Use Case #3](#target-solution-blueprint-use-case-3)
- [3-Hour Build Sprint: Execution Playbook](#3-hour-build-sprint-execution-playbook)
- [Round 2 Deliverables Tracker (11 Required Items)](#round-2-deliverables-tracker-11-required-items)
- [Round 3: Pitch Execution Cue Sheet (3–5 Minutes)](#round-3-pitch-execution-cue-sheet-35-minutes)
- [Key Event Details](#key-event-details)
- [Prizes & Industry Perks](#prizes--industry-perks)
- [Competition Format (3 Progressive Rounds)](#competition-format-3-progressive-rounds)
- [Official Challenge Use Cases (Digital ID Stack)](#official-challenge-use-cases-digital-id-stack)
- [Judging Rubric (100 Points Total)](#judging-rubric-100-points-total)
- [Key Rules & Policies](#key-rules--policies)
- [Team Details](#team-details)
- [CodeNova 2026 Prep Schedule](#codenova-2026-prep-schedule)
- [Support Contacts](#support-contacts)

---

## Target Solution Blueprint: Use Case #3

### 1. Architecture Flow
Regulator (Issuer / Revoker) -> Professional Wallet (Holder) -> Employer Portal (Verifier).

### 2. Schema Specification
- `practitioner_id`: Unique license string
- `practitioner_name`: Full legal name
- `profession`: e.g., "Registered Nurse (RN)"
- `issuing_authority`: e.g., "Health Regulators Authority"
- `issue_date`: ISO-8601 timestamp
- `revocation_enabled`: `true` *(non-negotiable: must be enabled at definition creation)*

### 3. Concrete Component Deliverables
- [ ] **Regulator Portal:** Dashboard to issue license credentials and a one-click "Revoke License" action.
- [ ] **Professional Wallet:** Mobile/web holder interface displaying the active verifiable credential with QR proof generation.
- [ ] **Employer Verifier Portal:** Verification desk requesting proof and rendering real-time validation badges: ![Status: VERIFIED](https://img.shields.io/badge/Status-VERIFIED-2ea44f?style=flat-square) vs ![Status: DENIED](https://img.shields.io/badge/Status-DENIED-d73a49?style=flat-square).

---

## 3-Hour Build Sprint: Execution Playbook

Strict minute-by-minute execution timeline for event day (Round 2):

| Time Window | Focus Block | Action Items |
| :--- | :--- | :--- |
| **00:00 – 00:30** | **Bootstrap & Schemas** | Deploy pre-built scaffolding, initialize credential definitions with revocation enabled, bind environment variables. |
| **00:30 – 01:30** | **Core Logic & Revocation** | Connect issuance endpoint, implement wallet QR presentation, code live websocket/polling revocation status listener. |
| **01:30 – 02:15** | **End-to-End Verification** | Execute full happy-path: Issue -> Store in Wallet -> Employer Verifies (![Status: VERIFIED](https://img.shields.io/badge/Status-VERIFIED-2ea44f?style=flat-square)). Trigger revoke -> Employer re-verifies (![Status: DENIED](https://img.shields.io/badge/Status-DENIED-d73a49?style=flat-square)). |
| **02:15 – 02:45** | **Submission Packaging** | Finalize all 11 required submission items, push clean repo commit, record URLs. |
| **02:45 – 03:00** | **Pitch Demo Rehearsal** | Stage the live screens, test offline fallbacks, submit before the countdown hits zero. |

---

## Round 2 Deliverables Tracker (11 Required Items)

All items must be packaged and submitted prior to the 3-hour deadline:

- [ ] 1. **Project & Product Name:** Chosen solution title. *(Owner: Oumar — Project Manager)*
- [ ] 2. **Team Name:** Registered team identifier. *(Owner: Oumar — Project Manager)*
- [ ] 3. **Problem Statement:** Concise summary of the cross-border licensing delay. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 4. **Solution Description:** Technical summary of verifiable credential flow. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 5. **Prototype / Product Link:** Deployed web interface or local executable instructions. *(Owner: Oumar — Project Manager)*
- [ ] 6. **Source Code Repository:** Clean GitHub repository with installation instructions. *(Owner: Oumar — Project Manager)*
- [ ] 7. **Technical README:** System architecture, component map, and API documentation. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 8. **Technology Stack:** Languages, frameworks, IDS Sandbox endpoints used. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 9. **AI Usage Declaration:** Pre-drafted declaration detailing AI tools, modifications, and validation. *(Owner: Oumar — Project Manager)*
- [ ] 10. **Security & Privacy Declaration:** Data handling statement ensuring no sensitive PII leakage. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 11. **Supplemental Materials:** Pitch slides and fallback 60-90s demo recording link. *(Owner: Team)*

---

## Round 3: Pitch Execution Cue Sheet (3–5 Minutes)

Prioritize the live functional demonstration over static slides:

| Elapsed Time | Section | Key Points to Cover | Screen State |
| :--- | :--- | :--- | :--- |
| **0:00 – 0:45** | **The Problem** | Relocating nurses/professionals face 9-month credential backlogs; paper certs cannot be revoked instantly across borders. | Title & Problem Slide |
| **0:45 – 01:15** | **The Solution** | Verifiable credentials on the Digital ID Stack with real-time cryptographic revocation registry. | Architecture Overview Slide |
| **01:15 – 02:30** | **The Live Demo** | 1. Regulator issues credential.<br>2. Candidate accepts in wallet.<br>3. Employer verifies instantly -> ![Status: VERIFIED](https://img.shields.io/badge/Status-VERIFIED-2ea44f?style=flat-square)<br>4. Regulator clicks **Revoke**.<br>5. Employer re-checks -> badge flips to ![Status: DENIED](https://img.shields.io/badge/Status-DENIED-d73a49?style=flat-square). | Live Split-Screen Demo |
| **02:30 – 03:00** | **Impact & Close** | Global portability, enterprise scalability, fraud prevention; transition to judges' Q&A. | Impact & Team Slide |

---

## Key Event Details

| Event | Date & Time | Mode / Location |
| :--- | :--- | :--- |
| **Pre-Orientation Session** | Friday, 18 September 2026<br>`10:00 AM – 12:00 PM` | Online (IDS Concept Briefing & Platform Overview) |
| **Main Hackathon** | Tuesday, 22 September 2026<br>`09:00 AM – 04:00 PM` | Block 14, Dubai Knowledge Park, Symbiosis International University, Dubai (In-Person) |

- **Entry:** **Free** (Limited capacity; Team Leader must hold an active [IEEE](https://www.ieee.org/) membership).
- **Core Philosophy:** `LEARN → THINK → BUILD → DEMONSTRATE → PITCH`

---

## Prizes & Industry Perks

### Cash Awards ($1,000 USD Pool)
- **Winner:** $500
- **1st Runner-up:** $300
- **2nd Runner-up:** $200  
*(Prize distribution structure subject to final confirmation by the Organizing Committee)*

### Industry & Technical Perks
- **Internship Opportunities:** Standout performers evaluated directly for internship positions at IDS.
- **Hands-on Mentoring:** Technical guidance, expert sessions, and access to the IDS Sandbox.
- **Patent & IP Support:** Guidance on intellectual property protection and commercialization feasibility.

---

## Competition Format (3 Progressive Rounds)

| Round | Stage | Format | Outcome / Timing |
| :---: | :--- | :--- | :--- |
| **1** | **Knowledge Challenge** | Online MCQ Quiz (Kahoot / Quizizz / Google Forms) covering IDS pre-orientation concepts, tech fundamentals & problem-solving. | **Top 20 Teams Qualify**<br>*(Qualification only; score does not carry forward)* |
| **2** | **The Build Sprint** | 3-Hour Rapid Product Development Sprint based on selected verifiable credential use cases. | Working prototype, source repo & technical submission |
| **3** | **Pitch & Judgement** | 3–5 min Product Demonstration + Pitch + Q&A with judging panel. | Final 100-pt scoring & winners announced |

---

## Official Challenge Use Cases (Digital ID Stack)

The build sprint centers on **chained issuance and verification** using verifiable credentials. Teams can implement one of the 5 official scenarios or an equivalent use case:

| # | Scenario | Core Problem | Issuance & Verification Chain |
| :-: | :--- | :--- | :--- |
| **1** | **The Airport Corridor** | Redundant manual ID & passport checks across 5 transit touchpoints. | Airline (issuer) → Passenger Wallet → Security, Lounge, Gate, Customs, Baggage (5 selective verifiers). |
| **2** | **Business Identity (KYB)** | Multi-week manual corporate onboarding for bank accounts & trade terms. | Licensing Authority → Business → Bank (verifier & issuer) → Supplier / Processor (verifier). |
| **3** | **Cross-Border Licensing** | Months-long credential validation backlog for relocating professionals. | Regulator (issuer & revoker) → Professional → Employer & Platform (verifiers). |
| **4** | **Trade & Supply Chain** | Tamper-prone paper certificates for origin & cold-chain compliance. | Certifier → Exporter → Carrier → Customs → Retailer (*verify-then-issue* chain). |
| **5** | **Logistics Coordination** | Unscheduled delivery delays causing cascading warehouse congestion. | Shipper → Logistics Provider → Warehouse → Carrier → Delivery Partner. |

### 3-Hour Sprint Slices & Demo Moments

1. **The Airport Corridor (One Card, Five Desks)**
   - **Scope:** 1 schema, 1 issuance, 5 verifier views (each requesting minimal necessary claims via pre-built proof requests).
   - **Demo Moment:** Walk through 5 desks in 90 seconds; highlight the disclosure map showing selective disclosure (e.g. baggage claim verifies bag tag ownership without seeing passenger name).

2. **Business Identity for Banks (6-Week KYB in 6 Seconds)**
   - **Scope:** 3 tenants, 2 schemas, 2 issuances, 2 verifications (business represented via mobile wallet).
   - **Demo Moment:** Supplier extends net-30 credit having never seen the raw trade licence, relying solely on the bank's verified attestation.
   - **Advantage:** Demonstrates chained issuance (*one credential earns the next*), a highly weighted platform capability.

3. **Cross-Border Professional Licensing (Instant Trust & Revocation)**
   - **Scope:** License schema with revocation enabled at definition creation + Employer verify portal + Regulator revoke action.
   - **Demo Moment:** Verify candidate → revoke license live from regulator console → re-check instantly flips status to ![Status: DENIED](https://img.shields.io/badge/Status-DENIED-d73a49?style=flat-square).

4. **Trade & Supply Chain (Provenance as a Credential Chain)**
   - **Scope:** Cut to 3 chain links and pre-seed initial credentials before the clock starts.
   - **Demo Moment:** Scan shelf QR to view unbroken provenance; revoke batch credential to trigger instant shelf-status alert.
   - *Risk Flag:* High complexity — recommended for advanced teams only.

5. **Logistics & Shipment Coordination (Verified Real-Time Handoffs)**
   - **Scope:** 3 partner links with a dashboard tracking *Scheduled*, *In Transit*, *Delayed*, and *Delivered*.
   - **Demo Moment:** Switch shipment to "Delayed" and demonstrate downstream partners immediately receiving the verified update.

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

---

## Key Rules & Policies

- **Team Composition:** 1–4 members. Each team must designate one leader with an active IEEE membership who submits registration. No member additions, swaps, or transfers are permitted once the event starts.
- **AI Policy:** AI tools are permitted where disclosed; teams must submit an **AI Usage Declaration**. AI assistance does not replace understanding, testing, and presenting the codebase.
- **Intellectual Property (IP):** Teams retain ownership of their original IP created during the hackathon. All third-party libraries and assets must respect their open-source licenses.
- **Security & Responsible Tech:** Zero tolerance for attacks on competition infrastructure, network disruption, tampering with other teams' work, or credential/data theft.
- **Participant Checklist (Bring to Venue):**
  - [x] Laptop with charger
  - [x] Pre-installed IDEs, compilers, libraries, and runtimes (avoid relying solely on venue Wi-Fi)
  - [x] Pre-registered accounts for necessary development platforms / APIs
  - [x] Valid IEEE Member ID for the Team Leader

---

## Team Details

- **Oumar Mamoun Ibrahim:** Team Leader & Project Manager
  - University Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae)
  - Primary Contact: [omarbenzema50@gmail.com](mailto:omarbenzema50@gmail.com)
  - Phone: [+971 56 632 6900](tel:+971566326900)
- **Mohamad Khairi Bin Ishak:** Documentation Lead & Core Contributor

---

## CodeNova 2026 Prep Schedule

**Team:** Oumar Mamoun Ibrahim & Mohamad Khairi Bin Ishak  
**Timeline:** Wednesday, 2 Sep 2026 -> Tuesday, 22 Sep 2026 (Event Day)  
**Schedule Model:** 3 Extended Weekend Blocks (Thursday night + Friday + Saturday + Sunday) providing ~50–60 hours of available preparation time across 10+ dedicated days, plus Friday, 18 Sep Pre-Orientation. Monday, 21 Sep is a dedicated rest day.

### Core Strategy & Principles
- **Substantial Buffer & Zero Panic:** With 3-day weekends (Fri–Sun) plus Thursday nights, total available time (~50–60h) comfortably exceeds total estimated effort (~29h). There is ample room for deep testing, breaks, and zero burnout.
- **Reusable Plumbing First:** Dedicate Weekend 2 to generic wallet, issuer, and verifier scaffolding. On event day, the real 3 hours go strictly toward the unique demo moment (**Use Case #3: Cross-Border Licensing & Revocation Flip**).
- **Non-Negotiable Mock Sprint:** Full timed 3-hour simulation on Saturday, 19 Sep remains the single highest-value preparation block.
- **Thursday Night Advantage:** Use Thursday evenings for light syncing, dependency pre-downloads, and planning so Friday morning starts with pure execution.

### Actionable Priority Matrix

| Task | Deadline | Effort | Priority | Status |
| :--- | :--- | :---: | :---: | :---: |
| Finalize Use Case #3 scope (schemas, screens, revoke logic) | Sep 4-6 | 2.5h | ![P1: Critical](https://img.shields.io/badge/P1-Critical-d73a49?style=flat-square) | ![Status: Pending](https://img.shields.io/badge/Status-Pending-gray?style=flat-square) |
| Pre-install dev environment & verify offline readiness | By Sep 13 | 2.0h | ![P1: Critical](https://img.shields.io/badge/P1-Critical-d73a49?style=flat-square) | ![Status: Pending](https://img.shields.io/badge/Status-Pending-gray?style=flat-square) |
| Build reusable wallet, issuer, and verifier scaffolding | By Sep 13 | 5.0h | ![P1: Critical](https://img.shields.io/badge/P1-Critical-d73a49?style=flat-square) | ![Status: Pending](https://img.shields.io/badge/Status-Pending-gray?style=flat-square) |
| Draft AI Usage & Security/Privacy declarations | By Sep 13 | 1.0h | ![P1: Critical](https://img.shields.io/badge/P1-Critical-d73a49?style=flat-square) | ![Status: Pending](https://img.shields.io/badge/Status-Pending-gray?style=flat-square) |
| Map 11-point submission checklist to assigned owners | By Sep 13 | 1.5h | ![P1: Critical](https://img.shields.io/badge/P1-Critical-d73a49?style=flat-square) | ![Status: Pending](https://img.shields.io/badge/Status-Pending-gray?style=flat-square) |
| Attend Pre-Orientation Session | Fri Sep 18 | 2.0h | ![P1: Critical](https://img.shields.io/badge/P1-Critical-d73a49?style=flat-square) | ![Status: Scheduled](https://img.shields.io/badge/Status-Scheduled-0969da?style=flat-square) |
| Timed 3-hour Mock Build Sprint simulation | Sat Sep 19 | 3.5h | ![P1: Critical](https://img.shields.io/badge/P1-Critical-d73a49?style=flat-square) | ![Status: Scheduled](https://img.shields.io/badge/Status-Scheduled-0969da?style=flat-square) |
| Research IDS Sandbox & Digital ID Stack documentation | By Sep 6 | 2.0h | ![P2: High-Value](https://img.shields.io/badge/P2-High_Value-f59e0b?style=flat-square) | ![Status: Pending](https://img.shields.io/badge/Status-Pending-gray?style=flat-square) |
| Draft 6-part pitch deck skeleton & conduct 2 rehearsals | Sep 13-20 | 4.0h | ![P2: High-Value](https://img.shields.io/badge/P2-High_Value-f59e0b?style=flat-square) | ![Status: Pending](https://img.shields.io/badge/Status-Pending-gray?style=flat-square) |
| Review Round 1 knowledge concepts & pre-orientation notes | Ongoing | 2.0h | ![P2: High-Value](https://img.shields.io/badge/P2-High_Value-f59e0b?style=flat-square) | ![Status: Ongoing](https://img.shields.io/badge/Status-Ongoing-f59e0b?style=flat-square) |
| Record 60-90s backup demo video | Sat Sep 19 | 1.5h | ![P3: Contingency](https://img.shields.io/badge/P3-Contingency-0969da?style=flat-square) | ![Status: Scheduled](https://img.shields.io/badge/Status-Scheduled-0969da?style=flat-square) |
| Prepare rubric-based judge Q&A answers | Sun Sep 20 | 1.0h | ![P3: Contingency](https://img.shields.io/badge/P3-Contingency-0969da?style=flat-square) | ![Status: Scheduled](https://img.shields.io/badge/Status-Scheduled-0969da?style=flat-square) |

### Extended Weekend Roadmap (Thu Night + Fri–Sun)

#### Weekend 1 (Sep 3–6): Foundation, Scoping & Environment
- **Thursday Night, Sep 3:**
  - `20:00 - 21:30`: Team kickoff, plan extended weekend deliverables, and align sprint goals.
- **Friday, Sep 4:**
  - `09:30 - 12:30`: Deep dive into Use Case #3 scope: schema fields, verifier UI, and revocation trigger (P1).
  - `14:00 - 16:30`: Study IDS Sandbox and Digital Identity Stack architecture and concepts (P2).
- **Saturday, Sep 5:**
  - `09:30 - 12:30`: Draft credential schema and issuer/verifier logic for Use Case #3 (P1).
  - `14:00 - 16:30`: Setup dev environment, install dependencies, verify API keys, and test offline toolchains (P1).
- **Sunday, Sep 6:**
  - `10:00 - 12:30`: Clean repo documentation, assign sprint roles, configure task board (P2).
  - `14:00 - 15:30`: Buffer block: log organizer queries (Round 1 date, sandbox access), review progress.

#### Weekend 2 (Sep 10–13): Reusable Scaffolding & Compliance Prep
- **Thursday Night, Sep 10:**
  - `20:00 - 21:30`: Architecture review, component breakdown, and task assignments for scaffolding.
- **Friday, Sep 11:**
  - `09:30 - 13:00`: Build generic wallet/holder UI shell and local credential storage (P1).
  - `14:30 - 17:00`: Build issuer flow skeleton (form + credential definition binding) (P1).
- **Saturday, Sep 12:**
  - `09:30 - 13:00`: Build verifier flow skeleton (proof request + selective disclosure screens) (P1).
  - `14:30 - 16:30`: Run end-to-end dummy issue/verify test pass (P1).
- **Sunday, Sep 13:**
  - `09:30 - 12:00`: Implement unique demo logic: regulator revoke button with live status flip (P1).
  - `13:30 - 15:00`: Outline 6-part pitch deck skeleton (P2).
  - `15:15 - 16:45`: Pre-draft AI & Privacy declarations; assign owners for all 11 submission items (P1).

#### Weekend 3 (Sep 17–20): Orientation, Mock Sprint & Dress Rehearsal
- **Thursday Night, Sep 17:**
  - `20:00 - 21:00`: Pre-orientation checklist prep and question list for organizers.
- **Friday, Sep 18 (Orientation Day):**
  - `10:00 - 12:00`: **Pre-Orientation Session** (Online). Capture Round 1 quiz date, IDS Sandbox endpoints, and rules.
  - `14:00 - 16:30`: Debrief session notes, adapt schemas/scaffolding to any official updates.
- **Saturday, Sep 19 (Mock Sprint):**
  - `09:15 - 12:15`: **Full 3-Hour Timed Mock Sprint** (strict competition clock simulation) (P1).
  - `13:30 - 15:30`: Sprint retrospective and address biggest code/workflow bottlenecks.
  - `15:45 - 16:45`: Record 60-90 second backup demo video (P3).
- **Sunday, Sep 20 (Dress Rehearsal & Polish):**
  - `09:30 - 11:30`: Pitch rehearsals #1 and #2 (timed against 3–5 min slot).
  - `11:45 - 12:45`: Rubric-based judge Q&A preparation (P3).
  - `14:00 - 16:00`: Final documentation polish, packing checklist (chargers, laptops, offline copies), and final team sync.

#### Event Week
- **Monday, Sep 21 (Rest Day):** Full rest. Zero new code; light review only. Sleep and mental reset.
- **Tuesday, Sep 22 (Event Day):** Round 1 Knowledge Challenge -> Round 2 Build Sprint (3 hours) -> Round 3 Pitch & Demonstration.

---

## Support Contacts

- **Rithika MaheshKumar:** [+971 56 668 4497](tel:+971566684497) (Competition Coordinator, SIU Dubai IEEE Student Branch)
- **Alok Kurien Mathew:** [+971 56 596 6571](tel:+971565966571) (Technical Coordinator, SIU Dubai IEEE Student Branch)
