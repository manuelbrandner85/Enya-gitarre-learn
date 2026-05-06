import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class ReferenceAudioService {
  final AudioPlayer _player = AudioPlayer();

  // Auf XMARI aufgenommene Samples
  static const Map<String, String> _noteSamples = {
    'E2': 'assets/audio/notes/e2_clean.mp3',
    'A2': 'assets/audio/notes/a2_clean.mp3',
    'D3': 'assets/audio/notes/d3_clean.mp3',
    'G3': 'assets/audio/notes/g3_clean.mp3',
    'B3': 'assets/audio/notes/b3_clean.mp3',
    'E4': 'assets/audio/notes/e4_clean.mp3',
  };

  static const Map<String, String> _chordSamples = {
    'Em': 'assets/audio/chords/em_clean.mp3',
    'Am': 'assets/audio/chords/am_clean.mp3',
    'D': 'assets/audio/chords/d_clean.mp3',
    'G': 'assets/audio/chords/g_clean.mp3',
    'C': 'assets/audio/chords/c_clean.mp3',
    'E': 'assets/audio/chords/e_clean.mp3',
    'A': 'assets/audio/chords/a_clean.mp3',
  };

  Future<void> playNote(String noteName) async {
    final path = _noteSamples[noteName];
    if (path == null) return;
    try {
      await _player.setAsset(path);
      await _player.play();
    } catch (e) {
      debugPrint('ReferenceAudioService.playNote error: $e');
    }
  }

  Future<void> playChord(String chordName) async {
    final path = _chordSamples[chordName];
    if (path == null) return;
    try {
      await _player.setAsset(path);
      await _player.play();
    } catch (e) {
      debugPrint('ReferenceAudioService.playChord error: $e');
    }
  }

  Future<void> stop() async => _player.stop();

  void dispose() => _player.dispose();
}
