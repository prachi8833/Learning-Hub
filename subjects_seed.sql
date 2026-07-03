-- ============================================================
-- Subjects seed for Riaan & Kairav Learning Hub
-- Run this in: Supabase Dashboard > SQL Editor
-- ============================================================
-- Aligned to the subject_key values already used across the real
-- content tables (modules: 50 rows, game_templates/game_items, and
-- reading topics), NOT the older key set in supabase_rls_fix.sql
-- (which used reading/writing/music — those don't match any modules
-- rows and would leave Hinduism/Health/Indigenous topics orphaned).
--
-- NOTE: no ON CONFLICT clause — `key` has no unique constraint in
-- this table, so an ON CONFLICT clause fails and silently rolls back
-- the whole insert (this happened on the first attempt, 2026-07-02).
-- ============================================================

delete from subjects;
insert into subjects (key, name, icon, color, active, sort_order) values
  ('math',       'Maths',                '🔢', '#2BBFB8', true, 1),
  ('english',    'English',              '📖', '#8266DE', true, 2),
  ('science',    'Science',              '🔬', '#4CAF50', true, 3),
  ('social',     'Social Studies',       '🌍', '#E91E63', true, 4),
  ('hinduism',   'Hinduism',             '🕉️', '#FF9800', true, 5),
  ('hindi',      'Hindi',                '🔤', '#F6C04A', true, 6),
  ('health',     'Health & Life Skills', '💪', '#4A90D9', true, 7),
  ('indigenous', 'Indigenous BC',        '🪶', '#E07830', true, 8);
