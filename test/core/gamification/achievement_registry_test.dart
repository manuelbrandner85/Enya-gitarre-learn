import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/models/achievement.dart';

void main() {
  group('AchievementRegistry', () {
    test('alle Streak-Keys existieren', () {
      expect(AchievementRegistry.streak7, 'streak_7');
      expect(AchievementRegistry.streak30, 'streak_30');
      expect(AchievementRegistry.streak100, 'streak_100');
      expect(AchievementRegistry.streak365, 'streak_365');
    });

    test('Level-Keys existieren', () {
      expect(AchievementRegistry.level5, contains('5'));
      expect(AchievementRegistry.level10, contains('10'));
    });

    test('allAchievements enthält alle definierten Keys', () {
      expect(AchievementRegistry.allAchievements, isNotEmpty);
      // Must contain streak-7
      final keys =
          AchievementRegistry.allAchievements.map((a) => a.key).toSet();
      expect(keys.contains(AchievementRegistry.streak7), isTrue);
      expect(keys.contains(AchievementRegistry.firstNote), isTrue);
    });

    test('findByKey liefert das richtige Achievement', () {
      final a = AchievementRegistry.findByKey(AchievementRegistry.streak7);
      expect(a, isNotNull);
      expect(a!.key, AchievementRegistry.streak7);
    });

    test('findByKey unbekannter Key → null', () {
      expect(
        AchievementRegistry.findByKey('definitely-not-an-achievement'),
        isNull,
      );
    });
  });
}
