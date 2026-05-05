import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/app_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

// Re-export central providers so existing imports of `app/app.dart` keep working.
export '../core/providers/app_providers.dart'
    show
        themeModeProvider,
        localeProvider,
        onboardingCompletedProvider,
        currentUserProfileProvider,
        moduleProgressProvider,
        achievementsProvider,
        databaseProvider,
        sharedPreferencesProvider,
        pitchDetectorProvider,
        tunerServiceProvider,
        metronomeServiceProvider,
        audioInputServiceProvider,
        bluetoothServiceProvider,
        pitchStreamProvider,
        tunerStreamProvider,
        audioConnectionStreamProvider;

class EnyaGitarreApp extends ConsumerWidget {
  const EnyaGitarreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'E-Gitarre Leicht',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
