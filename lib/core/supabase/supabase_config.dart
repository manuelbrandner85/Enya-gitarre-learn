/// Supabase project configuration.
///
/// Values are injected at build time via `--dart-define=SUPABASE_URL=...`
/// and `--dart-define=SUPABASE_ANON_KEY=...`. The defaults below are the
/// production project so the app also runs from a plain `flutter run`
/// without flags during local development.
///
/// The publishable (anon) key is safe to embed in the client because Row-Level
/// Security gates all access on the server. Rotate it together with an RLS
/// audit if it is ever leaked outside the intended users.
class SupabaseConfig {
  const SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://bosxikglcxojjcehbgcg.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvc3hpa2dsY3hvampjZWhiZ2NnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwMDY4OTgsImV4cCI6MjA5MzU4Mjg5OH0.UIWVkMtXtGgpBFwiRqo3684ajIORnDPuecYMzMSaySI',
  );

  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  static const String recordingsBucket = 'recordings';
}
