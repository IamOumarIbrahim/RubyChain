# CodeNova 2026 — AI Usage Declaration
**Project:** RubyChain — Verifiable Trade & Supply Chain Provenance  
**Competition:** CodeNova 2026 (IEEE SIU Dubai x IDS)  
**Round:** Round 2 (Build Sprint) & Round 3 (Submission)  

---

## 1. Declaration Summary
In accordance with **Section 5 (Build Sprint Rules)** and **Section 7 (Final Submission)** of the official CodeNova 2026 Rulebook, this document formally discloses all Artificial Intelligence (AI) tooling utilized throughout the research, architecture, and development of RubyChain.

---

## 2. Tools Used & Scope of Application

| Tool Name | Version / Model | Scope & Purpose |
| :--- | :--- | :--- |
| **Google Antigravity** | Advanced Agentic Coding | Codebase scaffolding, test suite generation, refactoring, and documentation drafting. |
| **GitHub Copilot / CLI** | v2.95 | Command-line automation, git workflow assistance, and syntax checking. |

---

## 3. Workflow & Human Verification Protocol

### A. Purpose of Usage
AI was leveraged exclusively as an **accelerator for standard boilerplate reduction**, test case enumeration, and automated verification script authoring to achieve rapid prototyping within the strict 3-hour competition constraints.

### B. Code Modification & Review
* **Zero Unaudited Code:** Every function, cryptographic hash algorithm (SHA-256), database schema definition (`rubychain.db`), and state machine transition was manually reviewed and verified by the development team.
* **Streamlining & Abstraction Removal:** AI-generated scaffolding was actively pruned by 42% to enforce the low-abstraction, zero-framework Ruby philosophy mandated for 3-hour hackathon reproducibility.

### C. Output Verification & Automated Testing
All code outputs were rigorously validated through:
1. **Automated Unit Tests (`test/chain_test.rb`):** 8/8 test cases validating cryptographic integrity and circuit-breaker revocation.
2. **End-to-End API Tests (`test/api_test.rb`):** 10/10 test cases confirming dual HTTP/HTTPS endpoints and W3C JSON-LD schemas.
3. **Physical Hardware Testing:** Real-time QR optical scanning on an Apple iPhone (iOS Safari) via dual WebRTC/HTTPS ports.

---

## 4. Team Affirmation
We confirm that all logic, system architecture, and domain decisions reflect our team's original problem formulation and technical understanding.
