import 'note.dart';

enum ChordType {
  major,
  minor,
  dominant7,
  major7,
  minor7,
  sus2,
  sus4,
  diminished,
  augmented,
  power,
}

extension ChordTypeExtension on ChordType {
  String get displayName {
    switch (this) {
      case ChordType.major:
        return '';
      case ChordType.minor:
        return 'm';
      case ChordType.dominant7:
        return '7';
      case ChordType.major7:
        return 'maj7';
      case ChordType.minor7:
        return 'm7';
      case ChordType.sus2:
        return 'sus2';
      case ChordType.sus4:
        return 'sus4';
      case ChordType.diminished:
        return 'dim';
      case ChordType.augmented:
        return 'aug';
      case ChordType.power:
        return '5';
    }
  }

  List<int> get intervals {
    switch (this) {
      case ChordType.major:
        return [0, 4, 7];
      case ChordType.minor:
        return [0, 3, 7];
      case ChordType.dominant7:
        return [0, 4, 7, 10];
      case ChordType.major7:
        return [0, 4, 7, 11];
      case ChordType.minor7:
        return [0, 3, 7, 10];
      case ChordType.sus2:
        return [0, 2, 7];
      case ChordType.sus4:
        return [0, 5, 7];
      case ChordType.diminished:
        return [0, 3, 6];
      case ChordType.augmented:
        return [0, 4, 8];
      case ChordType.power:
        return [0, 7];
    }
  }
}

class Chord {
  final String name;
  final Note root;
  final ChordType type;

  /// Voicing: fret positions per string (0=low E, 5=high E)
  /// -1 = muted string, 0 = open string, >0 = fret number
  final List<int> voicing;

  const Chord({
    required this.name,
    required this.root,
    required this.type,
    required this.voicing,
  });

  /// Returns the full chord symbol (e.g. "Am", "G", "Cmaj7")
  String get symbol => '${root.name}${type.displayName}';

  /// Returns all notes in this chord based on type intervals
  List<Note> get notes {
    return type.intervals.map((semitones) => root.transpose(semitones)).toList();
  }

  /// Returns the fingering description
  String get voicingString => voicing
      .map((f) => f == -1 ? 'x' : f.toString())
      .join('-');

  /// Returns the lowest fret used (ignoring open strings and muted)
  int get lowestFret {
    final frets = voicing.where((f) => f > 0);
    if (frets.isEmpty) return 0;
    return frets.reduce((a, b) => a < b ? a : b);
  }

  /// Returns the highest fret used
  int get highestFret {
    final frets = voicing.where((f) => f > 0);
    if (frets.isEmpty) return 0;
    return frets.reduce((a, b) => a > b ? a : b);
  }

  /// Returns the fret span (difficulty indicator)
  int get fretSpan => highestFret - lowestFret;

