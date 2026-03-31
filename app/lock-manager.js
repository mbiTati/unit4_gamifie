// lock-manager.js — Système de verrouillage centralisé
// Le prof bloque/débloque, les élèves voient le résultat
(function() {
  var SB = 'https://jslbfkaujahihvjdxcjg.supabase.co/rest/v1';
  var AK = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzbGJma2F1amFoaWh2amR4Y2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1ODA3MzksImV4cCI6MjA4ODE1NjczOX0.h1lCm-DOG8wgUpMc0Ob1fUDSGpSu_Ix6PpboggdAVAc';
  var stu = JSON.parse(localStorage.getItem('cq_student') || 'null');
  var isProf = stu && stu.role === 'teacher';
  
  // Cache locks in memory
  window._dqLocks = {};
  
  // Load all locks from Supabase
  window.loadLocks = function(callback) {
    fetch(SB + '/cq_locks?select=lock_key,is_locked', { headers: { 'apikey': AK } })
      .then(function(r) { return r.json(); })
      .then(function(data) {
        if (Array.isArray(data)) {
          for (var i = 0; i < data.length; i++) {
            window._dqLocks[data[i].lock_key] = data[i].is_locked;
          }
        }
        // Fallback: merge with localStorage cache
        var cached = JSON.parse(localStorage.getItem('dq_locks_cache') || '{}');
        for (var k in cached) {
          if (window._dqLocks[k] === undefined) window._dqLocks[k] = cached[k];
        }
        if (callback) callback(window._dqLocks);
      })
      .catch(function() {
        // Offline: use localStorage cache
        window._dqLocks = JSON.parse(localStorage.getItem('dq_locks_cache') || '{}');
        if (callback) callback(window._dqLocks);
      });
  };
  
  // Check if a key is locked
  window.isLocked = function(key) {
    if (isProf) return false; // Prof sees everything
    return window._dqLocks[key] === true;
  };
  
  // Toggle lock (prof only)
  window.toggleLock = function(key, callback) {
    if (!isProf) return;
    var newVal = !window._dqLocks[key];
    window._dqLocks[key] = newVal;
    
    // Save to localStorage cache
    localStorage.setItem('dq_locks_cache', JSON.stringify(window._dqLocks));
    
    // Upsert to Supabase
    fetch(SB + '/cq_locks?lock_key=eq.' + key, {
      method: 'PATCH',
      headers: { 'apikey': AK, 'Content-Type': 'application/json', 'Prefer': 'return=representation' },
      body: JSON.stringify({ is_locked: newVal, updated_at: new Date().toISOString() })
    }).then(function(r) { return r.json(); }).then(function(d) {
      if (!Array.isArray(d) || d.length === 0) {
        fetch(SB + '/cq_locks', {
          method: 'POST',
          headers: { 'apikey': AK, 'Content-Type': 'application/json' },
          body: JSON.stringify({ lock_key: key, is_locked: newVal })
        });
      }
      if (callback) callback(newVal);
    }).catch(function() {
      if (callback) callback(newVal);
    });
  };
  
  // Set lock to specific value (prof only)
  window.setLock = function(key, locked, callback) {
    if (!isProf) return;
    window._dqLocks[key] = locked;
    localStorage.setItem('dq_locks_cache', JSON.stringify(window._dqLocks));
    
    fetch(SB + '/cq_locks?lock_key=eq.' + key, {
      method: 'PATCH',
      headers: { 'apikey': AK, 'Content-Type': 'application/json', 'Prefer': 'return=representation' },
      body: JSON.stringify({ is_locked: locked, updated_at: new Date().toISOString() })
    }).then(function(r) { return r.json(); }).then(function(d) {
      if (!Array.isArray(d) || d.length === 0) {
        fetch(SB + '/cq_locks', {
          method: 'POST',
          headers: { 'apikey': AK, 'Content-Type': 'application/json' },
          body: JSON.stringify({ lock_key: key, is_locked: locked })
        });
      }
      if (callback) callback(locked);
    }).catch(function() { if (callback) callback(locked); });
  };
})();
