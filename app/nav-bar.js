// nav-bar.js — Shared DataQuest navigation bar on all pages
(function() {
  var student = null;
  try { student = JSON.parse(localStorage.getItem('cq_student') || 'null'); } catch(e) {}
  if (!student) return;

  // Skip if there's already a dqNavBar on the page (index.html has its own)
  if (document.getElementById('dqNavBar')) return;

  var path = window.location.pathname || '';

  // Determine link prefixes
  var appPrefix = '';
  var indexHref = '';
  if (path.indexOf('/jeux/') > -1) {
    appPrefix = '../../app/';
    indexHref = '../../index.html';
  } else if (path.indexOf('/app/') > -1) {
    appPrefix = '';
    indexHref = '../index.html';
  } else {
    appPrefix = 'app/';
    indexHref = 'index.html';
  }

  // Detect current page for highlight
  var page = path.split('/').pop();

  function lnk(href, label, active) {
    var color = active ? '#32E0C4' : '#e2e8f0';
    var border = active ? '#0D7377' : '#1e3a5f';
    return '<a href="' + href + '" style="color:' + color + ';text-decoration:none;font-size:.7rem;font-weight:600;border:1px solid ' + border + ';padding:.25rem .5rem;border-radius:4px;font-family:Outfit,system-ui,sans-serif">' + label + '</a>';
  }

  var nav = document.createElement('div');
  nav.id = 'dqNavBar';
  nav.style.cssText = 'background:#0a0f1a;border-bottom:1px solid #1e3a5f;padding:.5rem 1rem;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:.5rem;position:sticky;top:0;z-index:999';

  var left = '<div style="display:flex;align-items:center;gap:.6rem">';
  left += '<a href="' + appPrefix + 'home.html" style="font-family:Outfit,system-ui,sans-serif;font-size:.85rem;font-weight:800;background:linear-gradient(135deg,#32E0C4,#0D7377);-webkit-background-clip:text;-webkit-text-fill-color:transparent;text-decoration:none">DataQuest</a>';
  left += '<span style="font-size:.6rem;color:#94a3b8">' + student.first_name + ' ' + student.last_name + '</span>';
  left += '</div>';

  var right = '<div style="display:flex;gap:.4rem;flex-wrap:wrap">';
  right += lnk(appPrefix + 'home.html', 'Accueil', page === 'home.html');
  right += lnk(indexHref, 'Cours', page === 'index.html');
  right += lnk(appPrefix + 'profile.html', 'Mon Profil', page === 'profile.html');
  right += lnk(appPrefix + 'scores.html', 'Classement', page === 'scores.html');
  right += '<button onclick="try{if(window.supabase)supabase.signOut();}catch(e){}localStorage.clear();window.location.href=\'' + appPrefix + 'login.html\'" style="color:#94a3b8;font-size:.7rem;font-weight:600;border:1px solid #1e3a5f;padding:.25rem .5rem;border-radius:4px;background:none;cursor:pointer;font-family:Outfit,system-ui,sans-serif">D\u00e9connexion</button>';
  right += '</div>';

  nav.innerHTML = left + right;

  // Insert at very top of body (before prof-bar)
  if (document.body.firstChild) {
    document.body.insertBefore(nav, document.body.firstChild);
  } else {
    document.body.appendChild(nav);
  }

  // Hide any existing page-specific topbar
  var oldTop = document.querySelector('.top');
  if (oldTop) oldTop.style.display = 'none';
  var oldTopbar = document.querySelector('.topbar');
  if (oldTopbar) oldTopbar.style.display = 'none';
})();
