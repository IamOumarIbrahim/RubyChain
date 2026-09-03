# Trade & Supply Chain — Provenance as a Credential Chain

[![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![Hotwire](https://img.shields.io/badge/UI-Hotwire%20Turbo%20%26%20Stimulus-F3A712)](https://hotwired.dev/)

> [!TIP]
> This Project is being developed for **CodeNova 2026** [(IEEE SIU Dubai Student Branch × IDS)](https://www.google.com/maps/place/Symbiosis+International+University+Dubai+%D8%AC%D8%A7%D9%85%D8%B9%D8%A9+%D8%B3%D9%85%D8%A8%D9%8A%D9%88%D8%B3%D9%8A%D8%B3%E2%80%AD/@25.1035795,55.1652636,175m/data=!3m1!1e3!4m6!3m5!1s0x3e5f6b0004b9dc29:0x840b5f64965d1ce6!8m2!3d25.1035336!4d55.1652772!16s%2Fg%2F11vx5qmbwn?entry=ttu&g_ep=EgoyMDI2MDgzMS4wIKXMDSoASAFQAw%3D%3D).

## Round 1

The round will be conducted as an online MCQ-based quiz using one of the following platforms (to be determined):
- Kahoot
- Quizizz
- Google Forms

### Question Categories

The quiz may include questions covering:
- Concepts discussed during the IDS pre-orientation.
- Technology fundamentals.
- Programming and computational thinking.
- Problem-solving and debugging.
- Digital technologies relevant to the competition.
- Basic product and innovation concepts.

## Round 2

### Problem 
A shipment of coffee claims organic, fair-trade, and cold-chain compliance, which is a folder of PDFs anyone can alter.

### Solution
1. The certifier issues an origin credential to the exporter.
2. The exporter presents it to the shipping line, which issues a custody credential.
3. Customs verifies both and issues a clearance credential.
4. The retailer verifies the whole chain at the shelf. 
5. A recall revokes one batch credential and every downstream check breaks.

### Chain

> [!NOTE]
> Four handoffs, each verify-then-issue.

```text
Certifier (pre-seeded before clock starts) → exporter → carrier → customs → retailer. 
```

### Demo
1. Scan the shelf QR code to see the full unbroken chain.
2. Revoke the batch and watch the shelf status turn red.

## Deliverables

The submission should contain, where applicable:
1.	Project / Product Name
2.	Team Name
3.	Problem Statement
4.	Solution Description
5.	Prototype / Product Link or File
6.	Source Code / Repository
7.	README or Technical Documentation
8.	Technology Stack
9.	AI Usage Declaration
10.	Security & Privacy Declaration
11.	Any additional materials requested by the organizers

## Round 3
Each team will be given a fixed pitching slot. The recommended format is 3–5 minutes per team, followed by a short Q&A / judge interaction period.
1.	The Problem — What problem are you solving?
2.	The Solution — What have you built?
3.	How It Works — Briefly explain the technology and implementation.
4.	Demonstration — Show the product/prototype working.
5.	Impact & Innovation — Why does the solution matter?
6.	Future Potential — How could the product be improved, scaled, or deployed in the real world?

## Rubrics

The competition uses a 100-point judging framework.

| Category | Weight | Focus Areas |
| :--- | :---: | :--- |
| **Problem Identification & Relevance** | 15 pts | Clear problem definition, relevance, and alignment |
| **Innovation & Creativity** | 15 pts | Originality, differentiation, and creative tech usage |
| **Technical Implementation (IDS)** | 25 pts | Architecture quality, IDS integration, code depth, and complexity |
| **Functionality & Demonstration** | 15 pts | Live working prototype, key feature validation, and testing |
| **User Experience / Product Design** | 10 pts | UI clarity, seamless user journey, and ease of use |
| **Impact & Scalability** | 10 pts | Practical feasibility, enterprise scalability, and market impact |
| **Pitch & Communication** | 10 pts | Presentation clarity, narrative flow, timekeeping, and Q&A |
| **TOTAL** | **100 pts** | **Complete evaluation framework** |

### Detailed Evaluation Breakdown

#### 1. Problem Identification & Relevance (15 Points)
- **Problem Clarity:** Is the problem statement clearly and unambiguously defined?
- **Relevance:** Is the supply chain challenge meaningful and urgent in the real world?
- **Solution Alignment:** Does the proposed credential chain directly resolve the core problem?

#### 2. Innovation & Creativity (15 Points)
- **Originality:** How novel and distinctive is the approach?
- **Differentiation:** Does the solution clearly set itself apart from existing paper/PDF processes?
- **Technology Synergy:** How effectively are digital identity concepts combined with supply chain realities?

#### 3. Technical Implementation (25 Points)
- **Architecture Quality:** Well-structured codebase, clean system design, and sound component mapping.
- **IDS Utilization:** Deep, idiomatic implementation of Digital Identity Stack primitives (DIDs, VCs, Status Lists).
- **Execution under Constraints:** Technical complexity and ambition achieved within the 3-hour sprint.
- **Tooling & Discipline:** Principled use of development workflows, libraries, and AI tooling.

#### 4. Functionality & Demonstration (15 Points)
- **Live Execution:** Does the application reliably work in the real-time demonstration?
- **Key Flow Verification:** Can the team showcase the full flow (QR scan → credential verify → batch revoke → instant red status)?
- **Completeness:** How robust and complete is the prototype implementation?

#### 5. User Experience & Product Design (10 Points)
- **Usability:** Intuitive interfaces for Certifiers, Carriers, Grocers, and mobile consumers.
- **Visual Polish:** High-quality design, distinct status badges, and accessible layouts.
- **Frictionless Journey:** Zero-install mobile verification via standard QR cameras.

#### 6. Impact & Scalability (10 Points)
- **Real-World Value:** High-impact solution for global trade, food safety, and compliance auditing.
- **Enterprise Feasibility:** Ready to scale across multi-actor global supply chains.
- **Future Potential:** Clear roadmap for enterprise adoption and regulatory readiness.

#### 7. Pitch & Communication (10 Points)
- **Narrative Delivery:** Engaging, confident 3–5 minute pitch explaining Problem, Solution, Tech, and Demo.
- **Time Management:** Respects the strict competition time limits.
- **Technical Q&A:** Ability to articulate architecture and answer judging panel questions accurately.

## Team Members

1. **Oumar Mamoun Ibrahim:** Team Leader
  - [![ORCID](https://img.shields.io/badge/ORCID-0009--0008--0312--1605-A6CE39?logo=orcid&logoColor=white)](https://orcid.org/0009-0008-0312-1605) [![IEEE](https://img.shields.io/badge/IEEE-Member-00629B?logo=ieee&logoColor=white)](https://www.ieee.org/)  
  - Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae) / [omarbenzema50@gmail.com](mailto:omarbenzema50@gmail.com) | Phone: [+971 56 632 6900](tel:+971566326900)
2. **Mohamad Khairi Bin Ishak**
3. **Nameer Anwar** 
  - Email: [nameeranwar@yahoo.com](mailto:nameeranwar@yahoo.com) | Phone: [+971 56 959 5743](tel:+971569595743)
4. **Aqsa Khan**
