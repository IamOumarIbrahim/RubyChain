# CodeNova: Food Provenance & Rapid Recall Network

> **A decentralized food safety and instant batch-recall verification network powered by the Digital Identity Stack (IDS) and W3C Verifiable Credentials.**  
> Built for **CodeNova 2026** (IEEE SIU Dubai Student Branch × IDS).

---

## The Problem: Recall Panic & Food Waste

Modern food supply chains rely on disconnected paper records and unreadable printed lot codes. When bacterial contamination strikes, shoppers cannot tell whether a specific item in their hands is tainted or safe.

- **Surging Recalls:** In August 2026 alone, the FDA issued **26 food recall notices**—with *Salmonella* warnings jumping sixfold.
- **Category-Wide Boycotts:** According to a nationwide [Fortune / GS1 US investigation](https://fortune.com/2026/09/02/food-recalls-fda-americans-avoid-food-categories/), **94% of Americans worry about food recalls**, and **67% of consumers stop buying an entire food category** (such as all eggs or all produce) after just one notice.
- **Wasted Safe Produce:** **59% of consumers throw away food** even when their region was never affected, simply because package lot numbers are confusing or impossible to read. Another **66% hesitate to buy the brand again**.
- **The Core Dilemma:** As GS1 US stated, *"Consumers are making a category-level decision about a product-level problem."* With enforcement of the FDA’s Food Traceability Rule delayed to **July 2028**, supply chains urgently need verifiable item-level proof.

---

## The Solution: Cryptographic Provenance Chain

CodeNova replaces fragile paper trails with an unbroken chain of cryptographically signed **W3C Verifiable Credentials (VCs)** from farm to grocery shelf:

```
[Food Safety Certifier]
        │ (Issues Origin & Safety Credential with Revocation Enabled)
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
        │ (Shopper scans QR: instant cryptographic verification)
```

---

## The 3-Hour Demo Moment

1. **Verified on Shelf:** A shopper scans the shelf QR code on their phone. The mobile browser instantly displays green: `ORIGIN VERIFIED` → `COLD CHAIN VERIFIED` → `SAFE TO CONSUME`.
2. **One-Click Selective Recall:** An inspector flags contamination at the source farm and revokes the specific batch on the IDS revocation registry with one click.
3. **Instant Live Alert:** Without refreshing the page, the shopper's screen immediately flips to flashing red: `BATCH RECALLED / DO NOT SELL`. Untainted batches from other farms remain green, stopping blind panic and keeping safe food on grocery shelves.

---

## Key Features

- **Selective Batch Revocation:** Revoke contaminated batches in milliseconds on the IDS Bitstring Status List without affecting safe inventory.
- **Zero-Reload Reactive UI:** Hotwire Turbo Streams push live WebSocket state changes directly to mobile browser scanners.
- **Zero-App Consumer Verification:** Standard smartphone cameras scan GS1-compatible 2D QR codes with zero software installation.
- **Privacy-Preserving Proofs:** Zero-Knowledge selective disclosure strips sensitive wholesale pricing and supplier contracts from public view.

---

## Technology Stack

- **Backend Framework:** Ruby on Rails (Ruby 4.0+)
- **Reactive UI Layer:** Hotwire (Turbo Streams & Stimulus) via WebSockets
- **Decentralized Identity:** Digital Identity Stack (IDS) Sandbox APIs (DIDs, VCs, Revocation Registries)
- **HTTP Client:** Faraday / Net::HTTP for RESTful IDS endpoint integration
- **Database:** SQLite (rapid prototyping) / PostgreSQL
- **Fallbacks:** Python (FastAPI / Flask) or C++ (cryptographic utilities)

---

## Repository Documentation Index

| Document | Focus & Scope |
| :--- | :--- |
| **[Technical Specification & Architecture](file:///c:/Dev/repos/Public%20repos/codenova/docs/technical_documentation.md)** | Full JSON schemas, REST API specs, Mermaid system diagrams, and security model. |
| **[Round 2 & 3 Execution Playbook](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_2_3_playbook.md)** | 3-hour build sprint schedule, 11-item deliverables tracker, and 3-minute pitch cue sheet. |
| **[Round 1 Qualification & Study Guide](file:///c:/Dev/repos/Public%20repos/codenova/docs/round_1_study_guide.md)** | Competition schedule, quiz topics, tie-breaker rules, and preparation checklist. |

---

## Team Members

- **Oumar Mamoun Ibrahim:** Team Leader & Project Manager  
  Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae) / [omarbenzema50@gmail.com](mailto:omarbenzema50@gmail.com) | Phone: [+971 56 632 6900](tel:+971566326900)
- **Mohamad Khairi Bin Ishak:** Documentation Lead & Core Contributor
