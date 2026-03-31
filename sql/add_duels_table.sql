-- ============================================
-- MIGRATION: Table cq_duels pour le matchmaking Duel SQL
-- À exécuter dans Supabase SQL Editor
-- ============================================

CREATE TABLE IF NOT EXISTS cq_duels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player1_id UUID NOT NULL REFERENCES cq_students(id),
  player2_id UUID REFERENCES cq_students(id),
  status TEXT NOT NULL DEFAULT 'waiting', -- waiting, accepted, playing, finished
  questions JSONB NOT NULL DEFAULT '[]',
  player1_score INTEGER DEFAULT 0,
  player2_score INTEGER DEFAULT 0,
  player1_answers JSONB DEFAULT '[]',
  player2_answers JSONB DEFAULT '[]',
  current_question INTEGER DEFAULT 0,
  unit_id INTEGER DEFAULT 4,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE cq_duels ENABLE ROW LEVEL SECURITY;
CREATE POLICY cq_duels_select ON cq_duels FOR SELECT USING (true);
CREATE POLICY cq_duels_insert ON cq_duels FOR INSERT WITH CHECK (true);
CREATE POLICY cq_duels_update ON cq_duels FOR UPDATE USING (true);
CREATE POLICY cq_duels_delete ON cq_duels FOR DELETE USING (true);
GRANT ALL ON cq_duels TO anon, authenticated;

-- Index for fast lookups
CREATE INDEX IF NOT EXISTS idx_duels_status ON cq_duels(status);
CREATE INDEX IF NOT EXISTS idx_duels_players ON cq_duels(player1_id, player2_id);
