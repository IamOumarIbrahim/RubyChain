# CodeNova 2026: Team Preparation Guide

> **Organizers:** IEEE SIU Dubai Student Branch × IDS  
> **Goal:** Score in the **Top 20 Teams** in Round 1 to qualify for the 3-hour Build Sprint. *(Scores do not carry forward).*

---

## Important Dates & Schedule

| Event | Date & Time | Format | Focus |
| :--- | :--- | :--- | :--- |
| **Pre-Orientation** | Friday, 18 Sep 2026<br>`10:00 AM – 12:00 PM` | Online | **Mandatory:** IDS platform architecture & tested concepts. |
| **Round 1: Quiz** | Tuesday, 22 Sep 2026<br>*(Time TBA)* | Online MCQ | Elimination round: Top 20 teams qualify for Round 2. |

*(Question count, duration, and scoring details will be announced prior to the quiz).*

---

## Selected Project: Use Case #4 — Trade & Supply Chain
### *Food Provenance & Rapid Recall Network*

### The Problem: Recall Panic & Wasted Food
Opaque supply chains and illegible lot codes make it impossible for consumers to verify product safety during recalls:
- **Surging FDA Notices:** The FDA posted **26 food recall notices in August 2026 alone**, with *Salmonella* warnings jumping sixfold.
- **Category-Level Panic:** A [Fortune / GS1 US study](https://fortune.com/2026/09/02/food-recalls-fda-americans-avoid-food-categories/) found that **94% of Americans worry about recalls**, and **67% avoid an entire food category** (e.g., all eggs or all produce) after just one notice.
- **Wasted Safe Food:** **59% of consumers discard safe food** because printed packaging codes are confusing, while **66% hesitate to buy the brand again**.
- **The Core Issue:** As GS1 US noted, *"Consumers are making a category-level decision about a product-level problem."* With FDA Food Traceability Rule enforcement delayed to **July 2028**, supply chains urgently need verifiable item-level proof.

### The Solution: Verifiable Credential Chain
Using the **Digital Identity Stack (IDS)** and **Verifiable Credentials (VCs)**, we build a tamper-proof chain of custody from farm to grocery shelf:

```
[Food Safety Certifier]
        │ (Origin & Safety Credential)
        ▼
[Exporter / Farm]
        │ (Presents Origin Credential)
        ▼
[Cold-Chain Carrier]
        │ (Verifies Origin → Temperature & Custody Credential)
        ▼
[Customs & Import Clearance]
        │ (Verifies Custody → Port Clearance Credential)
        ▼
[Retailer Shelf & Consumer QR Code]
        │ (Real-time cryptographic verification)
```

### The 3-Hour Demo Moment
1. **Shelf Scan:** Consumer scans shelf QR code; mobile view displays green `ORIGIN & COLD CHAIN VERIFIED`.
2. **One-Click Recall:** Certifier flags contamination and revokes the specific batch credential on the IDS registry.
3. **Live Status Flip:** The consumer's screen instantly flips to red `BATCH RECALLED / DO NOT SELL` without refreshing, while safe batches remain green.

> [!TIP]
> - For full data schemas, REST API specs, and Mermaid architecture flows, see the [Technical Specification & System Architecture](file:///c:/Dev/repos/Public%20repos/codenova/docs/technical_documentation.md).
> - For sprint time allocations, deliverables checklist, and pitch cue sheet, see the [Round 2 & 3 Execution Playbook](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_2_3_playbook.md).

---

## Qualification & Tie-Breakers

- **Passing Rule:** Top 20 teams qualify for Round 2.
- **Tie-Breaker Order:**
  1. Most correct answers.
  2. Fastest completion time.
  3. Pre-selected tie-breaker challenge.
- **Authority:** Organizing committee decision is final.

---

## Study Guide: Round 1 Topics

| Topic | Key Concepts |
| :--- | :--- |
| **1. IDS Pre-Orientation** | IDS platform architecture, SSI Issuer-Holder-Verifier triad, and IDS Sandbox tools. |
| **2. Digital Identity** | DIDs, Verifiable Credentials (VCs), Verifiable Presentations (VPs), and Revocation Registries. |
| **3. Tech Basics** | REST APIs, JSON payloads, WebSockets, public/private keys, SHA-256 hashing, and HTTPS/TLS. |
| **4. Code & Logic** | Program control flow, conditionals, core data structures (arrays, maps, queues), and problem breakdown. |
| **5. Debugging** | Code tracing, diagnosing errors, edge cases, and HTTP status codes (`200`, `400`, `401`, `403`, `404`, `500`). |
| **6. Product & Innovation** | Clear problem statements, MVP scoping, user journey mapping, and feasibility. |

---

## Technology Stack

- **Primary Stack:** Ruby on Rails (Ruby 4.0+) with Hotwire (Turbo Streams & Stimulus) for live badge flips
- **Fallbacks:** Python (FastAPI / Flask) or C++ (cryptographic utilities)
- **Integration Layer:** RESTful HTTP client (`Faraday` / `Net::HTTP`) connecting to IDS Sandbox APIs & webhooks
- **Database:** SQLite (rapid prototyping) or PostgreSQL

---

## Action Checklist

- [ ] **Attend Pre-Orientation:** Friday, 18 Sep (`10:00 AM – 12:00 PM`). Note key terms and platform hints.
- [ ] **Master IDS & SSI:** Learn Issuer-Holder-Verifier flow, DIDs, VCs, and revocation registries.
- [ ] **Review Core CS:** Asymmetric keys, hashing, HTTP status codes, and code tracing.
- [ ] **Rails Setup:** Verify local Ruby 4.0+, install Rails, and prepare a minimal starter template.
- [ ] **Hardware & Redundancy:** Test reliable Wi-Fi, mobile hotspot backup, and dual screens.

---

## Team Members

- **Oumar Mamoun Ibrahim:** Team Leader & Project Manager  
  Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae) / [omarbenzema50@gmail.com](mailto:omarbenzema50@gmail.com) | Phone: [+971 56 632 6900](tel:+971566326900)
- **Mohamad Khairi Bin Ishak:** Documentation Lead & Core Contributor

---

## Organizer Contacts

- **Rithika MaheshKumar:** [+971 56 668 4497](tel:+971566684497) (Competition Coordinator, SIU Dubai IEEE Student Branch)
- **Alok Kurien Mathew:** [+971 56 596 6571](tel:+971565966571) (Technical Coordinator, SIU Dubai IEEE Student Branch)

---

*Note: Detailed architectural specs are documented in [docs/technical_documentation.md](file:///c:/Dev/repos/Public%20repos/codenova/docs/technical_documentation.md). Sprint operational plans are documented in [docs/round_2_3_playbook.md](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_2_3_playbook.md).*
