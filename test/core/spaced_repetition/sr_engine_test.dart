import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/spaced_repetition/sr_engine.dart';

SpacedRepetitionItem _newItem() => SpacedRepetitionItem.newItem(
      id: 'i1',
      itemType: SpacedRepetitionItemType.chord,
      itemId: 'C',
    );

void main() {
  group('SpacedRepetitionEngine.review – quality >= 3 (Erfolg)', () {
    test('Erste erfolgreiche Wiederholung → Intervall = 1 Tag', () {
      final item = _newItem();
      final r = SpacedRepetitionEngine.review(item, 5);
      expect(r.repetitions, 1);
      expect(r.intervalDays, 1);
    });

    test('Zweite erfolgreiche Wiederholung → Intervall = 6 Tage', () {
      var item = _newItem();
      item = SpacedRepetitionEngine.review(item, 5); // 1
      final r = SpacedRepetitionEngine.review(item, 5); // 2
      expect(r.repetitions, 2);
      expect(r.intervalDays, 6);
    });

    test('Dritte+ Wiederholung wächst um EaseFactor', () {
      var item = _newItem();
      item = SpacedRepetitionEngine.review(item, 5);
      item = SpacedRepetitionEngine.review(item, 5);
      final r = SpacedRepetitionEngine.review(item, 5);
      expect(r.intervalDays, greaterThan(6));
    });

    test('EaseFactor steigt bei quality=5', () {
      final item = _newItem();
      final r = SpacedRepetitionEngine.review(item, 5);
      expect(r.easeFactor, greaterThan(item.easeFactor));
    });
  });

  group('SpacedRepetitionEngine.review – quality < 3 (Fehler)', () {
    test('Reset auf Intervall = 1 und Repetitions = 0', () {
      var item = _newItem();
      // Ein paar erfolgreiche Reviews
      item = SpacedRepetitionEngine.review(item, 5);
      item = SpacedRepetitionEngine.review(item, 5);
      // Nun ein Fehler
      final r = SpacedRepetitionEngine.review(item, 1);
      expect(r.intervalDays, 1);
      expect(r.repetitions, 0);
    });

    test('EaseFactor bleibt bei Misserfolg gleich (SM-2)', () {
      var item = _newItem();
      item = SpacedRepetitionEngine.review(item, 5);
      final beforeFail = item.easeFactor;
      final r = SpacedRepetitionEngine.review(item, 1);
      expect(r.easeFactor, beforeFail);
    });

    test('EaseFactor fällt nicht unter Minimum (1.3)', () {
      var item = _newItem();
      // Wiederhole mit niedrigster gültiger Erfolgsqualität (3)
      // bis EF runter pendelt
      for (int i = 0; i < 50; i++) {
        item = SpacedRepetitionEngine.review(item, 3);
      }
      expect(item.easeFactor, greaterThanOrEqualTo(1.3));
    });
  });

  group('SpacedRepetitionEngine.estimateQuality', () {
    test('Sehr hohe accuracy → quality 5', () {
      final q = SpacedRepetitionEngine.estimateQuality(0.99);
      expect(q, 5);
    });

    test('Niedrige accuracy → quality < 3', () {
      final q = SpacedRepetitionEngine.estimateQuality(0.30);
      expect(q, lessThan(3));
    });
  });
}
