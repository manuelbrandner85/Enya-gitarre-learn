import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../audio/audio_input_service.dart';
import '../database/app_database.dart';
import '../providers/app_providers.dart';
import '../supabase/supabase_sync_service.dart';
import '../utils/constants.dart';

/// Tracks an active practice session: started when a lesson is opened, ended
/// on navigation away or after a period of inactivity.
class PracticeSessionTracker {
  PracticeSessionTracker({
    required AppDatabase db,
    required SharedPreferences prefs,
    required SupabaseSyncService supabaseSync,
    required AudioInputService audioInput,
  })  : _db = db,
        _prefs = prefs,
        _supabase = supabaseSync,
        _audioInput = audioInput;

  final AppDatabase _db;
  final SharedPreferences _prefs;
  final SupabaseSyncService _supabase;
  final AudioInputService _audioInput;

  static const _idleCutoff = Duration(minutes: 5);

  String? _sessionId;
  DateTime? _startedAt;
  DateTime _lastActivity = DateTime.now();
  String _moduleId = '';
  String _lessonId = '';
  int _xpEarned = 0;
  Timer? _idleTimer;

  bool get isActive => _sessionId != null;

  /// Begins a session for the given lesson. No-op if one is already active.
  Future<void> start({required String moduleId, required String lessonId}) async {
    if (_sessionId != null) {
      _moduleId = moduleId;
      _lessonId = lessonId;
      _markActivity();
      return;
    }
    final userId = _prefs.getString(AppConstants.prefKeyUserId);
    if (userId == null) return;

    _sessionId = const Uuid().v4();
    _startedAt = DateTime.now();
    _moduleId = moduleId;
    _lessonId = lessonId;
    _xpEarned = 0;
    _lastActivity = _startedAt!;

    try {
      await _db.upsertPracticeSession(
        PracticeSessionsTableCompanion.insert(
          id: _sessionId!,
          userId: userId,
          startTime: _startedAt!,
          isActive: const Value(true),
          currentModuleId: Value(moduleId),
          currentLessonId: Value(lessonId),
        ),
      );
    } catch (e) {
      debugPrint('PracticeSessionTracker.start db failed: $e');
    }

    _idleTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (DateTime.now().difference(_lastActivity) > _idleCutoff) {
        end();
      }
    });
  }

  /// Records activity to extend the inactivity timeout.
  void markActivity() => _markActivity();

  void _markActivity() {
    _lastActivity = DateTime.now();
  }

  /// Records XP earned within this session (used at end-of-lesson).
  void addXp(int xp) {
    _xpEarned += xp;
    _markActivity();
  }

  /// Ends the active session, persists locally, and pushes to Supabase.
  Future<void> end() async {
    final id = _sessionId;
    final startedAt = _startedAt;
    if (id == null || startedAt == null) return;

    final endedAt = DateTime.now();
    final duration = endedAt.difference(startedAt);
    final durationSeconds = duration.inSeconds;
    final durationMinutes = (durationSeconds / 60).round();
    final userId = _prefs.getString(AppConstants.prefKeyUserId);

    _idleTimer?.cancel();
    _idleTimer = null;
    _sessionId = null;
    _startedAt = null;

    if (userId == null) return;

    try {
      await _db.upsertPracticeSession(
        PracticeSessionsTableCompanion.insert(
          id: id,
          userId: userId,
          startTime: startedAt,
          endTime: Value(endedAt),
          durationSeconds: Value(durationSeconds),
          xpEarned: Value(_xpEarned),
          currentModuleId: Value(_moduleId),
          currentLessonId: Value(_lessonId),
          isActive: const Value(false),
        ),
      );
    } catch (e) {
      debugPrint('PracticeSessionTracker.end db failed: $e');
    }

    try {
      await _supabase.recordPracticeSession(
        startedAt: startedAt,
        endedAt: endedAt,
        durationMinutes: durationMinutes,
        xpEarned: _xpEarned,
        inputType: _audioInput.currentConnectionType.name,
      );
    } catch (e) {
      debugPrint('PracticeSessionTracker.end sync failed: $e');
    }
  }
}

/// Singleton tracker provider — one session at a time across the app.
final practiceSessionTrackerProvider =
    Provider<PracticeSessionTracker>((ref) {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final sync = ref.watch(supabaseSyncProvider);
  final audio = ref.watch(audioInputServiceProvider);
  final tracker = PracticeSessionTracker(
    db: db,
    prefs: prefs,
    supabaseSync: sync,
    audioInput: audio,
  );
  ref.onDispose(() {
    // Best-effort flush.
    tracker.end();
  });
  return tracker;
});
