// nav.js — Navigation unifiée DataQuest
// Injecté sur TOUTES les pages pour une expérience cohérente
(function() {
  var stu = JSON.parse(localStorage.getItem('cq_student') || 'null');
  if (!stu) return;
  var isProf = stu.role === 'teacher';
  
  // Detect path depth for relative links
  var path = window.location.pathname || '';
  var prefix = '';
  if (path.indexOf('/app/') > -1) prefix = '';
  else if (path.indexOf('/jeux/') > -1) prefix = '../../app/';
  else prefix = 'app/'; // index.html level

  var hubLink = prefix ? prefix.replace('app/','') + 'index.html' : '../index.html';
  if (path.indexOf('/app/') > -1) hubLink = '../index.html';
  if (path === '/index.html' || path === '/' || path.indexOf('index.html') > -1 && path.indexOf('/jeux/') === -1) hubLink = 'index.html';

  // Build nav HTML
  var nav = document.createElement('div');
  nav.id = 'dqNav';
  nav.innerHTML = 
    // Prof banner
    (isProf ? '<div style="background:linear-gradient(135deg,rgba(245,158,11,.08),rgba(239,68,68,.04));border-bottom:1px solid rgba(245,158,11,.2);padding:.35rem 1rem;display:flex;align-items:center;gap:.8rem;flex-wrap:wrap;font-family:Outfit,system-ui,sans-serif;font-size:.7rem">' +
      '<span style="color:#F59E0B;font-weight:800">👑 PROF</span>' +
      '<a href="' + prefix + 'teacher.html" style="color:#F59E0B;text-decoration:none;font-weight:600">Dashboard</a>' +
      '<a href="' + prefix + 'teacher.html?tab=docs" style="color:#F59E0B;text-decoration:none;font-weight:600">Corrigés</a>' +
      '<a href="' + prefix + 'teacher.html?tab=access" style="color:#F59E0B;text-decoration:none;font-weight:600">🔒 Accès</a>' +
      '<a href="https://supabase.com/dashboard/project/jslbfkaujahihvjdxcjg/storage/buckets/team-uploads" target="_blank" style="color:#ef4444;text-decoration:none;font-weight:600">📥 Fichiers</a>' +
    '</div>' : '') +
    // Main nav
    '<div style="background:#111827;border-bottom:1px solid #1e3a5f;padding:.5rem 1rem;display:flex;align-items:center;gap:.1rem;flex-wrap:wrap;font-family:Outfit,system-ui,sans-serif">' +
      '<a href="' + hubLink + '" style="font-size:.9rem;font-weight:900;color:#32E0C4;text-decoration:none;margin-right:.8rem">🎮 DataQuest</a>' +
      '<a href="' + hubLink + '#cours" onclick="localStorage.setItem(\'dq_hub_tab\',\'cours\')" class="dqnav-link">Cours</a>' +
      '<a href="' + hubLink + '#activites" onclick="localStorage.setItem(\'dq_hub_tab\',\'activites\')" class="dqnav-link">Activités</a>' +
      '<a href="' + prefix + 'home.html" class="dqnav-link">Mon Profil</a>' +
      '<a href="' + prefix + 'scores.html" class="dqnav-link">Classement</a>' +
      '<a href="' + prefix + 'docs.html" class="dqnav-link">Documents</a>' +
      '<a href="' + prefix + 'cards.html" class="dqnav-link" style="color:#F59E0B">🃏 Cartes</a>' +
      '<div style="margin-left:auto;display:flex;gap:.1rem;align-items:center">' +
        '<a href="' + prefix + 'settings.html" class="dqnav-link">⚙️</a>' +
        '<button onclick="localStorage.clear();window.location.href=\'' + prefix + 'login.html\'" class="dqnav-link" style="background:none;border:1px solid #1e3a5f;cursor:pointer;font-family:inherit">Déconnexion</button>' +
      '</div>' +
    '</div>';

  // Inject CSS
  var style = document.createElement('style');
  style.textContent = '.dqnav-link{color:#94a3b8;text-decoration:none;font-size:.72rem;font-weight:600;padding:.3rem .55rem;border-radius:5px;border:1px solid transparent;transition:all .15s;font-family:Outfit,system-ui,sans-serif}.dqnav-link:hover{color:#e2e8f0;background:rgba(255,255,255,.04);border-color:#1e3a5f}';
  document.head.appendChild(style);

  // Highlight current page
  var links = nav.querySelectorAll('.dqnav-link');
  for (var i = 0; i < links.length; i++) {
    var href = links[i].getAttribute('href') || '';
    if (href && path.indexOf(href.replace('../','').replace('app/','')) > -1 && href.indexOf('#') === -1) {
      links[i].style.color = '#32E0C4';
      links[i].style.borderColor = 'rgba(50,224,196,.3)';
    }
  }
  // Highlight Cours/Activités on hub
  if (path.indexOf('index.html') > -1 || path === '/') {
    var tab = localStorage.getItem('dq_hub_tab') || 'cours';
    for (var j = 0; j < links.length; j++) {
      var h = links[j].getAttribute('href') || '';
      if (h.indexOf('#cours') > -1 && tab === 'cours') { links[j].style.color = '#32E0C4'; links[j].style.borderColor = 'rgba(50,224,196,.3)'; }
      if (h.indexOf('#activites') > -1 && tab === 'activites') { links[j].style.color = '#F59E0B'; links[j].style.borderColor = 'rgba(245,158,11,.3)'; }
    }
  }

  // Insert at very top of body
  document.body.insertBefore(nav, document.body.firstChild);
})();
