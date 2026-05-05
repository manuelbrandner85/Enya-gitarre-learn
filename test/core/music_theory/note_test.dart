import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/music_theory/note.dart';

void main() {
  group('Note.fromFrequency', () {
    test('440.0 Hz → A4', () {
      final note = Note.fromFrequency(440.0);
      expect(note.name, equals('A'));
      expect(note.octave, equals(4));
    });

    test('82.41 Hz → E2 (low E string)', () {
      final note = Note.fromFrequency(82.41);
      expect(note.name, equals('E'));
      expect(note.octave, equals(2));
    });

    test('110.0 Hz → A2 (A string)', () {
      final note = Note.fromFrequency(110.0);
      expect(note.name, equals('A'));
      expect(note.octave, equals(2));
    });

    test('329.63 Hz → E4 (high E string)', () {
      final note = Note.fromFrequency(329.63);
      expect(note.name, equals('E'));
      expect(note.octave, equals(4));
    });

    test('261.63 Hz → C4 (middle C)', () {
      final note = Note.fromFrequency(261.63);
      expect(note.name, equals('C'));
      expect(note.octave, equals(4));
    });

    test('non-positive frequency → defaults to C4', () {
      final note = Note.fromFrequency(0.0);
      expect(note.name, equals('C'));
      expect(note.octave, equals(4));
    });
  });

  group('Note.fromMidi', () {
    test('MIDI 69 → A4', () {
      final note = Note.fromMidi(69);
      expect(note.name, equals('A'));
      expect(note.octave, equals(4));
    });

    test('MIDI 60 → C4', () {
      final note = Note.fromMidi(60);
      expect(note.name, equals('C'));
      expect(note.octave, equals(4));
    });

    test('MIDI 40 → E2', () {
      final note = Note.fromMidi(40);
      expect(note.name, equals('E'));
      expect(note.octave, equals(2));
    });

    test('MIDI 45 → A2', () {
      final note = Note.fromMidi(45);
      expect(note.name, equals('A'));
      expect(note.octave, equals(2));
    });

    test('MIDI 0 is clamped (does not throw)', () {
      expect(() => Note.fromMidi(0), returnsNormally);
    });

    test('MIDI 127 is clamped (does not throw)', () {
      expect(() => Note.fromMidi(127), returnsNormally);
    });
  });

  group('Note.midiNumber', () {
    test('A4 → MIDI 69', () {
      expect(Note.a4.midiNumber, equals(69));
    });

    test('C4 → MIDI 60', () {
      expect(Note.c4.midiNumber, equals(60));
    });

    test('E2 → MIDI 40', () {
      expect(Note.e2.midiNumber, equals(40));
    });

    test('A2 → MIDI 45', () {
      expect(Note.a2.midiNumber, equals(45));
    });
  });

  group('Note.frequency', () {
    test('A4 frequency is 440.0 Hz', () {
      expect(Note.a4.frequency, closeTo(440.0, 0.01));
    });

    test('E2 frequency is ~82.41 Hz', () {
      expect(Note.e2.frequency, closeTo(82.41, 0.1));
    });

    test('A2 frequency is 110.0 Hz', () {
      expect(Note.a2.frequency, closeTo(110.0, 0.1));
    });
  });

  group('Note.centsFromFrequency', () {
    test('exact frequency → 0 cents', () {
      final cents = Note.a4.centsFromFrequency(440.0);
      expect(cents, closeTo(0.0, 0.1));
    });

    test('slightly sharp → positive cents', () {
      // One semitone sharp ≈ 100 cents
      final cents = Note.a4.centsFromFrequency(466.16); // A#4
      expect(cents, closeTo(100.0, 2.0));
    });

    test('zero frequency → returns 0', () {
      expect(Note.a4.centsFromFrequency(0.0), equals(0.0));
    });
  });

  group('Note.transpose', () {
    test('A4 transposed up 12 semitones → A5', () {
      final transposed = Note.a4.transpose(12);
      expect(transposed.name, equals('A'));
      expect(transposed.octave, equals(5));
    });

    test('A4 transposed down 12 semitones → A3', () {
      final transposed = Note.a4.transpose(-12);
      expect(transposed.name, equals('A'));
      expect(transposed.octave, equals(3));
    });

    test('A4 transposed up 2 semitones → B4', () {
      final transposed = Note.a4.transpose(2);
      expect(transposed.name, equals('B'));
      expect(transposed.octave, equals(4));
    });
  });

  group('Note.semitonesTo', () {
    test('A4 to A5 is 12 semitones', () {
      const a5 = Note(name: 'A', octave: 5);
      expect(Note.a4.semitonesTo(a5), equals(12));
    });

    test('E2 to A2 is 5 semitones', () {
      expect(Note.e2.semitonesTo(Note.a2), equals(5));
    });

    test('same note to itself is 0 semitones', () {
      expect(Note.a4.semitonesTo(Note.a4), equals(0));
    });
  });

  group('Note properties', () {
    test('fullName returns name+octave string', () {
      expect(Note.a4.fullName, equals('A4'));
      expect(Note.e2.fullName, equals('E2'));
    });

    test('toString returns name+octave string', () {
      expect(Note.a4.toString(), equals('A4'));
    });

    test('natural note isAccidental is false', () {
      expect(Note.a4.isAccidental, isFalse);
    });

    test('sharp note isAccidental is true', () {
      const cSharp4 = Note(name: 'C#', octave: 4);
      expect(cSharp4.isAccidental, isTrue);
    });

    test('naturalName strips accidentals', () {
      const cSharp4 = Note(name: 'C#', octave: 4);
      expect(cSharp4.naturalName, equals('C'));
    });

    test('chromaticIndex of C is 0', () {
      expect(Note.c4.chromaticIndex, equals(0));
    });

    test('chromaticIndex of A is 9', () {
      expect(Note.a4.chromaticIndex, equals(9));
    });

    test('equality: two notes with same name and octave are equal', () {
      expect(Note.a4, equals(const Note(name: 'A', octave: 4)));
    });

    test('inequality: different octave notes are not equal', () {
      const a5 = Note(name: 'A', octave: 5);
      expect(Note.a4, isNot(equals(a5)));
    });
  });

  group('Note.isEnharmonicWith', () {
    test('C# and C# are enharmonic', () {
      const cSharp = Note(name: 'C#', octave: 4);
      expect(cSharp.isEnharmonicWith(cSharp), isTrue);
    });
  });

  group('Note.enharmonicName', () {
    test('C# enharmonic is Db', () {
      const cSharp = Note(name: 'C#', octave: 4);
      expect(cSharp.enharmonicName, equals('Db'));
    });

    test('Db enharmonic is C#', () {
      const db = Note(name: 'Db', octave: 4);
      expect(db.enharmonicName, equals('C#'));
    });

    test('natural note enharmonic is same name', () {
      expect(Note.a4.enharmonicName, equals('A'));
    });
  });
}
