import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:enya_gitarre_learn/core/database/app_database.dart';

void main() {
  group('AppDatabase – Schema & Migrationen', () {
    test('schemaVersion ist >= 3 (mit v2→v3 Migration registriert)', () {
      final db = AppDatabase.fromExecutor(NativeDatabase.memory());
      expect(db.schemaVersion, greaterThanOrEqualTo(3));
      db.close();
    });

    test('frische DB hat alle Tabellen (onCreate)', () async {
      final db = AppDatabase.fromExecutor(NativeDatabase.memory());
      // `allTables` enthält alle generierten Drift-Tabellen.
      expect(db.allTables, isNotEmpty);
      final tableNames = db.allTables.map((t) => t.actualTableName).toSet();
      // Konvention im generierten Code: TableName + "_table"
      expect(tableNames, contains('user_profiles_table'));
      expect(tableNames, contains('exercise_results_table'));
      expect(tableNames, contains('practice_sessions_table'));
      await db.close();
    });

    test('Tabellen werden via onCreate angelegt und sind beschreibbar',
        () async {
      final db = AppDatabase.fromExecutor(NativeDatabase.memory());
      // Trigger onCreate, indem wir eine echte Query gegen eine Tabelle absetzen.
      final rows = await db.getExerciseResults('user-x', 'lesson-x');
      expect(rows, isEmpty);
      // Jetzt prüft sqlite_master, dass die Tabelle wirklich existiert.
      final result = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='exercise_results_table'",
      ).get();
      expect(result, isNotEmpty);
      await db.close();
    });
  });
}
