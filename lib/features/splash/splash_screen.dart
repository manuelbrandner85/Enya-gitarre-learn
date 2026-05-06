import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../core/curriculum/curriculum.dart';
import '../../core/providers/app_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String _loadingMessage = 'Starte App…';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final stopwatch = Stopwatch()..start();

    setState(() => _loadingMessage = 'Datenbank laden…');
    try {
      final db = ref.read(databaseProvider);
      await db.getUserProfile(
          ref.read(sharedPreferencesProvider).getString('user_id') ?? '');
    } catch (_) {}

    setState(() => _loadingMessage = 'Lehrplan vorbereiten…');
    // ignore: unused_local_variable
    final _ = Curriculum.allModules;

    setState(() => _loadingMessage = 'Fast bereit…');
    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 800) {
      await Future.delayed(Duration(milliseconds: 800 - elapsed));
    }

    if (!mounted) return;
    final onboardingComplete = ref.read(onboardingCompletedProvider);
    final user = ref.read(currentSupabaseUserProvider);
    if (user == null) {
      context.go('/auth');
    } else if (!onboardingComplete) {
      context.go('/onboarding');
    } else {
      context.go('/home/lessons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.electric_bolt,
                size: 64,
                color: AppColors.primary,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 600.ms,
                    curve: Curves.elasticOut),

            const SizedBox(height: 32),

            // App name
            Text(
              AppLocalizations.of(context)?.appTitle ?? 'E-Gitarre Leicht',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, duration: 600.ms),

            const SizedBox(height: 8),

            Text(
              'Für die Enya XMARI Smart Guitar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate(delay: 500.ms).fadeIn(duration: 600.ms),

            const SizedBox(height: 80),

            // Loading indicator
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.outline,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                borderRadius: BorderRadius.circular(4),
              ),
            ).animate(delay: 700.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Animated loading message
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _loadingMessage,
                key: ValueKey(_loadingMessage),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
            ).animate(delay: 800.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}
