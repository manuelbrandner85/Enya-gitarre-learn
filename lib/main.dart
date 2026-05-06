import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers/app_providers.dart';
import 'core/supabase/supabase_config.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      _setupErrorHandling();

      // Resolve SharedPreferences early so providers can read it synchronously.
      final prefs = await SharedPreferences.getInstance();

      // Initialize notifications (non-blocking).
      await NotificationService().initialize();

      // Initialise Supabase (auth, postgres, storage). Failure does not block
      // app start — the app keeps working in offline-only mode.
      try {
        await Supabase.initialize(
          url: SupabaseConfig.url,
          anonKey: SupabaseConfig.anonKey,
          debug: kDebugMode,
        );
      } catch (e, st) {
        debugPrint('Supabase initialization failed: $e\n$st');
      }

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const EnyaGitarreApp(),
        ),
      );
    },
    (error, stack) {
      debugPrint('Unhandled error: $error\n$stack');
    },
  );
}

void _setupErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('PlatformDispatcher error: $error\n$stack');
    return true;
  };
}
