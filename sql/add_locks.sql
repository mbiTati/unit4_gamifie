-- ============================================
-- TABLE DE VERROUILLAGE GÉNÉRIQUE
-- Le prof peut bloquer/débloquer n'importe quoi
-- À exécuter dans Supabase SQL Editor
-- ============================================

CREATE TABLE IF NOT EXISTS cq_locks (
  id SERIAL PRIMARY KEY,
  lock_key TEXT NOT NULL UNIQUE,
  is_locked BOOLEAN NOT NULL DEFAULT true,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE cq_locks ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_locks_all ON cq_locks;
CREATE POLICY cq_locks_all ON cq_locks FOR ALL USING (true) WITH CHECK (true);
GRANT ALL ON cq_locks TO anon, authenticated;
GRANT USAGE ON SEQUENCE cq_locks_id_seq TO anon, authenticated;

-- Valeurs par défaut (tout verrouillé)
INSERT INTO cq_locks (lock_key, is_locked) VALUES
  ('lo4', true),
  ('documents_corriges', true),
  ('projets_equipe', true),
  ('duel_sql', false),
  ('pipeline_bdd', false),
  ('quiz_live', false)
ON CONFLICT (lock_key) DO NOTHING;

SELECT 'Locks table created' as status;
