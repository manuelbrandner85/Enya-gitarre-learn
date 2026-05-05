import 'dart:math' as math;

import '../utils/constants.dart';

class Note {
  final String name;
  final int octave;

  const Note({required this.name, required this.octave});

  /// MIDI note number (C4 = 60)
  int get midiNumber {
    final noteIdx = AppConstants.noteNames.indexOf(name);
    if (noteIdx < 0) return -1;
    return (octave + 1) * 12 + noteIdx;
  }

  /// Frequency in Hz using equal temperament
  double get frequency {
    final semitones = midiNumber - AppConstants.midiA4;
    return AppConstants.a4ReferenceHz *
        math.pow(2, semitones / 12).toDouble();
  }

  /// Creates a Note from a frequency in Hz
  factory Note.fromFrequency(double hz) {
    if (hz <= 0) return const Note(name: 'C', octave: 4);

    final semitones =
        12 * (math.log(hz / AppConstants.a4ReferenceHz) / math.log(2));
    final midiNote = (semitones + AppConstants.midiA4).round();

    return Note.fromMidi(midiNote);
  }

  /// Creates a Note from a MIDI note number
  factory Note.fromMidi(int midi) {
    final clamped = midi.clamp(0, 127);
    final noteIdx = clamped % 12;
    final octave = (clamped ~/ 12) - 1;
    return Note(
      name: AppConstants.noteNames[noteIdx],
      octave: octave,
    );
  }

  /// Returns the cents offset from another note
  /// Positive means this note is sharp relative to other
  double centsFrom(Note other) {
    final diff = midiNumber - other.midiNumber;
    final freqRatio = frequency / other.frequency;
    return 1200 * (math.log(freqRatio) / math.log(2)) - (diff * 100.0);
  }

  /// Returns the cents offset from a raw frequency
  double centsFromFrequency(double hz) {
    if (hz <= 0) return 0;
    return 1200 * (math.log(hz / frequency) / math.log(2));
  }

  /// Returns true if this note is enharmonically equivalent to other
  bool isEnharmonicWith(Note other) {
    return midiNumber == other.midiNumber;
  }

  /// Returns the note index (0-11) in the chromatic scale
  int get chromaticIndex => AppConstants.noteNames.indexOf(name);

  /// Returns true if this note has a sharp/flat
  bool get isAccidental => name.contains('#') || name.contains('b');

  /// Returns the natural version of this note (removes sharp/flat)
  String get naturalName => name.replaceAll('#', '').replaceAll('b', '');

  /// Returns the flat equivalent if sharp, sharp if flat
  String get enharmonicName {
    const sharps = ['C#', 'D#', 'F#', 'G#', 'A#'];
    const flats = ['Db', 'Eb', 'Gb', 'Ab', 'Bb'];
    final idx = sharps.indexOf(name);
    if (idx >= 0) return flats[idx];
    final idx2 = flats.indexOf(name);
    if (idx2 >= 0) return sharps[idx2];
    return name;
  }

  /// Returns a transposed note by the given number of semitones
  Note transpose(int semitones) {
    return Note.fromMidi(midiNumber + semitones);
  }

  /// Returns the interval in semitones between this note and other
  int semitonesTo(Note other) {
    return (other.midiNumber - midiNumber).abs();
  }

  /// Full note name with octave (e.g. "A4")
  String get fullName => '$name$octave';

  @override
  String toString() => '$name$octave';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          octave == other.octave;

  @override
  int get hashCode => midiNumber.hashCode;

  // Common notes
  static const Note a4 = Note(name: 'A', octave: 4);
  static const Note c4 = Note(name: 'C', octave: 4);
  static const Note e2 = Note(name: 'E', octave: 2); // Low E string
  static const Note a2 = Note(name: 'A', octave: 2); // A string
  static const Note d3 = Note(name: 'D', octave: 3); // D string
  static const Note g3 = Note(name: 'G', octave: 3); // G string
  static const Note b3 = Note(name: 'B', octave: 3); // B string
  static const Note e4 = Note(name: 'E', octave: 4); // High E string
}
