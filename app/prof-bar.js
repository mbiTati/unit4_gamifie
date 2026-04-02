// prof-bar.js — Teacher banner + back button injected on all pages
// Include via <script src="prof-bar.js?v=TIMESTAMP"></script> on every page
(function() {
  var student = null;
  try { student = JSON.parse(localStorage.getItem('cq_student') || 'null'); } catch(e) {}
  if (!student) return;

  var isTeacher = student.role === 'teacher';

  // ===== BACK BUTTON (all users) =====
  var path = window.location.pathname || '';
  var backHref = null;
  var backLabel = '← Retour';

  // Determine back target based on current page
  if (path.indexOf('/jeux/') > -1) {
    // Game pages → back to index.html (cours hub)
    // jeux are at root level: jeux/xxx/index.html → ../../index.html
    backHref = '../../index.html';
  } else if (path.indexOf('/app/') > -1) {
    var page = path.split('/').pop();
    // Profile group pages → back to profile
    if (['cards.html','scores.html','docs.html','settings.html'].indexOf(page) > -1) {
      backHref = 'profile.html';
    }
    // Activity pages → back to activites or home
    else if (['duel-sql.html','pipeline-bdd.html','team-projects.html'].indexOf(page) > -1) {
      backHref = 'activites.html';
    }
    // Game-like pages in app/ → back to index.html
    else if (['join-master.html','normalisation-puzzle.html','query-racer.html','constraint-catcher.html','df-explorer.html','erd-builder.html','quiz-live.html','table-designer.html','sql-editor.html','block-animations.html'].indexOf(page) > -1) {
      backHref = '../index.html';
    }
    // Projet → back to home
    else if (['projet-veloshop.html','veloshop-app.html','veloshop-corrige.html'].indexOf(page) > -1) {
      backHref = 'home.html';
    }
    // Activites → back to home
    else if (page === 'activites.html') {
      backHref = 'home.html';
    }
    // Avatar shop → back to profile
    else if (page === 'avatar-shop.html') {
      backHref = 'profile.html';
    }
    // Profile itself → back to home
    else if (page === 'profile.html') {
      backHref = 'home.html';
    }
    // Home, login, teacher → no back button
  }

  if (backHref) {
    var backBtn = document.createElement('a');
    backBtn.href = backHref;
    backBtn.textContent = backLabel;
    backBtn.style.cssText = 'position:fixed;top:8px;left:8px;z-index:10000;color:#94a3b8;text-decoration:none;font-family:Outfit,system-ui,sans-serif;font-size:.72rem;font-weight:700;background:rgba(17,24,39,.9);border:1px solid #1e3a5f;padding:.3rem .6rem;border-radius:6px;backdrop-filter:blur(4px);transition:all .2s';
    backBtn.addEventListener('mouseover', function() { this.style.color = '#32E0C4'; this.style.borderColor = '#0D7377'; });
    backBtn.addEventListener('mouseout', function() { this.style.color = '#94a3b8'; this.style.borderColor = '#1e3a5f'; });
    document.body.appendChild(backBtn);
  }

  // ===== PROF BAR (teacher only) =====
  if (!isTeacher) return;

  // Determine relative path prefix for links
  var prefix = '';
  if (path.indexOf('/jeux/') > -1) {
    prefix = '../../app/';
  } else if (path.indexOf('/app/') > -1) {
    prefix = '';
  } else {
    // Root level (index.html, exercices-entreprise.html)
    prefix = 'app/';
  }

  var indexPrefix = '';
  if (path.indexOf('/jeux/') > -1) {
    indexPrefix = '../../';
  } else if (path.indexOf('/app/') > -1) {
    indexPrefix = '../';
  } else {
    indexPrefix = '';
  }

  var bar = document.createElement('div');
  bar.id = 'dqProfBar';
  bar.style.cssText = 'background:rgba(245,158,11,.06);border-bottom:1px solid rgba(245,158,11,.15);padding:.35rem 1rem;display:flex;align-items:center;gap:.8rem;font-size:.7rem;font-family:Outfit,system-ui,sans-serif;flex-wrap:wrap;position:sticky;top:0;z-index:9999';

  var links = [
    { label: 'Dashboard', href: prefix + 'teacher.html', emoji: '' },
    { label: 'Acc\u00e8s', href: prefix + 'teacher.html?tab=access', emoji: '\uD83D\uDD12 ' },
    { label: 'Projets', href: prefix + 'teacher.html?tab=projets', emoji: '\uD83D\uDCCB ' },
    { label: 'Mes Cours', href: indexPrefix + 'index.html', emoji: '' },
    { label: 'Mes Documents', href: prefix + 'teacher.html?tab=docs', emoji: '' },
    { label: 'Fichiers', href: 'https://supabase.com/dashboard/project/jslbfkaujahihvjdxcjg/storage/buckets/team-uploads', emoji: '\uD83D\uDCE5 ', target: '_blank' }
  ];

  var html = '<span style="color:#F59E0B;font-weight:800;margin-right:.3rem">👑 PROF</span>';
  for (var i = 0; i < links.length; i++) {
    var lk = links[i];
    var tgt = lk.target ? ' target="' + lk.target + '"' : '';
    html += '<a href="' + lk.href + '"' + tgt + ' style="color:#F59E0B;text-decoration:none;font-weight:600;padding:.15rem .4rem;border:1px solid rgba(245,158,11,.2);border-radius:4px;transition:all .2s">' + lk.emoji + lk.label + '</a>';
  }
  bar.innerHTML = html;

  // Insert at very top of body
  if (document.body.firstChild) {
    document.body.insertBefore(bar, document.body.firstChild);
  } else {
    document.body.appendChild(bar);
  }

  // Hide any existing prof-bar in the page (like the one in home.html)
  var oldBar = document.getElementById('profBar');
  if (oldBar) oldBar.style.display = 'none';
})();
