/// Utility class for transposing guitar chord names.
///
/// Handles all common chord types: major, minor, 7, maj7, m7, sus2, sus4,
/// dim, aug, 5 (power), add9, etc. Supports slash chords (e.g. "G/B").
/// Prefers sharp notation except for the standard flat keys: Bb, Eb, Ab, Db, Gb.
class ChordTransposer {
  ChordTransposer._();

  /// Chromatic scale in sharps (used for output when sharp is preferred).
  static const List<String> _sharps = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B',
  ];

  /// Chromatic scale in flats (used for output when flat is preferred).
  static const List<String> _flats = [
    'C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B',
  ];

  /// Notes that are conventionally written with flats.
  static const Set<String> _preferFlat = {'Bb', 'Eb', 'Ab', 'Db', 'Gb'};

  /// All enharmonic spellings → semitone index (0 = C).
  static const Map<String, int> _noteToSemitone = {
    'C': 0,
    'C#': 1, 'Db': 1,
    'D': 2,
    'D#': 3, 'Eb': 3,
    'E': 4, 'Fb': 4,
    'F': 5, 'E#': 5,
    'F#': 6, 'Gb': 6,
    'G': 7,
    'G#': 8, 'Ab': 8,
    'A': 9,
    'A#': 10, 'Bb': 10,
    'B': 11, 'Cb': 11,
  };

  /// Transpose a chord name by [semitones] (can be negative).
  ///
  /// Examples:
  ///   transpose('Am7', 2) → 'Bm7'
  ///   transpose('G/B', -1) → 'F#/A#'
  ///   transpose('Bb', 1) → 'B'
  static String transpose(String chord, int semitones) {
    if (semitones == 0) return chord;
    // Normalise to mod 12.
    final shift = ((semitones % 12) + 12) % 12;

    // Handle slash chords: "G/B"
    final slashIndex = chord.indexOf('/');
    if (slashIndex != -1) {
      final root = chord.substring(0, slashIndex);
      final bass = chord.substring(slashIndex + 1);
      return '${_transposeRoot(root, shift)}/${_transposeRoot(bass, shift)}';
    }

    return _transposeRoot(chord, shift);
  }

  /// What a guitarist's fingers play when a capo is placed on [capo].
  ///
  /// The chord shape is transposed DOWN by capo frets from the sounding chord,
  /// so the guitarist plays a simpler open shape.
  ///   applyCapo('A', 2) → 'G'  (play G shape, capo 2 sounds like A)
  static String applyCapo(String chord, int capo) {
    return transpose(chord, -capo);
  }

  /// The actual sounding pitch when a capo is on fret [capo] and the
  /// guitarist plays [chord].
  ///
  /// Use this when you know the fingered chord and want the sounding key.
  ///   soundingKey('G', 2) → 'A'
  static String soundingKey(String chord, int capo) {
    return transpose(chord, capo);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Internal helpers
  // ──────────────────────────────────────────────────────────────────────────

  /// Transpose a single root+suffix token (e.g. 'Am7', 'Cmaj7', 'F#5').
  static String _transposeRoot(String chord, int shift) {
    if (chord.isEmpty) return chord;

    // Parse the note name (1 or 2 characters: letter + optional # or b).
    final note = _parseNote(chord);
    if (note == null) return chord; // unrecognised, return as-is

    final suffix = chord.substring(note.length); // everything after the note
    final semitone = _noteToSemitone[note];
    if (semitone == null) return chord;

    final newSemitone = (semitone + shift) % 12;
    final newNote = _semitoneToNote(newSemitone);
    return '$newNote$suffix';
  }

  /// Extracts the leading note name from a chord string.
  /// Returns the note string (e.g. 'C', 'F#', 'Bb') or null if not recognised.
  static String? _parseNote(String chord) {
    if (chord.isEmpty) return null;
    final letter = chord[0];
    if (!RegExp(r'[A-G]').hasMatch(letter)) return null;

    if (chord.length > 1) {
      final second = chord[1];
      if (second == '#' || second == 'b') {
        final candidate = chord.substring(0, 2);
        if (_noteToSemitone.containsKey(candidate)) return candidate;
      }
    }
    return letter;
  }

  /// Returns the conventional spelling of a semitone value.
  /// Prefers sharp notation except for the 5 standard flat roots.
  static String _semitoneToNote(int semitone) {
    final sharp = _sharps[semitone];
    final flat = _flats[semitone];
    // If both are the same (natural note), just return it.
    if (sharp == flat) return sharp;
    // Use flat spelling for the 5 standard flat keys.
    return _preferFlat.contains(flat) ? flat : sharp;
  }
}
