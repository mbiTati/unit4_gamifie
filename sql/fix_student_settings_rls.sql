-- ============================================
-- MIGRATION: Fix RLS on cq_student_settings
-- À exécuter dans Supabase SQL Editor
-- ============================================

-- Ensure RLS is enabled
ALTER TABLE cq_student_settings ENABLE ROW LEVEL SECURITY;

-- SELECT: everyone can read (needed for classement to check scores_public)
DROP POLICY IF EXISTS cq_settings_select ON cq_student_settings;
CREATE POLICY cq_settings_select ON cq_student_settings FOR SELECT USING (true);

-- INSERT: anyone can insert their own settings  
DROP POLICY IF EXISTS cq_settings_insert ON cq_student_settings;
CREATE POLICY cq_settings_insert ON cq_student_settings FOR INSERT WITH CHECK (true);

-- UPDATE: anyone can update (filtered by student_id in the query)
DROP POLICY IF EXISTS cq_settings_update ON cq_student_settings;
CREATE POLICY cq_settings_update ON cq_student_settings FOR UPDATE USING (true);

GRANT ALL ON cq_student_settings TO anon, authenticated;
