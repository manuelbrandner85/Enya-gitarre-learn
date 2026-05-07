import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'tone_generator.dart';

class ReferenceAudioService {
  final AudioPlayer _player = AudioPlayer();

  // Semitones from A2 (110 Hz) for each open-string note.
  static const Map<String, int> _noteSemitones = {
    'E2': -7,
    'F2': -6,
    'F#2': -5,
    'G2': -4,
    'G#2': -3,
    'A2': 0,
    'A#2': 1,
    'B2': 2,
    'C3': 3,
    'C#3': 4,
    'D3': 5,
    'D#3': 6,
    'E3': 7,
    'F3': 8,
    'F#3': 9,
    'G3': 10,
    'G#3': 11,
    'A3': 12,
    'A#3': 13,
    'B3': 14,
    'C4': 15,
    'C#4': 16,
    'D4': 17,
    'D#4': 18,
    'E4': 19,
    'F4': 20,
    'F#4': 21,
    'G4': 22,
    'G#4': 23,
    'A4': 24,
    'B4': 26,
  };

  // Chord semitone sets relative to A2.
  static const Map<String, List<int>> _chordSemitones = {
    'C': [3, 10, 15, 19, 22],   // C E G
    'D': [5, 12, 17, 21],       // D F# A
    'E': [-7, 2, 7, 11, 14, 19], // E B E G# B E
    'Em': [-7, 2, 7, 10, 14, 19],
    'G': [-2, 2, 10, 14, 19, 22],
    'A': [0, 4, 7, 12, 16],
    'Am': [0, 3, 7, 12, 15],
  };

  Future<void> playNote(String noteName) async {
    final semitone = _noteSemitones[noteName];
    if (semitone == null) {
      debugPrint('ReferenceAudioService: unknown note $noteName');
      return;
    }
    try {
      final path = await ToneGenerator.generateSequence(
        [semitone],
        noteDuration: 1.0,
        gapDuration: 0.0,
      );
      await _player.setFilePath(path);
      await _player.play();
    } catch (e) {
      debugPrint('ReferenceAudioService.playNote error: $e');
    }
  }

  Future<void> playChord(String chordName) async {
    final semitones = _chordSemitones[chordName];
    if (semitones == null) {
      debugPrint('ReferenceAudioService: unknown chord $chordName');
      return;
    }
    try {
      final path = await ToneGenerator.generateChord(semitones, duration: 1.5);
      await _player.setFilePath(path);
      await _player.play();
    } catch (e) {
      debugPrint('ReferenceAudioService.playChord error: $e');
    }
  }

  Future<void> stop() async => _player.stop();

  void dispose() => _player.dispose();
}
