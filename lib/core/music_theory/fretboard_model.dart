import '../utils/constants.dart';
import 'note.dart';
import 'chord.dart';
import 'scale.dart';

class FretboardModel {
  FretboardModel._();

  /// Returns the Note at a given string and fret position
  /// string: 0 = low E (E2), 5 = high E (E4)
  /// fret: 0 = open string, 1-22 = fretted notes
  static Note noteAt(int string, int fret) {
    assert(string >= 0 && string < AppConstants.stringCount,
        'String must be 0-5');
    assert(fret >= 0 && fret <= AppConstants.fretCount,
        'Fret must be 0-${AppConstants.fretCount}');

    final openMidi = AppConstants.standardTuningMidi[string];
    return Note.fromMidi(openMidi + fret);
  }

  /// Returns the frequency at a given string and fret position
  static double frequencyAt(int string, int fret) {
    return noteAt(string, fret).frequency;
  }

  /// Returns all fret positions for a chord voicing
  List<FretPosition> notesForChord(Chord chord) {
    final positions = <FretPosition>[];

    for (int string = 0; string < chord.voicing.length; string++) {
      final fret = chord.voicing[string];
      if (fret >= 0) {
        // Not muted
        final note = noteAt(string, fret);
        positions.add(FretPosition(
          string: string,
          fret: fret,
          note: note,
          isRoot: note.chromaticIndex == chord.root.chromaticIndex,
        ));
      }
    }

    return positions;
  }

  /// Returns all fret positions for a scale within a fret range
  List<FretPosition> notesForScale(Scale scale, int startFret, int endFret) {
    return scale.fretboardPositions(startFret, endFret);
  }

  /// Returns all positions that match a given note name (ignoring octave)
  static List<FretPosition> positionsForNoteName(String noteName,
      {int maxFret = 12}) {
    final positions = <FretPosition>[];
    final targetIndex =
        AppConstants.noteNames.indexOf(noteName.replaceAll('b', '').trim());
    if (targetIndex < 0) return positions;

    for (int string = 0; string < AppConstants.stringCount; string++) {
      for (int fret = 0; fret <= maxFret; fret++) {
        final note = noteAt(string, fret);
        if (note.chromaticIndex == targetIndex) {
          positions.add(FretPosition(
            string: string,
            fret: fret,
            note: note,
            isRoot: false,
          ));
        }
      }
    }

    return positions;
  }

  /// Returns the lowest position (closest to nut) for a given note
  static FretPosition? lowestPositionForNote(Note note) {
    final positions =
        positionsForNoteName(note.name, maxFret: AppConstants.fretCount);
    if (positions.isEmpty) return null;

    positions.sort((a, b) {
      final fretDiff = a.fret.compareTo(b.fret);
      if (fretDiff != 0) return fretDiff;
      return a.string.compareTo(b.string);
    });

    return positions.first;
  }

  /// Returns all open string notes (fret = 0)
  static List<Note> get openStringNotes {
    return List.generate(
      AppConstants.stringCount,
      (string) => noteAt(string, 0),
    );
  }

  /// Returns the standard tuning string names
  static List<String> get stringNames => AppConstants.stringNames;

  /// Returns string frequency ranges for auto-detection
  static Map<int, (double, double)> get stringFrequencyRanges {
    return {
      0: (70.0, 100.0),  // Low E: ~82 Hz
      1: (95.0, 135.0),  // A: ~110 Hz
      2: (128.0, 175.0), // D: ~147 Hz
      3: (175.0, 230.0), // G: ~196 Hz
      4: (220.0, 280.0), // B: ~247 Hz
      5: (290.0, 380.0), // High E: ~330 Hz
    };
  }

  /// Detects which string is most likely being played based on frequency
  static int? detectString(double frequency) {
    final ranges = stringFrequencyRanges;
    for (final entry in ranges.entries) {
      final (min, max) = entry.value;
      if (frequency >= min && frequency <= max) {
        return entry.key;
      }
    }
    return null;
  }

  /// Returns all notes on a specific string as a list indexed by fret
  static List<Note> notesOnString(int string, {int maxFret = 22}) {
    return List.generate(
      maxFret + 1,
      (fret) => noteAt(string, fret),
    );
  }

  /// Returns fret positions for all notes in a specific octave range
  static List<FretPosition> positionsInOctaveRange(int minOctave, int maxOctave) {
    final positions = <FretPosition>[];

    for (int string = 0; string < AppConstants.stringCount; string++) {
      for (int fret = 0; fret <= AppConstants.fretCount; fret++) {
        final note = noteAt(string, fret);
        if (note.octave >= minOctave && note.octave <= maxOctave) {
          positions.add(FretPosition(
            string: string,
            fret: fret,
            note: note,
            isRoot: false,
          ));
        }
      }
    }

    return positions;
  }
}
