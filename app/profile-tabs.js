// profile-tabs.js — Shared sub-navigation for profile pages
// Include on: profile.html, cards.html, scores.html, docs.html, settings.html
(function() {
  var path = window.location.pathname || '';
  var page = path.split('/').pop();

  var tabs = [
    { label: '👤 Profil', href: 'profile.html', id: 'profile.html' },
    { label: '🃏 Cartes', href: 'cards.html', id: 'cards.html' },
    { label: '🏆 Classement', href: 'scores.html', id: 'scores.html' },
    { label: '📄 Documents', href: 'docs.html', id: 'docs.html' },
    { label: '⚙️ Paramètres', href: 'settings.html', id: 'settings.html' }
  ];

  var nav = document.createElement('div');
  nav.style.cssText = 'background:#111827;border-bottom:1px solid #1e3a5f;padding:.3rem .8rem;display:flex;gap:.2rem;flex-wrap:wrap;justify-content:center;font-family:Outfit,system-ui,sans-serif';

  for (var i = 0; i < tabs.length; i++) {
    var t = tabs[i];
    var isActive = page === t.id;
    var a = document.createElement('a');
    a.href = t.href;
    a.textContent = t.label;
    a.style.cssText = 'text-decoration:none;font-size:.7rem;font-weight:' + (isActive ? '800' : '600') + ';padding:.3rem .6rem;border-radius:5px;transition:all .2s;color:' + (isActive ? '#32E0C4' : '#94a3b8') + ';background:' + (isActive ? 'rgba(50,224,196,.08)' : 'transparent') + ';border:1px solid ' + (isActive ? 'rgba(50,224,196,.2)' : 'transparent');
    nav.appendChild(a);
  }

  // Insert after the first topbar-like element
  var topbar = document.querySelector('.topbar') || document.querySelector('[style*="border-bottom"]');
  if (topbar && topbar.nextSibling) {
    topbar.parentNode.insertBefore(nav, topbar.nextSibling);
  } else {
    // Fallback: insert after first child of body
    var kids = document.body.children;
    for (var j = 0; j < kids.length; j++) {
      if (kids[j].tagName !== 'SCRIPT') {
        kids[j].parentNode.insertBefore(nav, kids[j].nextSibling);
        break;
      }
    }
  }
})();
