import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../music_theory/note.dart';
import '../utils/constants.dart';

// Message sent TO the worker isolate
class _DetectMessage {
  final Float32List samples;
  final int sampleRate;
  final SendPort replyPort;
  const _DetectMessage(this.samples, this.sampleRate, this.replyPort);
}

// Result sent BACK from the worker isolate
class _DetectResult {
  final double? frequency;
  final double amplitude;
  const _DetectResult(this.frequency, this.amplitude);
}

// Entry point for the worker isolate (must be top-level)
void _pitchWorkerEntry(SendPort mainPort) {
  final receivePort = ReceivePort();
  mainPort.send(receivePort.sendPort);

  receivePort.listen((message) {
    if (message is _DetectMessage) {
      final freq = _autocorrelate(message.samples, message.sampleRate);
      final amp = _rmsAmplitude(message.samples);
      message.replyPort.send(_DetectResult(freq, amp));
    }
  });
}

double _rmsAmplitude(Float32List samples) {
  double sum = 0;
  for (final s in samples) sum += s * s;
  return math.sqrt(sum / samples.length);
}

double? _autocorrelate(Float32List samples, int sr) {
  final n = samples.length;
  if (n < 2) return null;

  final windowed = Float32List(n);
  for (int i = 0; i < n; i++) {
    final w = 0.54 - 0.46 * math.cos(2 * math.pi * i / (n - 1));
    windowed[i] = samples[i] * w;
  }

  final minLag = (sr / 1400).ceil();
  final maxLag = (sr / 60).floor();
  if (maxLag >= n) return null;

  double r0 = 0;
  for (int i = 0; i < n; i++) r0 += windowed[i] * windowed[i];
  if (r0 == 0) return null;

  var bestLag = minLag;
  var bestCorr = double.negativeInfinity;
  for (int lag = minLag; lag <= maxLag; lag++) {
    double corr = 0;
    for (int i = 0; i < n - lag; i++) corr += windowed[i] * windowed[i + lag];
    corr /= r0;
    if (corr > bestCorr) { bestCorr = corr; bestLag = lag; }
  }

  if (bestCorr < AppConstants.minPitchPrecision) return null;

  // Parabolic interpolation
  if (bestLag <= 0 || bestLag >= n - 1) return sr / bestLag.toDouble();
  double rr(int l) {
    double c = 0;
    for (int i = 0; i < n - l && i < n; i++) c += windowed[i] * windowed[i + l];
    return c;
  }
  final ym1 = rr(bestLag - 1), y0 = rr(bestLag), y1 = rr(bestLag + 1);
  final denom = 2 * (ym1 - 2 * y0 + y1);
  if (denom.abs() < 1e-10) return sr / bestLag.toDouble();
  final refined = bestLag - (y1 - ym1) / denom;
  return sr / refined;
}

/// Manages a long-lived background isolate for pitch detection.
class PitchDetectionIsolate {
  Isolate? _isolate;
  SendPort? _workerSendPort;
  ReceivePort? _mainReceivePort;
  bool _ready = false;

  Future<void> start() async {
    _mainReceivePort = ReceivePort();
    try {
      _isolate = await Isolate.spawn(
        _pitchWorkerEntry,
        _mainReceivePort!.sendPort,
        debugName: 'PitchDetectionWorker',
      );
      _workerSendPort = await _mainReceivePort!.first as SendPort;
      _ready = true;
      debugPrint('PitchDetectionIsolate: worker started');
    } catch (e) {
      debugPrint('PitchDetectionIsolate: spawn failed: $e');
      _ready = false;
    }
  }

  /// Send samples for processing. Returns null immediately if not ready.
  Future<_DetectResult?> detect(Float32List samples, int sampleRate) async {
    if (!_ready || _workerSendPort == null) return null;
    final replyPort = ReceivePort();
    _workerSendPort!.send(_DetectMessage(samples, sampleRate, replyPort.sendPort));
    final result = await replyPort.first as _DetectResult;
    replyPort.close();
    return result;
  }

  void stop() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _mainReceivePort?.close();
    _mainReceivePort = null;
    _workerSendPort = null;
    _ready = false;
  }

  bool get isReady => _ready;
}
