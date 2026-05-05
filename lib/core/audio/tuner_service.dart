import 'dart:async';
import 'dart:math' as math;

import '../music_theory/note.dart';
import '../utils/constants.dart';
import 'pitch_detector.dart';

class TunerReading {
  final Note detectedNote;
  final Note targetNote;
  final double centsOff;
  final bool isInTune;
  final int stringIndex; // 0-5, -1 if unknown
  final double frequency;
  final double amplitude;

  const TunerReading({
    required this.detectedNote,
    required this.targetNote,
    required this.centsOff,
    required this.isInTune,
    required this.stringIndex,
    required this.frequency,
    required this.amplitude,
  });

  /// Returns the tuning accuracy as a value from -1.0 (very flat) to 1.0 (very sharp)
  /// 0.0 is perfect tuning
  double get tuningOffset => (centsOff / 50.0).clamp(-1.0, 1.0);

  /// Returns true if the note is close to in tune (within 15 cents)
  bool get isAlmostInTune =>
      centsOff.abs() <= AppConstants.almostInTuneCentsThreshold;

  /// Returns the tuning direction
  TuningDirection get direction {
    if (isInTune) return TuningDirection.inTune;
    if (centsOff > 0) return TuningDirection.sharp;
    return TuningDirection.flat;
  }

  static const TunerReading empty = TunerReading(
    detectedNote: Note(name: '--', octave: 0),
    targetNote: Note(name: 'E', octave: 2),
    centsOff: 0,
    isInTune: false,
    stringIndex: -1,
    frequency: 0,
    amplitude: 0,
  );
}

enum TuningDirection { flat, inTune, sharp }

class TunerService {
  TuningType _tuningType;
  final PitchDetector _pitchDetector;
  final StreamController<TunerReading> _tunerController =
      StreamController<TunerReading>.broadcast();

  StreamSubscription<PitchResult>? _pitchSubscription;

  TunerService({TuningType tuningType = TuningType.standard})
      : _tuningType = tuningType,
        _pitchDetector = PitchDetector();

  Stream<TunerReading> get tunerStream => _tunerController.stream;

  TuningType get currentTuning => _tuningType;

  /// Changes the tuning type and updates detection
  void setTuningType(TuningType tuning) {
    _tuningType = tuning;
    _pitchDetector.setTuning(tuning);
  }

  /// Returns all target notes for the current tuning
  List<Note> get targetNotes {
    return _tuningType.midiNotes.map((midi) => Note.fromMidi(midi)).toList();
  }

  /// Starts the tuner service
  Future<void> start() async {
    await _pitchDetector.start();

    _pitchSubscription = _pitchDetector.pitchStream.listen((pitchResult) {
      if (!pitchResult.isValid) return;

      final reading = _processResult(pitchResult);
      _tunerController.add(reading);
    });
  }

  /// Stops the tuner service
  Future<void> stop() async {
    await _pitchSubscription?.cancel();
    _pitchSubscription = null;
    await _pitchDetector.stop();
  }

  /// Process a pitch result to find the closest string target
  TunerReading _processResult(PitchResult result) {
    // Find the closest string based on frequency
    final stringIndex = _detectString(result.frequency);
    final targetNote = _getTargetNote(result.frequency);
    final detectedNote = Note(name: result.noteName, octave: result.octave);

    // Calculate cents deviation from the target note
    final centsOff = detectedNote.centsFromFrequency(result.frequency);

    // More precise: calculate from target note frequency
    final targetFrequency = targetNote.frequency;
    final preciseCents = 1200 *
        (math.log(result.frequency / targetFrequency) / math.log(2));

    final isInTune = preciseCents.abs() <= AppConstants.inTuneCentsThreshold;

    return TunerReading(
      detectedNote: detectedNote,
      targetNote: targetNote,
      centsOff: preciseCents,
      isInTune: isInTune,
      stringIndex: stringIndex,
      frequency: result.frequency,
      amplitude: result.amplitude,
    );
  }

  /// Detects which string is most likely being played
  int _detectString(double frequency) {
    final tuningMidi = _tuningType.midiNotes;
    int closestString = 0;
    double minCentsDiff = double.maxFinite;

    for (int i = 0; i < tuningMidi.length; i++) {
      final stringNote = Note.fromMidi(tuningMidi[i]);
      // Check octaves around the expected string frequency
      for (int octaveOffset = -1; octaveOffset <= 1; octaveOffset++) {
        final checkMidi = tuningMidi[i] + (octaveOffset * 12);
        final checkNote = Note.fromMidi(checkMidi);
        final cents = (1200 *
                (math.log(frequency / checkNote.frequency) / math.log(2)))
            .abs();

        if (cents < minCentsDiff) {
          minCentsDiff = cents;
          closestString = i;
          // stringNote used for type check only
          assert(stringNote.midiNumber >= 0);
        }
      }
    }

    return closestString;
  }

  /// Returns the target note for the closest string to the given frequency
  Note _getTargetNote(double frequency) {
    final tuningMidi = _tuningType.midiNotes;
    int closestString = 0;
    double minCentsDiff = double.maxFinite;

    for (int i = 0; i < tuningMidi.length; i++) {
      // Also check one octave up/down for harmonics
      for (int octaveOffset = -1; octaveOffset <= 1; octaveOffset++) {
        final checkMidi = tuningMidi[i] + (octaveOffset * 12);
        final checkNote = Note.fromMidi(checkMidi);
        final cents = (1200 *
                (math.log(frequency / checkNote.frequency) / math.log(2)))
            .abs();

        if (cents < minCentsDiff) {
          minCentsDiff = cents;
          closestString = i;
        }
      }
    }

    return Note.fromMidi(tuningMidi[closestString]);
  }

  void dispose() {
    stop();
    _tunerController.close();
    _pitchDetector.dispose();
  }
}
