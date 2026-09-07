# CodeNova 2026 — Security & Privacy Declaration
**Project:** RubyChain — Verifiable Trade & Supply Chain Provenance  
**Competition:** CodeNova 2026 (IEEE SIU Dubai x IDS)  
**Round:** Round 2 (Build Sprint) & Round 3 (Submission)  

---

## 1. Compliance Statement
In compliance with **Section 7 (Final Submission)** and **Section 17 (Security & Responsible Technology)** of the CodeNova 2026 Rulebook, this declaration outlines the security posture, privacy safeguards, and responsible engineering standards adhered to by RubyChain.

---

## 2. Key Security Safeguards

### A. Cryptographic Integrity & Hash Chaining
* **Tamper-Evident SHA-256 Merkle Links:** Every custody handoff mathematically incorporates the cryptographic hash of the preceding milestone (`PREV:<hash>|<milestone>|<issuer>`), making retrospective ledger manipulation mathematically impossible without invalidating downstream nodes.
* **Salted Password Hashing:** User authentication employs SHA-256 with application-scoped salt (`rubychain_salt_<pwd>`).

### B. Input Validation & Injection Immunity
* **Parameterized SQL Queries:** 100% of database interactions across SQLite3 use prepared statements (`?` parameters), strictly preventing SQL Injection (SQLi) attacks.
* **String Encoding Sanitization:** WEBrick input parameters are explicitly cleaned, stripped, and UTF-8 normalized to thwart encoding mismatch exploits.

### C. Zero Proprietary Lock-In & Secure Transport
* **Dual HTTP / TLS 1.3 HTTPS:** Dual port architecture ensures secure encrypted mobile camera transmission over HTTPS (Port 8443) with auto-generated certificates compliant with mobile WebRTC security requirements.

---

## 3. Privacy & Minimal Disclosure (IDS Principles)
* **Zero PII Exposure:** No personally identifiable information (PII) is stored or transmitted in the credential chain. Identifiers are limited to role-based tenant handles (`certifier`, `exporter`, `carrier`, `customs`, `retailer`) and decentralized identifiers (`did:rubychain:user:<id>`).
* **Need-to-Know Segregation:** Downstream verifiers (e.g. customs authorities or retail cashiers) verify validity without gaining access to private commercial pricing or sensitive financial contracts.
