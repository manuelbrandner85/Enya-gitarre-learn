import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/gamification/xp_system.dart';

void main() {
  group('XpSystem.calculateLevel', () {
    test('Level-Formel: level = floor(sqrt(xp/100)) mit min Level 1', () {
      expect(XpSystem.calculateLevel(0), 1);
      expect(XpSystem.calculateLevel(99), 1);
      expect(XpSystem.calculateLevel(100), 1); // sqrt(1)=1
      expect(XpSystem.calculateLevel(400), 2); // sqrt(4)=2
      expect(XpSystem.calculateLevel(900), 3);
      expect(XpSystem.calculateLevel(1600), 4);
      expect(XpSystem.calculateLevel(2500), 5);
      expect(XpSystem.calculateLevel(3600), 6);
      expect(XpSystem.calculateLevel(10000), 10);
    });

    test('Level steigt bei XP-Erhöhung niemals zurück', () {
      var prev = XpSystem.calculateLevel(0);
      for (int xp = 0; xp <= 20000; xp += 50) {
        final lvl = XpSystem.calculateLevel(xp);
        expect(lvl, greaterThanOrEqualTo(prev));
        prev = lvl;
      }
    });
  });

  group('XpSystem.xpForLevel & xpToNextLevel', () {
    test('xpForLevel ist Inverse von calculateLevel', () {
      for (int level = 1; level <= 20; level++) {
        final xp = XpSystem.xpForLevel(level);
        expect(XpSystem.calculateLevel(xp), level);
      }
    });

    test('xpToNextLevel ist immer >= 0', () {
      for (int xp = 0; xp <= 10000; xp += 100) {
        expect(XpSystem.xpToNextLevel(xp), greaterThanOrEqualTo(0));
      }
    });
  });

  group('XpSystem.levelProgress', () {
    test('liefert 0.0 bei Level-Start, ~1.0 vor Level-Up', () {
      // Level 2 startet bei 400 XP, Level 3 bei 900 XP.
      expect(XpSystem.levelProgress(400), closeTo(0.0, 0.01));
      expect(XpSystem.levelProgress(800), closeTo(0.8, 0.05));
    });

    test('gibt nie Werte außerhalb [0,1] zurück', () {
      for (int xp = 0; xp <= 10000; xp += 50) {
        final p = XpSystem.levelProgress(xp);
        expect(p, inInclusiveRange(0.0, 1.0));
      }
    });
  });
}
