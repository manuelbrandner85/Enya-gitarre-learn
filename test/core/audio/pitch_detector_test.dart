import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';

Float32List generateSineWave(double freq, int sampleRate, int numSamples) {
  final samples = Float32List(numSamples);
  for (int i = 0; i < numSamples; i++) {
    samples[i] = (0.5 * math.sin(2 * math.pi * freq * i / sampleRate)).toDouble();
  }
  return samples;
}

void main() {
  // Initialize Flutter binding so platform channels work in tests
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the 'record' package platform channel so AudioRecorder construction
  // and disposal don't throw MissingPluginException in the test environment.
  const recordChannel = MethodChannel('com.llfbandit.record/messages');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(recordChannel, (MethodCall call) async {
    // Return sensible defaults for all methods the plugin might call
    switch (call.method) {
      case 'create':
      case 'dispose':
      case 'stop':
      case 'pause':
      case 'resume':
        return null;
      case 'isRecording':
      case 'isPaused':
        return false;
      case 'hasPermission':
        return true;
      default:
        return null;
    }
  });

  late PitchDetector detector;
  const sampleRate = 44100;
  const numSamples = 4096;

  setUp(() => detector = PitchDetector(sampleRate: sampleRate));
  tearDown(() => detector.dispose());

  group('PitchResult', () {
    test('fullNoteName concatenates noteName and octave', () {
      const result = PitchResult(
        frequency: 440.0,
        noteName: 'A',
        octave: 4,
        midiNote: 69,
        accuracy: 100.0,
        centsOff: 0.0,
        amplitude: 0.5,
        isOnPitch: true,
      );
      expect(result.fullNoteName, equals('A4'));
    });

    test('isValid is true when frequency and amplitude are non-zero', () {
      const result = PitchResult(
        frequency: 440.0,
        noteName: 'A',
        octave: 4,
        midiNote: 69,
        accuracy: 100.0,
        centsOff: 0.0,
        amplitude: 0.5,
        isOnPitch: true,
      );
      expect(result.isValid, isTrue);
    });

    test('PitchResult.empty has frequency 0 and is not valid', () {
      expect(PitchResult.empty.frequency, equals(0));
      expect(PitchResult.empty.isValid, isFalse);
    });
  });

  group('TuningType', () {
    test('standard tuning has correct MIDI notes', () {
      expect(TuningType.standard.midiNotes, equals([40, 45, 50, 55, 59, 64]));
    });

    test('drop D tuning lowers low E to D2 (MIDI 38)', () {
      expect(TuningType.dropD.midiNotes.first, equals(38));
    });

    test('displayName is non-empty for all tunings', () {
      for (final tuning in TuningType.values) {
        expect(tuning.displayName, isNotEmpty);
      }
    });
  });

  group('PitchDetector.detectFromSamples', () {
    test('440 Hz sine wave → A4', () {
      final samples = generateSineWave(440.0, sampleRate, numSamples);
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNotNull);
      expect(result!.noteName, equals('A'));
      expect(result.octave, equals(4));
      expect(result.midiNote, equals(69));
      expect(result.frequency, closeTo(440.0, 5.0));
    });

    test('329.63 Hz sine wave → E4 (high E string)', () {
      final samples = generateSineWave(329.63, sampleRate, numSamples);
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNotNull);
      expect(result!.noteName, equals('E'));
      expect(result.octave, equals(4));
    });

    test('82.41 Hz sine wave → E2 (low E string)', () {
      // Low frequencies require a larger buffer for the autocorrelation
      // algorithm to distinguish the fundamental from harmonics.
      // 8192 samples matches AppConstants.bufferSize used in production.
      final samples = generateSineWave(82.41, sampleRate, 8192);
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNotNull);
      expect(result!.noteName, equals('E'));
      expect(result.octave, equals(2));
    });

    test('110 Hz sine wave → A2 (A string)', () {
      final samples = generateSineWave(110.0, sampleRate, numSamples);
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNotNull);
      expect(result!.noteName, equals('A'));
      expect(result.octave, equals(2));
    });

    test('silent buffer (all zeros) → null (below amplitude threshold)', () {
      final samples = Float32List(numSamples); // all zeros
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNull);
    });

    test('very low amplitude → null', () {
      final samples = generateSineWave(440.0, sampleRate, numSamples);
      for (int i = 0; i < samples.length; i++) {
        samples[i] *= 0.001;
      }
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNull);
    });

    test('detected frequency is within 10 Hz of 440 Hz target', () {
      final samples = generateSineWave(440.0, sampleRate, numSamples);
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNotNull);
      expect(result!.frequency, closeTo(440.0, 10.0));
    });

    test('result amplitude is positive for valid sine wave', () {
      final samples = generateSineWave(440.0, sampleRate, numSamples);
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNotNull);
      expect(result!.amplitude, greaterThan(0.0));
    });

    test('accuracy is in range 0–100', () {
      final samples = generateSineWave(440.0, sampleRate, numSamples);
      final result = detector.detectFromSamples(samples, sampleRate);
      expect(result, isNotNull);
      expect(result!.accuracy, inInclusiveRange(0.0, 100.0));
    });
  });

  group('PitchDetector state', () {
    test('isRunning is false before start', () {
      expect(detector.isRunning, isFalse);
    });

    test('setTuning does not throw', () {
      expect(() => detector.setTuning(TuningType.dropD), returnsNormally);
    });
  });
}
