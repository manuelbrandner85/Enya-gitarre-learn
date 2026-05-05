import 'package:drift/drift.dart';

/// Migration from schema version 1 to 2.
/// Adds: curriculum_cache table, app_settings table,
/// preferred_input_source column to user_profiles,
/// input_source column to practice_sessions.
Future<void> migrateV1ToV2(Migrator m, GeneratedDatabase db) async {
  // New table: curriculum_cache
  await db.customStatement('''
    CREATE TABLE IF NOT EXISTS curriculum_cache (
      id TEXT NOT NULL PRIMARY KEY,
      module_id TEXT NOT NULL,
      lesson_id TEXT NOT NULL,
      content_json TEXT NOT NULL,
      version INTEGER NOT NULL DEFAULT 1,
      last_updated INTEGER NOT NULL,
      checksum TEXT NOT NULL
    )
  ''');

  // New table: app_settings (key-value store)
  await db.customStatement('''
    CREATE TABLE IF NOT EXISTS app_settings (
      key TEXT NOT NULL PRIMARY KEY,
      value TEXT NOT NULL,
      updated_at INTEGER NOT NULL
    )
  ''');

  // New column: preferred_input_source in user_profiles (SQLite ALTER TABLE)
  try {
    await db.customStatement(
      "ALTER TABLE user_profiles ADD COLUMN preferred_input_source TEXT DEFAULT 'microphone'",
    );
  } catch (_) {
    // Column may already exist (idempotent)
  }

  // New column: input_source in practice_sessions
  try {
    await db.customStatement(
      'ALTER TABLE practice_sessions ADD COLUMN input_source TEXT',
    );
  } catch (_) {}
}
