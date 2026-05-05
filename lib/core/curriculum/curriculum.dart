import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

import 'module_1_data.dart';
import 'module_2_data.dart';
import 'module_3_data.dart';
import 'module_4_data.dart';
import 'module_5_data.dart';
import 'module_6_data.dart';
import 'module_7_data.dart';
import 'module_8_data.dart';
import 'module_9_data.dart';
import 'module_10_data.dart';
import 'module_11_data.dart';
import 'module_12_data.dart';

export 'module_1_data.dart';
export 'module_2_data.dart';
export 'module_3_data.dart';
export 'module_4_data.dart';
export 'module_5_data.dart';
export 'module_6_data.dart';
export 'module_7_data.dart';
export 'module_8_data.dart';
export 'module_9_data.dart';
export 'module_10_data.dart';
export 'module_11_data.dart';
export 'module_12_data.dart';

/// Aggregator for the full 12-module curriculum.
///
/// All 12 modules are fully built out with detailed lesson content.
class Curriculum {
  Curriculum._();

  /// All 12 modules with detailed content.
  static List<Module> get allModules {
    final result = <Module>[
      module1,
      module2,
      module3,
      module4,
      module5,
      module6,
      module7,
      module8,
      module9,
      module10,
      module11,
      module12,
    ];
    result.sort((a, b) => a.moduleNumber.compareTo(b.moduleNumber));
    return result;
  }

  /// Looks up a module by its numeric id (1..12) or string id ("module-01").
  static Module? findModule(dynamic id) {
    final modules = allModules;
    if (id is int) {
      for (final m in modules) {
        if (m.moduleNumber == id) return m;
      }
      return null;
    }
    if (id is String) {
      for (final m in modules) {
        if (m.id == id) return m;
      }
      return null;
    }
    return null;
  }

  /// Looks up a single lesson by [moduleId] (string or int) and [lessonId].
  static Lesson? findLesson(dynamic moduleId, String lessonId) {
    final module = findModule(moduleId);
    if (module == null) return null;
    for (final lesson in module.lessons) {
      if (lesson.id == lessonId) return lesson;
    }
    return null;
  }

  /// Returns the next lesson in the module after [lessonId], or null if it was
  /// the last one.
  static Lesson? nextLesson(dynamic moduleId, String lessonId) {
    final module = findModule(moduleId);
    if (module == null) return null;
    final idx = module.lessons.indexWhere((l) => l.id == lessonId);
    if (idx < 0 || idx + 1 >= module.lessons.length) return null;
    return module.lessons[idx + 1];
  }

  /// Returns the total XP available across the entire curriculum.
  static int get totalXpAvailable =>
      allModules.fold(0, (sum, m) => sum + m.totalXpAvailable);

  /// Returns the total number of lessons across all modules.
  static int get totalLessonCount =>
      allModules.fold(0, (sum, m) => sum + m.lessons.length);
}

/// Convenience top-level constant exposed for callers that want the list directly.
List<Module> get allModules => Curriculum.allModules;
