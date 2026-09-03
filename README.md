# Trade & Supply Chain — Provenance as a Credential Chain

[![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![Hotwire](https://img.shields.io/badge/UI-Hotwire%20Turbo%20%26%20Stimulus-F3A712)](https://hotwired.dev/)

> [!TIP]
> This Project is being developed for **CodeNova 2026** [(IEEE SIU Dubai Student Branch × IDS)](https://www.google.com/maps/place/Symbiosis+International+University+Dubai+%D8%AC%D8%A7%D9%85%D8%B9%D8%A9+%D8%B3%D9%85%D8%A8%D9%8A%D9%88%D8%B3%D9%8A%D8%B3%E2%80%AD/@25.1035795,55.1652636,175m/data=!3m1!1e3!4m6!3m5!1s0x3e5f6b0004b9dc29:0x840b5f64965d1ce6!8m2!3d25.1035336!4d55.1652772!16s%2Fg%2F11vx5qmbwn?entry=ttu&g_ep=EgoyMDI2MDgzMS4wIKXMDSoASAFQAw%3D%3D).

## The Problem: Recall Panic & Food Waste

Modern food supply chains rely on disconnected paper records and unreadable printed lot codes. When bacterial contamination strikes, shoppers cannot tell whether a specific item in their hands is tainted or safe.

![Food Recall Crisis and Consumer Avoidance](assets/Graphic.png)

With enforcement of the FDA's Food Traceability Rule (FSMA 204) delayed until July 2028, supply chains lack an interoperable, real-time mechanism to isolate contaminated batches. As investigated by [Fortune and GS1 US](https://fortune.com/2026/09/02/food-recalls-fda-americans-avoid-food-categories/), this information vacuum turns localized contamination into category-wide consumer panic and widespread food waste. Restoring confidence requires instant, item-level cryptographic verification that shoppers and retailers can validate directly at the shelf.

### Problem 
A shipment of coffee claims organic, fair-trade, and cold-chain compliance, which is a folder of PDFs anyone can alter.

### Solution
1. The certifier issues an origin credential to the exporter.
2. The exporter presents it to the shipping line, which issues a custody credential.
3. Customs verifies both and issues a clearance credential.
4. The retailer verifies the whole chain at the shelf. 
5. A recall revokes one batch credential and every downstream check breaks.

### Chain
```text
Certifier (pre-seeded before clock starts) → exporter → carrier → customs → retailer. Four handoffs, each verify-then-issue.
```

### Demo
1. Scan the shelf QR code to see the full unbroken chain.
2. Revoke the batch and watch the shelf status turn red.

## Technology Stack & Component Mapping

| Subsystem / Responsibility | Implementation Technology | Technical Role |
| :--- | :--- | :--- |
| **Credential Issuance** | [![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/) | Generates W3C-compliant `OriginCredential` & `CustodyCredential` payloads. |
| **Credential Verification** | [![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/) | Cryptographically validates signatures, schema fields, and expiry bounds. |
| **Credential Revocation** | [![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/) | Sets revocation bit flags on the IDS registry with one-click admin execution. |
| **Chain & Provenance Logic** | [![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?logo=rubyonrails&logoColor=white)](https://rubyonrails.org/) | Links custody credentials cryptographically back to the farm origin credential hash. |
| **Database & Persistence** | [![SQLite](https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white)](https://www.sqlite.org/) [![ActiveRecord](https://img.shields.io/badge/Rails-ActiveRecord-CC0000?logo=rubyonrails&logoColor=white)](https://guides.rubyonrails.org/active_record_basics.html) | Persists batch metadata, verification audit logs, and cached public DIDs. |
| **Frontend Pages & Live UI** | [![Hotwire](https://img.shields.io/badge/Hotwire-Turbo%20%26%20Stimulus-F3A712?logo=hotwire&logoColor=white)](https://hotwired.dev/) | Powers instant zero-reload status flips (`VERIFIED` → `RECALLED`) over WebSockets. |
| **QR Code Generation** | [![RubyGems](https://img.shields.io/badge/RubyGems-rqrcode-E9573F?logo=rubygems&logoColor=white)](https://rubygems.org/gems/rqrcode) | Generates 2D GS1 Digital Link shelf QR codes dynamically for smartphone scanning. |
| **IDS API Communication** | [![Faraday](https://img.shields.io/badge/Faraday-HTTP%20Client-CC342D?logo=ruby&logoColor=white)](https://lostisland.github.io/faraday/) | Manages REST calls, bearer tokens, and webhook ingestion with the IDS Sandbox. |
| **Authentication & Sessions** | [![Ruby on Rails](https://img.shields.io/badge/Rails-has__secure__password-CC0000?logo=rubyonrails&logoColor=white)](https://guides.rubyonrails.org/active_model_basics.html) | Provides role-based session isolation for Certifiers, Carriers, and Grocers. |


## Team Members

- **Oumar Mamoun Ibrahim:** Team Leader & Project Manager  
  - [![ORCID](https://img.shields.io/badge/ORCID-0009--0008--0312--1605-A6CE39?logo=orcid&logoColor=white)](https://orcid.org/0009-0008-0312-1605) [![IEEE](https://img.shields.io/badge/IEEE-Member-00629B?logo=ieee&logoColor=white)](https://www.ieee.org/)  
  - Email: [U22200741@sharjah.ac.ae](mailto:U22200741@sharjah.ac.ae) / [omarbenzema50@gmail.com](mailto:omarbenzema50@gmail.com) | Phone: [+971 56 632 6900](tel:+971566326900)
- **Mohamad Khairi Bin Ishak:** Documentation Lead & Core Contributor
- **Nameer Anwar:** Research / Documentation Lead
