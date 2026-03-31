-- ============================================
-- TOUTES LES MIGRATIONS À EXÉCUTER
-- Copier-coller dans Supabase SQL Editor :
-- https://supabase.com/dashboard/project/jslbfkaujahihvjdxcjg/sql/new
-- ============================================

-- 1. unit_id sur cq_game_scores
ALTER TABLE cq_game_scores ADD COLUMN IF NOT EXISTS unit_id INTEGER DEFAULT 4;
UPDATE cq_game_scores SET unit_id = 4 WHERE unit_id IS NULL;
CREATE INDEX IF NOT EXISTS idx_game_scores_unit ON cq_game_scores(unit_id);

-- 2. unit_id sur cq_student_progress
ALTER TABLE cq_student_progress ADD COLUMN IF NOT EXISTS unit_id INTEGER DEFAULT 4;
UPDATE cq_student_progress SET unit_id = 4 WHERE unit_id IS NULL;
CREATE INDEX IF NOT EXISTS idx_progress_unit ON cq_student_progress(unit_id);

-- 3. Table cq_student_settings (scores public/privé)
CREATE TABLE IF NOT EXISTS cq_student_settings (
  id SERIAL PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES cq_students(id) ON DELETE CASCADE UNIQUE,
  scores_public BOOLEAN DEFAULT true,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE cq_student_settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_settings_select ON cq_student_settings;
CREATE POLICY cq_settings_select ON cq_student_settings FOR SELECT USING (true);
DROP POLICY IF EXISTS cq_settings_insert ON cq_student_settings;
CREATE POLICY cq_settings_insert ON cq_student_settings FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS cq_settings_update ON cq_student_settings;
CREATE POLICY cq_settings_update ON cq_student_settings FOR UPDATE USING (true);
GRANT ALL ON cq_student_settings TO anon, authenticated;
GRANT USAGE ON SEQUENCE cq_student_settings_id_seq TO anon, authenticated;

-- 4. Table cq_presence (suivi temps réel)
CREATE TABLE IF NOT EXISTS cq_presence (
  id SERIAL PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES cq_students(id) ON DELETE CASCADE UNIQUE,
  page_url TEXT NOT NULL,
  page_title TEXT,
  unit_id INTEGER DEFAULT 4,
  last_seen TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
ALTER TABLE cq_presence ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_presence_select ON cq_presence;
CREATE POLICY cq_presence_select ON cq_presence FOR SELECT USING (true);
DROP POLICY IF EXISTS cq_presence_insert ON cq_presence;
CREATE POLICY cq_presence_insert ON cq_presence FOR INSERT WITH CHECK (true);
DROP POLICY IF EXISTS cq_presence_update ON cq_presence;
CREATE POLICY cq_presence_update ON cq_presence FOR UPDATE USING (true);
DROP POLICY IF EXISTS cq_presence_delete ON cq_presence;
CREATE POLICY cq_presence_delete ON cq_presence FOR DELETE USING (true);
GRANT ALL ON cq_presence TO anon, authenticated;
GRANT USAGE ON SEQUENCE cq_presence_id_seq TO anon, authenticated;
CREATE INDEX IF NOT EXISTS idx_presence_student ON cq_presence(student_id);
CREATE INDEX IF NOT EXISTS idx_presence_last_seen ON cq_presence(last_seen DESC);

-- 5. RPC update_presence
CREATE OR REPLACE FUNCTION update_presence(
  p_student_id UUID, p_page_url TEXT, 
  p_page_title TEXT DEFAULT NULL, p_unit_id INTEGER DEFAULT 4
) RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO cq_presence (student_id, page_url, page_title, unit_id, last_seen)
  VALUES (p_student_id, p_page_url, p_page_title, p_unit_id, NOW())
  ON CONFLICT (student_id) DO UPDATE SET
    page_url = p_page_url, page_title = p_page_title,
    unit_id = p_unit_id, last_seen = NOW();
END; $$;
GRANT EXECUTE ON FUNCTION update_presence(UUID, TEXT, TEXT, INTEGER) TO anon, authenticated;

-- 6. Table cq_duels (Duel SQL)
CREATE TABLE IF NOT EXISTS cq_duels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player1_id UUID NOT NULL REFERENCES cq_students(id),
  player2_id UUID REFERENCES cq_students(id),
  status TEXT NOT NULL DEFAULT 'waiting',
  questions JSONB NOT NULL DEFAULT '[]',
  player1_score INTEGER DEFAULT 0,
  player2_score INTEGER DEFAULT 0,
  unit_id INTEGER DEFAULT 4,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE cq_duels ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_duels_all ON cq_duels;
CREATE POLICY cq_duels_all ON cq_duels FOR ALL USING (true) WITH CHECK (true);
GRANT ALL ON cq_duels TO anon, authenticated;
CREATE INDEX IF NOT EXISTS idx_duels_status ON cq_duels(status);

-- 7. RLS sur cq_game_scores (si manquant)
ALTER TABLE cq_game_scores ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_game_scores_select ON cq_game_scores;
CREATE POLICY cq_game_scores_select ON cq_game_scores FOR SELECT USING (true);
DROP POLICY IF EXISTS cq_game_scores_insert ON cq_game_scores;
CREATE POLICY cq_game_scores_insert ON cq_game_scores FOR INSERT WITH CHECK (true);
GRANT ALL ON cq_game_scores TO anon, authenticated;

-- DONE
SELECT 'ALL MIGRATIONS APPLIED' as status;
