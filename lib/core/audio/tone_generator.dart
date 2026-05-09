import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Generates simple sine-wave WAV files on-device for ear-training and library
/// playback, so the app never needs pre-recorded MP3 samples for these features.
class ToneGenerator {
  static const _sampleRate = 22050;
  static const _amplitude = 0.38;

  // Base frequency: A2 = 110 Hz
  static const _baseFreq = 110.0;

  static const Map<String, List<int>> intervalSemitones = {
    'kleine Sekunde': [0, 1],
    'große Sekunde': [0, 2],
    'kleine Terz': [0, 3],
    'große Terz': [0, 4],
    'Quarte': [0, 5],
    'Tritonus': [0, 6],
    'Quinte': [0, 7],
    'kleine Sexte': [0, 8],
    'große Sexte': [0, 9],
    'kleine Septime': [0, 10],
    'große Septime': [0, 11],
    'Oktave': [0, 12],
  };

  static const Map<String, List<int>> chordSemitones = {
    'Dur': [0, 4, 7],
    'Moll': [0, 3, 7],
    'Dominant 7': [0, 4, 7, 10],
    'Vermindert': [0, 3, 6],
    'Übermäßig': [0, 4, 8],
    'Sus4': [0, 5, 7],
  };

  static const Map<String, List<int>> scaleSemitones = {
    'Dur': [0, 2, 4, 5, 7, 9, 11, 12],
    'Moll': [0, 2, 3, 5, 7, 8, 10, 12],
    'Pentatonik Moll': [0, 3, 5, 7, 10, 12],
    'Blues': [0, 3, 5, 6, 7, 10, 12],
    'Dorisch': [0, 2, 3, 5, 7, 9, 10, 12],
    'Mixolydisch': [0, 2, 4, 5, 7, 9, 10, 12],
  };

  static double _semitoneFreq(int semitones) =>
      _baseFreq * pow(2.0, semitones / 12.0);

  /// Play notes one after another (intervals, scales).
  static Future<String> generateSequence(
    List<int> semitones, {
    double noteDuration = 0.45,
    double gapDuration = 0.06,
  }) async {
    final noteSamples = (_sampleRate * noteDuration).round();
    final gapSamples = (_sampleRate * gapDuration).round();
    final totalSamples =
        semitones.length * noteSamples + (semitones.length - 1) * gapSamples;

    final data = Int16List(totalSamples);
    int offset = 0;

    for (int n = 0; n < semitones.length; n++) {
      final freq = _semitoneFreq(semitones[n]);
      for (int i = 0; i < noteSamples; i++) {
        final env = _env(i, noteSamples);
        final sample = _guitarSample(freq, i) / _guitarNorm;
        final val = (_amplitude * env * sample * 32767).round();
        data[offset++] = val.clamp(-32768, 32767);
      }
      if (n < semitones.length - 1) {
        offset += gapSamples; // silence gap already zero-initialised
      }
    }

    return _saveWav(data);
  }

  /// Play all notes simultaneously (chords).
  static Future<String> generateChord(
    List<int> semitones, {
    double duration = 1.2,
  }) async {
    final numSamples = (_sampleRate * duration).round();
    final data = Int16List(numSamples);
    final n = semitones.length.toDouble();

    for (int i = 0; i < numSamples; i++) {
      final env = _env(i, numSamples);
      double sum = 0;
      for (final s in semitones) {
        final freq = _semitoneFreq(s);
        // Gitarren-Obertöne pro Saite des Akkords
        sum += _guitarSample(freq, i) / _guitarNorm;
      }
      final val = (_amplitude * env * sum / n * 32767).round();
      data[i] = val.clamp(-32768, 32767);
    }

    return _saveWav(data);
  }

  /// Generate chord tones for a given ChordType name.
  static List<int> semitonesByChordTypeName(String typeName) {
    const map = {
      'major': [0, 4, 7],
      'minor': [0, 3, 7],
      'dominant7': [0, 4, 7, 10],
      'major7': [0, 4, 7, 11],
      'minor7': [0, 3, 7, 10],
      'sus2': [0, 2, 7],
      'sus4': [0, 5, 7],
      'diminished': [0, 3, 6],
      'augmented': [0, 4, 8],
      'power': [0, 7],
    };
    return map[typeName] ?? [0, 4, 7];
  }

  /// Gitarren-ähnliche additive Synthese: Grundton + Obertöne in typischen Amplitudenverhältnissen.
  /// Klingt wesentlich natürlicher als ein reiner Sinus.
  static double _guitarSample(double freq, int sampleIndex) {
    final t = sampleIndex / _sampleRate;
    // Obertöne mit typischen Gitarren-Amplitudenverhältnissen (Saiteninstrument)
    return 1.00 * sin(2 * pi * freq * 1 * t) +
           0.50 * sin(2 * pi * freq * 2 * t) +
           0.25 * sin(2 * pi * freq * 3 * t) +
           0.12 * sin(2 * pi * freq * 4 * t) +
           0.06 * sin(2 * pi * freq * 5 * t) +
           0.03 * sin(2 * pi * freq * 6 * t);
  }

  /// Normalisierungsfaktor für die Obertöne (Summe der Amplituden)
  static const _guitarNorm = 1.00 + 0.50 + 0.25 + 0.12 + 0.06 + 0.03;

  static double _env(int i, int total) {
    final t = i / total;
    // Gitarren-typisches ADSR: schneller Attack, langsamer Decay/Release
    if (t < 0.01) return t / 0.01; // Attack 10ms
    if (t < 0.15) return 1.0 - (t - 0.01) * 0.3 / 0.14; // leichter Decay
    if (t > 0.85) return (1.0 - t) / 0.15 * 0.7; // Release
    return 0.7; // Sustain
  }

  static Future<String> _saveWav(Int16List data) async {
    final dataBytes = data.length * 2;
    final buf = Uint8List(44 + dataBytes);
    final bd = ByteData.view(buf.buffer);

    buf.setAll(0, 'RIFF'.codeUnits);
    bd.setUint32(4, 36 + dataBytes, Endian.little);
    buf.setAll(8, 'WAVE'.codeUnits);
    buf.setAll(12, 'fmt '.codeUnits);
    bd.setUint32(16, 16, Endian.little);
    bd.setUint16(20, 1, Endian.little);
    bd.setUint16(22, 1, Endian.little);
    bd.setUint32(24, _sampleRate, Endian.little);
    bd.setUint32(28, _sampleRate * 2, Endian.little);
    bd.setUint16(32, 2, Endian.little);
    bd.setUint16(34, 16, Endian.little);
    buf.setAll(36, 'data'.codeUnits);
    bd.setUint32(40, dataBytes, Endian.little);

    for (int i = 0; i < data.length; i++) {
      bd.setInt16(44 + i * 2, data[i], Endian.little);
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/tone_${DateTime.now().microsecondsSinceEpoch}.wav';
    await File(path).writeAsBytes(buf);
    return path;
  }
}
