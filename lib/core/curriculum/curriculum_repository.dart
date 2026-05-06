import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import '../utils/result.dart';
import 'curriculum_fallback.dart';
import 'models/curriculum_models.dart';

class CurriculumRepository {
  final SupabaseClient _supabase;
  final AppDatabase _db;

  static const Duration _cacheMaxAge = Duration(hours: 24);

  CurriculumRepository({
    required SupabaseClient supabase,
    required AppDatabase db,
  })  : _supabase = supabase,
        _db = db;

  /// Returns modules using the following priority:
  /// 1. Fresh local cache (< 24 h old)
  /// 2. Supabase remote fetch (writes to cache on success)
  /// 3. Stale local cache (any age)
  /// 4. Built-in fallback data
  Future<Result<List<ModuleModel>>> getModules() async {
    // 1. Try fresh cache
    try {
      final cached = await _getCachedModules();
      if (cached != null) {
        debugPrint('CurriculumRepository: modules from cache');
        return Success(cached);
      }
    } catch (e) {
      debugPrint('CurriculumRepository: cache read error: $e');
    }

    // 2. Fetch from Supabase
    try {
      final rows = await _supabase
          .from('modules')
          .select()
          .order('order_index');
      final modules = (rows as List)
          .map((r) => ModuleModel.fromJson(r as Map<String, dynamic>))
          .toList();
      await _cacheModules(modules);
      debugPrint(
          'CurriculumRepository: ${modules.length} modules from Supabase');
      return Success(modules);
    } catch (e) {
      debugPrint('CurriculumRepository: Supabase fetch failed: $e');
    }

    // 3. Stale cache fallback
    try {
      final stale = await _getCachedModules(ignoreAge: true);
      if (stale != null) {
        debugPrint('CurriculumRepository: stale cache fallback');
        return Success(stale);
      }
    } catch (_) {}

    // 4. Built-in fallback
    debugPrint('CurriculumRepository: using built-in fallback data');
    return Success(CurriculumFallback.modules);
  }

  /// Fetches lessons for a given [moduleId] from Supabase.
  /// Falls back to an empty list on error.
  Future<Result<List<LessonModel>>> getLessonsForModule(
      String moduleId) async {
    try {
      final rows = await _supabase
          .from('lessons')
          .select()
          .eq('module_id', moduleId)
          .order('order_index');
      return Success((rows as List)
          .map((r) => LessonModel.fromJson(r as Map<String, dynamic>))
          .toList());
    } catch (e) {
      return Failure('Lektionen konnten nicht geladen werden.', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Cache helpers
  // ---------------------------------------------------------------------------

  Future<List<ModuleModel>?> _getCachedModules(
      {bool ignoreAge = false}) async {
    try {
      final rows = await _db
          .customSelect(
            "SELECT content_json, last_updated FROM curriculum_cache "
            "WHERE module_id = 'modules' AND lesson_id = 'all'",
          )
          .get();
      if (rows.isEmpty) return null;
      final row = rows.first;
      final lastUpdated = DateTime.fromMillisecondsSinceEpoch(
          row.read<int>('last_updated'));
      if (!ignoreAge &&
          DateTime.now().difference(lastUpdated) > _cacheMaxAge) {
        return null;
      }
      final json =
          jsonDecode(row.read<String>('content_json')) as List<dynamic>;
      return json
          .map((e) => ModuleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _cacheModules(List<ModuleModel> modules) async {
    try {
      final json = jsonEncode(modules.map((m) => m.toJson()).toList());
      await _db.customStatement(
        '''INSERT OR REPLACE INTO curriculum_cache
           (id, module_id, lesson_id, content_json, version, last_updated, checksum)
           VALUES ('modules_all', 'modules', 'all', ?, 1, ?, '')''',
        [json, DateTime.now().millisecondsSinceEpoch],
      );
    } catch (e) {
      debugPrint('CurriculumRepository: cache write error: $e');
    }
  }
}
