import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/gamification/xp_system.dart';

void main() {
  group('XpSystem.calculateLevel', () {
    test('0 XP → level 1', () {
      expect(XpSystem.calculateLevel(0), equals(1));
    });

    test('negative XP → level 1', () {
      expect(XpSystem.calculateLevel(-100), equals(1));
    });

    test('100 XP → level 1 (sqrt(100/100) = 1)', () {
      expect(XpSystem.calculateLevel(100), equals(1));
    });

    test('400 XP → level 2 (sqrt(400/100) = 2)', () {
      expect(XpSystem.calculateLevel(400), equals(2));
    });

    test('900 XP → level 3', () {
      expect(XpSystem.calculateLevel(900), equals(3));
    });

    test('10000 XP → level 10', () {
      expect(XpSystem.calculateLevel(10000), equals(10));
    });

    test('level is always at least 1', () {
      expect(XpSystem.calculateLevel(1), greaterThanOrEqualTo(1));
    });
  });

  group('XpSystem.xpForLevel', () {
    test('level 1 requires 0 XP', () {
      expect(XpSystem.xpForLevel(1), equals(0));
    });

    test('level 2 requires 400 XP (2^2 * 100)', () {
      expect(XpSystem.xpForLevel(2), equals(400));
    });

    test('level 10 requires 10000 XP (10^2 * 100)', () {
      expect(XpSystem.xpForLevel(10), equals(10000));
    });

    test('xpForLevel and calculateLevel are inverses', () {
      for (final level in [1, 2, 3, 5, 10, 20]) {
        final xp = XpSystem.xpForLevel(level);
        expect(XpSystem.calculateLevel(xp), equals(level));
      }
    });
  });

  group('XpSystem.xpToNextLevel', () {
    test('at exactly level threshold, xpToNextLevel > 0', () {
      // At 10000 XP we are level 10; next level (11) needs 12100 XP
      expect(XpSystem.xpToNextLevel(10000), greaterThan(0));
    });

    test('result is non-negative', () {
      for (final xp in [0, 50, 400, 1000, 10000]) {
        expect(XpSystem.xpToNextLevel(xp), greaterThanOrEqualTo(0));
      }
    });

    test('at 0 XP, xpToNextLevel equals xpForLevel(2)', () {
      // Level 1 at 0 XP; next is level 2 which requires xpForLevel(2) = 400
      expect(XpSystem.xpToNextLevel(0), equals(XpSystem.xpForLevel(2)));
    });
  });

  group('XpSystem.levelProgress', () {
    test('at level-start XP progress is 0.0', () {
      // xpForLevel(2) = 400, which is the exact start of level 2
      expect(XpSystem.levelProgress(400), closeTo(0.0, 0.01));
    });

    test('progress is between 0.0 and 1.0 for any XP', () {
      for (final xp in [0, 100, 500, 1500, 9999]) {
        final progress = XpSystem.levelProgress(xp);
        expect(progress, inInclusiveRange(0.0, 1.0));
      }
    });

    test('more XP within a level means higher progress', () {
      // Both in level 2 (400–900 XP)
      final p1 = XpSystem.levelProgress(450);
      final p2 = XpSystem.levelProgress(700);
      expect(p2, greaterThan(p1));
    });
  });

  group('XpSystem.lessonXp', () {
    test('perfect accuracy (>= 0.98) doubles base and adds perfectAccuracy bonus', () {
      const difficulty = 1;
      final xp = XpSystem.lessonXp(difficulty, 1.0);
      final base = XpSystem.lessonComplete + (difficulty * 10); // 60
      final expected = (base * 2.0).round() + XpSystem.perfectAccuracy; // 120 + 25 = 145
      expect(xp, equals(expected));
    });

    test('gold accuracy (0.90–0.97) gives 1.5x multiplier', () {
      final xp = XpSystem.lessonXp(0, 0.93);
      final base = XpSystem.lessonComplete; // 50
      final expected = (base * 1.5).round(); // 75
      expect(xp, equals(expected));
    });

    test('standard accuracy (0.75–0.89) gives 1.0x multiplier', () {
      final xp = XpSystem.lessonXp(0, 0.80);
      expect(xp, equals(XpSystem.lessonComplete));
    });

    test('low accuracy (< 0.75) gives 0.5x multiplier', () {
      final xp = XpSystem.lessonXp(0, 0.50);
      final expected = (XpSystem.lessonComplete * 0.5).round();
      expect(xp, equals(expected));
    });

    test('higher difficulty increases XP', () {
      final xpLow = XpSystem.lessonXp(1, 0.80);
      final xpHigh = XpSystem.lessonXp(5, 0.80);
      expect(xpHigh, greaterThan(xpLow));
    });
  });

  group('XpSystem.sessionXp', () {
    test('0 seconds → 0 XP', () {
      expect(XpSystem.sessionXp(0), equals(0));
    });

    test('5 minutes → practiceSession XP (10)', () {
      expect(XpSystem.sessionXp(300), equals(XpSystem.practiceSession));
    });

    test('more minutes → more XP', () {
      expect(XpSystem.sessionXp(600), greaterThan(XpSystem.sessionXp(300)));
    });

    test('beyond 60 minutes is capped (3600s and 7200s give same result)', () {
      expect(XpSystem.sessionXp(3600), equals(XpSystem.sessionXp(7200)));
    });
  });

  group('XpSystem.streakDayBonusXp', () {
    test('streak 1 → base streakBonus (5)', () {
      expect(XpSystem.streakDayBonusXp(1), equals(XpSystem.streakBonus));
    });

    test('streak 7 → 2x streakBonus', () {
      expect(XpSystem.streakDayBonusXp(7), equals(XpSystem.streakBonus * 2));
    });

    test('streak 30 → 3x streakBonus', () {
      expect(XpSystem.streakDayBonusXp(30), equals(XpSystem.streakBonus * 3));
    });

    test('streak 100 → 5x streakBonus', () {
      expect(XpSystem.streakDayBonusXp(100), equals(XpSystem.streakBonus * 5));
    });

    test('streak 365 → 10x streakBonus', () {
      expect(XpSystem.streakDayBonusXp(365), equals(XpSystem.streakBonus * 10));
    });

    test('higher streak gives at least as many XP', () {
      expect(
        XpSystem.streakDayBonusXp(30),
        greaterThanOrEqualTo(XpSystem.streakDayBonusXp(7)),
      );
    });
  });

  group('XpSystem.streakMilestoneXp', () {
    test('streak 7 → 50 XP', () {
      expect(XpSystem.streakMilestoneXp(7), equals(50));
    });

    test('streak 30 → 200 XP', () {
      expect(XpSystem.streakMilestoneXp(30), equals(200));
    });

    test('streak 100 → 500 XP', () {
      expect(XpSystem.streakMilestoneXp(100), equals(500));
    });

    test('streak 365 → 2000 XP', () {
      expect(XpSystem.streakMilestoneXp(365), equals(2000));
    });

    test('non-milestone streak → 0 XP', () {
      expect(XpSystem.streakMilestoneXp(5), equals(0));
      expect(XpSystem.streakMilestoneXp(15), equals(0));
    });
  });

  group('XpSystem.xpTierName', () {
    test('0 XP → Beginner', () {
      expect(XpSystem.xpTierName(0), equals('Beginner'));
    });

    test('1000 XP → Bronze', () {
      expect(XpSystem.xpTierName(1000), equals('Bronze'));
    });

    test('5000 XP → Silber', () {
      expect(XpSystem.xpTierName(5000), equals('Silber'));
    });

    test('10000 XP → Gold', () {
      expect(XpSystem.xpTierName(10000), equals('Gold'));
    });

    test('20000 XP → Platin', () {
      expect(XpSystem.xpTierName(20000), equals('Platin'));
    });

    test('50000 XP → Diamant', () {
      expect(XpSystem.xpTierName(50000), equals('Diamant'));
    });
  });
}
