import 'dart:math' as math;

import 'constants.dart';

extension StringExtensions on String {
  /// Parses a note name like "A#4" into its components.
  /// Returns null if not a valid note string.
  Map<String, dynamic>? parseNote() {
    final regex = RegExp(r'^([A-G][#b]?)(\d)$');
    final match = regex.firstMatch(trim());
    if (match == null) return null;
    return {
      'name': match.group(1)!,
      'octave': int.parse(match.group(2)!),
    };
  }

  /// Returns true if this string represents a valid note name (e.g. "C#", "Bb")
  bool get isValidNoteName {
    return RegExp(r'^[A-G][#b]?$').hasMatch(trim());
  }

  /// Returns the enharmonic equivalent of a note name
  String get enharmonicEquivalent {
    const sharps = ['C#', 'D#', 'F#', 'G#', 'A#'];
    const flats = ['Db', 'Eb', 'Gb', 'Ab', 'Bb'];
    final idx = sharps.indexOf(trim());
    if (idx >= 0) return flats[idx];
    final idx2 = flats.indexOf(trim());
    if (idx2 >= 0) return sharps[idx2];
    return this;
  }

  /// Capitalizes first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Truncates string to maxLength with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }
}

extension DoubleExtensions on double {
  /// Formats a frequency value with Hz suffix
  String toHzString({int decimals = 1}) {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(decimals)} kHz';
    }
    return '${toStringAsFixed(decimals)} Hz';
  }

  /// Formats cents offset with + or - prefix
  String toCentsString() {
    final rounded = round();
    if (rounded > 0) return '+$rounded ¢';
    if (rounded < 0) return '$rounded ¢';
    return '0 ¢';
  }

  /// Converts frequency to MIDI note number
  int toMidiNote() {
    if (this <= 0) return 0;
    return (12 * (math.log(this / AppConstants.a4ReferenceHz) / math.log(2)) +
            AppConstants.midiA4)
        .round();
  }

  /// Converts frequency to nearest note name with octave
  String toNoteName() {
    final midi = toMidiNote();
    if (midi < 0 || midi > 127) return '--';
    final noteIdx = midi % 12;
    final octave = (midi ~/ 12) - 1;
    return '${AppConstants.noteNames[noteIdx]}$octave';
  }

  /// Formats as percentage string
  String toPercentString({int decimals = 0}) {
    return '${(this * 100).toStringAsFixed(decimals)}%';
  }

  /// Clamps value and returns as int
  int clampToInt(double min, double max) {
    return clamp(min, max).toInt();
  }

  /// Returns true if the value represents a "good" accuracy (>= 75%)
  bool get isGoodAccuracy => this >= 0.75;

  /// Returns true if the value represents a "perfect" accuracy (>= 98%)
  bool get isPerfectAccuracy => this >= 0.98;
}

extension DateTimeExtensions on DateTime {
  /// Returns true if this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true if this date was yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns the number of days since this date
  int get daysSince {
    final now = DateTime.now();
    final difference = now.difference(this);
    return difference.inDays;
  }

  /// Returns true if the streak is still alive (practiced today or yesterday)
  bool get isStreakAlive {
    return isToday || isYesterday;
  }

  /// Formats as German date string (e.g. "05. Januar 2024")
  String toGermanDateString() {
    const months = [
      'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
      'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
    ];
    return '${day.toString().padLeft(2, '0')}. ${months[month - 1]} $year';
  }

  /// Formats as short German date string (e.g. "05.01.2024")
  String toShortGermanDateString() {
    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year';
  }

  /// Returns a human-readable "time ago" string in German
  String toGermanRelativeString() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Gerade eben';
    if (diff.inMinutes < 60) return 'Vor ${diff.inMinutes} Minuten';
    if (diff.inHours < 24) return 'Vor ${diff.inHours} Stunden';
    if (diff.inDays == 1) return 'Gestern';
    if (diff.inDays < 7) return 'Vor ${diff.inDays} Tagen';
    if (diff.inDays < 30) return 'Vor ${(diff.inDays / 7).floor()} Wochen';
    if (diff.inDays < 365) return 'Vor ${(diff.inDays / 30).floor()} Monaten';
    return 'Vor ${(diff.inDays / 365).floor()} Jahren';
  }

  /// Returns the start of day (midnight)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns true if same day as other
  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension IntExtensions on int {
  /// Formats XP value with + prefix and "XP" suffix
  String toXpString() => '+$this XP';

  /// Returns the level for a given XP value
  int get levelFromXp => math.sqrt(this / 100).floor();

  /// Returns XP needed for the next level
  int get xpToNextLevel {
    final level = levelFromXp;
    final nextLevelXp = ((level + 1) * (level + 1)) * 100;
    return nextLevelXp - this;
  }

  /// Returns XP needed for the current level start
  int get xpForCurrentLevel {
    final level = levelFromXp;
    return (level * level) * 100;
  }

  /// Returns progress (0.0 - 1.0) towards next level
  double get levelProgress {
    final level = levelFromXp;
    final currentLevelXp = (level * level) * 100;
    final nextLevelXp = ((level + 1) * (level + 1)) * 100;
    final range = nextLevelXp - currentLevelXp;
    if (range <= 0) return 1.0;
    return (this - currentLevelXp) / range;
  }

  /// Formats as duration string (seconds to mm:ss)
  String toDurationString() {
    final minutes = this ~/ 60;
    final seconds = this % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats large numbers with K suffix (e.g. 1500 → "1.5K")
  String toCompactString() {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }

  /// Returns streak level label in German
  String get streakLevelLabel {
    if (this >= 365) return 'Diamant';
    if (this >= 100) return 'Gold';
    if (this >= 30) return 'Silber';
    if (this >= 7) return 'Bronze';
    return 'Keine';
  }

  /// Ordinal number in German (1 → "1.")
  String get germanOrdinal => '$this.';
}

extension ListExtensions<T> on List<T> {
  /// Returns the element at index, or null if out of bounds
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Chunks a list into sub-lists of given size
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, math.min(i + size, length)));
    }
    return chunks;
  }
}
