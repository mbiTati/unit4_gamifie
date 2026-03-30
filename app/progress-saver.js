// progress-saver.js — Save game scores + module progress to Supabase
// Usage: include this script, then call saveGameScore() at end of game

const PROGRESS_SUPABASE_URL = 'https://jslbfkaujahihvjdxcjg.supabase.co';
const PROGRESS_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzbGJma2F1amFoaWh2amR4Y2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1ODA3MzksImV4cCI6MjA4ODE1NjczOX0.h1lCm-DOG8wgUpMc0Ob1fUDSGpSu_Ix6PpboggdAVAc';

async function saveGameScore(gameId, score, durationSeconds) {
  const student = JSON.parse(localStorage.getItem('cq_student') || 'null');
  if (!student) return;
  
  try {
    // Save to cq_game_scores
    await fetch(PROGRESS_SUPABASE_URL + '/rest/v1/cq_game_scores', {
      method: 'POST',
      headers: {
        'apikey': PROGRESS_ANON_KEY,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
      },
      body: JSON.stringify({
        student_id: student.id,
        game_id: gameId,
        score: score,
        duration_seconds: durationSeconds || 0,
      })
    });
    
    console.log('Score saved:', gameId, score);
  } catch(e) {
    console.error('Failed to save score:', e);
  }
}

async function saveModuleProgress(moduleId, creditsEarned, quizScore, totalQuestions) {
  const student = JSON.parse(localStorage.getItem('cq_student') || 'null');
  if (!student) return;
  
  try {
    // Check if progress exists
    const existing = await fetch(
      PROGRESS_SUPABASE_URL + '/rest/v1/cq_student_progress?student_id=eq.' + student.id + '&module_id=eq.' + moduleId + '&select=id,credits_earned',
      { headers: { 'apikey': PROGRESS_ANON_KEY } }
    ).then(r => r.json());
    
    if (Array.isArray(existing) && existing.length > 0) {
      // Update if new score is higher
      if (creditsEarned > (existing[0].credits_earned || 0)) {
        await fetch(
          PROGRESS_SUPABASE_URL + '/rest/v1/cq_student_progress?id=eq.' + existing[0].id,
          {
            method: 'PATCH',
            headers: { 'apikey': PROGRESS_ANON_KEY, 'Content-Type': 'application/json' },
            body: JSON.stringify({
              credits_earned: creditsEarned,
              quiz_score: quizScore || 0,
              total_questions: totalQuestions || 0,
              updated_at: new Date().toISOString(),
            })
          }
        );
      }
    } else {
      // Insert new progress
      await fetch(PROGRESS_SUPABASE_URL + '/rest/v1/cq_student_progress', {
        method: 'POST',
        headers: { 'apikey': PROGRESS_ANON_KEY, 'Content-Type': 'application/json', 'Prefer': 'return=representation' },
        body: JSON.stringify({
          student_id: student.id,
          module_id: moduleId,
          credits_earned: creditsEarned,
          quiz_score: quizScore || 0,
          total_questions: totalQuestions || 0,
          current_step: 1,
        })
      });
    }
    
    console.log('Progress saved: module', moduleId, 'credits', creditsEarned);
  } catch(e) {
    console.error('Failed to save progress:', e);
  }
}
