import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../music_theory/note.dart';
import '../utils/constants.dart';
import 'pitch_detection_isolate.dart';

enum TuningType {
  standard,
  dropD,
  halfStepDown,
  openG,
  openD,
  dadgad,
}

extension TuningTypeExtension on TuningType {
  String get displayName {
    switch (this) {
      case TuningType.standard:
        return 'Standard (E-A-D-G-B-E)';
      case TuningType.dropD:
        return 'Drop D (D-A-D-G-B-E)';
      case TuningType.halfStepDown:
        return 'Halbton tief (Eb-Ab-Db-Gb-Bb-Eb)';
      case TuningType.openG:
        return 'Open G (D-G-D-G-B-D)';
      case TuningType.openD:
        return 'Open D (D-A-D-F#-A-D)';
      case TuningType.dadgad:
        return 'DADGAD (D-A-D-G-A-D)';
    }
  }

  List<int> get midiNotes {
    switch (this) {
      case TuningType.standard:
        return [40, 45, 50, 55, 59, 64]; // E2-A2-D3-G3-B3-E4
      case TuningType.dropD:
        return [38, 45, 50, 55, 59, 64]; // D2-A2-D3-G3-B3-E4
      case TuningType.halfStepDown:
        return [39, 44, 49, 54, 58, 63]; // Eb2-Ab2-Db3-Gb3-Bb3-Eb4
      case TuningType.openG:
        return [38, 43, 50, 55, 59, 62]; // D2-G2-D3-G3-B3-D4
      case TuningType.openD:
        return [38, 45, 50, 54, 57, 62]; // D2-A2-D3-F#3-A3-D4
      case TuningType.dadgad:
        return [38, 45, 50, 55, 57, 62]; // D2-A2-D3-G3-A3-D4
    }
  }
}

class PitchResult {
  final double frequency;
  final String noteName;
  final int octave;
  final int midiNote;
  final double accuracy; // 0-100
  final double centsOff;
  final double amplitude;
  final bool isOnPitch;

  const PitchResult({
    required this.frequency,
    required this.noteName,
    required this.octave,
    required this.midiNote,
    required this.accuracy,
    required this.centsOff,
    required this.amplitude,
    required this.isOnPitch,
  });

  String get fullNoteName => '$noteName$octave';

  bool get isValid => frequency > 0 && amplitude > 0.01;

  @override
  String toString() =>
      'PitchResult($fullNoteName, ${frequency.toStringAsFixed(1)} Hz, ${centsOff.toStringAsFixed(1)} cents, acc=$accuracy)';

  static const PitchResult empty = PitchResult(
    frequency: 0,
    noteName: '--',
    octave: 0,
    midiNote: 0,
    accuracy: 0,
    centsOff: 0,
    amplitude: 0,
    isOnPitch: false,
  );
}

class PitchDetector {
  final int sampleRate;
  final int bufferSize;

  TuningType _tuningType = TuningType.standard;
  final StreamController<PitchResult> _pitchController =
      StreamController<PitchResult>.broadcast();

  bool _isRunning = false;
  Timer? _simulationTimer;
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _audioSub;
  final PitchDetectionIsolate _detectionIsolate = PitchDetectionIsolate();
  bool _isolateReady = false;

  PitchDetector({
    this.sampleRate = AppConstants.sampleRate,
    this.bufferSize = AppConstants.bufferSize,
  });

  Stream<PitchResult> get pitchStream => _pitchController.stream;

  bool get isRunning => _isRunning;

  void setTuning(TuningType tuning) {
    _tuningType = tuning;
  }