  /// Standard open chords for beginners
  static List<Chord> get openChords => [
        // Em - Most beginner-friendly
        Chord(
          name: 'Em',
          root: const Note(name: 'E', octave: 2),
          type: ChordType.minor,
          voicing: [0, 2, 2, 0, 0, 0],
        ),
        // Am
        Chord(
          name: 'Am',
          root: const Note(name: 'A', octave: 2),
          type: ChordType.minor,
          voicing: [-1, 0, 2, 2, 1, 0],
        ),
        // E Major
        Chord(
          name: 'E',
          root: const Note(name: 'E', octave: 2),
          type: ChordType.major,
          voicing: [0, 2, 2, 1, 0, 0],
        ),
        // D Major
        Chord(
          name: 'D',
          root: const Note(name: 'D', octave: 3),
          type: ChordType.major,
          voicing: [-1, -1, 0, 2, 3, 2],
        ),
        // G Major
        Chord(
          name: 'G',
          root: const Note(name: 'G', octave: 2),
          type: ChordType.major,
          voicing: [3, 2, 0, 0, 0, 3],
        ),
        // C Major
        Chord(
          name: 'C',
          root: const Note(name: 'C', octave: 3),
          type: ChordType.major,
          voicing: [-1, 3, 2, 0, 1, 0],
        ),
        // A Major
        Chord(
          name: 'A',
          root: const Note(name: 'A', octave: 2),
          type: ChordType.major,
          voicing: [-1, 0, 2, 2, 2, 0],
        ),
        // Dm
        Chord(
          name: 'Dm',
          root: const Note(name: 'D', octave: 3),
          type: ChordType.minor,
          voicing: [-1, -1, 0, 2, 3, 1],
        ),
        // F Major (barre)
        Chord(
          name: 'F',
          root: const Note(name: 'F', octave: 3),
          type: ChordType.major,
          voicing: [1, 3, 3, 2, 1, 1],
        ),
        // Em7
        Chord(
          name: 'Em7',
          root: const Note(name: 'E', octave: 2),
          type: ChordType.minor7,
          voicing: [0, 2, 0, 0, 0, 0],
        ),
        // A7
        Chord(
          name: 'A7',
          root: const Note(name: 'A', octave: 2),
          type: ChordType.dominant7,
          voicing: [-1, 0, 2, 0, 2, 0],
        ),
        // D7
        Chord(
          name: 'D7',
          root: const Note(name: 'D', octave: 3),
          type: ChordType.dominant7,
          voicing: [-1, -1, 0, 2, 1, 2],
        ),
        // G7
        Chord(
          name: 'G7',
          root: const Note(name: 'G', octave: 2),
          type: ChordType.dominant7,
          voicing: [3, 2, 0, 0, 0, 1],
        ),
        // Cadd9
        Chord(
          name: 'Cadd9',
          root: const Note(name: 'C', octave: 3),
          type: ChordType.sus2,
          voicing: [-1, 3, 2, 0, 3, 0],
        ),
      ];

  /// Creates a power chord from a root note
  static Chord powerChord(Note root, {bool withOctave = false}) {
    // Find the string and fret for the root note
    // Standard power chord voicing: root on 6th string
    final fret = _fretForNote(root);
    if (withOctave) {
      return Chord(
        name: '${root.name}5',
        root: root,
        type: ChordType.power,
        voicing: [-1 , -1, fret, fret + 2, fret + 4, -1],
      );
    }
    return Chord(
      name: '${root.name}5',
      root: root,
      type: ChordType.power,
      voicing: [fret, fret + 2, fret + 2, -1, -1, -1],
    );
  }

  static int _fretForNote(Note root) {
    // Map root note to low E string fret
    const openE = 40; // E2 MIDI
    return (root.midiNumber - openE).clamp(0, 22);
  }

  /// Common power chords
  static List<Chord> get powerChords => [
        const Chord(
          name: 'E5',
          root: Note(name: 'E', octave: 2),
          type: ChordType.power,
          voicing: [0, 2, 2, -1, -1, -1],
        ),
        const Chord(
          name: 'A5',
          root: Note(name: 'A', octave: 2),
          type: ChordType.power,
          voicing: [-1, 0, 2, 2, -1, -1],
        ),
        const Chord(
          name: 'D5',
          root: Note(name: 'D', octave: 3),
          type: ChordType.power,
          voicing: [-1, -1, 0, 2, 3, -1],
        ),
        const Chord(
          name: 'G5',
          root: Note(name: 'G', octave: 2),
          type: ChordType.power,
          voicing: [3, 5, 5, -1, -1, -1],
        ),
        const Chord(
          name: 'B5',
          root: Note(name: 'B', octave: 2),
          type: ChordType.power,
          voicing: [-1, 2, 4, 4, -1, -1],
        ),
        const Chord(
          name: 'C5',
          root: Note(name: 'C', octave: 3),
          type: ChordType.power,
          voicing: [-1, 3, 5, 5, -1, -1],
        ),
      ];

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chord &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;

  @override
  int get hashCode => Object.hash(name, type);
}
