// duel-notify.js — Check for incoming duel challenges on ANY page
// Shows a floating popup with Accept/Decline buttons
(function() {
  var DURL = 'https://jslbfkaujahihvjdxcjg.supabase.co/rest/v1';
  var DKEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzbGJma2F1amFoaWh2amR4Y2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1ODA3MzksImV4cCI6MjA4ODE1NjczOX0.h1lCm-DOG8wgUpMc0Ob1fUDSGpSu_Ix6PpboggdAVAc';
  
  var student = JSON.parse(localStorage.getItem('cq_student') || 'null');
  if (!student || student.role === 'teacher') return;
  
  var lastCheckedDuel = null;
  
  function checkForDuels() {
    fetch(DURL + '/cq_duels?player2_id=eq.' + student.id + '&status=eq.waiting&order=created_at.desc&limit=1', {
      headers: { 'apikey': DKEY }
    })
    .then(function(r) { return r.json(); })
    .then(function(duels) {
      if (!Array.isArray(duels) || duels.length === 0) return;
      var duel = duels[0];
      
      // Don't show same duel twice
      if (lastCheckedDuel === duel.id) return;
      lastCheckedDuel = duel.id;
      
      // Ignore duels older than 2 minutes
      var created = new Date(duel.created_at);
      if ((new Date() - created) > 120000) return;
      
      // Get challenger name
      fetch(DURL + '/cq_students?id=eq.' + duel.player1_id + '&select=first_name,last_name', {
        headers: { 'apikey': DKEY }
      })
      .then(function(r) { return r.json(); })
      .then(function(students) {
        var name = 'Un camarade';
        if (Array.isArray(students) && students[0]) {
          name = students[0].first_name + ' ' + students[0].last_name;
        }
        showDuelPopup(duel.id, name);
      });
    })
    .catch(function() {});
  }
  
  function showDuelPopup(duelId, challengerName) {
    // Remove existing popup
    var old = document.getElementById('dqDuelPopup');
    if (old) old.remove();
    
    var popup = document.createElement('div');
    popup.id = 'dqDuelPopup';
    popup.style.cssText = 'position:fixed;top:20px;right:20px;z-index:99999;background:#1a2332;border:2px solid #F59E0B;border-radius:12px;padding:1.2rem;width:300px;box-shadow:0 20px 60px rgba(0,0,0,.6);animation:dqSlideIn .4s ease;font-family:Outfit,system-ui,sans-serif';
    
    popup.innerHTML = '' +
      '<style>@keyframes dqSlideIn{from{transform:translateX(120%);opacity:0}to{transform:translateX(0);opacity:1}}@keyframes dqPulse{0%,100%{box-shadow:0 0 0 0 rgba(245,158,11,.4)}50%{box-shadow:0 0 20px 5px rgba(245,158,11,.2)}}</style>' +
      '<div style="display:flex;align-items:center;gap:.5rem;margin-bottom:.6rem">' +
        '<span style="font-size:1.5rem">⚔️</span>' +
        '<div>' +
          '<div style="font-size:.9rem;font-weight:800;color:#F59E0B">DÉFI SQL !</div>' +
          '<div style="font-size:.7rem;color:#94a3b8">Duel en temps réel</div>' +
        '</div>' +
      '</div>' +
      '<div style="font-size:.85rem;margin-bottom:.8rem;color:#e2e8f0"><strong>' + challengerName + '</strong> vous défie en duel SQL !</div>' +
      '<div style="font-size:.7rem;color:#94a3b8;margin-bottom:.8rem">8 questions SQL · 5 minutes · Le plus rapide gagne</div>' +
      '<div style="display:flex;gap:.4rem">' +
        '<button onclick="dqAcceptDuel(\'' + duelId + '\')" style="flex:1;padding:.5rem;background:linear-gradient(135deg,#F59E0B,#d97706);color:#fff;border:none;border-radius:6px;font-family:inherit;font-weight:700;font-size:.82rem;cursor:pointer">Accepter ⚔️</button>' +
        '<button onclick="dqDeclineDuel(\'' + duelId + '\')" style="padding:.5rem .8rem;background:#111827;color:#94a3b8;border:1px solid #1e3a5f;border-radius:6px;font-family:inherit;font-size:.75rem;cursor:pointer">Non</button>' +
      '</div>' +
      '<div style="font-size:.6rem;color:#64748b;margin-top:.4rem;text-align:center">Disparaît dans 2 minutes</div>';
    
    document.body.appendChild(popup);
    
    // Auto-remove after 2 minutes
    setTimeout(function() {
      var el = document.getElementById('dqDuelPopup');
      if (el) el.remove();
    }, 120000);
  }
  
  // Accept: update status, redirect to duel page
  window.dqAcceptDuel = function(duelId) {
    fetch(DURL + '/cq_duels?id=eq.' + duelId, {
      method: 'PATCH',
      headers: { 'apikey': DKEY, 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: 'playing', updated_at: new Date().toISOString() })
    }).then(function() {
      // Redirect to duel page with duel ID
      var base = window.location.pathname.includes('/jeux/') ? '../../app/' : 
                 window.location.pathname.includes('/app/') ? '' : 'app/';
      window.location.href = base + 'duel-sql.html?duel=' + duelId;
    });
  };
  
  // Decline: delete duel, remove popup
  window.dqDeclineDuel = function(duelId) {
    fetch(DURL + '/cq_duels?id=eq.' + duelId, {
      method: 'DELETE',
      headers: { 'apikey': DKEY }
    });
    var el = document.getElementById('dqDuelPopup');
    if (el) el.remove();
    lastCheckedDuel = null;
  };
  
  // Check every 5 seconds
  checkForDuels();
  setInterval(checkForDuels, 5000);
})();
