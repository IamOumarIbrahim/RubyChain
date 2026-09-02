# CodeNova 2026: Round 2 & 3 Execution Playbook

This document preserves the tactical execution playbook, use cases, deliverables tracker, and pitch cue sheet for **Round 2 (Build Sprint)** and **Round 3 (Pitching & Judgement)** after passing Round 1.

---

## Target Solution Blueprint: Use Case #3 (Cross-Border Licensing)

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
- [ ] **Employer Verifier Portal:** Verification desk requesting proof and rendering real-time validation badges: `VERIFIED` vs `DENIED`.

---

## 3-Hour Build Sprint: Execution Playbook (180-Minute Time Slots)

The 3-hour development sprint accommodates all 10 required competition activities across structured time slots:

| Time Slot | Phase & Activities Covered | Operational Focus & Deliverables | Owner Lead |
| :---: | :--- | :--- | :--- |
| **00:00 – 00:20**<br>*(20 min)* | **1. Challenge Understanding & Scoping**<br>• Understanding the challenge<br>• Brainstorming<br>• Research | Review official problem statement, confirm Use Case #3 scope, consult IDS Sandbox documentation, and align technical constraints. | Oumar (PM) & Mohamad Khairi (Docs) |
| **00:20 – 00:45**<br>*(25 min)* | **2. Product Design**<br>• Product design & architecture<br>• Schema modeling | Finalize credential definition schema (`revocation_enabled: true`) and sketch UI wireframes for Regulator, Wallet, and Employer screens. | Mohamad Khairi (Docs) |
| **00:45 – 01:45**<br>*(60 min)* | **3. Core Development**<br>• Coding / development<br>• Platform integration | Spin up pre-built scaffolding, integrate issuance API, build wallet credential receiver, and implement live websocket/polling revocation listener. | Oumar (PM) |
| **01:45 – 02:15**<br>*(30 min)* | **4. Testing & Debugging**<br>• Testing<br>• Debugging | Execute end-to-end verification pass: Issue → Store in Wallet → Verify (`VERIFIED`) → Revoke → Re-verify (`DENIED`). Fix latency and runtime bugs. | Oumar (PM) & Mohamad Khairi (Docs) |
| **02:15 – 02:40**<br>*(25 min)* | **5. Documentation**<br>• Documentation<br>• Compliance declarations | Complete technical README, architecture breakdown, finalize AI Usage & Security/Privacy declarations, push clean commit to GitHub. | Mohamad Khairi (Docs) |
| **02:40 – 03:00**<br>*(20 min)* | **6. Submission & Pitch Preparation**<br>• Final submission<br>• Pitch preparation | **Submit all 11 required deliverables before the official deadline** (avoid late penalties); stage live demo screens and rehearse 3-min pitch flow. | Team (Oumar & Mohamad Khairi) |

---

## Round 2 Deliverables Tracker (11 Required Items)

Before the 3-hour deadline, every team must submit its final project through the submission mechanism specified by the organizers. The submission should contain, where applicable:

- [ ] 1. **Project / Product Name:** Chosen solution title. *(Owner: Oumar — Project Manager)*
- [ ] 2. **Team Name:** Registered team identifier. *(Owner: Oumar — Project Manager)*
- [ ] 3. **Problem Statement:** Concise summary of the cross-border licensing delay. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 4. **Solution Description:** Technical summary of verifiable credential flow. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 5. **Prototype / Product Link or File:** Deployed web interface or local executable instructions. *(Owner: Oumar — Project Manager)*
- [ ] 6. **Source Code / Repository:** Clean GitHub repository with setup instructions. *(Owner: Oumar — Project Manager)*
- [ ] 7. **README or Technical Documentation:** System architecture, component map, and API documentation. *(Owner: Mohamad Khairi — Documentation Lead)*
- [ ] 8. **Technology Stack:** Languages, frameworks, IDS Sandbox endpoints used. *(Owner: Mohamad Khairi — Documentation Lead)*
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
