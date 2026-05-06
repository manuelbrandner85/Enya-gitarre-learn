import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/providers/app_providers.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_flow.dart';
import '../features/onboarding/pages/welcome_page.dart';
import '../features/onboarding/pages/guitar_setup_page.dart';
import '../features/onboarding/pages/onboarding_tuner_page.dart';
import '../features/onboarding/pages/profile_setup_page.dart';
import '../features/home/home_screen.dart';
import '../features/lessons/module_overview_screen.dart';
import '../features/lessons/lesson_screen.dart';
import '../features/tuner/tuner_screen.dart';
import '../features/metronome/metronome_screen.dart';
import '../features/progress/progress_dashboard_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/lessons/lesson_complete_screen.dart';
import '../features/chord_library/screens/chord_library_screen.dart';
import '../features/scale_library/screens/scale_library_screen.dart';
import '../features/songs/screens/song_library_screen.dart';
import '../features/songs/screens/song_practice_screen.dart';
import '../features/recording/screens/recording_screen.dart';
import '../features/recording/screens/recordings_list_screen.dart';
import '../features/backing_tracks/screens/backing_tracks_screen.dart';
import '../features/ear_training/screens/ear_training_screen.dart';
import '../features/xmari_settings/screens/xmari_preset_manager_screen.dart';
import '../features/progress/screens/achievements_screen.dart';
import '../features/progress/screens/practice_diary_screen.dart';
import '../features/auth/screens/auth_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final onboardingComplete = ref.watch(onboardingCompletedProvider);
  final user = ref.watch(currentSupabaseUserProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // From the splash route, decide where to go.
      if (state.matchedLocation == '/') {
        if (user == null) return '/auth';
        return onboardingComplete ? '/home/lessons' : '/onboarding';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingFlow(),
        routes: [
          GoRoute(
            path: 'welcome',
            name: 'onboarding-welcome',
            builder: (context, state) => const WelcomePage(),
          ),
          GoRoute(
            path: 'guitar-setup',
            name: 'onboarding-guitar-setup',
            builder: (context, state) => const GuitarSetupPage(),
          ),
          GoRoute(
            path: 'tuner',
            name: 'onboarding-tuner',
            builder: (context, state) => const OnboardingTunerPage(),
          ),
          GoRoute(
            path: 'profile',
            name: 'onboarding-profile',
            builder: (context, state) => const ProfileSetupPage(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0 – Lernen
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/lessons',
                name: 'lessons',
                builder: (context, state) => const ModuleOverviewScreen(),
                routes: [
                  GoRoute(
                    path: ':moduleId/:lessonId',
                    name: 'lesson',
                    builder: (context, state) {
                      final moduleId =
                          state.pathParameters['moduleId'] ?? '';
                      final lessonId =
                          state.pathParameters['lessonId'] ?? '';
                      return LessonScreen(
                        moduleId: moduleId,
                        lessonId: lessonId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 1 – Songbuch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/songbuch',
                name: 'songbuch',
                builder: (context, state) =>
                    const SongLibraryScreen(isTab: true),
                routes: [
                  GoRoute(
                    path: ':songId',
                    name: 'songbuch-practice',
                    builder: (context, state) {
                      final id = state.pathParameters['songId'] ?? '';
                      return SongPracticeScreen(songId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2 – Stimmgerät
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/tuner',
                name: 'tuner',
                builder: (context, state) => const TunerScreen(),
              ),
            ],
          ),
          // Branch 3 – Fortschritt
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/progress',
                name: 'progress',
                builder: (context, state) => const ProgressDashboardScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/home/metronome',
        name: 'metronome',
        builder: (_, __) => const MetronomeScreen(),
      ),
      GoRoute(
        path: '/home/settings',
        name: 'settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/home/chord-library',
        name: 'chord-library',
        builder: (context, state) => const ChordLibraryScreen(),
      ),
      GoRoute(
        path: '/home/scale-library',
        name: 'scale-library',
        builder: (context, state) => const ScaleLibraryScreen(),
      ),
      GoRoute(
        path: '/home/songs',
        name: 'songs',
        builder: (context, state) => const SongLibraryScreen(),
        routes: [
          GoRoute(
            path: ':songId',
            name: 'song-practice',
            builder: (context, state) {
              final id = state.pathParameters['songId'] ?? '';
              return SongPracticeScreen(songId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/home/recording',
        name: 'recording',
        builder: (context, state) => const RecordingScreen(),
        routes: [
          GoRoute(
            path: 'list',
            name: 'recording-list',
            builder: (context, state) => const RecordingsListScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/home/backing-tracks',
        name: 'backing-tracks',
        builder: (context, state) => const BackingTracksScreen(),
      ),
      GoRoute(
        path: '/home/ear-training',
        name: 'ear-training',
        builder: (context, state) => const EarTrainingScreen(),
      ),
      GoRoute(
        path: '/home/xmari-presets',
        name: 'xmari-presets',
        builder: (context, state) => const XmariPresetManagerScreen(),
      ),
      GoRoute(
        path: '/home/progress/achievements',
        name: 'progress-achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/home/progress/diary',
        name: 'progress-diary',
        builder: (context, state) => const PracticeDiaryScreen(),
      ),
      GoRoute(
        path: '/lesson-complete',
        name: 'lesson-complete',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LessonCompleteScreen(
            lessonTitle: extra?['lessonTitle'] as String? ?? '',
            xpEarned: extra?['xpEarned'] as int? ?? 0,
            accuracy: extra?['accuracy'] as double? ?? 0.0,
            newAchievements:
                extra?['newAchievements'] as List<String>? ?? [],
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Seite nicht gefunden',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(state.error?.message ?? 'Unbekannter Fehler'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Zurück zur Startseite'),
            ),
          ],
        ),
      ),
    ),
  );
}
