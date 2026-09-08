// public/app.js - Streamlined Application Controller (~200 lines)
(function() {
  'use strict';

  const state = {
    user: null,
    selectedRole: 'certifier',
    selectedAction: 'verify_issue',
    scannedBarcode: null,
    cameraActive: false,
    cameraStream: null,
    scanInterval: null
  };

  const el = {
    loginView: document.getElementById('login-view'),
    mainView: document.getElementById('main-view'),
    usernameInput: document.getElementById('username-input'),
    passwordInput: document.getElementById('password-input'),
    roleTitleText: document.getElementById('role-title-text'),
    scannerVideo: document.getElementById('scanner-video'),
    scannerPreviewImg: document.getElementById('scanner-preview-img'),
    scannerCanvas: document.getElementById('scanner-canvas'),
    cameraTapPrompt: document.getElementById('camera-tap-prompt'),
    cameraFallbackInput: document.getElementById('camera-fallback-input'),
    btnToggleCamera: document.getElementById('btn-toggle-camera'),
    chainStatusHeader: document.getElementById('chain-status-header'),
    statusCertifier: document.getElementById('status-certifier'),
    statusExporter: document.getElementById('status-exporter'),
    statusCustoms: document.getElementById('status-customs'),
    statusRetailer: document.getElementById('status-retailer'),
    toastMsg: document.getElementById('toast-msg'),
    httpsBanner: document.getElementById('https-banner')
  };

  function toast(msg, isDanger = false) {
    if (!el.toastMsg) return;
    el.toastMsg.textContent = msg;
    el.toastMsg.className = 'toast-msg ' + (isDanger ? 'danger' : 'success');
    el.toastMsg.style.display = 'block';
    setTimeout(() => { el.toastMsg.style.display = 'none'; }, 3000);
  }

  // --- Auth & Role Switching ---
  function initAuth() {
    const saved = localStorage.getItem('rubychain_user');
    if (saved) {
      try { state.user = JSON.parse(saved); showMain(); } catch (e) {}
    }

    document.querySelectorAll('.role-btn').forEach(btn => {
      btn.onclick = () => {
        document.querySelectorAll('.role-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        state.selectedRole = btn.dataset.role;
        el.usernameInput.value = state.selectedRole;
        el.passwordInput.value = 'password123';
      };
    });

    document.querySelectorAll('.mini-pill').forEach(p => {
      p.onclick = () => {
        const target = document.querySelector(`.role-btn[data-role="${p.dataset.fillRole}"]`);
        if (target) target.click();
      };
    });

    document.getElementById('auth-submit-btn').onclick = async () => {
      const username = el.usernameInput.value.trim() || state.selectedRole;
      const password = el.passwordInput.value || 'password123';
      try {
        const res = await fetch('/api/auth/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ username, password, role: state.selectedRole })
        });
        const data = await res.json();
        if (data.success) {
          state.user = data.user;
          localStorage.setItem('rubychain_user', JSON.stringify(data.user));
          showMain();
          toast(data.created ? `Signed up as ${data.user.role.toUpperCase()}` : `Signed in as ${data.user.role.toUpperCase()}`);
        } else {
          toast(data.error || 'Login failed', true);
        }
      } catch (err) {
        state.user = { user_id: 1, username, role: state.selectedRole };
        showMain();
      }
    };

    document.getElementById('sign-out-btn').onclick = () => {
      stopCamera();
      state.user = null;
      state.scannedBarcode = null;
      localStorage.removeItem('rubychain_user');
      el.mainView.classList.remove('active');
      el.loginView.classList.add('active');
    };
  }

  function showMain() {
    el.loginView.classList.remove('active');
    el.mainView.classList.add('active');
    el.roleTitleText.textContent = `${state.user.role.charAt(0).toUpperCase() + state.user.role.slice(1)} View`;

    const isSecure = window.isSecureContext || location.protocol === 'https:' || location.hostname === 'localhost';
    if (!isSecure && el.httpsBanner) {
      el.httpsBanner.style.display = 'flex';
      const link = document.getElementById('switch-https-link');
      if (link) link.href = `https://${location.hostname}:8443${location.pathname}`;
    }

    if (state.scannedBarcode) {
      fetchChain(state.scannedBarcode);
    } else {
      el.chainStatusHeader.innerHTML = 'Chain Status: <span style="color:#6e6e73; font-weight: 500;">Waiting for Scan...</span>';
      ['statusCertifier', 'statusExporter', 'statusCustoms', 'statusRetailer'].forEach(k => {
        if (el[k]) { el[k].textContent = 'Not Verified'; el[k].className = 'status-val val-not-verified'; }
      });
    }
    if (isSecure) startCamera();
  }

  // --- Camera & QR Decoding ---
  async function startCamera() {
    if (location.protocol !== 'https:' && location.hostname !== 'localhost') {
      toast('iOS requires HTTPS for camera stream. Redirecting...', true);
      setTimeout(() => { location.href = `https://${location.hostname}:8443${location.pathname}`; }, 1000);
      return;
    }
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      el.cameraFallbackInput.click();
      return;
    }

    try {
      let stream;
      try {
        stream = await navigator.mediaDevices.getUserMedia({ audio: false, video: { facingMode: { ideal: 'environment' } } });
      } catch (e) {
        stream = await navigator.mediaDevices.getUserMedia({ audio: false, video: true });
      }
      state.cameraStream = stream;
      el.scannerVideo.srcObject = stream;
      await el.scannerVideo.play();
      state.cameraActive = true;
      el.btnToggleCamera.textContent = 'Stop Cam';
      if (el.cameraTapPrompt) el.cameraTapPrompt.style.display = 'none';
      if (el.scannerPreviewImg) el.scannerPreviewImg.style.display = 'none';
      startScanLoop();
    } catch (err) {
      el.btnToggleCamera.textContent = 'Start Cam';
      state.cameraActive = false;
      toast('Camera unavailable. Tap Snap Photo.', true);
    }
  }

  function stopCamera() {
    if (state.cameraStream) {
      state.cameraStream.getTracks().forEach(t => t.stop());
      state.cameraStream = null;
    }
    if (state.scanInterval) clearInterval(state.scanInterval);
    state.cameraActive = false;
    el.btnToggleCamera.textContent = 'Start Cam';
    if (el.cameraTapPrompt) el.cameraTapPrompt.style.display = 'block';
  }

  function startScanLoop() {
    if (state.scanInterval) clearInterval(state.scanInterval);
    state.scanInterval = setInterval(() => {
      if (!state.cameraActive || el.scannerVideo.readyState !== el.scannerVideo.HAVE_ENOUGH_DATA) return;
      const cvs = el.scannerCanvas, ctx = cvs.getContext('2d');
      cvs.width = el.scannerVideo.videoWidth;
      cvs.height = el.scannerVideo.videoHeight;
      ctx.drawImage(el.scannerVideo, 0, 0, cvs.width, cvs.height);
      if (window.jsQR) {
        const code = window.jsQR(ctx.getImageData(0, 0, cvs.width, cvs.height).data, cvs.width, cvs.height);
        if (code && code.data) handleCode(code.data);
      }
    }, 250);
  }

  function handleCode(val) {
    let clean = val.trim();
    if (clean.includes('/')) clean = clean.split('/').pop();
    if (clean !== state.scannedBarcode) {
      state.scannedBarcode = clean;
      if (navigator.vibrate) navigator.vibrate(100);
      toast(`Scanned: ${clean}`);
      fetchChain(clean);
    }
  }

  // --- Viewport & Button Listeners ---
  if (el.cameraTapPrompt) el.cameraTapPrompt.onclick = startCamera;
  document.getElementById('scanner-viewport').onclick = (e) => {
    if (!e.target.closest('.camera-controls-overlay') && !state.cameraActive) startCamera();
  };
  el.btnToggleCamera.onclick = () => { state.cameraActive ? stopCamera() : startCamera(); };

  document.getElementById('btn-snap-photo').onclick = () => el.cameraFallbackInput.click();
  document.getElementById('btn-simulate-scan').onclick = () => handleCode('5901234123457');
  const btn403 = document.getElementById('btn-simulate-scan-403');
  if (btn403) btn403.onclick = () => handleCode('5901234123458');
  const btnAuto = document.getElementById('btn-auto-demo');
  if (btnAuto) {
    btnAuto.onclick = async () => {
      const code = state.scannedBarcode || '5901234123457';
      state.scannedBarcode = code;
      try {
        const res = await fetch('/api/action/auto_demo', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ barcode: code })
        });
        const data = await res.json();
        toast(data.message || 'Auto Demo Complete!');
        fetchChain(code);
      } catch (err) {
        toast('Auto demo error', true);
      }
    };
  }

  el.cameraFallbackInput.onchange = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const r = new FileReader();
    r.onload = (ev) => {
      el.scannerPreviewImg.src = ev.target.result;
      el.scannerPreviewImg.style.display = 'block';
      if (el.cameraTapPrompt) el.cameraTapPrompt.style.display = 'none';
      const img = new Image();
      img.onload = () => {
        const cvs = el.scannerCanvas, ctx = cvs.getContext('2d');
        cvs.width = img.width; cvs.height = img.height;
        ctx.drawImage(img, 0, 0);
        const code = window.jsQR ? window.jsQR(ctx.getImageData(0, 0, cvs.width, cvs.height).data, cvs.width, cvs.height) : null;
        if (code && code.data) {
          handleCode(code.data);
        } else {
          toast('No QR detected in photo', true);
        }
      };
      img.src = ev.target.result;
    };
    r.readAsDataURL(file);
  };

  let currentChainData = null;

  function showOffline() {
    const elOff = document.getElementById('offline-indicator');
    if (elOff) elOff.style.display = 'inline-block';
  }

  function hideOffline() {
    const elOff = document.getElementById('offline-indicator');
    if (elOff) elOff.style.display = 'none';
  }

  // --- Chain Status & Actions ---
  async function fetchChain(barcode) {
    if (!barcode) return;
    try {
      const res = await fetch(`/api/item?barcode=${encodeURIComponent(barcode)}`);
      const data = await res.json();
      if (data.success) {
        localStorage.setItem('rubychain_cache_' + barcode, JSON.stringify(data));
        renderChain(data);
        hideOffline();
      } else {
        toast('Item not registered in chain', true);
      }
    } catch (e) {
      const cached = localStorage.getItem('rubychain_cache_' + barcode);
      if (cached) {
        try {
          const data = JSON.parse(cached);
          renderChain(data);
          showOffline();
          toast('⚡ Loaded from local offline cache');
          return;
        } catch (err) {}
      }
      toast('Network offline & no local cache found', true);
    }
  }

  function renderChain(data) {
    currentChainData = data;
    const broken = data.chain_status === 'Broken';
    const tampered = data.chain_status === 'Tampered' || data.tampered;
    const codeBadge = state.scannedBarcode ? `<span style="font-size:12px; font-weight:600; color:#374151; margin-left:6px; font-family:monospace; background:#e5e7eb; padding:2px 8px; border-radius:10px;">${state.scannedBarcode}</span>` : '';
    
    let statusBadge = `<span class="status-intact">Intact</span>`;
    if (broken) {
      statusBadge = `<span class="status-broken">Broken</span>`;
    } else if (tampered) {
      statusBadge = `<span class="status-tampered">⚠️ Tampered</span>`;
    }

    el.chainStatusHeader.innerHTML = `Chain Status: ${statusBadge}${codeBadge}`;
    setBadge(el.statusCertifier, data.credentials.origin.verified, data.credentials.origin.hash);
    setBadge(el.statusExporter, data.credentials.transit.verified, data.credentials.transit.hash);
    setBadge(el.statusCustoms, data.credentials.border.verified, data.credentials.border.hash);
    setBadge(el.statusRetailer, data.credentials.shelf.verified, data.credentials.shelf.hash);

    const drawer = document.getElementById('hash-audit-drawer');
    const drawerContent = document.getElementById('audit-drawer-content');
    if (tampered && drawer && drawerContent) {
      drawer.style.display = 'block';
      const detail = data.tamper_details || {};
      drawerContent.innerHTML = `<span style="color:#b91c1c; font-weight:bold;">⚠️ CRYPTOGRAPHIC INTEGRITY BREACH!</span><br>Milestone: <strong>${detail.milestone || 'Chain link'}</strong><br>Hash seal mismatch. Downstream custodial verification blocked.`;
    }

    const vcLink = document.getElementById('btn-view-vc');
    if (vcLink && state.scannedBarcode) vcLink.href = `/api/credentials?barcode=${encodeURIComponent(state.scannedBarcode)}`;
    const zkLink = document.getElementById('btn-view-zk');
    if (zkLink && state.scannedBarcode) zkLink.href = `/api/credentials?barcode=${encodeURIComponent(state.scannedBarcode)}&selective=1`;
    const epcisLink = document.getElementById('btn-view-epcis');
    if (epcisLink && state.scannedBarcode) epcisLink.href = `/api/epcis?barcode=${encodeURIComponent(state.scannedBarcode)}`;
    const auditLink = document.getElementById('btn-view-audit');
    if (auditLink && state.scannedBarcode) auditLink.href = `/api/audit?barcode=${encodeURIComponent(state.scannedBarcode)}&format=csv`;
  }

  function setBadge(elm, ok, hash) {
    if (!elm) return;
    if (ok) {
      const shortHash = hash ? ` [${hash.slice(0, 6)}…]` : '';
      elm.innerHTML = `Verified<span class="hash-tag" title="${hash || ''}">${shortHash}</span>`;
      elm.className = 'status-val val-verified';
    } else {
      elm.textContent = 'Not Verified';
      elm.className = 'status-val val-not-verified';
    }
  }

  document.querySelectorAll('.action-toggle-btn').forEach(b => {
    b.onclick = () => {
      document.querySelectorAll('.action-toggle-btn').forEach(btn => btn.classList.remove('active'));
      b.classList.add('active');
      state.selectedAction = b.dataset.action;
    };
  });

  document.getElementById('btn-confirm').onclick = async () => {
    if (!state.user) return toast('Sign in first', true);
    if (!state.scannedBarcode) return toast('Please scan a QR code first', true);
    const endpoint = state.selectedAction === 'recall' ? '/api/action/recall' : '/api/action/verify_issue';
    const body = { barcode: state.scannedBarcode, user_id: state.user.user_id, role: state.user.role };
    try {
      const res = await fetch(endpoint, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
      const data = await res.json();
      toast(data.message || (data.success ? 'Success' : data.error), !data.success);
      fetchChain(state.scannedBarcode);
    } catch (e) {
      toast('Network error', true);
    }
  };

  const resetBtn = document.getElementById('btn-reset-demo');
  if (resetBtn) {
    resetBtn.onclick = async (e) => {
      e.preventDefault();
      const code = state.scannedBarcode || '5901234123457';
      await fetch('/api/reset_demo', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ barcode: code }) });
      toast('Demo reset to initial clean state');
      if (state.scannedBarcode) fetchChain(state.scannedBarcode);
    };
  }

  const tamperBtn = document.getElementById('btn-simulate-tamper');
  if (tamperBtn) {
    tamperBtn.onclick = async (e) => {
      e.preventDefault();
      const code = state.scannedBarcode || '5901234123457';
      try {
        const res = await fetch('/api/action/simulate_tamper', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ barcode: code })
        });
        const data = await res.json();
        if (data.success) {
          toast('⚠️ Cryptographic fault injected! Hash seal corrupted.', true);
        } else {
          toast(data.error || 'Tamper injection failed', true);
        }
        fetchChain(code);
      } catch (err) {
        toast('Network error', true);
      }
    };
  }

  document.querySelectorAll('.status-item').forEach((item, idx) => {
    item.onclick = () => {
      if (!currentChainData || !currentChainData.credentials) return;
      const keys = ['origin', 'transit', 'border', 'shelf'];
      const names = ['Certifier Origin Proof', 'Exporter Custody Pass', 'Customs Border Clearance', 'Retailer Shelf Pass'];
      const key = keys[idx];
      const cred = currentChainData.credentials[key];
      const drawer = document.getElementById('hash-audit-drawer');
      const content = document.getElementById('audit-drawer-content');
      if (!drawer || !content) return;
      if (cred && cred.verified && cred.hash) {
        drawer.style.display = 'block';
        content.innerHTML = `<strong>${names[idx]}</strong><br>SHA-256: <span style="color:#851419;">${cred.hash}</span><br>Status: Cryptographically Intact ✓`;
      } else {
        drawer.style.display = 'block';
        content.innerHTML = `<strong>${names[idx]}</strong><br>Status: Pending upstream handoff (Not Verified)`;
      }
    };
  });

  initAuth();
})();
