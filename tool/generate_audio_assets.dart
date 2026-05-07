// Generiert synthetische WAV-Audio-Assets für die App.
//
// Erzeugt:
//   - Metronom-Sounds in assets/audio/
//   - Einzelne Noten (E2..E5 mit allen Halbtönen) in assets/audio/notes/
//   - Akkord-Samples (C, D, E, Em, A, Am, G, F, Dm, E7, A7, D7) in assets/audio/chords/
//
// Aufruf: dart run tool/generate_audio_assets.dart
//
// Das Format ist 16-Bit PCM, 44100 Hz, Mono.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const int sampleRate = 44100;
const int bitsPerSample = 16;
const int channels = 1;

// ── WAV-Encoder ──────────────────────────────────────────────────────────────

Uint8List encodeWav(Float64List samples) {
  final byteRate = sampleRate * channels * bitsPerSample ~/ 8;
  final blockAlign = channels * bitsPerSample ~/ 8;
  final dataSize = samples.length * 2;
  final fileSize = 36 + dataSize;

  final buf = BytesBuilder();

  // RIFF Header
  buf.add('RIFF'.codeUnits);
  buf.add(_uint32LE(fileSize));
  buf.add('WAVE'.codeUnits);

  // fmt-Chunk
  buf.add('fmt '.codeUnits);
  buf.add(_uint32LE(16)); // Sub-Chunk-Größe
  buf.add(_uint16LE(1)); // PCM
  buf.add(_uint16LE(channels));
  buf.add(_uint32LE(sampleRate));
  buf.add(_uint32LE(byteRate));
  buf.add(_uint16LE(blockAlign));
  buf.add(_uint16LE(bitsPerSample));

  // data-Chunk
  buf.add('data'.codeUnits);
  buf.add(_uint32LE(dataSize));

  // PCM-Daten (clamp + Konvertierung)
  for (final s in samples) {
    final clamped = s.clamp(-1.0, 1.0);
    final int16 = (clamped * 32767).round();
    buf.add(_int16LE(int16));
  }

  return buf.toBytes();
}

List<int> _uint32LE(int v) =>
    [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF];
List<int> _uint16LE(int v) => [v & 0xFF, (v >> 8) & 0xFF];
List<int> _int16LE(int v) {
  if (v < 0) v += 0x10000;
  return [v & 0xFF, (v >> 8) & 0xFF];
}

// ── Synthese-Hilfsfunktionen ─────────────────────────────────────────────────

/// Erzeugt eine reine Sinuswelle mit ADSR-ähnlicher Hüllkurve.
Float64List synthSine({
  required double frequency,
  required double durationSec,
  double amplitude = 0.6,
  double fadeInSec = 0.005,
  double fadeOutSec = 0.05,
}) {
  final n = (durationSec * sampleRate).round();
  final out = Float64List(n);
  final fadeInSamples = (fadeInSec * sampleRate).round();
  final fadeOutSamples = (fadeOutSec * sampleRate).round();
  for (int i = 0; i < n; i++) {
    final t = i / sampleRate;
    double env = amplitude;
    if (i < fadeInSamples) env *= i / fadeInSamples;
    if (i > n - fadeOutSamples) env *= (n - i) / fadeOutSamples;
    out[i] = math.sin(2 * math.pi * frequency * t) * env;
  }
  return out;
}

/// Mischt mehrere Frequenzen (für Akkorde) zu einem Signal.
Float64List synthChord({
  required List<double> frequencies,
  required double durationSec,
  double amplitude = 0.4,
  double fadeInSec = 0.01,
  double fadeOutSec = 0.15,
  double strumOffsetSec = 0.02,
}) {
  final n = (durationSec * sampleRate).round();
  final out = Float64List(n);
  final fadeInSamples = (fadeInSec * sampleRate).round();
  final fadeOutSamples = (fadeOutSec * sampleRate).round();
  for (int idx = 0; idx < frequencies.length; idx++) {
    final f = frequencies[idx];
    final offset = (idx * strumOffsetSec * sampleRate).round();
    for (int i = 0; i < n - offset; i++) {
      final t = i / sampleRate;
      double env = amplitude / math.sqrt(frequencies.length);
      if (i < fadeInSamples) env *= i / fadeInSamples;
      if (i > n - fadeOutSamples - offset) {
        env *= (n - offset - i) / fadeOutSamples;
      }
      // Leichte Obertöne hinzufügen für gitarrigen Klang
      final fund = math.sin(2 * math.pi * f * t);
      final harmonic2 = 0.3 * math.sin(2 * math.pi * f * 2 * t);
      final harmonic3 = 0.15 * math.sin(2 * math.pi * f * 3 * t);
      out[i + offset] += (fund + harmonic2 + harmonic3) * env;
    }
  }
  // Normalisierung gegen Clipping
  double peak = 0;
  for (final s in out) {
    if (s.abs() > peak) peak = s.abs();
  }
  if (peak > 0.95) {
    for (int i = 0; i < n; i++) {
      out[i] *= 0.95 / peak;
    }
  }
  return out;
}

