import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Erzeugt programmatisch einen einfachen 4-Takt-Backing-Track als WAV-Datei
/// auf dem Gerät. Genre-spezifisch: Bass auf Beat 1, Akkord-Strums auf 2-3-4
/// (mit Variationen je nach Genre).
class BackingTrackGenerator {
  static const int sampleRate = 22050;

  /// Genre-Profile.
  static const String genreBlues = 'blues';
  static const String genreRock = 'rock';
  static const String genrePop = 'pop';
  static const String genreFunk = 'funk';

  /// Akkord-Progression für die häufigsten Tonarten (12-Bar-Blues, I-IV-V).
  /// Jeder Eintrag = ein Takt; insgesamt 4 Takte für Loop.
  static const Map<String, List<List<int>>> _progressions = {
    // Werte sind Halbtöne relativ zur Tonika (Root-Note in Hz unten gemappt).
    // 4 Takte je 4 Beats.
    'A': [
      [0, 4, 7], // I (A-Dur)
      [0, 4, 7],
      [5, 9, 0], // IV (D-Dur)
      [7, 11, 2], // V (E-Dur)
    ],
    'C': [
      [0, 4, 7],
      [0, 4, 7],
      [5, 9, 0],
      [7, 11, 2],
    ],
    'D': [
      [0, 4, 7],
      [0, 4, 7],
      [5, 9, 0],
      [7, 11, 2],
    ],
    'E': [
      [0, 4, 7],
      [0, 4, 7],
      [5, 9, 0],
      [7, 11, 2],
    ],
    'G': [
      [0, 4, 7],
      [0, 4, 7],
      [5, 9, 0],
      [7, 11, 2],
    ],
    'Am': [
      [0, 3, 7],
      [0, 3, 7],
      [5, 8, 0], // iv
      [7, 10, 2], // v
    ],
    'Em': [
      [0, 3, 7],
      [0, 3, 7],
      [5, 8, 0],
      [7, 10, 2],
    ],
    'Dm': [
      [0, 3, 7],
      [0, 3, 7],
      [5, 8, 0],
      [7, 10, 2],
    ],
  };

  /// Wurzelnoten in Hz pro Tonart.
  static const Map<String, double> _rootHz = {
    'A': 110.0,
    'C': 130.81,
    'D': 146.83,
    'E': 82.41,
    'G': 98.00,
    'Am': 110.0,
    'Em': 82.41,
    'Dm': 146.83,
  };

  /// Erzeugt eine WAV-Datei mit einem 4-Takt-Loop. Pfad wird zurückgegeben.
  static Future<String> generate({
    required String key,
    required int bpm,
    required String genre,
  }) async {
    final progression = _progressions[key] ?? _progressions['A']!;
    final rootHz = _rootHz[key] ?? 110.0;

    final beatSamples = (sampleRate * 60.0 / bpm).round();
    const beatsPerBar = 4;
    final totalSamples = progression.length * beatsPerBar * beatSamples;

    final out = Float64List(totalSamples);
    final rng = Random(0);

    for (int bar = 0; bar < progression.length; bar++) {
      final chord = progression[bar];
      for (int beat = 0; beat < beatsPerBar; beat++) {
        final beatStart = (bar * beatsPerBar + beat) * beatSamples;
        _renderBeat(
          out: out,
          startSample: beatStart,
          beatLengthSamples: beatSamples,
          rootHz: rootHz,
          chordSemis: chord,
          beatInBar: beat,
          genre: genre,
          rng: rng,
        );
      }
    }

    // Soft-clip + 16-bit
    final pcm = Int16List(totalSamples);
    for (int i = 0; i < totalSamples; i++) {
      final clamped = out[i].clamp(-1.0, 1.0);
      pcm[i] = (clamped * 32700).round();
    }
    return _saveWav(pcm, sampleRate);
  }

  // ── Pro-Beat-Rendering ─────────────────────────────────────────────────────

  static void _renderBeat({
    required Float64List out,
    required int startSample,
    required int beatLengthSamples,
    required double rootHz,
    required List<int> chordSemis,
    required int beatInBar,
    required String genre,
    required Random rng,
  }) {
    switch (genre) {
      case genreBlues:
        _renderBluesBeat(
            out, startSample, beatLengthSamples, rootHz, chordSemis, beatInBar);
        break;
      case genreRock:
        _renderRockBeat(
            out, startSample, beatLengthSamples, rootHz, chordSemis, beatInBar);
        break;
      case genrePop:
        _renderPopBeat(
            out, startSample, beatLengthSamples, rootHz, chordSemis, beatInBar);
        break;
      case genreFunk:
        _renderFunkBeat(
            out, startSample, beatLengthSamples, rootHz, chordSemis, beatInBar, rng);
        break;
    }
  }

  /// Blues-Shuffle: gepunktete 8tel auf Bass und Akkord.
  static void _renderBluesBeat(
    Float64List out,
    int startSample,
    int beatLength,
    double rootHz,
    List<int> chordSemis,
    int beatInBar,
  ) {
    // Shuffle: 2/3 + 1/3 Aufteilung
    final firstNoteLen = (beatLength * 2 / 3).round();
    final secondNoteLen = beatLength - firstNoteLen;

    if (beatInBar == 0) {
      // Bass-Note + Akkord
      _addTone(out, startSample, firstNoteLen, rootHz / 2, 0.45,
          fadeOutFrac: 0.5);
      _addChord(out, startSample, firstNoteLen, rootHz, chordSemis, 0.25,
          fadeOutFrac: 0.5);
    } else {
      _addChord(out, startSample, firstNoteLen, rootHz, chordSemis, 0.30,
          fadeOutFrac: 0.5);
    }
    _addChord(
        out, startSample + firstNoteLen, secondNoteLen, rootHz, chordSemis, 0.20,
        fadeOutFrac: 0.6);
  }

