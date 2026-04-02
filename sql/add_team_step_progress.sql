-- Run this in Supabase SQL Editor if not already done:
ALTER TABLE cq_team_projects ADD COLUMN IF NOT EXISTS step_data JSONB DEFAULT '{}';

-- New: team-level step progress
CREATE TABLE IF NOT EXISTS cq_team_step_progress (
  id SERIAL PRIMARY KEY,
  project_id TEXT NOT NULL,
  team_number INTEGER NOT NULL,
  step_index INTEGER NOT NULL,
  work TEXT DEFAULT '',
  score INTEGER DEFAULT 0,
  done BOOLEAN DEFAULT false,
  submitted_by UUID REFERENCES cq_students(id),
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  unit_id INTEGER DEFAULT 4,
  UNIQUE(project_id, team_number, step_index, unit_id)
);

ALTER TABLE cq_team_step_progress ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS cq_team_step_progress_all ON cq_team_step_progress;
CREATE POLICY cq_team_step_progress_all ON cq_team_step_progress FOR ALL USING (true) WITH CHECK (true);
GRANT ALL ON cq_team_step_progress TO anon, authenticated;
GRANT USAGE ON SEQUENCE cq_team_step_progress_id_seq TO anon, authenticated;

