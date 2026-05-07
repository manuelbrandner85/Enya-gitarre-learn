import 'dart:async';

import 'package:flutter/material.dart';

import 'fretboard_widget.dart';

/// Zeigt Finger-Positionen nacheinander animiert.
/// Jeder Finger "fliegt" von außen auf seine Position (Bogen-Animation).
/// Am Ende pulsiert die gesamte Griffposition 2× grün.
class FretboardStepAnimation extends StatefulWidget {
  /// Die anzuzeigenden Fingerpositionen in der gewünschten Reihenfolge.
  final List<FretPosition> positions;

  /// Wird aufgerufen, sobald die gesamte Animation (inkl. Puls) abgeschlossen ist.
  final VoidCallback? onComplete;

  /// Startet die Animation automatisch beim Einblenden des Widgets.
  final bool autoPlay;

  const FretboardStepAnimation({
    super.key,
    required this.positions,
    this.onComplete,
    this.autoPlay = true,
  });

  @override
  State<FretboardStepAnimation> createState() => _FretboardStepAnimationState();
}

class _FretboardStepAnimationState extends State<FretboardStepAnimation>
    with TickerProviderStateMixin {
  // Aktuell sichtbare Positionen (werden schrittweise hinzugefügt)
  final List<FretPosition> _visiblePositions = [];

  // Index des aktuell einzublendenden Fingers (0-basiert)
  int _currentStep = 0;

  // Ob alle Positionen angezeigt wurden
  bool _allShown = false;

  // Ob der grüne Pulseffekt aktiv ist
  bool _pulsing = false;

  // Steuerung des grünen Pulsrahmens
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // Einzelne Slide-in-Controller für jede Position
  final List<AnimationController> _stepControllers = [];
  final List<Animation<double>> _opacityAnimations = [];
  final List<Animation<double>> _slideAnimations = [];

  // Laufende Timer für die sequenzielle Steuerung
  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();

    // Puls-Controller: 2× grün aufleuchten (800 ms pro Zyklus)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.addStatusListener(_onPulseStatus);

    // Animations-Controller für jeden Schritt vorerstellen
    for (int i = 0; i < widget.positions.length; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      _stepControllers.add(ctrl);
      _opacityAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
        ),
      );
      _slideAnimations.add(
        Tween<double>(begin: -30.0, end: 0.0).animate(
          CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
        ),
      );
    }

    if (widget.autoPlay) {
      // Kurze Verzögerung, damit das Widget zuerst gerendert wird
      _timers.add(Timer(const Duration(milliseconds: 200), _playNextStep));
    }
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _pulseController.dispose();
    for (final ctrl in _stepControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  /// Puls-Listener: nach 2 Zyklen Animation abschließen
  void _onPulseStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Einen Reverse-Zyklus laufen lassen
      _pulseController.reverse();
    } else if (status == AnimationStatus.dismissed) {
      // Puls ist abgeschlossen
      if (mounted) {
        setState(() => _pulsing = false);
      }
      widget.onComplete?.call();
    }
  }

  /// Spielt den nächsten Schritt in der Sequenz ab.
  void _playNextStep() {
    if (!mounted) return;
    if (_currentStep >= widget.positions.length) {
      // Alle Schritte abgeschlossen → Puls starten
      setState(() {
        _allShown = true;
        _pulsing = true;
      });
      _pulseController.forward(from: 0.0);
      return;
    }

    // Neue Position zur sichtbaren Liste hinzufügen
    setState(() {
      _visiblePositions.add(widget.positions[_currentStep]);
    });

    // Slide-in-Animation starten
    _stepControllers[_currentStep].forward(from: 0.0);
    _currentStep++;

    // Nächsten Schritt nach 600 ms Einblend-Zeit + 800 ms Pause planen
    _timers.add(
      Timer(const Duration(milliseconds: 1400), _playNextStep),
    );
  }

  /// Setzt die Animation zurück und startet sie neu.
  void _replay() {
    // Alle Timer abbrechen
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();

    // Zustand zurücksetzen
    setState(() {
      _visiblePositions.clear();
      _currentStep = 0;
      _allShown = false;
      _pulsing = false;
    });

    _pulseController.stop();
    _pulseController.reset();
    for (final ctrl in _stepControllers) {
      ctrl.reset();
    }

    // Neu starten
    _timers.add(Timer(const Duration(milliseconds: 200), _playNextStep));
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = widget.positions.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Schrittanzeige: "Finger X von Y"
        _buildStepIndicator(totalSteps),

        const SizedBox(height: 8),

        // Griffbrett mit grünem Pulsrahmen
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final glowOpacity = _pulsing ? _pulseAnimation.value : 0.0;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color.lerp(
                    Colors.transparent,
                    const Color(0xFF4CAF50),
                    glowOpacity,
                  )!,
                  width: 2.5,
                ),
                boxShadow: _pulsing
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4CAF50)
                              .withOpacity(0.4 * glowOpacity),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : const [],
              ),
              child: child,
            );
          },
          child: _buildFretboard(),
        ),

        const SizedBox(height: 16),

        // "Nochmal"-Schaltfläche
        if (_allShown && !_pulsing)
          TextButton.icon(
            onPressed: _replay,
            icon: const Icon(Icons.replay, size: 18),
            label: const Text('Nochmal'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF7C3AED),
            ),
          ),
      ],
    );
  }

  /// Baut die Schrittanzeige ("Finger 2 von 4").
  Widget _buildStepIndicator(int totalSteps) {
    final displayStep = _currentStep.clamp(0, totalSteps);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _allShown
              ? 'Alle Finger platziert'
              : (displayStep == 0
                  ? 'Bereit …'
                  : 'Finger $displayStep von $totalSteps'),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFFB3B3B3),
          ),
        ),
      ],
    );
  }

  Widget _buildFretboard() {
    // Wir stapeln FretboardWidget + animierte Einblendeebene übereinander.
    // Da FretboardWidget intern zeichnet, übergeben wir _visiblePositions direkt.
    // Die letzte hinzugefügte Position wird mit TweenAnimationBuilder animiert.
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          // Basis-Griffbrett mit allen bereits sichtbaren Positionen
          FretboardWidget(
            highlightedPositions: _visiblePositions,
            showFingerNumbers: true,
          ),

          // Animations-Overlay für jede Position
          for (int i = 0; i < _visiblePositions.length; i++)
            if (i < _stepControllers.length)
              AnimatedBuilder(
                animation: _stepControllers[i],
                builder: (context, _) {
                  final opacity = _opacityAnimations[i].value;
                  final slide = _slideAnimations[i].value;
                  // Nur während der Animation ein Overlay zeigen
                  if (opacity >= 0.99) return const SizedBox.shrink();
                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(slide, 0),
                      // Markierung über dem aktuellen Punkt via transparentem Overlay
                      child: FretboardWidget(
                        highlightedPositions: [_visiblePositions[i]],
                        showFingerNumbers: true,
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
