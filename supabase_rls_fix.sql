-- ============================================================
-- Supabase RLS Fix for Riaan & Kairav Learning Hub
-- Run this in: Supabase Dashboard > SQL Editor
-- ============================================================
-- This fixes the "Error adding task" and missing data issues
-- by adding proper Row Level Security policies for the anon role.
-- ============================================================

-- TASKS table: allow full CRUD for anon role
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read tasks" ON tasks;
DROP POLICY IF EXISTS "Allow anon insert tasks" ON tasks;
DROP POLICY IF EXISTS "Allow anon update tasks" ON tasks;
DROP POLICY IF EXISTS "Allow anon delete tasks" ON tasks;
CREATE POLICY "Allow anon read tasks" ON tasks FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert tasks" ON tasks FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update tasks" ON tasks FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon delete tasks" ON tasks FOR DELETE TO anon USING (true);

-- SUBJECTS table: allow read for anon role
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read subjects" ON subjects;
DROP POLICY IF EXISTS "Allow anon insert subjects" ON subjects;
DROP POLICY IF EXISTS "Allow anon update subjects" ON subjects;
DROP POLICY IF EXISTS "Allow anon delete subjects" ON subjects;
CREATE POLICY "Allow anon read subjects" ON subjects FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert subjects" ON subjects FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update subjects" ON subjects FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon delete subjects" ON subjects FOR DELETE TO anon USING (true);

-- REWARD_SHOP table
ALTER TABLE reward_shop ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read reward_shop" ON reward_shop;
DROP POLICY IF EXISTS "Allow anon insert reward_shop" ON reward_shop;
DROP POLICY IF EXISTS "Allow anon update reward_shop" ON reward_shop;
DROP POLICY IF EXISTS "Allow anon delete reward_shop" ON reward_shop;
CREATE POLICY "Allow anon read reward_shop" ON reward_shop FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert reward_shop" ON reward_shop FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update reward_shop" ON reward_shop FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon delete reward_shop" ON reward_shop FOR DELETE TO anon USING (true);

-- BADGES table
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read badges" ON badges;
CREATE POLICY "Allow anon read badges" ON badges FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert badges" ON badges FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update badges" ON badges FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- TASK_COMPLETIONS table
ALTER TABLE task_completions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read task_completions" ON task_completions;
DROP POLICY IF EXISTS "Allow anon insert task_completions" ON task_completions;
DROP POLICY IF EXISTS "Allow anon update task_completions" ON task_completions;
CREATE POLICY "Allow anon read task_completions" ON task_completions FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert task_completions" ON task_completions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update task_completions" ON task_completions FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- EARNED_BADGES table
ALTER TABLE earned_badges ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read earned_badges" ON earned_badges;
DROP POLICY IF EXISTS "Allow anon insert earned_badges" ON earned_badges;
CREATE POLICY "Allow anon read earned_badges" ON earned_badges FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert earned_badges" ON earned_badges FOR INSERT TO anon WITH CHECK (true);

-- ACTIVE_GOALS table
ALTER TABLE active_goals ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read active_goals" ON active_goals;
DROP POLICY IF EXISTS "Allow anon insert active_goals" ON active_goals;
DROP POLICY IF EXISTS "Allow anon update active_goals" ON active_goals;
CREATE POLICY "Allow anon read active_goals" ON active_goals FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert active_goals" ON active_goals FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update active_goals" ON active_goals FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- STREAKS table
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read streaks" ON streaks;
DROP POLICY IF EXISTS "Allow anon insert streaks" ON streaks;
DROP POLICY IF EXISTS "Allow anon update streaks" ON streaks;
CREATE POLICY "Allow anon read streaks" ON streaks FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert streaks" ON streaks FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update streaks" ON streaks FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- QUESTIONS table
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read questions" ON questions;
DROP POLICY IF EXISTS "Allow anon insert questions" ON questions;
DROP POLICY IF EXISTS "Allow anon update questions" ON questions;
DROP POLICY IF EXISTS "Allow anon delete questions" ON questions;
CREATE POLICY "Allow anon read questions" ON questions FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert questions" ON questions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update questions" ON questions FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "Allow anon delete questions" ON questions FOR DELETE TO anon USING (true);

