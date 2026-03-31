-- ============================================
-- MIGRATION: Ajouter unit_id à cq_game_scores et cq_student_progress
-- À exécuter dans Supabase SQL Editor :
-- https://supabase.com/dashboard/project/jslbfkaujahihvjdxcjg/sql/new
-- ============================================

-- 1. Ajouter unit_id à cq_game_scores
ALTER TABLE cq_game_scores ADD COLUMN IF NOT EXISTS unit_id INTEGER DEFAULT 4;

-- 2. Ajouter unit_id à cq_student_progress (s'il n'existe pas)
ALTER TABLE cq_student_progress ADD COLUMN IF NOT EXISTS unit_id INTEGER DEFAULT 4;

-- 3. Mettre à jour les scores existants (tout est Unit 4 pour l'instant)
UPDATE cq_game_scores SET unit_id = 4 WHERE unit_id IS NULL;
UPDATE cq_student_progress SET unit_id = 4 WHERE unit_id IS NULL;

-- 4. Index pour filtrer rapidement par unité
CREATE INDEX IF NOT EXISTS idx_game_scores_unit ON cq_game_scores(unit_id);
CREATE INDEX IF NOT EXISTS idx_progress_unit ON cq_student_progress(unit_id);

-- Vérification
SELECT 'cq_game_scores' as tbl, COUNT(*) as total, COUNT(unit_id) as with_unit FROM cq_game_scores
UNION ALL SELECT 'cq_student_progress', COUNT(*), COUNT(unit_id) FROM cq_student_progress;
