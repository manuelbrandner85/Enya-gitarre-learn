import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../audio/audio_input_service.dart';
import '../audio/metronome_service.dart';
import '../audio/pitch_detector.dart';
import '../audio/tuner_service.dart';
import '../bluetooth/bluetooth_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../models/achievement.dart';
import '../models/lesson.dart';
import '../models/user_profile.dart';
import '../supabase/supabase_sync_service.dart';
import '../utils/constants.dart';

// =============================================
// CORE INFRASTRUCTURE PROVIDERS
// =============================================

/// AppDatabase singleton; disposed automatically when container is disposed.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// SharedPreferences provider. Override this in main() with the resolved value
/// to make it synchronously available everywhere via `ref.read`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

/// Async fallback to load SharedPreferences if not overridden.
final sharedPreferencesFutureProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

// =============================================
// AUDIO PROVIDERS
// =============================================

final pitchDetectorProvider = Provider<PitchDetector>((ref) {
  final detector = PitchDetector();
  ref.onDispose(() => detector.dispose());
  return detector;
});

final tunerServiceProvider = Provider<TunerService>((ref) {
  final service = TunerService();
  ref.onDispose(() => service.dispose());
  return service;
});

final metronomeServiceProvider = Provider<MetronomeService>((ref) {
  final service = MetronomeService();
  ref.onDispose(() => service.dispose());
  return service;
});

final audioInputServiceProvider = Provider<AudioInputService>((ref) {
  final service = AudioInputService();
  ref.onDispose(() => service.dispose());
  return service;
});

final bluetoothServiceProvider = Provider<AppBluetoothService>((ref) {
  final service = AppBluetoothService();
  ref.onDispose(() => service.dispose());
  return service;
});

// =============================================
// AUDIO STREAM PROVIDERS
// =============================================

final pitchStreamProvider = StreamProvider<PitchResult>((ref) {
  final detector = ref.watch(pitchDetectorProvider);
  return detector.pitchStream;
});

final tunerStreamProvider = StreamProvider<TunerReading>((ref) {
  final service = ref.watch(tunerServiceProvider);
  return service.tunerStream;
});

final audioConnectionStreamProvider = StreamProvider<ConnectionType>((ref) {
  final service = ref.watch(audioInputServiceProvider);
  return service.connectionStream;
});

// =============================================
// USER PROFILE
// =============================================

