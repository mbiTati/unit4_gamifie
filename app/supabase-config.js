// DataQuest — Supabase client for Unit 4
const SUPABASE_URL = 'https://jslbfkaujahihvjdxcjg.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzbGJma2F1amFoaWh2amR4Y2pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1ODA3MzksImV4cCI6MjA4ODE1NjczOX0.h1lCm-DOG8wgUpMc0Ob1fUDSGpSu_Ix6PpboggdAVAc';
const UNIT_ID = 4;

// 9 Niveaux BDD
const XP_LEVELS = [
  { name: 'Data Padawan', min: 0, color: '#94a3b8' },
  { name: 'Query Rookie', min: 50, color: '#a78bfa' },
  { name: 'Table Builder', min: 150, color: '#60a5fa' },
  { name: 'Join Warrior', min: 300, color: '#34d399' },
  { name: 'Schema Architect', min: 500, color: '#fbbf24' },
  { name: 'Index Master', min: 750, color: '#f97316' },
  { name: 'Database Sensei', min: 1000, color: '#ef4444' },
  { name: 'Data Wizard', min: 1500, color: '#ec4899' },
  { name: 'SQL Overlord', min: 2000, color: '#8b5cf6' },
];

function getLevel(xp) {
  let lvl = XP_LEVELS[0];
  for (const l of XP_LEVELS) if (xp >= l.min) lvl = l;
  const idx = XP_LEVELS.indexOf(lvl);
  const next = XP_LEVELS[idx + 1];
  const progress = next ? (xp - lvl.min) / (next.min - lvl.min) : 1;
  return { ...lvl, index: idx, xp, nextMin: next?.min || lvl.min, progress: Math.min(progress, 1) };
}

// ===== SUPABASE CLIENT =====
function _headers(needsAuth) {
  const h = { 'apikey': SUPABASE_ANON_KEY, 'Content-Type': 'application/json' };
  if (needsAuth) {
    const token = localStorage.getItem('cq_token');
    if (token) h['Authorization'] = 'Bearer ' + token;
  }
  return h;
}

const supabase = {
  // READ — no auth needed (RLS SELECT USING(true))
  async query(table, options = {}) {
    let url = SUPABASE_URL + '/rest/v1/' + table;
    const params = new URLSearchParams();
    if (options.select) params.set('select', options.select);
    if (options.filter) for (const [k, v] of Object.entries(options.filter)) params.set(k, v);
    if (options.order) params.set('order', options.order);
    if (options.limit) params.set('limit', options.limit);
    const q = params.toString();
    if (q) url += '?' + q;
    const res = await fetch(url, { headers: _headers(false) });
    return res.json();
  },

  // WRITE — needs auth token
  async insert(table, data) {
    await this._ensureToken();
    let res = await fetch(SUPABASE_URL + '/rest/v1/' + table, {
      method: 'POST', headers: { ..._headers(true), 'Prefer': 'return=representation' },
      body: JSON.stringify(data)
    });
    // Retry with anon if auth expired
    if (res.status === 401 || res.status === 403) {
      res = await fetch(SUPABASE_URL + '/rest/v1/' + table, {
        method: 'POST', headers: { ..._headers(false), 'Prefer': 'return=representation' },
        body: JSON.stringify(data)
      });
    }
    return res.json();
  },

  async update(table, data, filter) {
    await this._ensureToken();
    const params = new URLSearchParams(filter);
    const res = await fetch(SUPABASE_URL + '/rest/v1/' + table + '?' + params.toString(), {
      method: 'PATCH', headers: { ..._headers(true), 'Prefer': 'return=representation' },
      body: JSON.stringify(data)
    });
    return res.json();
  },

  async delete(table, filter) {
    await this._ensureToken();
    const params = new URLSearchParams(filter);
    const res = await fetch(SUPABASE_URL + '/rest/v1/' + table + '?' + params.toString(), {
      method: 'DELETE', headers: _headers(true)
    });
    return res.ok;
  },

  async rpc(fn, params = {}) {
    await this._ensureToken();
    let res = await fetch(SUPABASE_URL + '/rest/v1/rpc/' + fn, {
      method: 'POST', headers: _headers(true), body: JSON.stringify(params)
    });
    // If auth fails, retry with anon key only
    if (res.status === 401 || res.status === 403) {
      res = await fetch(SUPABASE_URL + '/rest/v1/rpc/' + fn, {
        method: 'POST', headers: _headers(false), body: JSON.stringify(params)
      });
    }
    return res.json();
  },

  // AUTH
  async signIn(email, password) {
    const res = await fetch(SUPABASE_URL + '/auth/v1/token?grant_type=password', {
      method: 'POST', headers: { 'apikey': SUPABASE_ANON_KEY, 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });
    const data = await res.json();
    if (data.access_token) {
      localStorage.setItem('cq_token', data.access_token);
      localStorage.setItem('cq_refresh', data.refresh_token);
      localStorage.setItem('cq_user', JSON.stringify(data.user));
    }
    return data;
  },

  async signOut() {
    localStorage.removeItem('cq_token');
    localStorage.removeItem('cq_refresh');
    localStorage.removeItem('cq_user');
    localStorage.removeItem('cq_student');
  },

  getUser() { const u = localStorage.getItem('cq_user'); return u ? JSON.parse(u) : null; },
  isLoggedIn() { return !!localStorage.getItem('cq_token'); },

  // Token refresh
  async _ensureToken() {
    const token = localStorage.getItem('cq_token');
    if (!token) return;
    // Check if token is expired (JWT decode)
    try {
      const payload = JSON.parse(atob(token.split('.')[1]));
      if (payload.exp * 1000 < Date.now() - 60000) { // expired or expiring in 1 min
        await this.refreshToken();
      }
    } catch(e) {}
  },

  async refreshToken() {
    const refresh = localStorage.getItem('cq_refresh');
    if (!refresh) return false;
    try {
      const res = await fetch(SUPABASE_URL + '/auth/v1/token?grant_type=refresh_token', {
        method: 'POST', headers: { 'apikey': SUPABASE_ANON_KEY, 'Content-Type': 'application/json' },
        body: JSON.stringify({ refresh_token: refresh })
      });
      const data = await res.json();
      if (data.access_token) {
        localStorage.setItem('cq_token', data.access_token);
        localStorage.setItem('cq_refresh', data.refresh_token);
        return true;
      }
    } catch(e) {}
    return false;
  },
};
