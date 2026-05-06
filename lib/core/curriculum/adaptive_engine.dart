import 'package:flutter/foundation.dart';

enum AdaptiveAction { celebrate, proceed, repeatSimplified, goBack }

class AdaptiveEngine {
  AdaptiveEngine._();

  static const double _masterThreshold = 0.95;
  static const double _proceedThreshold = 0.70;
  static const double _retryThreshold = 0.50;
  static const int _maxConsecutiveFailures = 3;

  static AdaptiveAction evaluate({
    required double accuracy,
    required int attempt,
    required int consecutiveFailures,
    required bool isFirstAttempt,
  }) {
    if (isFirstAttempt && accuracy >= _masterThreshold) return AdaptiveAction.celebrate;
    if (accuracy >= _proceedThreshold) return AdaptiveAction.proceed;
    if (consecutiveFailures >= _maxConsecutiveFailures) return AdaptiveAction.goBack;
    if (accuracy < _retryThreshold) return AdaptiveAction.repeatSimplified;
    return AdaptiveAction.proceed;
  }

  static String? getXmariHint({
    required double accuracy,
    required bool usbConnected,
    required int? batteryLevel,
    required String currentPreset,
    required String recommendedPreset,
  }) {
    if (batteryLevel != null && batteryLevel < 15) {
      return 'Dein XMARI-Akku ist bei $batteryLevel% – lade sie auf für stabiles Audio.';
    }
    if (accuracy < 0.50 && !usbConnected) {
      return 'Tipp: Verbinde deine XMARI per USB-C für präziseres Audio-Feedback.';
    }
    if (currentPreset != recommendedPreset && accuracy < 0.70) {
      return 'Tipp: Wechsle zu $recommendedPreset – das macht es einfacher den richtigen Ton zu hören.';
    }
    return null;
  }
}
