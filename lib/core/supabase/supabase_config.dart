/// Supabase project configuration.
///
/// The publishable (anon) key is intentionally checked in: it is meant to be
/// embedded in the client and is safe to expose because Row-Level Security
/// gates all access on the server. Rotate this key together with RLS audit if
/// it is ever leaked outside the intended users.
class SupabaseConfig {
  const SupabaseConfig._();

  static const String url = 'https://bosxikglcxojjcehbgcg.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvc3hpa2dsY3hvampjZWhiZ2NnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwMDY4OTgsImV4cCI6MjA5MzU4Mjg5OH0.UIWVkMtXtGgpBFwiRqo3684ajIORnDPuecYMzMSaySI';
  static const String recordingsBucket = 'recordings';
}
