/// Supabase Row Level Security (RLS) Policy Documentation
///
/// Apply these SQL policies in the Supabase SQL Editor.
/// All user-data tables have RLS enabled with user-scoped access.
///
/// ============================================================
/// RUN IN SUPABASE SQL EDITOR:
/// ============================================================
///
/// -- user_profiles
/// ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "select_own_profile" ON user_profiles
///   FOR SELECT USING (auth.uid()::text = id);
/// CREATE POLICY "insert_own_profile" ON user_profiles
///   FOR INSERT WITH CHECK (auth.uid()::text = id);
/// CREATE POLICY "update_own_profile" ON user_profiles
///   FOR UPDATE USING (auth.uid()::text = id);
///
/// -- module_progress
/// ALTER TABLE module_progress ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "crud_own_module_progress" ON module_progress
///   FOR ALL USING (auth.uid()::text = user_id);
///
/// -- lesson_progress
/// ALTER TABLE lesson_progress ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "crud_own_lesson_progress" ON lesson_progress
///   FOR ALL USING (auth.uid()::text = user_id);
///
/// -- exercise_results
/// ALTER TABLE exercise_results ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "crud_own_exercise_results" ON exercise_results
///   FOR ALL USING (auth.uid()::text = user_id);
///
/// -- achievements
/// ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "crud_own_achievements" ON achievements
///   FOR ALL USING (auth.uid()::text = user_id);
///
/// -- practice_sessions
/// ALTER TABLE practice_sessions ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "crud_own_practice_sessions" ON practice_sessions
///   FOR ALL USING (auth.uid()::text = user_id);
///
/// -- recordings
/// ALTER TABLE recordings ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "crud_own_recordings" ON recordings
///   FOR ALL USING (auth.uid()::text = user_id);
///
/// -- daily_stats
/// ALTER TABLE daily_stats ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "crud_own_daily_stats" ON daily_stats
///   FOR ALL USING (auth.uid()::text = user_id);
///
/// -- app_config (public read-only)
/// ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "public_read_app_config" ON app_config
///   FOR SELECT USING (true);
///
/// -- update_history (public read-only)
/// ALTER TABLE update_history ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "public_read_update_history" ON update_history
///   FOR SELECT USING (true);
///
/// -- modules, lessons, exercises (public read-only when created)
/// -- ALTER TABLE modules ENABLE ROW LEVEL SECURITY;
/// -- CREATE POLICY "public_read_modules" ON modules FOR SELECT USING (true);
/// ============================================================

// ignore_for_file: unused_element
class _RlsDocumentation {
  const _RlsDocumentation._();
}
