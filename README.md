# CodeNova 2026: The Code-to-Product Challenge

> **Organized by:** IEEE Symbiosis International University – Dubai Student Branch  
> **In Collaboration With:** IDS (International Digital Systems)

> [!TIP]
> **Registration Form**  
> [Submit your registration here](https://docs.google.com/forms/d/e/1FAIpQLSczWiVZIlIVd7nf-bivuWyLeuXc1LfHW_UJx3iR1PuMCTMXYA/viewform?pli=1)  
> *Note: Registered by Team Leader using:* [omarbenzema50@gmail.com](mailto:omarbenzema50@gmail.com)

> [!TIP]
> **Official Rulebook & Challenge Resources**  
> [Download official rulebook & use cases package](docs/rules.zip)

---

## Key Event Details

| Event | Date & Time | Mode / Location |
| :--- | :--- | :--- |
| **Pre-Orientation Session** | Friday, 18 September 2026<br>`10:00 AM – 12:00 PM` | Online (IDS Concept Briefing) |
| **Main Hackathon** | Tuesday, 22 September 2026<br>`09:00 AM – 04:00 PM` | Block 14, Knowledge Park, Symbiosis International University, Dubai (In-Person) |

- **Entry:** **Free** (Limited capacity; Team Leader must hold an active [IEEE](https://www.ieee.org/) membership).
- **Core Philosophy:** `LEARN → THINK → BUILD → DEMONSTRATE → PITCH`

---

## Prizes & Perks

### Cash Prizes ($1,000 USD Total)
- **Winner:** $500
- **1st Runner-up:** $300
- **2nd Runner-up:** $200

### Exclusive Perks
- **Internship Opportunities:** Direct evaluation for standout participants by IDS.
- **Hands-on Mentoring:** Technical support & IDS Sandbox integration during the build sprint.
- **Patent & IP Support:** Supported by **IDS** and [**MIT Square**](https://www.mitsquare.com/).

---

## Competition Format (3 Progressive Rounds)

| Round | Stage | Format | Outcome / Timing |
| :---: | :--- | :--- | :--- |
| **1** | **Knowledge Challenge** | Online MCQ Quiz (Kahoot / Quizizz / Google Forms) covering IDS pre-orientation concepts, tech fundamentals & problem-solving. | **Top 20 Teams Qualify**<br>*(Qualification only; score does not carry forward)* |
| **2** | **The Build Sprint** | 3-Hour Rapid Product Development Sprint based on given use cases/problem statements. | Working prototype, source repo & technical submission |
| **3** | **Pitch & Judgement** | 3–5 min Product Demonstration + Pitch + Q&A with judges. | Final 100-pt scoring & winners announced |

---

## Round 2: Build Sprint & Submission Guidelines

- **Duration:** Exactly **3 hours** (includes brainstorming, design, coding, testing, documentation, and pitch prep).
- **Permitted Resources:** Official documentation, internet research, IDEs, and the **IDS Sandbox**.
- **Deliverables Required Before Deadline:**
  1. Project & Team Name
  2. Problem Statement & Solution Description
  3. Working Prototype / Product Link or executable
  4. Source Code Repository & Technical `README`
  5. Technology Stack Summary
  6. **AI Usage Declaration** (tools used, modification details, and verification methods)
  7. **Security & Privacy Declaration**
- **Late Submissions:** Strictly penalized via point deductions, marked incomplete, or disqualified.

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
   - **Demo Moment:** Verify candidate → revoke license live from regulator console → re-check instantly flips status to **DENIED**.

4. **Trade & Supply Chain (Provenance as a Credential Chain)**
   - **Scope:** Cut to 3 chain links and pre-seed initial credentials before the clock starts.
   - **Demo Moment:** Scan shelf QR to view unbroken provenance; revoke batch credential to trigger instant shelf-status alert.
   - *Risk Flag:* High complexity — recommended for advanced teams only.

5. **Logistics & Shipment Coordination (Verified Real-Time Handoffs)**
   - **Scope:** 3 partner links with a dashboard tracking *Scheduled*, *In Transit*, *Delayed*, and *Delivered*.
   - **Demo Moment:** Switch shipment to "Delayed" and demonstrate downstream partners immediately receiving the verified update.

---

## Round 3: Pitch Structure (3–5 Minutes)

Teams should prioritize **live working demonstrations** over static slides:
1. **Problem:** Specific real-world problem being solved.
2. **Solution:** What was built during the sprint.
3. **How It Works:** Architecture, tech stack, and IDS integration.
4. **Live Demonstration:** Functional walkthrough of key user flows.
5. **Impact & Innovation:** Market differentiation and value creation.
6. **Future Potential:** Scalability, deployment feasibility, and next steps.

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

- **Team Leader:** Oumar Mamoun Ibrahim
  - Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae)
  - Phone: [+971 56 632 6900](tel:+971566326900)
- **Team Member 1:** Mohamad Khairi Bin Ishak

---

## CodeNova 2026 Prep Schedule

**Team:** Oumar Mamoun Ibrahim & Mohamad Khairi Bin Ishak  
**Timeline:** Wednesday, 2 Sep 2026 -> Tuesday, 22 Sep 2026 (Event Day)  
**Capacity:** Weekends only (3 weekends / ~30-36h total) + Friday, 18 Sep Pre-Orientation. Monday, 21 Sep is a dedicated rest day.

### Core Strategy & Principles
- **Reusable Plumbing First:** Spend Weekend 2 building generic wallet, issuer, and verifier scaffolding. On event day, the real 3 hours go strictly toward the unique demo moment (**Use Case #3: Cross-Border Licensing & Revocation Flip**).
- **Non-Negotiable Mock Sprint:** Full timed 3-hour simulation on Saturday, 19 Sep is the single highest-value preparation block.
- **Time Contingency:** Total workload is ~30.5h against ~30-36h available. If constrained, drop tasks in order: (1) backup demo video, (2) second pitch rehearsal, (3) formal Q&A prep. Never cut the mock sprint.

### Priority Matrix

| Task | Deadline | Impact if Missed | Effort | Priority |
| :--- | :--- | :--- | :---: | :---: |
| Fix registration email mismatch & verify active IEEE ID | ASAP | Ineligible or unregistered | 1.5h | **P1** |
| Finalize Use Case #3 scope (schemas, screens, revoke logic) | Sep 5-6 | Wasted sprint decision time | 2.5h | **P1** |
| Pre-install dev environment & verify offline readiness | By Sep 13 | Lost sprint time on installs/logins | 2.0h | **P1** |
| Build reusable wallet, issuer, and verifier scaffolding | By Sep 13 | Insufficient time for demo logic | 5.0h | **P1** |
| Draft AI Usage & Security/Privacy declarations | By Sep 13 | Rushed mid-sprint compliance | 1.0h | **P1** |
| Map 11-point submission checklist to assigned owners | By Sep 13 | Late or incomplete submission | 1.5h | **P1** |
| Attend Pre-Orientation Session | Fri Sep 18 | Miss IDS architecture & Round 1 hints | 2.0h | **P1** |
| Timed 3-hour Mock Build Sprint simulation | Sat Sep 19 | Untested pace & event-day chaos | 3.5h | **P1** |
| Research IDS Sandbox & Digital ID Stack documentation | By Sep 6 | Steep ramp-up on event day | 2.0h | **P2** |
| Draft 6-part pitch deck skeleton & conduct 2 rehearsals | Sep 13-20 | Weaker pitch and lost presentation points | 4.0h | **P2** |
| Review Round 1 knowledge concepts & pre-orientation notes | Ongoing | Risk of failing Round 1 cutoff | 2.0h | **P2** |
| Record 60-90s backup demo video | Sat Sep 19 | No fallback if live demo fails | 1.5h | **P3** |
| Prepare rubric-based judge Q&A answers | Sun Sep 20 | Weaker Q&A scoring | 1.0h | **P3** |

### Weekend Roadmap

#### Weekend 1 (Sep 5-6): Foundation & Scoping
- **Saturday, Sep 5:**
  - `09:00 - 10:15`: Confirm active IEEE ID, fix registration email, submit form (**P1**).
  - `10:30 - 12:30`: Lock Use Case #3 scope: schema fields, verifier UI, and revocation trigger (**P1**).
  - `13:30 - 16:30`: Clean repo/README details, assign roles, configure task board, log organizer queries (**P2**).
- **Sunday, Sep 6:**
  - `09:00 - 11:00`: Study IDS Sandbox and Digital Identity Stack documentation (**P2**).
  - `11:15 - 13:00`: Draft credential schema and issuer/verifier logic for Use Case #3 (**P1**).
  - `14:00 - 16:30`: Configure dependencies, verify accounts, test offline-safe toolchain (**P1**).

#### Weekend 2 (Sep 12-13): Reusable Scaffolding & Submission Prep
- **Saturday, Sep 12:**
  - `09:00 - 13:00`: Build generic wallet/holder UI shell and issuer flow skeleton (**P1**).
  - `14:00 - 16:45`: Build verifier flow skeleton and execute end-to-end dummy issue/verify pass (**P1**).
- **Sunday, Sep 13:**
  - `09:00 - 11:00`: Implement the unique demo moment: regulator revoke button with live status flip (**P1**).
  - `11:15 - 12:45`: Outline 6-part pitch deck skeleton (**P2**).
  - `13:45 - 16:15`: Pre-draft AI & Privacy declarations and assign owners for all 11 submission deliverables (**P1**).

#### Friday, Sep 18: Pre-Orientation
- `10:00 - 12:00` (Online): Attend live session. Capture Round 1 quiz dates, IDS Sandbox access details, and explicit AI/tech rules.

#### Weekend 3 (Sep 19-20): Dress Rehearsal & Polish
- **Saturday, Sep 19:**
  - `09:15 - 12:15`: **Full 3-Hour Timed Mock Sprint** (strict simulation under competition clock) (**P1**).
  - `13:15 - 15:30`: Sprint retrospective and address biggest identified code bottlenecks.
  - `15:45 - 16:30`: Record 60-90 second backup demo video (**P3**).
- **Sunday, Sep 20:**
  - `09:00 - 11:00`: Pitch rehearsals #1 and #2 (timed to 3-5 min limit).
  - `11:00 - 12:00`: Rubric-based judge Q&A preparation (**P3**).
  - `13:00 - 16:00`: Polish docs/diagrams, pack equipment (chargers, accounts, offline copies), and final team sync.

#### Event Week
- **Monday, Sep 21 (Rest Day):** Full rest. No new code; light review only.
- **Tuesday, Sep 22 (Event Day):** Round 1 Knowledge Challenge -> Round 2 Build Sprint (3 hours) -> Round 3 Pitch & Demonstration.

---

## Support Contacts

- **Rithika MaheshKumar:** [+971 56 668 4497](tel:+971566684497)
- **Alok Kurien Mathew:** [+971 56 596 6571](tel:+971565966571)