class UserProfileNotifier
    extends StateNotifier<AsyncValue<UserProfile?>> {
  final AppDatabase _db;
  final SharedPreferences _prefs;

  UserProfileNotifier(this._db, this._prefs)
      : super(const AsyncValue.loading()) {
    load();
  }

  /// Loads the current user profile from the DB or creates a default one.
  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      var userId = _prefs.getString(AppConstants.prefKeyUserId);
      if (userId == null || userId.isEmpty) {
        userId = const Uuid().v4();
        await _prefs.setString(AppConstants.prefKeyUserId, userId);
      }

      final row = await _db.getUserProfile(userId);
      if (row == null) {
        final profile = UserProfile.newGuest(userId);
        await _persist(profile);
        state = AsyncValue.data(profile);
      } else {
        state = AsyncValue.data(_fromRow(row));
      }
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<void> addXp(int amount) async {
    final current = state.value;
    if (current == null) return;
    final newXp = current.totalXp + amount;
    final newLevel = _levelForXp(newXp);
    final updated = current.copyWith(
      totalXp: newXp,
      level: newLevel,
      updatedAt: DateTime.now(),
    );
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> incrementStreak() async {
    final current = state.value;
    if (current == null) return;
    final newStreak = current.currentStreak + 1;
    final updated = current.copyWith(
      currentStreak: newStreak,
      longestStreak: newStreak > current.longestStreak
          ? newStreak
          : current.longestStreak,
      lastPracticeDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> unlockPreset(GuitarPreset preset) async {
    final current = state.value;
    if (current == null) return;
    if (current.unlockedPresets.contains(preset.name)) return;
    final updated = current.copyWith(
      unlockedPresets: [...current.unlockedPresets, preset.name],
      updatedAt: DateTime.now(),
    );
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> updateProfile(UserProfile profile) async {
    final updated = profile.copyWith(updatedAt: DateTime.now());
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  /// Converts a database row to a UserProfile.
  UserProfile _fromRow(UserProfilesTableData row) {
    return UserProfile(
      id: row.id,
      username: row.username,
      email: row.email,
      avatarUrl: row.avatarUrl,
      totalXp: row.totalXp,
      level: row.level,
      currentStreak: row.currentStreak,
      longestStreak: row.longestStreak,
      lastPracticeDate: row.lastPracticeDate,
      totalPracticeMinutes: row.totalPracticeMinutes,
      totalLessonsCompleted: row.totalLessonsCompleted,
      totalModulesCompleted: row.totalModulesCompleted,
      onboardingComplete: row.onboardingComplete,
      preferredTuning: row.preferredTuning,
      isDarkMode: row.isDarkMode,
      notificationsEnabled: row.notificationsEnabled,
      soundEffectsEnabled: row.soundEffectsEnabled,
      masterVolume: row.masterVolume,
      language: row.language,
      isGuest: row.isGuest,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<void> _persist(UserProfile profile) async {
    await _db.upsertUserProfile(
      UserProfilesTableCompanion.insert(
        id: profile.id,
        username: Value(profile.username),
        email: Value(profile.email),
        avatarUrl: Value(profile.avatarUrl),
        totalXp: Value(profile.totalXp),
        level: Value(profile.level),
        currentStreak: Value(profile.currentStreak),
        longestStreak: Value(profile.longestStreak),
        lastPracticeDate: Value(profile.lastPracticeDate),
        totalPracticeMinutes: Value(profile.totalPracticeMinutes),
        totalLessonsCompleted: Value(profile.totalLessonsCompleted),
        totalModulesCompleted: Value(profile.totalModulesCompleted),
        onboardingComplete: Value(profile.onboardingComplete),
        preferredTuning: Value(profile.preferredTuning),
        isDarkMode: Value(profile.isDarkMode),
        notificationsEnabled: Value(profile.notificationsEnabled),
        soundEffectsEnabled: Value(profile.soundEffectsEnabled),
        masterVolume: Value(profile.masterVolume),
        language: Value(profile.language),
        isGuest: Value(profile.isGuest),
        createdAt: Value(profile.createdAt ?? DateTime.now()),
        updatedAt: Value(profile.updatedAt ?? DateTime.now()),
      ),
    );
  }

  static int _levelForXp(int xp) {
    // Level formula: floor(sqrt(xp / 100)) + 1
    if (xp <= 0) return 1;
    var level = 1;
    while ((level + 1) * (level + 1) * 100 <= xp) {
      level++;
    }
    return level;
  }
}

final currentUserProfileProvider = StateNotifierProvider<UserProfileNotifier,
    AsyncValue<UserProfile?>>((ref) {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserProfileNotifier(db, prefs);
});

// =============================================
// MODULE PROGRESS
// =============================================

class ModuleProgressState {
  final Map<String, double> completionPercent; // moduleId -> 0..1
  final Set<String> completedModuleIds;

  const ModuleProgressState({
    this.completionPercent = const {},
    this.completedModuleIds = const {},
  });

  ModuleProgressState copyWith({
    Map<String, double>? completionPercent,
    Set<String>? completedModuleIds,
  }) {
    return ModuleProgressState(
      completionPercent: completionPercent ?? this.completionPercent,
      completedModuleIds: completedModuleIds ?? this.completedModuleIds,
    );
  }
}

class ModuleProgressNotifier extends StateNotifier<ModuleProgressState> {
  final AppDatabase _db;
  final SharedPreferences _prefs;

  ModuleProgressNotifier(this._db, this._prefs)
      : super(const ModuleProgressState()) {
    load();
  }

  Future<void> load() async {
    final userId = _prefs.getString(AppConstants.prefKeyUserId);
    if (userId == null) return;

    final rows = await _db.getAllModuleProgress(userId);
    final completion = <String, double>{};
    final completed = <String>{};
    for (final r in rows) {
      completion[r.moduleId] = r.completionPercentage;
      if (r.isCompleted) completed.add(r.moduleId);
    }
    state = ModuleProgressState(
      completionPercent: completion,
      completedModuleIds: completed,
    );
  }

  Future<void> setCompletion(String moduleId, double percent) async {
    final userId = _prefs.getString(AppConstants.prefKeyUserId);
    if (userId == null) return;

    final isCompleted = percent >= 1.0;
    await _db.upsertModuleProgress(
      ModuleProgressTableCompanion.insert(
        moduleId: moduleId,
        userId: userId,
        completionPercentage: Value(percent),
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
        lastAccessedAt: Value(DateTime.now()),
      ),
    );

    final newCompletion = Map<String, double>.from(state.completionPercent)
      ..[moduleId] = percent;
    final newCompleted = Set<String>.from(state.completedModuleIds);
    if (isCompleted) {
      newCompleted.add(moduleId);
    } else {
      newCompleted.remove(moduleId);
    }
    state = state.copyWith(
      completionPercent: newCompletion,
      completedModuleIds: newCompleted,
    );
  }

  Future<void> markComplete(String moduleId) => setCompletion(moduleId, 1.0);
}

final moduleProgressProvider =
    StateNotifierProvider<ModuleProgressNotifier, ModuleProgressState>((ref) {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return ModuleProgressNotifier(db, prefs);
});

// =============================================
// ACHIEVEMENTS
// =============================================

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final AppDatabase _db;
  final SharedPreferences _prefs;

  AchievementsNotifier(this._db, this._prefs) : super(const []) {
    load();
  }

  Future<void> load() async {
    final userId = _prefs.getString(AppConstants.prefKeyUserId);
    if (userId == null) return;
    final rows = await _db.getUnlockedAchievements(userId);
    final unlocked = <Achievement>[];
    for (final r in rows) {
      final base = AchievementRegistry.findByKey(r.key);
      if (base != null) {
        unlocked.add(base.copyWith(unlockedAt: r.unlockedAt));
      }
    }
    state = unlocked;
  }

  Future<bool> unlock(String key) async {
    final userId = _prefs.getString(AppConstants.prefKeyUserId);
    if (userId == null) return false;
    if (state.any((a) => a.key == key)) return false;
    final base = AchievementRegistry.findByKey(key);
    if (base == null) return false;
    final unlockedAt = DateTime.now();
    await _db.unlockAchievement(userId, key, unlockedAt);
    state = [...state, base.copyWith(unlockedAt: unlockedAt)];
    return true;
  }

  bool isUnlocked(String key) => state.any((a) => a.key == key);
}

final achievementsProvider =
    StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AchievementsNotifier(db, prefs);
});

// =============================================
// THEME MODE
// =============================================

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences prefs) {
    final raw = prefs.getString(AppConstants.prefKeyThemeMode);
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(AppConstants.prefKeyThemeMode, mode.name);
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setMode(next);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

// =============================================
// LOCALE
// =============================================

class LocaleNotifier extends StateNotifier<Locale> {
  static const String _prefsKey = 'app_locale';
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs) : super(_load(_prefs));

  static Locale _load(SharedPreferences prefs) {
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return const Locale('de');
    final parts = raw.split('_');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return Locale(parts[0]);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final tag = locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_${locale.countryCode}';
    await _prefs.setString(_prefsKey, tag);
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

// =============================================
// ONBOARDING COMPLETED
// =============================================

class OnboardingCompletedNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  OnboardingCompletedNotifier(this._prefs)
      : super(_prefs.getBool(AppConstants.prefKeyOnboardingComplete) ?? false);

  Future<void> setCompleted(bool value) async {
    state = value;
    await _prefs.setBool(AppConstants.prefKeyOnboardingComplete, value);
  }
}

final onboardingCompletedProvider =
    StateNotifierProvider<OnboardingCompletedNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingCompletedNotifier(prefs);
});

// =============================================
// SUPABASE
// =============================================

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final supabaseSyncProvider = Provider<SupabaseSyncService>((ref) {
  return SupabaseSyncService(ref.watch(supabaseClientProvider));
});

/// Streams the current Supabase auth state. The initial value is whatever
/// Supabase already restored from SharedPreferences on init().
final authStateStreamProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

/// Convenience: the currently signed-in [User] (or null when signed out).
final currentSupabaseUserProvider = Provider<User?>((ref) {
  ref.watch(authStateStreamProvider);
  return ref.watch(supabaseClientProvider).auth.currentUser;
});
