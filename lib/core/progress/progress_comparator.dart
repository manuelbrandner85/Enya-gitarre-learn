class ComparisonData {
  final double accuracyThen;
  final double accuracyNow;
  final int daysDiff;
  final int presetsUnlockedThen;
  final int presetsUnlockedNow;

  const ComparisonData({
    required this.accuracyThen,
    required this.accuracyNow,
    required this.daysDiff,
    required this.presetsUnlockedThen,
    required this.presetsUnlockedNow,
  });

  double get accuracyDelta => accuracyNow - accuracyThen;
  bool get isImproving => accuracyDelta > 0;
  int get presetsDelta => presetsUnlockedNow - presetsUnlockedThen;

  String get presetProgressText {
    if (presetsDelta > 0) {
      return 'Vor $daysDiff Tagen: $presetsUnlockedThen Sound${presetsUnlockedThen == 1 ? "" : "s"}. '
          'Heute: $presetsUnlockedNow Sounds freigeschaltet!';
    }
    return 'Freigeschaltete Sounds: $presetsUnlockedNow / 4';
  }
}

class ProgressComparator {
  ProgressComparator._();

  static ComparisonData compare({
    required double accuracyBefore,
    required double accuracyNow,
    required int days,
    required int presetsUnlockedBefore,
    required int presetsUnlockedNow,
  }) {
    return ComparisonData(
      accuracyThen: accuracyBefore,
      accuracyNow: accuracyNow,
      daysDiff: days,
      presetsUnlockedThen: presetsUnlockedBefore,
      presetsUnlockedNow: presetsUnlockedNow,
    );
  }
}
