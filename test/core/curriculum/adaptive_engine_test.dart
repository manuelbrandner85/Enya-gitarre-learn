import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/curriculum/adaptive_engine.dart';

void main() {
  group('AdaptiveEngine.evaluate', () {
    test('skipAhead bei accuracy >= 0.90', () {
      expect(AdaptiveEngine.evaluate(0.95, 0), AdaptiveAction.skipAhead);
      expect(AdaptiveEngine.evaluate(0.90, 0), AdaptiveAction.skipAhead);
    });

    test('continue_ bei accuracy zwischen 0.70 und 0.90', () {
      expect(AdaptiveEngine.evaluate(0.75, 0), AdaptiveAction.continue_);
      expect(AdaptiveEngine.evaluate(0.85, 2), AdaptiveAction.continue_);
    });

    test('reviewPrevious bei 3+ Failures und accuracy <= 0.50', () {
      expect(AdaptiveEngine.evaluate(0.40, 3),
          AdaptiveAction.reviewPrevious);
      expect(AdaptiveEngine.evaluate(0.30, 5),
          AdaptiveAction.reviewPrevious);
    });

    test('simplify bei accuracy <= 0.70 ohne genug Failures', () {
      expect(AdaptiveEngine.evaluate(0.65, 0), AdaptiveAction.simplify);
      expect(AdaptiveEngine.evaluate(0.50, 1), AdaptiveAction.simplify);
    });

    test('describe liefert für jede Aktion einen nicht-leeren Text', () {
      for (final a in AdaptiveAction.values) {
        expect(AdaptiveEngine.describe(a), isNotEmpty);
      }
    });
  });
}
