import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';

import 'tone_generator.dart';

/// Spielt Referenz-Töne und Akkorde ab.
///
/// Strategie:
///   1. Versuche zuerst die echte WAV-Datei aus assets/audio/notes oder
///      assets/audio/chords zu laden (per `tool/generate_audio_assets.dart`
///      vorbereitet).
///   2. Falls die Datei fehlt: programmatische Sinus-Synthese via
///      [ToneGenerator] als Fallback.
class ReferenceAudioService {
  final AudioPlayer _player = AudioPlayer();

  // Halbtöne relativ zu A2 (110 Hz).
  static const Map<String, int> _noteSemitones = {
    'E2': -7, 'F2': -6, 'F#2': -5, 'G2': -4, 'G#2': -3,
    'A2': 0, 'A#2': 1, 'B2': 2,
    'C3': 3, 'C#3': 4, 'D3': 5, 'D#3': 6, 'E3': 7,
    'F3': 8, 'F#3': 9, 'G3': 10, 'G#3': 11,
    'A3': 12, 'A#3': 13, 'B3': 14,
    'C4': 15, 'C#4': 16, 'D4': 17, 'D#4': 18, 'E4': 19,
    'F4': 20, 'F#4': 21, 'G4': 22, 'G#4': 23,
    'A4': 24, 'B4': 26,
  };

  static const Map<String, List<int>> _chordSemitones = {
    'C': [3, 10, 15, 19, 22],
    'D': [5, 12, 17, 21],
    'E': [-7, 2, 7, 11, 14, 19],
    'Em': [-7, 2, 7, 10, 14, 19],
    'G': [-2, 2, 10, 14, 19, 22],
    'A': [0, 4, 7, 12, 16],
    'Am': [0, 3, 7, 12, 15],
    'F': [-4, 3, 8, 12, 15, 20],
    'Dm': [5, 12, 17, 20],
    'E7': [-7, 2, 5, 11, 14, 19],
    'A7': [0, 4, 10, 12, 16],
    'D7': [5, 12, 15, 21],
  };

  /// Wandelt 'C#3' in den Asset-Pfad-Suffix 'Csharp3' um (Filesystem-sicher).
  String _safeAssetName(String note) => note.replaceAll('#', 'sharp');

  Future<bool> _tryPlayAsset(String assetPath) async {
    try {
      // Existiert das Asset wirklich? rootBundle.load wirft sonst.
      await rootBundle.load(assetPath);
      await _player.setAsset(assetPath);
      await _player.play();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> playNote(String noteName) async {
    // 1) Versuche Asset
    final assetPath = 'assets/audio/notes/${_safeAssetName(noteName)}.wav';
    if (await _tryPlayAsset(assetPath)) return;

    // 2) Fallback: synthetische Sinuswelle
    final semitone = _noteSemitones[noteName];
    if (semitone == null) {
      debugPrint('ReferenceAudioService: unbekannte Note $noteName');
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
    // 1) Versuche Asset
    final assetPath = 'assets/audio/chords/$chordName.wav';
    if (await _tryPlayAsset(assetPath)) return;

    // 2) Fallback: synthetische Akkord-Synthese
    final semitones = _chordSemitones[chordName];
    if (semitones == null) {
      debugPrint('ReferenceAudioService: unbekannter Akkord $chordName');
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
