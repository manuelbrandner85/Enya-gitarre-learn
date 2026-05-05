import 'dart:math' as math;

enum SpacedRepetitionItemType {
  chord,
  scale,
  note,
  rhythm,
  earTraining,
}

class SpacedRepetitionItem {
  final String id;
  final SpacedRepetitionItemType itemType;
  final String itemId;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final DateTime nextReviewDate;
  final DateTime? lastReviewDate;
  final int lastQuality; // 0-5 rating of the last review

  const SpacedRepetitionItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    this.repetitions = 0,
    required this.nextReviewDate,
    this.lastReviewDate,
    this.lastQuality = 0,
  });

  /// Creates a new item with default values
  factory SpacedRepetitionItem.newItem({
    required String id,
    required SpacedRepetitionItemType itemType,
    required String itemId,
  }) =>
      SpacedRepetitionItem(
        id: id,
        itemType: itemType,
        itemId: itemId,
        nextReviewDate: DateTime.now(),
      );

  /// Returns true if this item is due for review
  bool get isDue => DateTime.now().isAfter(nextReviewDate);

  /// Returns the days until next review (negative if overdue)
  int get daysUntilReview {
    return nextReviewDate.difference(DateTime.now()).inDays;
  }

  /// Returns how many days overdue this item is (0 if not overdue)
  int get daysOverdue {
    final diff = DateTime.now().difference(nextReviewDate).inDays;
    return math.max(0, diff);
  }

  SpacedRepetitionItem copyWith({
    String? id,
    SpacedRepetitionItemType? itemType,
    String? itemId,
    double? easeFactor,
    int? intervalDays,
    int? repetitions,
    DateTime? nextReviewDate,
    DateTime? lastReviewDate,
    int? lastQuality,
  }) {
    return SpacedRepetitionItem(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      lastQuality: lastQuality ?? this.lastQuality,
    );
  }

  @override
  String toString() =>
      'SRItem($itemId, rep=$repetitions, EF=$easeFactor, interval=${intervalDays}d)';
}

class SpacedRepetitionEngine {
  SpacedRepetitionEngine._();

  static const double _minEaseFactor = 1.3;
  static const double _defaultEaseFactor = 2.5;

  /// Reviews an item with a quality rating (0-5) and returns the updated item.
  ///
  /// Quality scale:
  /// 5 - Perfect response, effortless
  /// 4 - Correct response after brief hesitation
  /// 3 - Correct response with significant difficulty
  /// 2 - Incorrect response; correct answer seemed easy to recall
  /// 1 - Incorrect response; correct answer remembered
  /// 0 - Complete blackout / no recall
  static SpacedRepetitionItem review(
    SpacedRepetitionItem item,
    int quality,
  ) {
    assert(quality >= 0 && quality <= 5, 'Quality must be 0-5');

    final q = quality.clamp(0, 5);

    double newEaseFactor;
    int newInterval;
    int newRepetitions;

    if (q >= 3) {
      // Correct response - advance the item
      if (item.repetitions == 0) {
        newInterval = 1;
      } else if (item.repetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (item.intervalDays * item.easeFactor).round();
      }

      newRepetitions = item.repetitions + 1;

      // SM-2 ease factor formula
      // EF' = EF + (0.1 - (5-q) * (0.08 + (5-q) * 0.02))
      newEaseFactor = item.easeFactor +
          (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
      newEaseFactor = math.max(_minEaseFactor, newEaseFactor);
    } else {
      // Incorrect response - reset
      newInterval = 1;
      newRepetitions = 0;
      newEaseFactor = item.easeFactor; // EF doesn't decrease on failure in SM-2
    }

    final nextReviewDate = DateTime.now().add(Duration(days: newInterval));

    return item.copyWith(
      easeFactor: newEaseFactor,
      intervalDays: newInterval,
      repetitions: newRepetitions,
      nextReviewDate: nextReviewDate,
      lastReviewDate: DateTime.now(),
      lastQuality: quality,
    );
  }

  /// Returns all items that are due for review, sorted by urgency
  static List<SpacedRepetitionItem> getDueItems(
    List<SpacedRepetitionItem> items,
  ) {
    final due = items.where((item) => item.isDue).toList();

    // Sort by: most overdue first, then by ease factor (harder items first)
    due.sort((a, b) {
      final urgencyA = a.daysOverdue;
      final urgencyB = b.daysOverdue;

      if (urgencyA != urgencyB) return urgencyB.compareTo(urgencyA);

      // Secondary sort: items with lower ease factor are more difficult
      return a.easeFactor.compareTo(b.easeFactor);
    });

    return due;
  }

  /// Returns items due today (not overdue, just due today)
  static List<SpacedRepetitionItem> getTodayItems(
    List<SpacedRepetitionItem> items,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return items.where((item) {
      final reviewDate = item.nextReviewDate;
      return !reviewDate.isAfter(tomorrow) && item.isDue;
    }).toList();
  }

  /// Estimates quality based on accuracy (0.0-1.0) and time taken
  static int estimateQuality(double accuracy, {int? timeTakenSeconds, int? expectedSeconds}) {
    if (accuracy >= 0.95) return 5;
    if (accuracy >= 0.85) return 4;
    if (accuracy >= 0.70) return 3;
    if (accuracy >= 0.50) return 2;
    if (accuracy >= 0.20) return 1;
    return 0;
  }

  /// Returns statistics about the review queue
  static Map<String, int> queueStats(List<SpacedRepetitionItem> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return {
      'total': items.length,
      'due': items.where((i) => i.isDue).length,
      'dueToday': items
          .where((i) =>
              i.nextReviewDate.isBefore(today.add(const Duration(days: 1))))
          .length,
      'dueTomorrow': items
          .where((i) =>
              i.nextReviewDate.isAfter(today) &&
              i.nextReviewDate.isBefore(today.add(const Duration(days: 2))))
          .length,
      'new': items.where((i) => i.repetitions == 0).length,
      'learning': items.where((i) => i.repetitions > 0 && i.repetitions < 3).length,
      'mature': items.where((i) => i.repetitions >= 3).length,
    };
  }
}
