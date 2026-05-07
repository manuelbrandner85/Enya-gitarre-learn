import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'migrations/migration_registry.dart';

part 'app_database.g.dart';

// =============================================
// TABLE DEFINITIONS
// =============================================

class UserProfilesTable extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get avatarUrl => text().withDefault(const Constant(''))();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPracticeDate => dateTime().nullable()();
  IntColumn get totalPracticeMinutes => integer().withDefault(const Constant(0))();
  IntColumn get totalLessonsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get totalModulesCompleted => integer().withDefault(const Constant(0))();
  TextColumn get unlockedAchievementsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get unlockedPresetsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get completedLessonIdsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get completedModuleIdsJson =>
      text().withDefault(const Constant('[]'))();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  TextColumn get preferredTuning =>
      text().withDefault(const Constant('standard'))();
  BoolColumn get isDarkMode => boolean().withDefault(const Constant(true))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get soundEffectsEnabled =>
      boolean().withDefault(const Constant(true))();
  RealColumn get masterVolume => real().withDefault(const Constant(1.0))();
  TextColumn get language => text().withDefault(const Constant('de'))();
  BoolColumn get isGuest => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ModuleProgressTable extends Table {
  TextColumn get moduleId => text()();
  TextColumn get userId => text()();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  RealColumn get completionPercentage =>
      real().withDefault(const Constant(0.0))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get lastAccessedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {moduleId, userId};
}

class LessonProgressTable extends Table {
  TextColumn get lessonId => text()();
  TextColumn get userId => text()();
  TextColumn get moduleId => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  RealColumn get bestAccuracy => real().withDefault(const Constant(0.0))();
  IntColumn get stars => integer().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {lessonId, userId};
}

class ExerciseResultsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exerciseId => text()();
  TextColumn get lessonId => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text()();
  RealColumn get accuracy => real().withDefault(const Constant(0.0))();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get notesPlayed => integer().withDefault(const Constant(0))();
  BoolColumn get passed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime()();
}

class SpacedRepetitionItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get itemType => text()();
  TextColumn get itemId => text()();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(1))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextReviewDate => dateTime()();
  DateTimeColumn get lastReviewDate => dateTime().nullable()();
  IntColumn get lastQuality => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class AchievementsTable extends Table {
  TextColumn get key => text()();
  TextColumn get userId => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key, userId};
}

class PracticeSessionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  TextColumn get lessonsCompletedJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get exercisesCompletedJson =>
      text().withDefault(const Constant('[]'))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  RealColumn get averageAccuracy => real().withDefault(const Constant(0.0))();
  IntColumn get notesPlayed => integer().withDefault(const Constant(0))();
  IntColumn get chordsPlayed => integer().withDefault(const Constant(0))();
  TextColumn get currentModuleId =>
      text().withDefault(const Constant(''))();
  TextColumn get currentLessonId =>
      text().withDefault(const Constant(''))();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  TextColumn get achievementsUnlockedJson =>
      text().withDefault(const Constant('[]'))();
  BoolColumn get wasRecorded => boolean().withDefault(const Constant(false))();
  TextColumn get recordingPath =>
      text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class RecordingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text()();
  TextColumn get lessonId => text().withDefault(const Constant(''))();
  TextColumn get filePath => text()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  TextColumn get title => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyStatsTable extends Table {
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get practiceMinutes => integer().withDefault(const Constant(0))();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get lessonsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get notesPlayed => integer().withDefault(const Constant(0))();
  BoolColumn get streakMaintained =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {userId, date};
}

// =============================================
// DATABASE CLASS
// =============================================

