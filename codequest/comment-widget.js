// CommentWidget — Bouton "Question au prof" injectable dans n'importe quelle page
// Usage: ajouter <script src="../codequest/comment-widget.js"></script> en bas de page

(function() {
  const SUPABASE_URL = 'https://jslbfkaujahihvjdxcjg.supabase.co';
  const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzbGJma2F1amFoaWh2amR4Y2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1ODA3MzksImV4cCI6MjA4ODE1NjczOX0.h1lCm-DOG8wgUpMc0Ob1fUDSGpSu_Ix6PpboggdAVAc';
  
  const student = JSON.parse(localStorage.getItem('cq_student') || 'null');
  if (!student) return; // Only for logged-in users
  
  // Create floating button
  const btn = document.createElement('div');
  btn.innerHTML = `
    <button id="cqCommentBtn" style="position:fixed;bottom:20px;right:20px;width:50px;height:50px;border-radius:50%;background:linear-gradient(135deg,#0D7377,#32E0C4);border:none;color:#fff;font-size:1.2rem;cursor:pointer;box-shadow:0 4px 15px rgba(50,224,196,.3);z-index:9999;transition:transform .2s" title="Question au prof" onclick="document.getElementById('cqCommentModal').style.display='flex'">?</button>
    <div id="cqCommentModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:10000;align-items:center;justify-content:center" onclick="if(event.target===this)this.style.display='none'">
      <div style="background:#1a2332;border:1px solid #1e3a5f;border-radius:12px;padding:1.5rem;width:90%;max-width:400px;color:#e2e8f0;font-family:Outfit,system-ui,sans-serif">
        <h3 style="font-size:.95rem;font-weight:700;margin-bottom:.8rem;color:#32E0C4">Question au prof</h3>
        <div style="font-size:.75rem;color:#94a3b8;margin-bottom:.5rem">Page : ${document.title}</div>
        <textarea id="cqCommentText" style="width:100%;min-height:80px;background:#111827;border:1px solid #1e3a5f;border-radius:6px;color:#e2e8f0;padding:.5rem;font-family:inherit;font-size:.85rem;resize:vertical" placeholder="Écrivez votre question ici..."></textarea>
        <div style="display:flex;gap:.5rem;margin-top:.8rem;justify-content:flex-end">
          <button onclick="document.getElementById('cqCommentModal').style.display='none'" style="padding:.4rem .8rem;background:#111827;border:1px solid #1e3a5f;border-radius:6px;color:#94a3b8;cursor:pointer;font-family:inherit;font-size:.78rem">Annuler</button>
          <button onclick="sendComment()" id="cqSendBtn" style="padding:.4rem .8rem;background:linear-gradient(135deg,#0D7377,#32E0C4);border:none;border-radius:6px;color:#fff;cursor:pointer;font-family:inherit;font-size:.78rem;font-weight:700">Envoyer</button>
        </div>
        <div id="cqCommentMsg" style="font-size:.78rem;margin-top:.5rem;min-height:1rem"></div>
      </div>
    </div>
  `;
  document.body.appendChild(btn);
  
  window.sendComment = async function() {
    const text = document.getElementById('cqCommentText').value.trim();
    const msg = document.getElementById('cqCommentMsg');
    if (!text) { msg.innerHTML = '<span style="color:#ef4444">Écrivez un message.</span>'; return; }
    
    document.getElementById('cqSendBtn').disabled = true;
    
    try {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/cq_comments`, {
        method: 'POST',
        headers: {
          'apikey': SUPABASE_ANON_KEY,
          'Content-Type': 'application/json',
          'Prefer': 'return=representation',
          'Authorization': `Bearer ${localStorage.getItem('cq_token') || SUPABASE_ANON_KEY}`,
        },
        body: JSON.stringify({
          student_id: student.id,
          content: text,
          page_context: document.title,
          unit_id: 4,
        })
      });
      
      if (res.ok) {
        msg.innerHTML = '<span style="color:#10b981">✅ Message envoyé !</span>';
        document.getElementById('cqCommentText').value = '';
        setTimeout(() => {
          document.getElementById('cqCommentModal').style.display = 'none';
          msg.textContent = '';
        }, 1500);
      } else {
        msg.innerHTML = '<span style="color:#ef4444">Erreur envoi.</span>';
      }
    } catch(e) {
      msg.innerHTML = '<span style="color:#ef4444">Erreur réseau.</span>';
    }
    document.getElementById('cqSendBtn').disabled = false;
  };
})();
