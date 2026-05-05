import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'migration_v1_to_v2.dart';

typedef MigrationFn = Future<void> Function(Migrator, GeneratedDatabase);

class MigrationRegistry {
  static final Map<int, MigrationFn> _migrations = {
    2: migrateV1ToV2,
  };

  static Future<void> runMigrations(
    Migrator m,
    GeneratedDatabase db,
    int from,
    int to,
  ) async {
    for (var target = from + 1; target <= to; target++) {
      final migration = _migrations[target];
      if (migration == null) {
        debugPrint('MigrationRegistry: No migration found for version $target');
        continue;
      }
      final startTime = DateTime.now();
      debugPrint('MigrationRegistry: Running migration to v$target...');
      await migration(m, db);
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      debugPrint('MigrationRegistry: Migration to v$target done in ${elapsed}ms');
    }
  }
}