@DriftDatabase(tables: [
  UserProfilesTable,
  ModuleProgressTable,
  LessonProgressTable,
  ExerciseResultsTable,
  SpacedRepetitionItemsTable,
  AchievementsTable,
  PracticeSessionsTable,
  RecordingsTable,
  DailyStatsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test-Konstruktor – erlaubt In-Memory-Datenbanken in Unit-Tests.
  AppDatabase.fromExecutor(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedInitialData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          await MigrationRegistry.runMigrations(m, this, from, to);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          if (details.wasCreated) {
            debugPrint(
              'AppDatabase: Fresh database created (schema v${details.versionNow})',
            );
          }
        },
      );

  Future<void> _seedInitialData() async {
    // Seed default app settings
    debugPrint('AppDatabase: Seeding initial data...');
  }

  // =============================================
  // USER PROFILE DAO
  // =============================================

  Future<UserProfilesTableData?> getUserProfile(String userId) async {
    return (select(userProfilesTable)
          ..where((t) => t.id.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> upsertUserProfile(UserProfilesTableCompanion profile) async {
    await into(userProfilesTable).insertOnConflictUpdate(profile);
  }

  Future<bool> updateUserXp(String userId, int newTotalXp, int newLevel) async {
    final rowsAffected = await (update(userProfilesTable)
          ..where((t) => t.id.equals(userId)))
        .write(UserProfilesTableCompanion(
          totalXp: Value(newTotalXp),
          level: Value(newLevel),
          updatedAt: Value(DateTime.now()),
        ));
    return rowsAffected > 0;
  }

  Future<bool> updateStreak(
      String userId, int streak, DateTime lastPractice) async {
    final rowsAffected = await (update(userProfilesTable)
          ..where((t) => t.id.equals(userId)))
        .write(UserProfilesTableCompanion(
          currentStreak: Value(streak),
          lastPracticeDate: Value(lastPractice),
          updatedAt: Value(DateTime.now()),
        ));
    return rowsAffected > 0;
  }

  // =============================================
  // MODULE PROGRESS DAO
  // =============================================

  Future<List<ModuleProgressTableData>> getAllModuleProgress(
      String userId) async {
    return (select(moduleProgressTable)
          ..where((t) => t.userId.equals(userId)))
        .get();
  }

  Future<ModuleProgressTableData?> getModuleProgress(
      String userId, String moduleId) async {
    return (select(moduleProgressTable)
          ..where((t) =>
              t.userId.equals(userId) & t.moduleId.equals(moduleId)))
        .getSingleOrNull();
  }

  Future<void> upsertModuleProgress(
      ModuleProgressTableCompanion progress) async {
    await into(moduleProgressTable).insertOnConflictUpdate(progress);
  }

  // =============================================
  // LESSON PROGRESS DAO
  // =============================================

  Future<List<LessonProgressTableData>> getAllLessonProgress(
      String userId) async {
    return (select(lessonProgressTable)
          ..where((t) => t.userId.equals(userId)))
        .get();
  }

  Future<LessonProgressTableData?> getLessonProgress(
      String userId, String lessonId) async {
    return (select(lessonProgressTable)
          ..where((t) =>
              t.userId.equals(userId) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();
  }

  Future<void> upsertLessonProgress(
      LessonProgressTableCompanion progress) async {
    await into(lessonProgressTable).insertOnConflictUpdate(progress);
  }

  // =============================================
  // EXERCISE RESULTS DAO
  // =============================================

  Future<int> insertExerciseResult(
      ExerciseResultsTableCompanion result) async {
    return into(exerciseResultsTable).insert(result);
  }

  Future<List<ExerciseResultsTableData>> getExerciseResults(
      String userId, String lessonId) async {
    return (select(exerciseResultsTable)
          ..where((t) =>
              t.userId.equals(userId) & t.lessonId.equals(lessonId))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  /// Liefert alle Übungs-Ergebnisse eines Users zwischen [from] und [to].
  Future<List<ExerciseResultsTableData>> getExerciseResultsBetween(
    String userId,
    DateTime from,
    DateTime to,
  ) async {
    return (select(exerciseResultsTable)
          ..where((t) =>
              t.userId.equals(userId) &
              t.completedAt.isBiggerOrEqualValue(from) &
              t.completedAt.isSmallerOrEqualValue(to))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  /// Summe aller `notesPlayed` über alle Exercise-Results des Users.
  Future<int> getTotalNotesPlayed(String userId) async {
    final notes = exerciseResultsTable.notesPlayed.sum();
    final query = selectOnly(exerciseResultsTable)
      ..addColumns([notes])
      ..where(exerciseResultsTable.userId.equals(userId));
    final row = await query.getSingleOrNull();
    return row?.read(notes) ?? 0;
  }

  // =============================================
  // SPACED REPETITION DAO
  // =============================================

  Future<List<SpacedRepetitionItemsTableData>> getSrItems(
      String userId) async {
    return (select(spacedRepetitionItemsTable)
          ..where((t) => t.userId.equals(userId)))
        .get();
  }

  Future<List<SpacedRepetitionItemsTableData>> getDueSrItems(
      String userId) async {
    final now = DateTime.now();
    return (select(spacedRepetitionItemsTable)
          ..where((t) =>
              t.userId.equals(userId) &
              t.nextReviewDate.isSmallerOrEqualValue(now)))
        .get();
  }

  Future<void> upsertSrItem(
      SpacedRepetitionItemsTableCompanion item) async {
    await into(spacedRepetitionItemsTable).insertOnConflictUpdate(item);
  }

  // =============================================
  // ACHIEVEMENTS DAO
  // =============================================

  Future<List<AchievementsTableData>> getUnlockedAchievements(
      String userId) async {
    return (select(achievementsTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.unlockedAt)]))
        .get();
  }

  Future<void> unlockAchievement(
      String userId, String key, DateTime unlockedAt) async {
    await into(achievementsTable).insertOnConflictUpdate(
      AchievementsTableCompanion(
        key: Value(key),
        userId: Value(userId),
        unlockedAt: Value(unlockedAt),
      ),
    );
  }

  Future<bool> isAchievementUnlocked(String userId, String key) async {
    final result = await (select(achievementsTable)
          ..where((t) => t.userId.equals(userId) & t.key.equals(key)))
        .getSingleOrNull();
    return result != null;
  }

  // =============================================
  // PRACTICE SESSIONS DAO
  // =============================================

  Future<void> upsertPracticeSession(
      PracticeSessionsTableCompanion session) async {
    await into(practiceSessionsTable).insertOnConflictUpdate(session);
  }

  Future<List<PracticeSessionsTableData>> getRecentSessions(
      String userId, {int limit = 30}) async {
    return (select(practiceSessionsTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
  }

  Future<PracticeSessionsTableData?> getActiveSession(
      String userId) async {
    return (select(practiceSessionsTable)
          ..where((t) => t.userId.equals(userId) & t.isActive.equals(true)))
        .getSingleOrNull();
  }

  // =============================================
  // RECORDINGS DAO
  // =============================================

  Future<int> insertRecording(RecordingsTableCompanion recording) async {
    return into(recordingsTable).insert(recording);
  }

  Future<List<RecordingsTableData>> getRecordings(String userId) async {
    return (select(recordingsTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<bool> deleteRecording(String recordingId) async {
    final rowsDeleted = await (delete(recordingsTable)
          ..where((t) => t.id.equals(recordingId)))
        .go();
    return rowsDeleted > 0;
  }

  // =============================================
  // DAILY STATS DAO
  // =============================================

  Future<void> upsertDailyStats(DailyStatsTableCompanion stats) async {
    await into(dailyStatsTable).insertOnConflictUpdate(stats);
  }

  Future<List<DailyStatsTableData>> getDailyStats(
      String userId, {int days = 30}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(dailyStatsTable)
          ..where((t) =>
              t.userId.equals(userId) &
              t.date.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<void> deleteEverything() async {
    await transaction(() async {
      try {
        await delete(dailyStatsTable).go();
      } catch (_) {}
      try {
        await delete(recordingsTable).go();
      } catch (_) {}
      try {
        await delete(practiceSessionsTable).go();
      } catch (_) {}
      try {
        await delete(achievementsTable).go();
      } catch (_) {}
      try {
        await delete(exerciseResultsTable).go();
      } catch (_) {}
      try {
        await delete(spacedRepetitionItemsTable).go();
      } catch (_) {}
      try {
        await delete(lessonProgressTable).go();
      } catch (_) {}
      try {
        await delete(moduleProgressTable).go();
      } catch (_) {}
      try {
        await delete(userProfilesTable).go();
      } catch (_) {}
    });
  }

  Future<DailyStatsTableData?> getTodayStats(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return (select(dailyStatsTable)
          ..where((t) =>
              t.userId.equals(userId) &
              t.date.isBiggerOrEqualValue(today) &
              t.date.isSmallerThanValue(tomorrow)))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbDir.path, 'enya_gitarre.db'));
    return NativeDatabase.createInBackground(file);
  });
}
