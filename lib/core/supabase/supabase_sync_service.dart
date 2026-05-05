import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';

/// Bridges the local Drift database with the remote Supabase Postgres.
///
/// All writes go through this service so RLS-protected rows always carry the
/// signed-in user's id. Reads are kept lightweight — the local Drift database
/// remains the source of truth for offline-first usage; this service only
/// pushes deltas and pulls the user's row on sign-in.
class SupabaseSyncService {
  SupabaseSyncService(this._client);

  final SupabaseClient _client;

  GoTrueClient get auth => _client.auth;
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signInAnonymously() => _client.auth.signInAnonymously();

  Future<AuthResponse> signUpEmail({
    required String email,
    required String password,
    String? username,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {if (username != null && username.isNotEmpty) 'username': username},
    );
  }

  Future<AuthResponse> signInEmail({
    required String email,
    required String password,
  }) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();

  // ----- Profile -----

  Future<UserProfile?> fetchProfile() async {
    final id = currentUser?.id;
    if (id == null) return null;
    try {
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (row == null) return null;
      return _profileFromRow(row);
    } catch (e, st) {
      debugPrint('Supabase fetchProfile failed: $e\n$st');
      return null;
    }
  }

  Future<void> upsertProfile(UserProfile profile) async {
    final id = currentUser?.id;
    if (id == null) return;
    try {
      await _client.from('profiles').upsert({
        'id': id,
        'username': profile.username,
        'email': profile.email,
        'avatar_url': profile.avatarUrl,
        'total_xp': profile.totalXp,
        'level': profile.level,
        'current_streak': profile.currentStreak,
        'longest_streak': profile.longestStreak,
        'last_practice_date': profile.lastPracticeDate?.toIso8601String(),
        'total_practice_minutes': profile.totalPracticeMinutes,
        'total_lessons_completed': profile.totalLessonsCompleted,
        'total_modules_completed': profile.totalModulesCompleted,
        'onboarding_complete': profile.onboardingComplete,
        'preferred_tuning': profile.preferredTuning,
        'is_dark_mode': profile.isDarkMode,
        'notifications_enabled': profile.notificationsEnabled,
        'sound_effects_enabled': profile.soundEffectsEnabled,
        'master_volume': profile.masterVolume,
        'language': profile.language,
      });
    } catch (e, st) {
      debugPrint('Supabase upsertProfile failed: $e\n$st');
    }
  }

  // ----- Lesson progress -----

  Future<void> upsertLessonProgress({
    required String lessonId,
    required int moduleId,
    required bool isCompleted,
    required double bestAccuracy,
    required int attempts,
    required int xpEarned,
    DateTime? completedAt,
  }) async {
    final id = currentUser?.id;
    if (id == null) return;
    try {
      await _client.from('lesson_progress').upsert({
        'user_id': id,
        'lesson_id': lessonId,
        'module_id': moduleId,
        'is_completed': isCompleted,
        'best_accuracy': bestAccuracy,
        'attempts': attempts,
        'xp_earned': xpEarned,
        'completed_at': completedAt?.toIso8601String(),
      }, onConflict: 'user_id,lesson_id');
    } catch (e, st) {
      debugPrint('Supabase upsertLessonProgress failed: $e\n$st');
    }
  }

  Future<void> insertExerciseResult({
    required String exerciseId,
    required String lessonId,
    required double accuracy,
    required double timingScore,
    required int durationSeconds,
  }) async {
    final id = currentUser?.id;
    if (id == null) return;
    try {
      await _client.from('exercise_results').insert({
        'user_id': id,
        'exercise_id': exerciseId,
        'lesson_id': lessonId,
        'accuracy': accuracy,
        'timing_score': timingScore,
        'duration_seconds': durationSeconds,
      });
    } catch (e, st) {
      debugPrint('Supabase insertExerciseResult failed: $e\n$st');
    }
  }