-- PARENT_SETTINGS table
ALTER TABLE parent_settings ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read parent_settings" ON parent_settings;
DROP POLICY IF EXISTS "Allow anon insert parent_settings" ON parent_settings;
DROP POLICY IF EXISTS "Allow anon update parent_settings" ON parent_settings;
CREATE POLICY "Allow anon read parent_settings" ON parent_settings FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert parent_settings" ON parent_settings FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update parent_settings" ON parent_settings FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- STAR_CONFIG table
ALTER TABLE star_config ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read star_config" ON star_config;
DROP POLICY IF EXISTS "Allow anon insert star_config" ON star_config;
DROP POLICY IF EXISTS "Allow anon update star_config" ON star_config;
CREATE POLICY "Allow anon read star_config" ON star_config FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert star_config" ON star_config FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update star_config" ON star_config FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- LEVEL_PROGRESS table (already working but ensure insert/update works)
ALTER TABLE level_progress ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read level_progress" ON level_progress;
DROP POLICY IF EXISTS "Allow anon insert level_progress" ON level_progress;
DROP POLICY IF EXISTS "Allow anon update level_progress" ON level_progress;
CREATE POLICY "Allow anon read level_progress" ON level_progress FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert level_progress" ON level_progress FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update level_progress" ON level_progress FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- SESSIONS table (already working but ensure insert works)
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read sessions" ON sessions;
DROP POLICY IF EXISTS "Allow anon insert sessions" ON sessions;
CREATE POLICY "Allow anon read sessions" ON sessions FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert sessions" ON sessions FOR INSERT TO anon WITH CHECK (true);

-- REDEMPTIONS table
ALTER TABLE redemptions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow anon read redemptions" ON redemptions;
DROP POLICY IF EXISTS "Allow anon insert redemptions" ON redemptions;
DROP POLICY IF EXISTS "Allow anon update redemptions" ON redemptions;
CREATE POLICY "Allow anon read redemptions" ON redemptions FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon insert redemptions" ON redemptions FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow anon update redemptions" ON redemptions FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- ============================================================
-- SEED DATA: Insert default tasks if tasks table is empty
-- ============================================================
INSERT INTO tasks (title, icon, time_block, stars_value, active, day_type, sort_order)
SELECT * FROM (VALUES
    ('Morning Reading', '📖', 'morning', 20, true, 'both', 1),
    ('Math Practice', '🔢', 'morning', 25, true, 'both', 2),
    ('Writing Practice', '✏️', 'learning', 20, true, 'both', 3),
    ('Science Activity', '🔬', 'afternoon', 20, true, 'both', 4),
    ('Hindi Practice', '🇮🇳', 'afternoon', 15, true, 'both', 5),
    ('Free Reading', '📚', 'evening', 15, true, 'both', 6),
    ('Coding Practice', '💻', 'afternoon', 25, true, 'both', 7),
    ('Bedtime Reading', '🌙', 'bedtime', 10, true, 'both', 8)
  ) AS v(title, icon, time_block, stars_value, active, day_type, sort_order)
WHERE NOT EXISTS (SELECT 1 FROM tasks LIMIT 1);

-- ============================================================
-- SEED DATA: Insert default subjects if subjects table is empty
-- ============================================================
INSERT INTO subjects (key, name, icon, color, bg_color, active, sort_order)
SELECT * FROM (VALUES
    ('math', 'Math', '🔢', '#29B0B8', '#E8F8F4', true, 1),
    ('reading', 'Reading', '📚', '#8266DE', '#F0ECFD', true, 2),
    ('science', 'Science', '🔬', '#3E8F3E', '#EAF4EA', true, 3),
    ('writing', 'Writing', '✏️', '#E08833', '#FDF3E7', true, 4),
    ('social', 'Social Studies', '🌍', '#C2185B', '#FCE4EC', true, 5),
    ('coding', 'Coding', '💻', '#1565C0', '#E3F2FD', true, 6),
    ('hindi', 'Hindi', '🇮🇳', '#FF6F00', '#FFF3E0', true, 7),
    ('music', 'Music', '🎵', '#880E4F', '#FCE4EC', true, 8)
  ) AS v(key, name, icon, color, bg_color, active, sort_order)
WHERE NOT EXISTS (SELECT 1 FROM subjects LIMIT 1);

-- ============================================================
-- SEED DATA: Default star_config if empty
-- ============================================================
INSERT INTO star_config (key, value, active)
SELECT * FROM (VALUES
    ('task_complete', 15, true),
    ('quiz_pass', 50, true),
    ('perfect_score_bonus', 300, true),
    ('daily_streak_bonus', 20, true),
    ('reading_complete', 30, true)
  ) AS v(key, value, active)
WHERE NOT EXISTS (SELECT 1 FROM star_config LIMIT 1);
