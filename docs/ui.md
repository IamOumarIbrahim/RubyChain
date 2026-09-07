# User Experience & Product Design (10 Points)

## 1. Design Philosophy: "Warehouse-First Ergonomics"
Supply chain operators, freight forwarders, and retail shelf stockers frequently work in demanding environments—often on the move, wearing safety gloves, or under varying warehouse illumination. 

RubyChain’s user experience is designed specifically around **Zero Cognitive Friction**:
1. **Single-Thumb Navigation:** All primary interactive controls (the segmented action toggle and large pill `Confirm` button) are anchored in the bottom thumb-reach zone of standard mobile screens.
2. **Instant Status Semantics:** Eliminates complex ledger jargon. Status is reduced to an unambiguous binary state:
   * **Intact (Emerald Green #1B873F):** Safe to advance or sell.
   * **Broken (Ruby Crimson #851419):** Stop immediately; do not pass or retail.
3. **Multi-Modal Feedback:** 
   * Visual toast notifications with distinct status coloring.
   * Haptic vibration bursts (`navigator.vibrate(100)`) on camera barcode acquisition to confirm detection without needing to look at the screen.

---

## 2. Visual Identity & Pixel Fidelity
The user interface faithfully replicates the RubyChain visual design specification:

* **Brand Colors:**
  * Primary Crimson: `#851419`
  * Crimson Hover: `#6D1014`
  * Soft Neutral Canvas: `#F5F5F7`
  * Dark Pill Accents: `#242426`
* **Typography:** System-native Apple San Francisco (`SF Pro Display` / `SF Pro Text`) ensuring crisp legibility on high-DPI Retina screens.
* **Camera Viewfinder:** Centered red targeting frame with corner brackets and gentle pulse animation to assist operators in framing barcodes rapidly.

---

## 3. The Seamless User Journey

```text
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│   Role Select   │  ──>  │   Camera Scan   │  ──>  │  One-Tap Action │
│ (1 tap shortcut)│       │(Autofocus + QR) │       │ (Verify/Recall) │
└─────────────────┘       └─────────────────┘       └─────────────────┘
```

1. **Step 1 (Role Pick):** Fast 2x2 grid to toggle between Exporter, Carrier, Customs, or Retailer modes.
2. **Step 2 (Camera View):** Real-time camera viewfinder instantly locks onto the shipment QR/barcode without requiring manual shutter clicks.
3. **Step 3 (Status Verification):** Instant inspection breakdown shows exact node credentials:
   * Certifier original credential : **Verified**
   * Exporter custody credential: **Verified**
   * Customs clearance credential: **Verified** / **Not Verified**
4. **Step 4 (Action):** Operator selects `[ Verify & Issue ]` or `[ Recall ]` and taps `Confirm`.

---

## 4. Accessibility & Cross-Device Compatibility
* **WCAG 2.1 AA Compliance:** High color contrast ratio (> 7:1) between text elements and backgrounds.
* **Universal Mobile Web:** Requires zero installation or App Store approval. Functions across:
  * Apple iPhone (Safari iOS 14+)
  * Android smartphones (Google Chrome, Firefox)
  * Desktop browsers (Mac, Windows, Linux)