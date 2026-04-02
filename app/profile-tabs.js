// profile-tabs.js — Shared sub-navigation for profile pages
(function() {
  var path = window.location.pathname || '';
  var page = path.split('/').pop();

  var tabs = [
    { label: '\uD83D\uDC64 Profil', href: 'profile.html', id: 'profile.html' },
    { label: '\uD83C\uDCCF Cartes', href: 'cards.html', id: 'cards.html' },
    { label: '\uD83C\uDFC6 Classement', href: 'scores.html', id: 'scores.html' },
    { label: '\uD83D\uDCC4 Documents', href: 'docs.html', id: 'docs.html' },
    { label: '\u2699\uFE0F Param\u00e8tres', href: 'settings.html', id: 'settings.html' }
  ];

  var nav = document.createElement('div');
  nav.id = 'dqProfileTabs';
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

  // Insert after prof-bar or nav-bar (whichever is last at the top)
  var anchor = document.getElementById('dqProfBar') || document.getElementById('dqNavBar');
  if (anchor && anchor.nextSibling) {
    anchor.parentNode.insertBefore(nav, anchor.nextSibling);
  } else if (anchor) {
    anchor.parentNode.appendChild(nav);
  } else {
    if (document.body.firstChild) {
      document.body.insertBefore(nav, document.body.firstChild);
    }
  }
})();
