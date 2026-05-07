/// Adaptive Schwierigkeits-Engine.
///
/// Wertet die zuletzt erreichte Genauigkeit einer Lektion aus und schlägt
/// eine Reaktion vor (weiter, einfacher, vorherige wiederholen, vorspringen).

/// Mögliche Aktionen, die die UI auswerten kann.
enum AdaptiveAction {
  /// User ist deutlich besser als nötig → nächste Lektion vorschlagen
  /// (90%+ accuracy).
  skipAhead,

  /// Normaler Fortgang (70%+ accuracy).
  continue_,

  /// User unter Soll-Genauigkeit → Hinweis + reduzierte Wiederholungen.
  simplify,

  /// 3+ Fehlversuche mit ≤ 50% → vorherige Lektion zur Wiederholung.
  reviewPrevious,

  // ── Aliase für ältere Aufrufstellen ────────────────────────────────────
  celebrate,
  proceed,
  repeatSimplified,
  goBack,
}

class AdaptiveEngine {
  AdaptiveEngine._();

  /// Schwellwert "Schnelllerner" (90%+).
  static const double thresholdSkipAhead = 0.90;

  /// Schwellwert für problemlosen Fortgang (70%).
  static const double thresholdContinue = 0.70;

  /// Schwellwert für Wiederholung der vorherigen Lektion (≤ 50%).
  static const double thresholdReview = 0.50;

  /// Max. aufeinanderfolgende Fehlversuche bevor zurückgesprungen wird.
  static const int maxConsecutiveFailures = 3;

  /// **Hauptmethode der Spezifikation**: bewertet anhand
  /// [accuracy] und [consecutiveFailures] und liefert eine Aktion.
  static AdaptiveAction evaluate(
      double accuracy, int consecutiveFailures) {
    if (accuracy >= thresholdSkipAhead) return AdaptiveAction.skipAhead;
    if (accuracy >= thresholdContinue) return AdaptiveAction.continue_;
    if (consecutiveFailures >= maxConsecutiveFailures &&
        accuracy <= thresholdReview) {
      return AdaptiveAction.reviewPrevious;
    }
    if (accuracy <= thresholdContinue) return AdaptiveAction.simplify;
    return AdaptiveAction.continue_;
  }

  /// Erweiterter Aufruf, der zusätzlich Erst-Versuch und Versuch-Nummer
  /// berücksichtigt. Wird intern auf [evaluate] gemappt.
  static AdaptiveAction evaluateExtended({
    required double accuracy,
    required int attempt,
    required int consecutiveFailures,
    required bool isFirstAttempt,
  }) {
    if (isFirstAttempt && accuracy >= 0.95) return AdaptiveAction.celebrate;
    final base = evaluate(accuracy, consecutiveFailures);
    // Mappe interne Aktionen auf alte Aliase wo erwartet.
    switch (base) {
      case AdaptiveAction.skipAhead:
        return AdaptiveAction.celebrate;
      case AdaptiveAction.continue_:
        return AdaptiveAction.proceed;
      case AdaptiveAction.simplify:
        return AdaptiveAction.repeatSimplified;
      case AdaptiveAction.reviewPrevious:
        return AdaptiveAction.goBack;
      default:
        return base;
    }
  }

  /// Liefert eine deutsche Kurzbeschreibung der Aktion für UI-Banner.
  static String describe(AdaptiveAction a) {
    switch (a) {
      case AdaptiveAction.skipAhead:
      case AdaptiveAction.celebrate:
        return 'Schnelllerner! 🚀 Du kannst direkt zur nächsten Lektion.';
      case AdaptiveAction.continue_:
      case AdaptiveAction.proceed:
        return 'Mach weiter so – du bist auf Kurs.';
      case AdaptiveAction.simplify:
      case AdaptiveAction.repeatSimplified:
        return 'Versuche es langsamer und konzentriere dich auf saubere Saiten-Treffer.';
      case AdaptiveAction.reviewPrevious:
      case AdaptiveAction.goBack:
        return 'Lass uns kurz die vorherige Lektion wiederholen.';
    }
  }

  /// XMARI-spezifischer Hinweis basierend auf Hardware-Status.
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