  /// Rock-Straight-Eighths: gerade 8tel mit Bass auf Beat 1.
  static void _renderRockBeat(
    Float64List out,
    int startSample,
    int beatLength,
    double rootHz,
    List<int> chordSemis,
    int beatInBar,
  ) {
    if (beatInBar == 0) {
      _addTone(out, startSample, beatLength ~/ 2, rootHz / 2, 0.55,
          fadeOutFrac: 0.4);
    }
    final eighth = beatLength ~/ 2;
    _addChord(out, startSample, eighth, rootHz, chordSemis, 0.30,
        fadeOutFrac: 0.5);
    _addChord(out, startSample + eighth, eighth, rootHz, chordSemis, 0.25,
        fadeOutFrac: 0.5);
  }

  /// Pop-Arpeggio: Akkordtöne nacheinander.
  static void _renderPopBeat(
    Float64List out,
    int startSample,
    int beatLength,
    double rootHz,
    List<int> chordSemis,
    int beatInBar,
  ) {
    final perNote = beatLength ~/ 4;
    for (int i = 0; i < 4; i++) {
      final semi = chordSemis[i % chordSemis.length];
      final f = rootHz * pow(2.0, semi / 12.0);
      _addTone(out, startSample + i * perNote, perNote, f.toDouble(), 0.30,
          fadeOutFrac: 0.6);
    }
    if (beatInBar == 0) {
      _addTone(out, startSample, beatLength ~/ 4, rootHz / 2, 0.40,
          fadeOutFrac: 0.5);
    }
  }

  /// Funk-Sechzehntel: stakkato Akkord-Hits.
  static void _renderFunkBeat(
    Float64List out,
    int startSample,
    int beatLength,
    double rootHz,
    List<int> chordSemis,
    int beatInBar,
    Random rng,
  ) {
    if (beatInBar == 0 || beatInBar == 2) {
      _addTone(out, startSample, beatLength ~/ 3, rootHz / 2, 0.55,
          fadeOutFrac: 0.3);
    }
    final sixteenth = beatLength ~/ 4;
    for (int i = 0; i < 4; i++) {
      // Funk: nicht jeden 16tel spielen, einige skippen
      if (rng.nextDouble() < 0.2) continue;
      final hitLen = (sixteenth * 0.6).round();
      _addChord(out, startSample + i * sixteenth, hitLen, rootHz, chordSemis,
          0.30,
          fadeOutFrac: 0.7);
    }
  }

  // ── Synthese-Bausteine ─────────────────────────────────────────────────────

  static void _addTone(
    Float64List out,
    int start,
    int length,
    double freq,
    double amp, {
    double fadeOutFrac = 0.5,
  }) {
    if (start + length > out.length) length = out.length - start;
    if (length <= 0) return;
    final fadeOut = (length * fadeOutFrac).round();
    final fadeIn = (length * 0.05).round().clamp(1, length);
    for (int i = 0; i < length; i++) {
      double env = amp;
      if (i < fadeIn) env *= i / fadeIn;
      if (i > length - fadeOut) env *= (length - i) / fadeOut;
      // Sinus + leichte Obertöne für gitarrigen Klang
      final t = i / sampleRate;
      final base = sin(2 * pi * freq * t);
      final h2 = 0.25 * sin(2 * pi * freq * 2 * t);
      out[start + i] += env * (base + h2);
    }
  }

  static void _addChord(
    Float64List out,
    int start,
    int length,
    double rootHz,
    List<int> chordSemis,
    double amp, {
    double fadeOutFrac = 0.5,
  }) {
    final perVoice = amp / sqrt(chordSemis.length.toDouble());
    for (int idx = 0; idx < chordSemis.length; idx++) {
      final f = rootHz * pow(2.0, chordSemis[idx] / 12.0);
      // Leichter Strum-Versatz pro Stimme
      final off = (idx * sampleRate * 0.005).round();
      _addTone(out, start + off, length - off, f.toDouble(), perVoice,
          fadeOutFrac: fadeOutFrac);
    }
  }

  static Future<String> _saveWav(Int16List pcm, int sr) async {
    final dataBytes = pcm.length * 2;
    final buf = Uint8List(44 + dataBytes);
    final bd = ByteData.view(buf.buffer);

    buf.setAll(0, 'RIFF'.codeUnits);
    bd.setUint32(4, 36 + dataBytes, Endian.little);
    buf.setAll(8, 'WAVE'.codeUnits);
    buf.setAll(12, 'fmt '.codeUnits);
    bd.setUint32(16, 16, Endian.little);
    bd.setUint16(20, 1, Endian.little);
    bd.setUint16(22, 1, Endian.little);
    bd.setUint32(24, sr, Endian.little);
    bd.setUint32(28, sr * 2, Endian.little);
    bd.setUint16(32, 2, Endian.little);
    bd.setUint16(34, 16, Endian.little);
    buf.setAll(36, 'data'.codeUnits);
    bd.setUint32(40, dataBytes, Endian.little);

    for (int i = 0; i < pcm.length; i++) {
      bd.setInt16(44 + i * 2, pcm[i], Endian.little);
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/backing_${DateTime.now().microsecondsSinceEpoch}.wav';
    await File(path).writeAsBytes(buf);
    return path;
  }
}
