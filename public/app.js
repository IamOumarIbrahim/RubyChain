// public/app.js
// ==============================================================================
// RubyChain Web Application Logic v1.1
// ==============================================================================
// Features:
// 1. Role-based authentication (Exporter, Carrier, Customs, Retailer)
// 2. Real-time iPhone camera QR & Barcode scanning via jsQR & WebRTC
// 3. Dual-context resilience (HTTPS WebRTC stream + Native iOS camera fallback)
// 4. Verify-then-issue credential pipeline & instant circuit-breaker recall
// ==============================================================================

(function() {
  'use strict';

  // Application State
  const state = {
    user: null,
    selectedRole: 'carrier',
    selectedAction: 'recall', // default as in mockup: Recall or Verify
    scannedBarcode: '5901234123457', // default pre-seeded coffee batch
    cameraActive: false,
    cameraStream: null,
    scanInterval: null
  };

  // DOM Elements
  const el = {
    loginView: document.getElementById('login-view'),
    mainView: document.getElementById('main-view'),
    roleButtons: document.querySelectorAll('.role-btn'),
    usernameInput: document.getElementById('username-input'),
    passwordInput: document.getElementById('password-input'),
    authSubmitBtn: document.getElementById('auth-submit-btn'),
    roleTitleText: document.getElementById('role-title-text'),
    signOutBtn: document.getElementById('sign-out-btn'),
    httpsBanner: document.getElementById('https-banner'),
    switchHttpsLink: document.getElementById('switch-https-link'),
    scannerViewport: document.getElementById('scanner-viewport'),
    scannerVideo: document.getElementById('scanner-video'),
    scannerPreviewImg: document.getElementById('scanner-preview-img'),
    scannerCanvas: document.getElementById('scanner-canvas'),
    cameraTapPrompt: document.getElementById('camera-tap-prompt'),
    cameraFallbackInput: document.getElementById('camera-fallback-input'),
    btnToggleCamera: document.getElementById('btn-toggle-camera'),
    btnSnapPhoto: document.getElementById('btn-snap-photo'),
    btnSimulateScan: document.getElementById('btn-simulate-scan'),
    chainStatusHeader: document.getElementById('chain-status-header'),
    statusCertifier: document.getElementById('status-certifier'),
    statusExporter: document.getElementById('status-exporter'),
    statusCustoms: document.getElementById('status-customs'),
    statusRetailer: document.getElementById('status-retailer'),
    actionToggleBtns: document.querySelectorAll('.action-toggle-btn'),
    btnConfirm: document.getElementById('btn-confirm'),
    toastMsg: document.getElementById('toast-msg'),
    btnResetDemo: document.getElementById('btn-reset-demo')
  };

  // ----------------------------------------------------------------------------
  // UI Helpers: Toast Notifications
  // ----------------------------------------------------------------------------
  function showToast(message, isDanger = false) {
    if (!el.toastMsg) return;
    el.toastMsg.textContent = message;
    el.toastMsg.className = 'toast-msg ' + (isDanger ? 'danger' : 'success');
    el.toastMsg.style.display = 'block';
    setTimeout(() => {
      el.toastMsg.style.display = 'none';
    }, 3500);
  }

  // ----------------------------------------------------------------------------
  // Authentication & Role Selection
  // ----------------------------------------------------------------------------
  function initAuth() {
    // Check saved session
    const savedUser = localStorage.getItem('rubychain_user');
    if (savedUser) {
      try {
        state.user = JSON.parse(savedUser);
        showMainView();
      } catch (e) {
        localStorage.removeItem('rubychain_user');
      }
    }

    // Role selection in login screen
    el.roleButtons.forEach(btn => {
      btn.addEventListener('click', () => {
        el.roleButtons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        state.selectedRole = btn.dataset.role;

        // Auto-fill username if empty for quick testing
        if (!el.usernameInput.value || ['exporter', 'carrier', 'customs', 'retailer'].includes(el.usernameInput.value)) {
          el.usernameInput.value = state.selectedRole;
          el.passwordInput.value = 'password123';
        }
      });
    });

    // Quick demo pill fills
    document.querySelectorAll('.mini-pill').forEach(pill => {
      pill.addEventListener('click', () => {
        const role = pill.dataset.fillRole;
        const targetBtn = document.querySelector(`.role-btn[data-role="${role}"]`);
        if (targetBtn) targetBtn.click();
      });
    });

    // Sign in / Sign up submit
    el.authSubmitBtn.addEventListener('click', handleAuthSubmit);

    // Sign out
    el.signOutBtn.addEventListener('click', () => {
      stopCamera();
      state.user = null;
      localStorage.removeItem('rubychain_user');
      el.mainView.classList.remove('active');
      el.loginView.classList.add('active');
      showToast('Signed out');
    });
  }

  async function handleAuthSubmit() {
    const username = el.usernameInput.value.trim() || state.selectedRole;
    const password = el.passwordInput.value || 'password123';
    const role = state.selectedRole;

    try {
      const res = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password, role })
      });
      const data = await res.json();

      if (data.success) {
        state.user = data.user;
        localStorage.setItem('rubychain_user', JSON.stringify(data.user));
        showMainView();
        showToast(`Signed in as ${data.user.role.toUpperCase()}`);
      } else {
        // Fallback auto-signup
        const suRes = await fetch('/api/auth/signup', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ username, password, role })
        });
        const suData = await suRes.json();
        if (suData.success) {
          state.user = suData.user;
          localStorage.setItem('rubychain_user', JSON.stringify(suData.user));
          showMainView();
          showToast(`Registered and signed in as ${suData.user.role.toUpperCase()}`);
        } else {
          showToast(suData.error || 'Authentication failed', true);
        }
      }
    } catch (err) {
      // Offline fallback
      state.user = { user_id: 2, username: username, role: role };
      showMainView();
      showToast(`Local Mode: Signed in as ${role.toUpperCase()}`);
    }
  }

  function showMainView() {
    el.loginView.classList.remove('active');
    el.mainView.classList.add('active');

    // Capitalize role name for title e.g. "Retailer View"
    const capitalized = state.user.role.charAt(0).toUpperCase() + state.user.role.slice(1);
    el.roleTitleText.textContent = `${capitalized} View`;

    // Check secure context for iPhone Safari camera access
    checkSecurityContext();

    // Start fetching chain data for default barcode
    fetchChainStatus(state.scannedBarcode);

    // Auto-attempt camera if secure context
    if (window.isSecureContext || location.protocol === 'https:' || location.hostname === 'localhost') {
      startCamera();
    }
  }

  function checkSecurityContext() {
    const isSecure = window.isSecureContext || location.protocol === 'https:' || location.hostname === 'localhost' || location.hostname === '127.0.0.1';
    if (!isSecure && el.httpsBanner) {
      el.httpsBanner.style.display = 'flex';
      if (el.switchHttpsLink) {
        el.switchHttpsLink.href = 'https://' + location.hostname + ':8443' + location.pathname;
        el.switchHttpsLink.addEventListener('click', (e) => {
          e.preventDefault();
          location.href = 'https://' + location.hostname + ':8443' + location.pathname;
        });
      }
    } else if (el.httpsBanner) {
      el.httpsBanner.style.display = 'none';
    }
  }

  // ----------------------------------------------------------------------------
  // Camera & QR Scanner (Native getUserMedia + jsQR + Fallback)
  // ----------------------------------------------------------------------------
  async function startCamera() {
    const isSecure = window.isSecureContext || location.protocol === 'https:' || location.hostname === 'localhost' || location.hostname === '127.0.0.1';
    
    // On iOS Safari, plain HTTP blocks getUserMedia
    if (!isSecure) {
      showToast('iOS requires HTTPS for camera. Tapping opens secure mode...', true);
      setTimeout(() => {
        location.href = 'https://' + location.hostname + ':8443' + location.pathname;
      }, 1000);
      return;
    }

    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      showToast('Camera API not accessible. Opening photo capture.', true);
      el.cameraFallbackInput.click();
      return;
    }

    try {
      showToast('Activating camera...');

      // Progressive constraint fallback ladder
      let stream = null;
      try {
        stream = await navigator.mediaDevices.getUserMedia({
          audio: false,
          video: { facingMode: { ideal: 'environment' }, width: { ideal: 1280 } }
        });
      } catch (e1) {
        try {
          stream = await navigator.mediaDevices.getUserMedia({
            audio: false,
            video: { facingMode: 'environment' }
          });
        } catch (e2) {
          stream = await navigator.mediaDevices.getUserMedia({ audio: false, video: true });
        }
      }

      state.cameraStream = stream;
      el.scannerVideo.srcObject = stream;
      el.scannerVideo.setAttribute('playsinline', '');
      el.scannerVideo.setAttribute('webkit-playsinline', '');
      el.scannerVideo.setAttribute('muted', '');
      el.scannerVideo.setAttribute('autoplay', '');
      
      await el.scannerVideo.play();
      state.cameraActive = true;
      el.btnToggleCamera.textContent = 'Stop Cam';

      if (el.cameraTapPrompt) el.cameraTapPrompt.style.display = 'none';
      if (el.scannerPreviewImg) el.scannerPreviewImg.style.display = 'none';
      el.scannerVideo.style.display = 'block';

      showToast('Camera feed active! Center QR code in frame');
      startScanningLoop();
    } catch (err) {
      console.warn('Live camera stream error:', err);
      el.btnToggleCamera.textContent = 'Start Cam';
      state.cameraActive = false;

      if (err.name === 'NotAllowedError') {
        showToast('Camera permission denied in browser settings', true);
      } else {
        showToast('Camera unavailable. Tap "Snap Photo" below.', true);
      }
    }
  }

  function stopCamera() {
    if (state.cameraStream) {
      state.cameraStream.getTracks().forEach(track => track.stop());
      state.cameraStream = null;
    }
    if (state.scanInterval) {
      clearInterval(state.scanInterval);
      state.scanInterval = null;
    }
    state.cameraActive = false;
    el.btnToggleCamera.textContent = 'Start Cam';
    if (el.cameraTapPrompt) el.cameraTapPrompt.style.display = 'block';
  }

  function startScanningLoop() {
    if (state.scanInterval) clearInterval(state.scanInterval);

    state.scanInterval = setInterval(() => {
      if (!state.cameraActive || el.scannerVideo.readyState !== el.scannerVideo.HAVE_ENOUGH_DATA) {
        return;
      }

      const canvas = el.scannerCanvas;
      const ctx = canvas.getContext('2d');
      canvas.width = el.scannerVideo.videoWidth;
      canvas.height = el.scannerVideo.videoHeight;
      ctx.drawImage(el.scannerVideo, 0, 0, canvas.width, canvas.height);

      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
      if (window.jsQR) {
        const code = window.jsQR(imageData.data, imageData.width, imageData.height, {
          inversionAttempts: 'dontInvert'
        });

        if (code && code.data) {
          handleScannedCode(code.data);
        }
      }
    }, 250);
  }

  function handleScannedCode(rawData) {
    let cleanCode = rawData.trim();
    // In case QR encodes full URL or JSON
    if (cleanCode.startsWith('{')) {
      try {
        const parsed = JSON.parse(cleanCode);
        if (parsed.barcode) cleanCode = parsed.barcode;
        else if (parsed.item_id) cleanCode = parsed.item_id;
      } catch (e) {}
    } else if (cleanCode.includes('/')) {
      cleanCode = cleanCode.split('/').pop();
    }

    if (cleanCode !== state.scannedBarcode) {
      state.scannedBarcode = cleanCode;
      if (navigator.vibrate) navigator.vibrate(100);
      showToast(`Scanned Code: ${cleanCode}`);
      fetchChainStatus(cleanCode);
    }
  }

  // Viewport tap gestures
  if (el.cameraTapPrompt) {
    el.cameraTapPrompt.addEventListener('click', (e) => {
      e.stopPropagation();
      startCamera();
    });
  }

  if (el.scannerViewport) {
    el.scannerViewport.addEventListener('click', (e) => {
      if (e.target.closest('.camera-controls-overlay')) return;
      if (!state.cameraActive) {
        startCamera();
      }
    });
  }

  // Camera Fallback: iPhone file input snap
  el.cameraFallbackInput.addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (event) => {
      const dataUrl = event.target.result;
      if (el.scannerPreviewImg) {
        el.scannerPreviewImg.src = dataUrl;
        el.scannerPreviewImg.style.display = 'block';
        if (el.cameraTapPrompt) el.cameraTapPrompt.style.display = 'none';
      }

      const img = new Image();
      img.onload = () => {
        const canvas = el.scannerCanvas;
        const ctx = canvas.getContext('2d');
        canvas.width = img.width;
        canvas.height = img.height;
        ctx.drawImage(img, 0, 0);
        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        if (window.jsQR) {
          const code = window.jsQR(imageData.data, imageData.width, imageData.height);
          if (code && code.data) {
            handleScannedCode(code.data);
          } else {
            showToast('QR Code not detected in photo. Using lot #402.', true);
            handleScannedCode('5901234123457');
          }
        }
      };
      img.src = dataUrl;
    };
    reader.readAsDataURL(file);
  });

  el.btnSnapPhoto.addEventListener('click', () => {
    el.cameraFallbackInput.click();
  });

  el.btnToggleCamera.addEventListener('click', () => {
    if (state.cameraActive) {
      stopCamera();
    } else {
      startCamera();
    }
  });

  el.btnSimulateScan.addEventListener('click', () => {
    handleScannedCode('5901234123457');
  });

  // ----------------------------------------------------------------------------
  // Chain Status Fetch & Render
  // ----------------------------------------------------------------------------
  async function fetchChainStatus(barcode) {
    try {
      const res = await fetch(`/api/item?barcode=${encodeURIComponent(barcode)}`);
      const data = await res.json();

      if (data.success && data.item) {
        renderChainStatus(data);
      } else {
        showToast('Item not found in ledger', true);
      }
    } catch (err) {
      console.error('Fetch chain status error:', err);
    }
  }

  function renderChainStatus(data) {
    const isBroken = data.chain_status === 'Broken' || data.item.recalled === 1;

    // Header: "Chain Status: Broken" (red) or "Chain Status: Intact" (green)
    if (isBroken) {
      el.chainStatusHeader.innerHTML = 'Chain Status: <span class="status-broken">Broken</span>';
    } else {
      el.chainStatusHeader.innerHTML = 'Chain Status: <span class="status-intact">Intact</span>';
    }

    // Milestones
    updateBadge(el.statusCertifier, data.credentials.origin.verified);
    updateBadge(el.statusExporter, data.credentials.transit.verified);
    updateBadge(el.statusCustoms, data.credentials.border.verified);
    if (el.statusRetailer) {
      updateBadge(el.statusRetailer, data.credentials.shelf.verified);
    }
  }

  function updateBadge(badgeElement, isVerified) {
    if (!badgeElement) return;
    if (isVerified) {
      badgeElement.textContent = 'Verified';
      badgeElement.className = 'status-val val-verified';
    } else {
      badgeElement.textContent = 'Not Verified';
      badgeElement.className = 'status-val val-not-verified';
    }
  }

  // ----------------------------------------------------------------------------
  // Action Handlers: Verify & Issue vs Recall
  // ----------------------------------------------------------------------------
  el.actionToggleBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      el.actionToggleBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      state.selectedAction = btn.dataset.action; // 'verify_issue' or 'recall'
    });
  });

  el.btnConfirm.addEventListener('click', handleConfirmAction);

  async function handleConfirmAction() {
    if (!state.user) {
      showToast('Please sign in first', true);
      return;
    }

    const payload = {
      barcode: state.scannedBarcode,
      user_id: state.user.user_id,
      role: state.user.role
    };

    if (state.selectedAction === 'verify_issue') {
      try {
        const res = await fetch('/api/action/verify_issue', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload)
        });
        const data = await res.json();

        if (data.success) {
          showToast(data.message || 'Credential verified & issued!');
          fetchChainStatus(state.scannedBarcode);
        } else {
          showToast(data.error || 'Verification failed', true);
        }
      } catch (err) {
        showToast('Network error during verification', true);
      }
    } else if (state.selectedAction === 'recall') {
      try {
        const res = await fetch('/api/action/recall', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            barcode: state.scannedBarcode,
            user_id: state.user.user_id,
            reason: 'Cold-chain excursion / Quality check failure'
          })
        });
        const data = await res.json();

        if (data.success) {
          showToast('RECALL ISSUED! Chain instantly broken.', true);
          fetchChainStatus(state.scannedBarcode);
        } else {
          showToast(data.error || 'Recall failed', true);
        }
      } catch (err) {
        showToast('Network error during recall', true);
      }
    }
  }

  // Demo Reset
  if (el.btnResetDemo) {
    el.btnResetDemo.addEventListener('click', async (e) => {
      e.preventDefault();
      try {
        const res = await fetch('/api/reset_demo', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ barcode: state.scannedBarcode })
        });
        const data = await res.json();
        showToast('Demo reset to initial clean state!');
        fetchChainStatus(state.scannedBarcode);
      } catch (err) {
        showToast('Error resetting demo', true);
      }
    });
  }

  // Initialize
  initAuth();

})();
