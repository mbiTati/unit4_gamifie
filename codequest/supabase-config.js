// Supabase client for CodeQuest - Unit 4
const SUPABASE_URL = 'https://jslbfkaujahihvjdxcjg.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzbGJma2F1amFoaWh2amR4Y2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1ODA3MzksImV4cCI6MjA4ODE1NjczOX0.h1lCm-DOG8wgUpMc0Ob1fUDSGpSu_Ix6PpboggdAVAc';
const UNIT_ID = 4;

// XP Levels (shared across all 3 apps)
const XP_LEVELS = [
  { name: 'Noob Master', min: 0, color: '#94a3b8' },
  { name: 'Noob Coder', min: 50, color: '#a78bfa' },
  { name: 'Little Coder', min: 150, color: '#60a5fa' },
  { name: 'Vibe Coder', min: 300, color: '#34d399' },
  { name: 'Code Rookie', min: 500, color: '#fbbf24' },
  { name: 'J Coder', min: 750, color: '#f97316' },
  { name: 'Code Master', min: 1000, color: '#ef4444' },
  { name: 'Code Legend', min: 1500, color: '#ec4899' },
  { name: 'Lord Coder', min: 2000, color: '#8b5cf6' },
];

function getLevel(xp) {
  let lvl = XP_LEVELS[0];
  for (const l of XP_LEVELS) {
    if (xp >= l.min) lvl = l;
  }
  const idx = XP_LEVELS.indexOf(lvl);
  const next = XP_LEVELS[idx + 1];
  const progress = next ? (xp - lvl.min) / (next.min - lvl.min) : 1;
  return { ...lvl, index: idx, xp, nextMin: next?.min || lvl.min, progress: Math.min(progress, 1) };
}

// Supabase client (using fetch, no SDK needed)
const supabase = {
  async query(table, options = {}) {
    let url = `${SUPABASE_URL}/rest/v1/${table}`;
    const params = new URLSearchParams();
    if (options.select) params.set('select', options.select);
    if (options.filter) {
      for (const [key, val] of Object.entries(options.filter)) {
        params.set(key, val);
      }
    }
    if (options.order) params.set('order', options.order);
    if (options.limit) params.set('limit', options.limit);
    const q = params.toString();
    if (q) url += '?' + q;

    const headers = {
      'apikey': SUPABASE_ANON_KEY,
      'Content-Type': 'application/json',
    };
    const token = localStorage.getItem('cq_token');
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const res = await fetch(url, { headers });
    return res.json();
  },

  async insert(table, data) {
    const url = `${SUPABASE_URL}/rest/v1/${table}`;
    const headers = {
      'apikey': SUPABASE_ANON_KEY,
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    };
    const token = localStorage.getItem('cq_token');
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const res = await fetch(url, { method: 'POST', headers, body: JSON.stringify(data) });
    return res.json();
  },

  async update(table, data, filter) {
    let url = `${SUPABASE_URL}/rest/v1/${table}`;
    const params = new URLSearchParams(filter);
    url += '?' + params.toString();

    const headers = {
      'apikey': SUPABASE_ANON_KEY,
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    };
    const token = localStorage.getItem('cq_token');
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const res = await fetch(url, { method: 'PATCH', headers, body: JSON.stringify(data) });
    return res.json();
  },

  async rpc(fn, params = {}) {
    const url = `${SUPABASE_URL}/rest/v1/rpc/${fn}`;
    const headers = {
      'apikey': SUPABASE_ANON_KEY,
      'Content-Type': 'application/json',
    };
    const token = localStorage.getItem('cq_token');
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const res = await fetch(url, { method: 'POST', headers, body: JSON.stringify(params) });
    return res.json();
  },

  // Auth
  async signIn(email, password) {
    const url = `${SUPABASE_URL}/auth/v1/token?grant_type=password`;
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON_KEY, 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    const data = await res.json();
    if (data.access_token) {
      localStorage.setItem('cq_token', data.access_token);
      localStorage.setItem('cq_refresh', data.refresh_token);
      localStorage.setItem('cq_user', JSON.stringify(data.user));
    }
    return data;
  },

  async signUp(email, password) {
    const url = `${SUPABASE_URL}/auth/v1/signup`;
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'apikey': SUPABASE_ANON_KEY, 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    });
    return res.json();
  },

  async signOut() {
    localStorage.removeItem('cq_token');
    localStorage.removeItem('cq_refresh');
    localStorage.removeItem('cq_user');
  },

  getUser() {
    const u = localStorage.getItem('cq_user');
    return u ? JSON.parse(u) : null;
  },

  isLoggedIn() {
    return !!localStorage.getItem('cq_token');
  },

  // Execute SQL on gescom/swisssound (read-only via RPC)
  async executeSQL(query) {
    // This will use a Supabase RPC function for safe SQL execution
    return this.rpc('execute_readonly_sql', { sql_query: query });
  }
};
