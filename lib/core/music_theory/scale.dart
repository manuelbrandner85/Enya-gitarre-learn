import 'note.dart';
import '../utils/constants.dart';

enum ScaleType {
  major,
  naturalMinor,
  minorPentatonic,
  majorPentatonic,
  blues,
  dorian,
  mixolydian,
  harmonicMinor,
  melodicMinor,
  chromatic,
}

extension ScaleTypeExtension on ScaleType {
  String get displayName {
    switch (this) {
      case ScaleType.major:
        return 'Dur';
      case ScaleType.naturalMinor:
        return 'Natürliches Moll';
      case ScaleType.minorPentatonic:
        return 'Moll-Pentatonik';
      case ScaleType.majorPentatonic:
        return 'Dur-Pentatonik';
      case ScaleType.blues:
        return 'Blues';
      case ScaleType.dorian:
        return 'Dorisch';
      case ScaleType.mixolydian:
        return 'Mixolydisch';
      case ScaleType.harmonicMinor:
        return 'Harmonisches Moll';
      case ScaleType.melodicMinor:
        return 'Melodisches Moll';
      case ScaleType.chromatic:
        return 'Chromatisch';
    }
  }

  List<int> get intervals {
    switch (this) {
      case ScaleType.major:
        return [0, 2, 4, 5, 7, 9, 11];
      case ScaleType.naturalMinor:
        return [0, 2, 3, 5, 7, 8, 10];
      case ScaleType.minorPentatonic:
        return [0, 3, 5, 7, 10];
      case ScaleType.majorPentatonic:
        return [0, 2, 4, 7, 9];
      case ScaleType.blues:
        return [0, 3, 5, 6, 7, 10];
      case ScaleType.dorian:
        return [0, 2, 3, 5, 7, 9, 10];
      case ScaleType.mixolydian:
        return [0, 2, 4, 5, 7, 9, 10];
      case ScaleType.harmonicMinor:
        return [0, 2, 3, 5, 7, 8, 11];
      case ScaleType.melodicMinor:
        return [0, 2, 3, 5, 7, 9, 11];
      case ScaleType.chromatic:
        return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    }
  }
}

class FretPosition {
  final int string; // 0 = low E, 5 = high E
  final int fret;
  final Note note;
  final bool isRoot;

  const FretPosition({
    required this.string,
    required this.fret,
    required this.note,
    required this.isRoot,
  });

  @override
  String toString() => 'String$string Fret$fret (${note.fullName})';
}

class Scale {
  final String name;
  final Note root;
  final ScaleType type;

  const Scale({
    required this.name,
    required this.root,
    required this.type,
  });

  /// Returns the intervals for this scale type
  List<int> get intervals => type.intervals;

  /// Returns all notes in this scale
  List<Note> get notes {
    return intervals.map((semitones) => root.transpose(semitones)).toList();
  }

  /// Returns the scale degree names for major scale
  List<String> get degreeNames {
    const majorDegrees = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII'];
    if (intervals.length <= majorDegrees.length) {
      return majorDegrees.sublist(0, intervals.length);
    }
    return List.generate(intervals.length, (i) => '${i + 1}');
  }

  /// Returns all fretboard positions for this scale within a fret range
  List<FretPosition> fretboardPositions(int startFret, int endFret) {
    final positions = <FretPosition>[];
    final scaleNotes = notes.map((n) => n.chromaticIndex).toSet();
    final rootIndex = root.chromaticIndex;

    for (int string = 0; string < AppConstants.stringCount; string++) {
      final openMidi = AppConstants.standardTuningMidi[string];

      for (int fret = startFret; fret <= endFret; fret++) {
        final midi = openMidi + fret;
        final noteIndex = midi % 12;

        if (scaleNotes.contains(noteIndex)) {
          final note = Note.fromMidi(midi);
          positions.add(FretPosition(
            string: string,
            fret: fret,
            note: note,
            isRoot: noteIndex == rootIndex,
          ));
        }
      }
    }

    return positions;
  }

  /// Returns scale positions as list of [string, fret] pairs
  List<List<int>> fretPositionPairs(int startFret, int endFret) {
    return fretboardPositions(startFret, endFret)
        .map((p) => [p.string, p.fret])
        .toList();
  }

  /// Common predefined scales
  static Scale aMinorPentatonic = Scale(
    name: 'Am Pentatonik',
    root: const Note(name: 'A', octave: 2),
    type: ScaleType.minorPentatonic,
  );

  static Scale eMajorPentatonic = Scale(
    name: 'E Dur Pentatonik',
    root: const Note(name: 'E', octave: 2),
    type: ScaleType.majorPentatonic,
  );

  static Scale eBlues = Scale(
    name: 'E Blues',
    root: const Note(name: 'E', octave: 2),
    type: ScaleType.blues,
  );

  static Scale gMajor = Scale(
    name: 'G Dur',
    root: const Note(name: 'G', octave: 2),
    type: ScaleType.major,
  );

  static Scale aMinor = Scale(
    name: 'A Moll',
    root: const Note(name: 'A', octave: 2),
    type: ScaleType.naturalMinor,
  );

  static Scale dDorian = Scale(
    name: 'D Dorisch',
    root: const Note(name: 'D', octave: 3),
    type: ScaleType.dorian,
  );

  @override
  String toString() => name;
}
