# CodeNova 2026: Round 1 Qualification Guide (Knowledge Challenge)

> **Organizers:** IEEE SIU Dubai Student Branch × IDS  
> **Objective:** Score in the **Top 20 Teams** in Round 1 to advance to the Build Sprint. Round 1 scores are qualification-only and do not carry forward.

---

## Key Dates & Format

| Event | Date & Time | Format / Platform | Focus |
| :--- | :--- | :--- | :--- |
| **Pre-Orientation Session** | Friday, 18 Sep 2026<br>`10:00 AM – 12:00 PM` | Online | **Mandatory:** Covers IDS platform architecture and core tested concepts. |
| **Round 1: Knowledge Challenge** | Tuesday, 22 Sep 2026<br>*(Timing announced prior)* | Online MCQ Quiz<br>*(Kahoot / Quizizz / Google Forms)* | Elimination round: Top 20 teams advance to Round 2. |

*(Exact question count, duration, and marking scheme will be announced before the competition).*

---
## Use Cases Considered (Round 2 Build Sprint)

The team is evaluating three high-impact use cases from the official competition brief, balancing technical complexity against the 3-hour build sprint constraint:

| Strategy & Priority | Use Case | Architectural Chain | 3-Hour Demo Moment | Risk & Evaluation |
| :--- | :--- | :--- | :--- | :--- |
| **Primary Target**<br>*(Hardest Contribution)* | **Use Case #4: Trade & Supply Chain**<br>*Provenance as a Credential Chain* | `Certifier` → `Exporter` → `Carrier` → `Customs` → `Retailer` | Scan shelf QR for unbroken provenance; trigger batch recall and watch downstream shelf badge flip to red. | **High Risk / Highest Upside:** Demonstrates deep multi-hop chained issuance; pre-seeding initial link is essential. |
| **Alternative**<br>*(Balanced Delivery)* | **Use Case #5: Logistics & Shipment**<br>*The Shipment That Keeps Everyone Waiting* | `Shipper` → `Logistics Provider` → `Warehouse` → `Carrier` → `Delivery Partner` | Real-time status dashboard (`Scheduled`, `In Transit`, `Delayed`); flip shipment to `Delayed` with instant propagation. | **Medium Risk / High UX:** Highly visual and intuitive for judges; clean 3-link handoff. |
| **Fallback**<br>*(If Short on Time)* | **Use Case #2: Business Identity for Banks**<br>*The Six-Week Onboarding in Six Seconds* | `Licensing Authority` → `Business` → `Bank (Verifier & Issuer)` → `Supplier / Processor` | Supplier extends credit having verified only the bank's attestation, without ever seeing the raw trade license. | **Lowest Risk / High Relevance:** Proven chained issuance pattern (3 tenants, 2 schemas, 2 issuances, 2 verifications). |

> [!TIP]
> Detailed architectural breakdowns, schema definitions, and time-slot allocations are documented in the [Round 2 & 3 Execution Playbook](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_2_3_playbook.md).

---

## Qualification & Tie-Breakers

- **Passing Rule:** Top 20 teams qualify for Round 2.
- **Tie-Breaker Order (if cutoff ties occur):**
  1. Higher number of correct answers.
  2. Faster completion time (speed matters on Kahoot / Quizizz).
  3. Predetermined tie-breaker question or mini challenge.
- **Authority:** The organizing committee's decision is final.

---

## Question Categories (Study Guide)

| Category | Key Concepts to Review |
| :--- | :--- |
| **1. IDS Pre-Orientation** | Digital Identity Stack (IDS) architecture, Self-Sovereign Identity (SSI) Issuer-Holder-Verifier triad, IDS Sandbox tools. |
| **2. Digital Identity Technologies** | Decentralized Identifiers (DIDs), Verifiable Credentials (VCs), Verifiable Presentations (VPs), Revocation Registries. |
| **3. Technology Fundamentals** | REST APIs, JSON payloads, WebSockets, public/private key cryptography, SHA-256 hashing, TLS integrity. |
| **4. Programming & Logic** | Algorithmic control flow, conditionals, core data structures (maps, arrays, queues), problem decomposition. |
| **5. Problem-Solving & Debugging** | Code tracing, error diagnosis, edge cases, HTTP status codes (`200`, `400`, `401`, `403`, `404`, `500`). |
| **6. Product & Innovation** | Problem-solution validation, MVP scoping, user journey mapping, and feasibility. |

---

## Technology Stack & Environment

- **Primary Language & Framework:** Ruby on Rails (Ruby 4.0+)
- **Fallback Languages & Frameworks:** Python (FastAPI / Flask) / C++ (for core performance, cryptographic utilities, or offline CLI verification)
- **Frontend / Real-Time Reactivity:** Hotwire (Turbo Streams / Stimulus) for zero-reload live badge updates (e.g., flipping status from `VERIFIED` to `RECALLED` / `DELAYED`)
- **API & Integration Layer:** RESTful JSON client (`Faraday` / `Net::HTTP` in Ruby; `httpx` / `requests` in Python) connecting to IDS Sandbox endpoints & webhooks
- **Database:** SQLite (local rapid prototyping) / PostgreSQL

---

## Action Checklist

- [ ] **Attend Pre-Orientation:** Friday, 18 Sep (`10:00 – 12:00`). Record technical terms, architecture diagrams, and platform hints.
- [ ] **Master IDS & SSI:** Review Issuer-Holder-Verifier flow, DIDs, VCs, and revocation registries.
- [ ] **Review Core CS:** Asymmetric keys, hashing, HTTP status codes, and code tracing.
- [ ] **Pre-install Ruby on Rails Environment:** Verify local Ruby 4.0+, install Rails (`gem install rails`), and prepare a minimal starter template before sprint day.
- [ ] **Setup & Redundancy:** Test stable Wi-Fi + mobile hotspot backup; set up dual screens for fast reference.

---

## Team Details

- **Oumar Mamoun Ibrahim:** Team Leader & Project Manager  
  Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae) / [omarbenzema50@gmail.com](mailto:omarbenzema50@gmail.com) | Phone: [+971 56 632 6900](tel:+971566326900)
- **Mohamad Khairi Bin Ishak:** Documentation Lead & Core Contributor

---

## Support Contacts

- **Rithika MaheshKumar:** [+971 56 668 4497](tel:+971566684497) (Competition Coordinator, SIU Dubai IEEE Student Branch)
- **Alok Kurien Mathew:** [+971 56 596 6571](tel:+971565966571) (Technical Coordinator, SIU Dubai IEEE Student Branch)

---

*Note: Rounds 2 & 3 Playbook (Build Sprint & Pitching) is archived in [docs/round_2_3_playbook.md](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_2_3_playbook.md).*
