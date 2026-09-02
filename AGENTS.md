# Technical Communication & Documentation Guidelines

All documentation, README files, playbooks, architecture specifications, and guides in the **CodeNova** repository must strictly follow the professional principles of **Technical Communication** and **User Experience (UX) Writing**.

---

## 1. The Overarching Objective
The goal of all documentation is to produce **useful, usable, and factual information** tailored to specific audiences (hackathon judges, technical evaluators, developers, and team contributors). 

- **Useful:** Capable of supporting a meaningful decision, evaluation, or implementation task.
- **Usable:** Structured so the reader can find, understand, and act on the information with zero friction.

---

## 2. The 6-Step Technical Writing Process (Cicero's Canons)

Every document produced or updated in this repository must apply the six core stages of technical communication:

### Step 1: Determine Purpose & Audience
- **Identify the Reader:** Distinguish between busy evaluators/judges (who need quick executive takeaways) and technical implementers (who need exact schemas, APIs, and step-by-step commands).
- **Accommodate Knowledge:** Bridge high-level real-world context (e.g., FDA recall crisis, consumer category avoidance) with granular cryptographic specifications (e.g., DIDs, VCs, revocation registries).
- **Design for Dual-Layer Reading:** Enable 60-second scanning via bold lead-ins and summary tables, while providing complete technical depth for thorough review.

### Step 2: Collect & Verify Information (Invention)
- **Empirical Grounding:** Back problem statements with verified data, real-world reports, and primary sources (e.g., FDA notices, GS1 US survey findings).
- **Acknowledge Sources:** Cite references and provide clickable links for all external articles, regulatory rules, and internal codebase files.
- **Accuracy First:** Cross-check all code examples, schema properties, and HTTP status codes against the live implementation.

### Step 3: Organize & Outline (Arrangement)
Select the appropriate organizational pattern before drafting:
- **Chronological / Step-by-Step:** Use for sprint schedules, installation instructions, user journeys, and live demo flows.
- **General-to-Specific / Simple-to-Complex:** Start with executive problem/solution abstracts before drilling into schema definitions and architecture internals.
- **Parts-of-an-Object:** Use for modular system decompositions (e.g., Certifier Console → Carrier Gateway → Retailer Shelf QR).

### Step 4: Draft Using the ABC Structure (Style & Elocution)
Every major document and section should follow the **Abstract – Body – Conclusion (ABC)** framework:
- **Abstract (Lead):** State the purpose, context, and relevance upfront. Never bury the lead.
- **Body (Depth):** Deliver structured technical substance using tables, code snippets, schema fields, and diagrams.
- **Conclusion / Action:** Provide explicit takeaways, next steps, action checklists, deliverables trackers, or contact details.
- **Topic Sentences:** Begin every subsection with a clear topic sentence that states its core message.

### Step 5: Revise for Usability & Cognitive Flow
- **Prune Redundancy:** Cut wordy filler, marketing fluff, and repetitive explanations.
- **Elaborate Complexities:** Provide concrete examples, sample payloads, and clear rationale for non-obvious design choices.
- **Test Usability:** Ensure instructions can be executed successfully by a reader without external assistance.

### Step 6: Edit for Style, Mechanics & UX Delivery
- **Modern Technical Style:**
  - Prefer **active voice** over passive voice (*"The Certifier revokes the credential"* instead of *"The credential is revoked by the Certifier"*).
  - Use **present tense** for system behavior and descriptions.
  - Choose **simple nouns and verbs** over dense academic or corporate jargon.
  - Keep sentences concise, punchy, and unambiguous.
- **Mechanical Polish:** Strictly check grammar, spelling, punctuation, capitalization, and markdown formatting.

---

## 3. UX Design in Technical Documentation ("Writing Around the Interface")

Technical documentation is an interface. Structure content to optimize user experience:
1. **Visual Hierarchy:** Use predictable heading ranks (`#` → `##` → `###`), clean dividers (`---`), and consistent section naming.
2. **Generous White Space:** Break long walls of text into short, scannable paragraphs (max 3–4 sentences).
3. **Scannable Lists & Tables:** Use bulleted lists with bold lead-ins for multi-item facts, and formatted markdown tables for comparative data.
4. **Visual Diagrams:** Use ASCII flows or Mermaid diagrams to visualize multi-hop architectures and cryptographic handoffs.
5. **Callout Alerts:** Strategically highlight critical requirements using GitHub markdown alerts:
   - `> [!NOTE]` for contextual background.
   - `> [!TIP]` for operational optimizations and links to related docs.
   - `> [!IMPORTANT]` for strict deadlines, non-negotiable rules, and breaking constraints.
   - `> [!WARNING]` for edge cases and risk areas.
6. **Clickable Links:** Always format references to repository files and code symbols using clickable GitHub-style markdown links (`file:///...`).
