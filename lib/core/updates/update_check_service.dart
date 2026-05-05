import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_config.dart';

class UpdateInfo {
  final String latestVersion;
  final String minVersion;
  final String apkUrl;
  final String changelog;
  final String releaseNotesUrl;
  final bool isForced;

  const UpdateInfo({
    required this.latestVersion,
    required this.minVersion,
    required this.apkUrl,
    required this.changelog,
    required this.releaseNotesUrl,
    required this.isForced,
  });
}

class UpdateCheckService {
  UpdateCheckService(this._client);

  final SupabaseClient _client;

  /// Returns an [UpdateInfo] if a newer version is available, otherwise null.
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final row = await _client
          .from('app_config')
          .select()
          .eq('platform', 'android')
          .maybeSingle();

      if (row == null) return null;

      final latest = (row['latest_version'] as String?) ?? '';
      final minVer = (row['min_version'] as String?) ?? '';
      final apkUrl = (row['apk_download_url'] as String?) ?? '';
      final changelog = (row['changelog'] as String?) ?? '';
      final notesUrl = (row['release_notes_url'] as String?) ?? '';

      if (latest.isEmpty) return null;

      final current = SupabaseConfig.appVersion;

      // No update if current >= latest
      if (_compareVersion(current, latest) >= 0) return null;

      final isForced =
          minVer.isNotEmpty && _compareVersion(current, minVer) < 0;

      return UpdateInfo(
        latestVersion: latest,
        minVersion: minVer,
        apkUrl: apkUrl,
        changelog: changelog,
        releaseNotesUrl: notesUrl,
        isForced: isForced,
      );
    } catch (e, st) {
      debugPrint('UpdateCheckService failed: $e\n$st');
      return null;
    }
  }

  /// Returns negative if a < b, zero if equal, positive if a > b.
  /// Compares semver-style versions (e.g. "1.2.3").
  static int _compareVersion(String a, String b) {
    final pa = _parse(a);
    final pb = _parse(b);
    final len = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < len; i++) {
      final ai = i < pa.length ? pa[i] : 0;
      final bi = i < pb.length ? pb[i] : 0;
      if (ai != bi) return ai - bi;
    }
    return 0;
  }

  static List<int> _parse(String v) {
    return v
        .split(RegExp(r'[.+\-]'))
        .map((p) => int.tryParse(p) ?? 0)
        .toList();
  }
}