/// Erzeugt Bandpass-Rauschen für Hi-Hat-ähnliche Sounds.
Float64List synthNoiseBurst({
  required double durationSec,
  double amplitude = 0.5,
  double centerFreq = 8000,
}) {
  final rng = math.Random(42);
  final n = (durationSec * sampleRate).round();
  final out = Float64List(n);
  for (int i = 0; i < n; i++) {
    final env = math.pow(1 - i / n, 3.0).toDouble();
    out[i] = (rng.nextDouble() * 2 - 1) * amplitude * env;
  }
  // Einfacher Bandpass über RC-Filter-Approximation
  final rc = 1.0 / (2 * math.pi * centerFreq);
  final dt = 1.0 / sampleRate;
  final alpha = dt / (rc + dt);
  double prev = 0;
  for (int i = 0; i < n; i++) {
    prev = prev + alpha * (out[i] - prev);
    out[i] = prev;
  }
  return out;
}

// ── Notennamen → Frequenz (Equal Temperament) ────────────────────────────────

const Map<String, int> noteToSemitoneOffset = {
  'C': 0, 'C#': 1, 'Db': 1,
  'D': 2, 'D#': 3, 'Eb': 3,
  'E': 4,
  'F': 5, 'F#': 6, 'Gb': 6,
  'G': 7, 'G#': 8, 'Ab': 8,
  'A': 9, 'A#': 10, 'Bb': 10,
  'B': 11,
};

double noteFrequency(String name, int octave) {
  final semis = noteToSemitoneOffset[name];
  if (semis == null) {
    throw ArgumentError('Unbekannter Notenname: $name');
  }
  // A4 = 440 Hz, MIDI 69. Halbton-Offset von A4 berechnen.
  final midi = (octave + 1) * 12 + semis;
  return 440.0 * math.pow(2, (midi - 69) / 12.0);
}

// ── Hauptprogramm ────────────────────────────────────────────────────────────