  Future<void> upsertModuleProgress({
    required int moduleId,
    required bool isUnlocked,
    required bool isCompleted,
    required double completionPercentage,
    DateTime? startedAt,
    DateTime? completedAt,
  }) async {
    final id = currentUser?.id;
    if (id == null) return;
    try {
      await _client.from('module_progress').upsert({
        'user_id': id,
        'module_id': moduleId,
        'is_unlocked': isUnlocked,
        'is_completed': isCompleted,
        'completion_percentage': completionPercentage,
        'started_at': startedAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      }, onConflict: 'user_id,module_id');
    } catch (e, st) {
      debugPrint('Supabase upsertModuleProgress failed: $e\n$st');
    }
  }

  Future<void> recordAchievement(String key) async {
    final id = currentUser?.id;
    if (id == null) return;
    try {
      await _client.from('achievements').upsert({
        'user_id': id,
        'achievement_key': key,
      }, onConflict: 'user_id,achievement_key');
    } catch (e, st) {
      debugPrint('Supabase recordAchievement failed: $e\n$st');
    }
  }

  Future<void> recordPracticeSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationMinutes,
    required int xpEarned,
    required String inputType,
  }) async {
    final id = currentUser?.id;
    if (id == null) return;
    try {
      await _client.from('practice_sessions').insert({
        'user_id': id,
        'started_at': startedAt.toIso8601String(),
        'ended_at': endedAt.toIso8601String(),
        'duration_minutes': durationMinutes,
        'xp_earned': xpEarned,
        'input_type': inputType,
      });
    } catch (e, st) {
      debugPrint('Supabase recordPracticeSession failed: $e\n$st');
    }
  }

  // ----- Recordings (Storage) -----

  Future<String?> uploadRecording({
    required String localPath,
    required String filename,
    required String title,
    required int durationSeconds,
    String? lessonId,
  }) async {
    final id = currentUser?.id;
    if (id == null) return null;
    final storagePath = '$id/$filename';
    try {
      await _client.storage
          .from('recordings')
          .upload(storagePath, File(localPath));
      await _client.from('recordings').insert({
        'user_id': id,
        'storage_path': storagePath,
        'title': title,
        'duration_seconds': durationSeconds,
        'associated_lesson_id': lessonId,
      });
      return storagePath;
    } catch (e, st) {
      debugPrint('Supabase uploadRecording failed: $e\n$st');
      return null;
    }
  }

  Future<String?> signedRecordingUrl(String storagePath) async {
    try {
      return await _client.storage
          .from('recordings')
          .createSignedUrl(storagePath, 60 * 60);
    } catch (_) {
      return null;
    }
  }

  // ----- Helpers -----

  UserProfile _profileFromRow(Map<String, dynamic> row) {
    DateTime? parse(dynamic v) =>
        v is String && v.isNotEmpty ? DateTime.tryParse(v) : null;
    return UserProfile(
      id: row['id'] as String,
      username: (row['username'] as String?) ?? 'Gitarrist',
      email: (row['email'] as String?) ?? '',
      avatarUrl: (row['avatar_url'] as String?) ?? '',
      totalXp: (row['total_xp'] as int?) ?? 0,
      level: (row['level'] as int?) ?? 1,
      currentStreak: (row['current_streak'] as int?) ?? 0,
      longestStreak: (row['longest_streak'] as int?) ?? 0,
      lastPracticeDate: parse(row['last_practice_date']),
      totalPracticeMinutes: (row['total_practice_minutes'] as int?) ?? 0,
      totalLessonsCompleted: (row['total_lessons_completed'] as int?) ?? 0,
      totalModulesCompleted: (row['total_modules_completed'] as int?) ?? 0,
      onboardingComplete: (row['onboarding_complete'] as bool?) ?? false,
      preferredTuning: (row['preferred_tuning'] as String?) ?? 'standard',
      isDarkMode: (row['is_dark_mode'] as bool?) ?? true,
      notificationsEnabled: (row['notifications_enabled'] as bool?) ?? true,
      soundEffectsEnabled: (row['sound_effects_enabled'] as bool?) ?? true,
      masterVolume: ((row['master_volume'] as num?) ?? 1.0).toDouble(),
      language: (row['language'] as String?) ?? 'de',
      isGuest: false,
      createdAt: parse(row['created_at']),
      updatedAt: parse(row['updated_at']),
    );
  }

}
