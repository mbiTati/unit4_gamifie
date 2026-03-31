-- ============================================
-- MIGRATION: Tables pour les projets en équipe
-- À exécuter dans Supabase SQL Editor
-- ============================================

-- Statut des projets (verrouillé/débloqué par le prof)
CREATE TABLE IF NOT EXISTS cq_team_projects (
  id SERIAL PRIMARY KEY,
  project_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'locked',
  team_data JSONB DEFAULT '[]',
  unit_id INTEGER DEFAULT 4,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(project_id, unit_id)
);

ALTER TABLE cq_team_projects ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_team_projects_all ON cq_team_projects;
CREATE POLICY cq_team_projects_all ON cq_team_projects FOR ALL USING (true) WITH CHECK (true);
GRANT ALL ON cq_team_projects TO anon, authenticated;
GRANT USAGE ON SEQUENCE cq_team_projects_id_seq TO anon, authenticated;

-- Membres des équipes
CREATE TABLE IF NOT EXISTS cq_team_members (
  id SERIAL PRIMARY KEY,
  project_id TEXT NOT NULL,
  team_number INTEGER NOT NULL,
  student_id UUID NOT NULL REFERENCES cq_students(id),
  unit_id INTEGER DEFAULT 4,
  UNIQUE(project_id, student_id, unit_id)
);

ALTER TABLE cq_team_members ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_team_members_all ON cq_team_members;
CREATE POLICY cq_team_members_all ON cq_team_members FOR ALL USING (true) WITH CHECK (true);
GRANT ALL ON cq_team_members TO anon, authenticated;
GRANT USAGE ON SEQUENCE cq_team_members_id_seq TO anon, authenticated;

SELECT 'Team projects tables created' as status;