void main() {
  final audioDir = Directory('assets/audio');
  final notesDir = Directory('assets/audio/notes');
  final chordsDir = Directory('assets/audio/chords');
  final backingDir = Directory('assets/audio/backing_tracks');
  for (final d in [audioDir, notesDir, chordsDir, backingDir]) {
    if (!d.existsSync()) d.createSync(recursive: true);
  }

  // ── Metronom ───────────────────────────────────────────────────────────────
  final metronomeSpecs = <String, Float64List>{
    'metronome_click.wav':
        synthSine(frequency: 1000, durationSec: 0.05, amplitude: 0.6),
    'metronome_click_accent.wav':
        synthSine(frequency: 1500, durationSec: 0.07, amplitude: 0.8),
    'metronome_hihat.wav':
        synthNoiseBurst(durationSec: 0.06, amplitude: 0.5, centerFreq: 9000),
    'metronome_hihat_accent.wav':
        synthNoiseBurst(durationSec: 0.08, amplitude: 0.7, centerFreq: 10000),
    'metronome_rimshot.wav': _mix([
      synthSine(frequency: 800, durationSec: 0.05, amplitude: 0.4),
      synthNoiseBurst(durationSec: 0.05, amplitude: 0.4, centerFreq: 5000),
    ]),
    'metronome_rimshot_accent.wav': _mix([
      synthSine(frequency: 800, durationSec: 0.07, amplitude: 0.5),
      synthNoiseBurst(durationSec: 0.07, amplitude: 0.5, centerFreq: 5500),
    ]),
    'metronome_woodblock.wav':
        synthSine(frequency: 2500, durationSec: 0.06, amplitude: 0.6),
    'metronome_woodblock_accent.wav':
        synthSine(frequency: 3000, durationSec: 0.08, amplitude: 0.8),
  };
  for (final entry in metronomeSpecs.entries) {
    final f = File('${audioDir.path}/${entry.key}');
    f.writeAsBytesSync(encodeWav(entry.value));
    stdout.writeln('  ✓ ${f.path} (${f.lengthSync()} bytes)');
  }

  // ── Einzelne Noten: E2 bis E5, alle Halbtöne ──────────────────────────────
  // Standard-Stimmung: E2, A2, D3, G3, B3, E4 + Bünde 0-12
  final noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  for (int oct = 2; oct <= 5; oct++) {
    for (final n in noteNames) {
      // E2 ist Untergrenze, E5 ist Obergrenze für Standard-Range
      final freq = noteFrequency(n, oct);
      if (freq < 75 || freq > 700) continue; // außerhalb des Spielbereichs
      final samples = synthSine(
        frequency: freq,
        durationSec: 1.0,
        amplitude: 0.55,
        fadeInSec: 0.02,
        fadeOutSec: 0.2,
      );
      // Saubere Dateinamen ohne #-Konflikt im Filesystem
      final safeName = n.replaceAll('#', 'sharp');
      final f = File('${notesDir.path}/$safeName$oct.wav');
      f.writeAsBytesSync(encodeWav(samples));
    }
  }
  stdout.writeln('  ✓ Noten generiert in ${notesDir.path}/');

  // ── Akkord-Samples ────────────────────────────────────────────────────────
  final chordDefs = <String, List<(String, int)>>{
    // Notennamen mit Oktave (von tief nach hoch wie auf Gitarre gespielt)
    'C': [('C', 3), ('E', 3), ('G', 3), ('C', 4), ('E', 4)],
    'D': [('D', 3), ('A', 3), ('D', 4), ('F#', 4)],
    'E': [('E', 2), ('B', 2), ('E', 3), ('G#', 3), ('B', 3), ('E', 4)],
    'Em': [('E', 2), ('B', 2), ('E', 3), ('G', 3), ('B', 3), ('E', 4)],
    'A': [('A', 2), ('E', 3), ('A', 3), ('C#', 4), ('E', 4)],
    'Am': [('A', 2), ('E', 3), ('A', 3), ('C', 4), ('E', 4)],
    'G': [('G', 2), ('B', 2), ('D', 3), ('G', 3), ('B', 3), ('G', 4)],
    'F': [('F', 2), ('C', 3), ('F', 3), ('A', 3), ('C', 4), ('F', 4)],
    'Dm': [('D', 3), ('A', 3), ('D', 4), ('F', 4)],
    'E7': [('E', 2), ('B', 2), ('D', 3), ('G#', 3), ('B', 3), ('E', 4)],
    'A7': [('A', 2), ('E', 3), ('G', 3), ('C#', 4), ('E', 4)],
    'D7': [('D', 3), ('A', 3), ('C', 4), ('F#', 4)],
  };
  for (final entry in chordDefs.entries) {
    final freqs = entry.value.map((n) => noteFrequency(n.$1, n.$2)).toList();
    final samples = synthChord(
      frequencies: freqs,
      durationSec: 1.5,
      amplitude: 0.5,
      strumOffsetSec: 0.025,
    );
    final f = File('${chordsDir.path}/${entry.key}.wav');
    f.writeAsBytesSync(encodeWav(samples));
  }
  stdout.writeln('  ✓ ${chordDefs.length} Akkorde generiert in ${chordsDir.path}/');

  stdout.writeln('Fertig.');
}

Float64List _mix(List<Float64List> sources) {
  final maxLen = sources.fold<int>(0, (m, s) => s.length > m ? s.length : m);
  final out = Float64List(maxLen);
  for (final s in sources) {
    for (int i = 0; i < s.length; i++) {
      out[i] += s[i];
    }
  }
  return out;
}
