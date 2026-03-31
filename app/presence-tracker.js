// presence-tracker.js — Track student location + give XP for course viewing
// Include on every page: <script src="../../app/presence-tracker.js"></script>

(function() {
  var PURL = 'https://jslbfkaujahihvjdxcjg.supabase.co';
  var PKEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzbGJma2F1amFoaWh2amR4Y2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1ODA3MzksImV4cCI6MjA4ODE1NjczOX0.h1lCm-DOG8wgUpMc0Ob1fUDSGpSu_Ix6PpboggdAVAc';
  
  var student = JSON.parse(localStorage.getItem('cq_student') || 'null');
  if (!student || student.role === 'teacher') return;
  
  var pageUrl = window.location.pathname;
  var pageTitle = document.title;
  
  function sendPresence() {
    try {
      fetch(PURL + '/rest/v1/rpc/update_presence', {
        method: 'POST',
        headers: { 'apikey': PKEY, 'Content-Type': 'application/json' },
        body: JSON.stringify({
          p_student_id: student.id,
          p_page_url: pageUrl,
          p_page_title: pageTitle,
          p_unit_id: 4
        })
      }).catch(function(){});
    } catch(e) {}
  }
  
  // Send on load
  sendPresence();
  
  // Send every 30 seconds (heartbeat)
  setInterval(sendPresence, 30000);
  
  // Also give XP for viewing course content (modules, chapters)
  // Award 5 points per course page visited
  var isCoursePage = pageUrl.includes('/jeux/module') || 
                     pageUrl.includes('index.html') ||
                     pageUrl.includes('/jeux/exercices') ||
                     pageUrl.includes('/jeux/cas_') ||
                     pageUrl.includes('/jeux/boss_');
  
  if (isCoursePage) {
    // Track this page view as a game score (small XP for engagement)
    var viewKey = 'dq_viewed_' + pageUrl;
    if (!localStorage.getItem(viewKey)) {
      localStorage.setItem(viewKey, '1');
      // Award 5 points for first visit to this page
      if (typeof saveGameScore === 'function') {
        saveGameScore('course_view', 5, 0);
      }
    }
  }
})();
