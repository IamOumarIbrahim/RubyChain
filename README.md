# CodeNova 2026: Team Preparation Guide

> **Organizers:** IEEE SIU Dubai Student Branch × IDS  
> **Goal:** Finish in the **Top 20 Teams** in Round 1 to qualify for the 3-hour Build Sprint. *(Round 1 scores are qualification-only and do not carry forward).*

---

## Important Dates & Schedule

| Event | Date & Time | Format | Details |
| :--- | :--- | :--- | :--- |
| **Pre-Orientation Session** | Friday, 18 Sep 2026<br>`10:00 AM – 12:00 PM` | Online | **Mandatory:** Learn how the IDS platform works and what will be tested. |
| **Round 1: Knowledge Challenge** | Tuesday, 22 Sep 2026<br>*(Time to be announced)* | Online Quiz<br>*(Kahoot / Quizizz / Google Forms)* | Elimination round: The top 20 teams qualify for Round 2. |

*(The organizers will announce the quiz time, number of questions, and scoring details before the event).*

---

## Finalized Project: Use Case #4 — Trade & Supply Chain
### *“Provenance as a Credential Chain”*

We have finalized our project choice for the Round 2 Build Sprint: **Use Case #4 (Trade & Supply Chain)**, applied directly to **Food Safety and Batch-Level Recalls**.

### Real-World Motivation: The Food Recall Crisis
According to a recent [Fortune investigation on FDA recalls](https://fortune.com/2026/09/02/food-recalls-fda-americans-avoid-food-categories/):
- **Surging Recalls:** In August 2026 alone, the FDA issued **26 food recall notices**—with *Salmonella* warnings jumping sixfold (12 notices in August vs. just 2 in July), affecting pantry staples from eggs and produce to snacks.
- **The "Category Avoidance" Crisis:** A nationwide survey by GS1 US found that **94% of Americans are worried** about frequent food recalls. Even worse, **67% of consumers stop buying an entire food category** (like all eggs or all berries) after hearing about just one recall notice.
- **Wasted Safe Food:** **59% of consumers throw away food** even when their region was never affected, simply because printed lot numbers on packaging are confusing or impossible to read. Another **66% hesitate to ever buy the brand again**.
- **The Core Problem:** As GS1 US noted, *"Consumers are making a category-level decision about a product-level problem."* Because modern supply chains pass produce through dozens of middlemen and repacking steps, information gets lost. Furthermore, Congress delayed enforcement of the FDA’s Food Traceability Rule to **July 2028**, leaving a critical safety gap.
- **Why We Need Verifiable Credentials:** When contamination happens, shoppers cannot verify if the item in their hands is clean or tainted. They panic and boycott the entire aisle. Honest producers lose millions, and perfectly safe food is thrown into the trash.

### How Our Solution Fixes This
Using the **Digital Identity Stack (IDS)** and **Verifiable Credentials (VCs)**, our solution creates a tamper-proof digital chain of custody from farm to grocery shelf:

```
[Food Safety Certifier]
        │ (Issues Origin & Safety Credential)
        ▼
[Exporter / Farm]
        │ (Presents Origin Credential)
        ▼
[Cold-Chain Carrier]
        │ (Verifies Origin → Issues Temperature & Custody Credential)
        ▼
[Customs & Import Clearance]
        │ (Verifies Custody → Issues Port Clearance Credential)
        ▼
[Retailer Shelf & Consumer QR Code]
        │ (Shopper scans QR code: shows complete verified history)
```

### The 3-Hour Demo Moment
1. **Verified on Shelf:** A shopper or store clerk scans the shelf QR code on their phone. The screen shows an all-green status: `ORIGIN VERIFIED` → `COLD CHAIN VERIFIED` → `SAFE TO CONSUME`.
2. **One-Click Recall:** An inspector detects contamination at the source farm and revokes that specific batch on the IDS revocation registry with one click.
3. **Instant Live Alert:** Without anyone refreshing the page, the shopper's screen immediately flips to a flashing red alert: `BATCH RECALLED / DO NOT SELL`. Safe batches from other farms remain green, preventing panic and keeping safe food on grocery shelves.

> [!TIP]
> Complete technical schemas, API workflows, and sprint timelines are documented in the [Round 2 & 3 Execution Playbook](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_2_3_playbook.md).

---

## Round 1 Qualification & Rules

- **Passing Rule:** The top 20 teams advance to Round 2.
- **Tie-Breaker Order (if scores are tied):**
  1. Higher number of correct answers.
  2. Faster completion time.
  3. Pre-selected tie-breaker question or mini challenge.
- **Final Authority:** The organizing committee's decision is final.

---

## Study Guide: Round 1 Topics

| Topic | What to Study |
| :--- | :--- |
| **1. IDS Pre-Orientation** | How the IDS platform is structured, the Issuer-Holder-Verifier triad in Self-Sovereign Identity (SSI), and IDS Sandbox tools. |
| **2. Digital Identity** | Decentralized Identifiers (DIDs), Verifiable Credentials (VCs), Verifiable Presentations (VPs), and Revocation Registries. |
| **3. Tech Basics** | REST APIs, JSON data, WebSockets, public/private key cryptography, SHA-256 hashing, and HTTPS/TLS integrity. |
| **4. Code & Logic** | Program control flow, conditionals (`if/else`), core data structures (arrays, hash maps, queues), and problem breakdown. |
| **5. Debugging** | Reading code, spotting errors, handling edge cases, and common HTTP status codes (`200 OK`, `400 Bad Request`, `401 Unauthorized`, `403 Forbidden`, `404 Not Found`, `500 Server Error`). |
| **6. Product & Innovation** | Clear problem statements, planning a Minimum Viable Product (MVP), user journey mapping, and realistic feasibility. |

---

## Technology Stack

- **Primary Framework:** Ruby on Rails (Ruby 4.0+)
- **Alternative Options:** Python (FastAPI / Flask) or C++ (for standalone cryptographic utilities)
- **Live UI Updates:** Hotwire (Turbo Streams & Stimulus) for instant, zero-refresh badge changes (e.g. flipping status from `VERIFIED` to `RECALLED`)
- **API Client:** RESTful HTTP client (`Faraday` / `Net::HTTP` in Ruby; `httpx` / `requests` in Python) connecting to IDS Sandbox endpoints and webhooks
- **Database:** SQLite (for rapid sprint development) or PostgreSQL

---

## Action Checklist

- [ ] **Attend Pre-Orientation:** Friday, 18 Sep (`10:00 AM – 12:00 PM`). Note key terms, architecture diagrams, and platform tips.
- [ ] **Master IDS & SSI Basics:** Review the Issuer-Holder-Verifier model, DIDs, VCs, and revocation registries.
- [ ] **Review Computer Science Basics:** Asymmetric cryptography, hashing, HTTP status codes, and code tracing.
- [ ] **Set Up Ruby on Rails:** Check local Ruby 4.0+ and Rails (`gem install rails`), and prepare a clean starter template before sprint day.
- [ ] **Test Hardware & Network:** Prepare reliable Wi-Fi, a backup mobile hotspot, and dual screens for fast reference during the quiz.

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

*Note: For the full Build Sprint and pitch plan, see the [Round 2 & 3 Execution Playbook](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_2_3_playbook.md).*