  Future<void> start() async {
    if (_isRunning) return;
    _isRunning = true;

    // Check permission first
    final granted = await Permission.microphone.isGranted;
    if (!granted) {
      debugPrint('PitchDetector: no mic permission — falling back to simulation');
      _startSimulation();
      return;
    }

    try {
      final stream = await _recorder.startStream(
        RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels: 1,
          bitRate: sampleRate * 16, // 16-bit mono
        ),
      );
      _audioSub = stream.listen(
        _processAudioChunk,
        onError: (e) {
          debugPrint('PitchDetector audio error: $e');
        },
      );
      debugPrint('PitchDetector: real microphone input started at $sampleRate Hz');
      // Start detection isolate (best-effort)
      await _detectionIsolate.start();
      _isolateReady = _detectionIsolate.isReady;
      if (!_isolateReady) {
        debugPrint('PitchDetector: isolate unavailable, running on main thread');
      }
    } catch (e) {
      debugPrint('PitchDetector: startStream failed ($e) — falling back to simulation');
      _startSimulation();
    }
  }

  void _processAudioChunk(Uint8List bytes) {
    if (!_isRunning || bytes.isEmpty) return;
    final sampleCount = bytes.length ~/ 2;
    if (sampleCount < 64) return;

    final samples = Float32List(sampleCount);
    for (int i = 0; i < sampleCount; i++) {
      final lo = bytes[i * 2] & 0xFF;
      final hi = bytes[i * 2 + 1] & 0xFF;
      var raw = (hi << 8) | lo;
      if (raw > 32767) raw -= 65536;
      samples[i] = raw / 32768.0;
    }

    if (_isolateReady) {
      _processInIsolate(samples);
    } else {
      final result = detectFromSamples(samples, sampleRate);
      if (result != null && !_pitchController.isClosed) {
        _pitchController.add(result);
      }
    }
  }

  Future<void> _processInIsolate(Float32List samples) async {
    final start = DateTime.now();
    final result = await _detectionIsolate.detect(samples, sampleRate);
    if (result == null || !_isRunning) return;

    final latencyMs = DateTime.now().difference(start).inMilliseconds;
    if (latencyMs > 50) {
      debugPrint('PitchDetector: high latency ${latencyMs}ms');
    }

    if (result.amplitude < 0.01) return;
    if (result.frequency == null) return;
    final freq = result.frequency!;
    if (freq < 60 || freq > 1400) return;

    final pitchResult = _frequencyToResult(freq, result.amplitude);
    if (!_pitchController.isClosed) _pitchController.add(pitchResult);
  }

  Future<void> stop() async {
    _isRunning = false;
    _simulationTimer?.cancel();
    _simulationTimer = null;
    await _audioSub?.cancel();
    _audioSub = null;
    try {
      await _recorder.stop();
    } catch (_) {}
    _detectionIsolate.stop();
    _isolateReady = false;
  }

  /// Process a raw audio sample buffer and return pitch detection result
  PitchResult? detectFromSamples(Float32List samples, int sr) {
    final amplitude = _calculateAmplitude(samples);

    // Too quiet - no pitch
    if (amplitude < 0.01) return null;

    final frequency = _autocorrelationPitchDetect(samples, sr);

    if (frequency == null || frequency < 60 || frequency > 1400) return null;

    return _frequencyToResult(frequency, amplitude);
  }

  /// Core autocorrelation-based pitch detection algorithm
  double? _autocorrelationPitchDetect(Float32List samples, int sr) {
    final n = samples.length;
    if (n < 2) return null;

    // Apply Hamming window to reduce spectral leakage
    final windowed = Float32List(n);
    for (int i = 0; i < n; i++) {
      final window = 0.54 - 0.46 * math.cos(2 * math.pi * i / (n - 1));
      windowed[i] = samples[i] * window;
    }

    // Compute autocorrelation
    // We search for lags corresponding to guitar frequency range (60 Hz to 1400 Hz)
    final minLag = (sr / 1400).ceil();
    final maxLag = (sr / 60).floor();

    if (maxLag >= n) return null;

    var bestLag = minLag;
    var bestCorr = double.negativeInfinity;

    // Normalize autocorrelation at lag 0
    double r0 = 0;
    for (int i = 0; i < n; i++) {
      r0 += windowed[i] * windowed[i];
    }
    if (r0 == 0) return null;

    for (int lag = minLag; lag <= maxLag; lag++) {
      double corr = 0;
      for (int i = 0; i < n - lag; i++) {
        corr += windowed[i] * windowed[i + lag];
      }
      corr /= r0;

      if (corr > bestCorr) {
        bestCorr = corr;
        bestLag = lag;
      }
    }

    // Precision below threshold - not confident enough
    if (bestCorr < AppConstants.minPitchPrecision) return null;

    // Parabolic interpolation for sub-sample accuracy
    final frequency = _refineWithParabolicInterpolation(
      windowed,
      bestLag,
      sr,
    );

    return frequency;
  }

  /// Parabolic interpolation for more accurate pitch
  double _refineWithParabolicInterpolation(
    Float32List samples,
    int lag,
    int sr,
  ) {
    if (lag <= 0 || lag >= samples.length - 1) return sr / lag.toDouble();

    // Calculate autocorrelation at lag-1, lag, lag+1
    double r(int l) {
      double corr = 0;
      final n = samples.length;
      for (int i = 0; i < n - l && i < n; i++) {
        corr += samples[i] * samples[i + l];
      }
      return corr;
    }

    final ym1 = r(lag - 1);
    final y0 = r(lag);
    final y1 = r(lag + 1);

    final denom = 2 * (ym1 - 2 * y0 + y1);
    if (denom.abs() < 1e-10) return sr / lag.toDouble();

    final refinedLag = lag - (y1 - ym1) / denom;
    return sr / refinedLag;
  }

  /// Calculates the RMS amplitude of a buffer
  double _calculateAmplitude(Float32List samples) {
    double sum = 0;
    for (final sample in samples) {
      sum += sample * sample;
    }
    return math.sqrt(sum / samples.length);
  }

  /// Converts a frequency to a PitchResult
  PitchResult _frequencyToResult(double frequency, double amplitude) {
    final note = Note.fromFrequency(frequency);
    final centsOff = note.centsFromFrequency(frequency);
    final isOnPitch = centsOff.abs() <= AppConstants.inTuneCentsThreshold;

    // Accuracy: 100 when perfectly in tune, drops off with cents deviation
    final accuracy = math.max(0.0,
        100.0 - (centsOff.abs() / 50.0) * 100.0).clamp(0.0, 100.0);

    return PitchResult(
      frequency: frequency,
      noteName: note.name,
      octave: note.octave,
      midiNote: note.midiNumber,
      accuracy: accuracy,
      centsOff: centsOff,
      amplitude: amplitude,
      isOnPitch: isOnPitch,
    );
  }

  // Simulation for development/testing
  void _startSimulation() {
    final notes = ['E2', 'A2', 'D3', 'G3', 'B3', 'E4'];
    int noteIdx = 0;

    _simulationTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!_isRunning) return;

      // Cycle through open string notes
      final noteStr = notes[noteIdx % notes.length];
      final noteName = noteStr.substring(0, noteStr.length - 1);
      final octave = int.parse(noteStr[noteStr.length - 1]);
      final note = Note(name: noteName, octave: octave);

      // Simulate slight detuning
      final offset = (math.Random().nextDouble() - 0.5) * 20;
      final simulatedFreq = note.frequency * math.pow(2, offset / 1200);

      final result = _frequencyToResult(simulatedFreq, 0.3);
      _pitchController.add(result);

      noteIdx++;
    });
  }

  void dispose() {
    stop();
    _recorder.dispose();
    _pitchController.close();
  }
}
