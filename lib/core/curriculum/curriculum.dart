import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/models/module.dart';

import 'module_1_data.dart';
import 'module_2_data.dart';
import 'module_3_data.dart';
import 'module_4_data.dart';

export 'module_1_data.dart';
export 'module_2_data.dart';
export 'module_3_data.dart';
export 'module_4_data.dart';

/// Aggregator for the full 12-module curriculum.
///
/// Modules 1-4 are fully built out with lessons in [module1Lessons] etc.
/// Modules 5-12 fall back to the placeholder definitions that already live in
/// [ModuleContent.allModules] in `core/models/module.dart`.
class Curriculum {
  Curriculum._();

  /// All 12 modules, with detailed content for modules 1-4 and placeholders
  /// for modules 5-12.
  static List<Module> get allModules {
    final placeholders = ModuleContent.allModules;
    final result = <Module>[
      module1,
      module2,
      module3,
      module4,
    ];
    // Append modules 5..12 from the static placeholder content.
    for (final m in placeholders) {
      if (m.moduleNumber >= 5) result.add(m);
    }
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
