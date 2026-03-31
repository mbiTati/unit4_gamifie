-- ============================================
-- MIGRATION: Présence en temps réel + XP cours
-- À exécuter dans Supabase SQL Editor :
-- https://supabase.com/dashboard/project/jslbfkaujahihvjdxcjg/sql/new
-- ============================================

-- 1. Table de présence (où est chaque élève en ce moment)
CREATE TABLE IF NOT EXISTS cq_presence (
  id SERIAL PRIMARY KEY,
  student_id UUID NOT NULL REFERENCES cq_students(id) ON DELETE CASCADE,
  page_url TEXT NOT NULL,
  page_title TEXT,
  unit_id INTEGER DEFAULT 4,
  last_seen TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(student_id)  -- Un seul enregistrement par élève (mis à jour)
);

-- RLS
ALTER TABLE cq_presence ENABLE ROW LEVEL SECURITY;
CREATE POLICY cq_presence_select ON cq_presence FOR SELECT USING (true);
CREATE POLICY cq_presence_insert ON cq_presence FOR INSERT WITH CHECK (true);
CREATE POLICY cq_presence_update ON cq_presence FOR UPDATE USING (true);
CREATE POLICY cq_presence_delete ON cq_presence FOR DELETE USING (true);

GRANT ALL ON cq_presence TO anon, authenticated;
GRANT USAGE ON SEQUENCE cq_presence_id_seq TO anon, authenticated;

-- Index pour requête rapide
CREATE INDEX IF NOT EXISTS idx_presence_student ON cq_presence(student_id);
CREATE INDEX IF NOT EXISTS idx_presence_last_seen ON cq_presence(last_seen DESC);

-- 2. Fonction pour mettre à jour la présence (UPSERT)
CREATE OR REPLACE FUNCTION update_presence(
  p_student_id UUID,
  p_page_url TEXT,
  p_page_title TEXT DEFAULT NULL,
  p_unit_id INTEGER DEFAULT 4
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO cq_presence (student_id, page_url, page_title, unit_id, last_seen)
  VALUES (p_student_id, p_page_url, p_page_title, p_unit_id, NOW())
  ON CONFLICT (student_id) DO UPDATE SET
    page_url = p_page_url,
    page_title = p_page_title,
    unit_id = p_unit_id,
    last_seen = NOW();
END;
$$;

GRANT EXECUTE ON FUNCTION update_presence(UUID, TEXT, TEXT, INTEGER) TO anon, authenticated;
