import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

part 'router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/tuner',
                name: 'tuner',
                builder: (context, state) => const TunerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/metronome',
                name: 'metronome',
                builder: (context, state) => const MetronomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/progress',
                name: 'progress',
                builder: (context, state) => const ProgressDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
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
