import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'fretboard_widget.dart';

/// Animiert den Übergang von einem Akkord zum nächsten.
/// Jeder Finger bewegt sich einzeln von alter zu neuer Position.
class ChordTransitionWidget extends StatefulWidget {
  /// Ausgangs-Akkord (Startpositionen der Finger)
  final List<FretPosition> fromChord;

  /// Ziel-Akkord (Endpositionen der Finger)
  final List<FretPosition> toChord;

  /// Geschwindigkeitsfaktor: 0.25 = sehr langsam, 1.0 = normal
  final double speedMultiplier;

  /// Ob die Animation mit dem Metronom synchronisiert wird (Platzhalter)
  final bool syncWithMetronome;

  /// Wird aufgerufen, sobald die Animation vollständig abgeschlossen ist
  final VoidCallback? onComplete;

  const ChordTransitionWidget({
    super.key,
    required this.fromChord,
    required this.toChord,
    this.speedMultiplier = 1.0,
    this.syncWithMetronome = false,
    this.onComplete,
  });

  @override
  State<ChordTransitionWidget> createState() => _ChordTransitionWidgetState();
}

class _ChordTransitionWidgetState extends State<ChordTransitionWidget>
    with TickerProviderStateMixin {
  /// Haupt-AnimationController für den Gesamtfortschritt
  late AnimationController _mainController;

  /// Gestaffelte Animationen: eine pro Finger (200 ms Dauer, 100 ms Versatz)
  final List<Animation<double>> _fingerAnimations = [];

  /// Aktueller Geschwindigkeitsmultiplikator (über Slider veränderbar)
  late double _currentSpeed;

  /// Ob eine Animation läuft
  bool _isPlaying = false;

  /// Ob _mainController bereits initialisiert wurde
  bool _controllerInitialized = false;

  // ─── Verfügbare Geschwindigkeitsstufen ────────────────────────────────────
  static const List<double> _speedValues = [0.25, 0.5, 1.0];

  @override
  void initState() {
    super.initState();
    _currentSpeed = widget.speedMultiplier.clamp(0.25, 1.0);
    _buildAnimations();
  }

  /// Erstellt die AnimationController und staggered Animations neu.
  void _buildAnimations() {
    if (_controllerInitialized) {
      _mainController.dispose();
    }

    final fingerCount =
        math.max(widget.fromChord.length, widget.toChord.length);

    // Gesamtdauer: 200 ms × Finger + 100 ms Versatz × (Finger-1), skaliert
    final totalMs = fingerCount > 0
        ? ((200 + 100 * (fingerCount - 1)) / _currentSpeed).round()
        : 400;

    _mainController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    )..addStatusListener(_onAnimationStatus);
    _controllerInitialized = true;

    _fingerAnimations.clear();

    // Für jeden Finger eine eigene Animation mit Versatz erstellen
    for (int i = 0; i < fingerCount; i++) {
      final startFraction =
          fingerCount > 1 ? (i * 100.0 / totalMs) : 0.0;
      final endFraction = math.min(
        startFraction + (200.0 / totalMs),
        1.0,
      );

      _fingerAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: Interval(startFraction, endFraction, curve: Curves.easeInOut),
          ),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(ChordTransitionWidget old) {
    super.didUpdateWidget(old);
    if (old.speedMultiplier != widget.speedMultiplier ||
        old.fromChord != widget.fromChord ||
        old.toChord != widget.toChord) {
      _currentSpeed = widget.speedMultiplier.clamp(0.25, 1.0);
      _buildAnimations();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (mounted) setState(() => _isPlaying = false);
      widget.onComplete?.call();
    }
  }

  void _play() {
    _mainController.forward(from: 0.0);
    setState(() => _isPlaying = true);
  }

  void _stop() {
    _mainController.stop();
    setState(() => _isPlaying = false);
  }

  /// Gibt den Slider-Wert (0..2) für die Geschwindigkeit zurück
  double get _sliderValue =>
      _speedValues.indexOf(_currentSpeed).toDouble().clamp(0, 2);

  void _onSpeedChanged(double value) {
    final idx = value.round().clamp(0, 2);
    final newSpeed = _speedValues[idx];
    if (newSpeed != _currentSpeed) {
      setState(() {
        _currentSpeed = newSpeed;
        _buildAnimations();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Griffbrett mit animierten Fingerpositionen
        SizedBox(
          height: 180,
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, _) {
              return CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _TransitionPainter(
                  fromPositions: widget.fromChord,
                  toPositions: widget.toChord,
                  fingerAnimations: _fingerAnimations,
                  animationProgress: _mainController.value,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Geschwindigkeits-Regler
        _buildSpeedSlider(),

        const SizedBox(height: 12),

        // Steuerungsschaltflächen
        _buildControls(),
      ],
    );
  }

  /// Geschwindigkeits-Slider: Schildkröte ← Schieber → Hase
  Widget _buildSpeedSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.speed, size: 18, color: Color(0xFF9E9E9E)),
          const SizedBox(width: 4),
          const Text(
            'Langsam',
            style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
          ),
          Expanded(
            child: Slider(
              value: _sliderValue,
              min: 0,
              max: 2,
              divisions: 2,
              activeColor: const Color(0xFF7C3AED),
              onChanged: _isPlaying ? null : _onSpeedChanged,
            ),
          ),
          const Text(
            'Schnell',
            style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.flash_on, size: 18, color: Color(0xFF9E9E9E)),
        ],
      ),
    );
  }

  /// Abspielen/Stop-Schaltflächen
  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _isPlaying ? null : _play,
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text('Abspielen'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF4A2D8A),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _isPlaying ? _stop : null,
          icon: const Icon(Icons.stop, size: 18),
          label: const Text('Stop'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF7C3AED),
            side: const BorderSide(color: Color(0xFF7C3AED)),
          ),
        ),
      ],
    );
  }
}

/// Zeichnet interpolierte Finger-Positionen während des Übergangs
class _TransitionPainter extends CustomPainter {
  final List<FretPosition> fromPositions;
  final List<FretPosition> toPositions;

  /// Eine Animation (0..1) pro Finger-Slot (gestaffelt)
  final List<Animation<double>> fingerAnimations;

  /// Gesamtfortschritt der Hauptanimation (0..1)
  final double animationProgress;

  // Koordinaten-Konstanten passend zu _FretboardPainter
  static const double _leftPadding = 32.0;
  static const double _topPadding = 20.0;
  static const double _rightPadding = 8.0;
  static const double _bottomPadding = 12.0;
  static const int _fretCount = 5;
  static const int _stringCount = 6;

  // Farben für die 4 Finger
  static const List<Color> _fingerColors = [
    Color(0xFF2196F3), // 1: blau
    Color(0xFF4CAF50), // 2: grün
    Color(0xFFFF9800), // 3: orange
    Color(0xFFF44336), // 4: rot
  ];

  const _TransitionPainter({
    required this.fromPositions,
    required this.toPositions,
    required this.fingerAnimations,
    required this.animationProgress,
  });

  /// Berechnet Canvas-Koordinaten für Saite/Bund
  Offset _toCanvasOffset(int string, int fret, Size size) {
    final fretboardWidth = size.width - _leftPadding - _rightPadding;
    final fretboardHeight = size.height - _topPadding - _bottomPadding;
    final stringSpacing = fretboardHeight / (_stringCount - 1);
    final fretSpacing = fretboardWidth / _fretCount;

    final stringIndex = (string - 1).clamp(0, 5);
    final y = _topPadding + stringIndex * stringSpacing;
    double x;
    if (fret == 0) {
      x = _leftPadding - 14;
    } else {
      x = _leftPadding + (fret.clamp(1, _fretCount) - 0.5) * fretSpacing;
    }
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawFretboard(canvas, size);

    // Maximale Finger-Anzahl über beide Akkorde
    final maxFingers =
        math.max(fromPositions.length, toPositions.length);

    for (int i = 0; i < maxFingers; i++) {
      final progress =
          i < fingerAnimations.length ? fingerAnimations[i].value : 0.0;

      final hasFrom = i < fromPositions.length;
      final hasTo = i < toPositions.length;

      if (hasFrom && hasTo) {
        // Finger existiert in beiden Akkorden: interpoliere Position
        final from = fromPositions[i];
        final to = toPositions[i];
        _drawMovingFinger(canvas, size, from, to, progress, i);
      } else if (hasFrom && !hasTo) {
        // Finger fällt weg: ausblenden
        final from = fromPositions[i];
        final opacity = (1.0 - progress).clamp(0.0, 1.0);
        _drawStaticFinger(canvas, size, from, opacity, i);
      } else if (!hasFrom && hasTo) {
        // Neuer Finger: einblenden
        _drawStaticFinger(canvas, size, toPositions[i], progress, i);
      }
    }

    // Nach Abschluss der Animation: Ziel-Akkord vollständig anzeigen
    if (animationProgress >= 1.0) {
      for (int i = 0; i < toPositions.length; i++) {
        _drawStaticFinger(canvas, size, toPositions[i], 1.0, i);
      }
    }
  }

  /// Zeichnet einen bewegten Finger mit Richtungspfeil
  void _drawMovingFinger(Canvas canvas, Size size, FretPosition from,
      FretPosition to, double progress, int index) {
    final fromOffset = _toCanvasOffset(from.string, from.fret, size);
    final toOffset = _toCanvasOffset(to.string, to.fret, size);

    // Lineare Interpolation der Canvas-Koordinaten
    final currentOffset = Offset.lerp(fromOffset, toOffset, progress)!;

    final color = _colorForFinger(from.finger ?? (index + 1));

    // Glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(currentOffset, 14, glowPaint);

    // Hauptkreis
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(currentOffset, 10, circlePaint);

    // Fingernummer
    if (to.finger != null) {
      _paintCenteredText(
          canvas, '${to.finger}', currentOffset, Colors.white, 11);
    }

    // Richtungspfeil (nur wenn Bewegung stattfindet und progress < 0.95)
    if (progress > 0.02 && progress < 0.95) {
      final dx = toOffset.dx - fromOffset.dx;
      final dy = toOffset.dy - fromOffset.dy;
      final dist = math.sqrt(dx * dx + dy * dy);
      if (dist > 2) {
        _drawMovementArrow(canvas, currentOffset, Offset(dx / dist, dy / dist),
            color);
      }
    }
  }

  /// Zeichnet einen kleinen Bewegungspfeil
  void _drawMovementArrow(
      Canvas canvas, Offset from, Offset dir, Color color) {
    const arrowLen = 14.0;
    const headLen = 6.0;
    const headAngle = 0.45;

    final tipX = from.dx + dir.dx * arrowLen;
    final tipY = from.dy + dir.dy * arrowLen;
    final tip = Offset(tipX, tipY);
    final tailX = from.dx + dir.dx * (arrowLen - 6);
    final tailY = from.dy + dir.dy * (arrowLen - 6);

    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(tailX, tailY), tip, paint);

    final angle = math.atan2(dir.dy, dir.dx);
    final p1 = Offset(
      tipX - headLen * math.cos(angle - headAngle),
      tipY - headLen * math.sin(angle - headAngle),
    );
    final p2 = Offset(
      tipX - headLen * math.cos(angle + headAngle),
      tipY - headLen * math.sin(angle + headAngle),
    );

    final headPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(
      Path()
        ..moveTo(tipX, tipY)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close(),
      headPaint,
    );
  }

  /// Zeichnet einen statischen Finger mit gegebener Opazität
  void _drawStaticFinger(
      Canvas canvas, Size size, FretPosition pos, double opacity, int index) {
    if (opacity <= 0.01) return;
    final offset = _toCanvasOffset(pos.string, pos.fret, size);
    final color = _colorForFinger(pos.finger ?? (index + 1));

    final circlePaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, 10, circlePaint);

    if (pos.finger != null && opacity > 0.5) {
      _paintCenteredText(
          canvas, '${pos.finger}', offset, Colors.white.withOpacity(opacity), 11);
    }
  }

  /// Zeichnet das einfache Griffbrett als Hintergrund
  void _drawFretboard(Canvas canvas, Size size) {
    final fretboardWidth = size.width - _leftPadding - _rightPadding;
    final fretboardHeight = size.height - _topPadding - _bottomPadding;
    final stringSpacing = fretboardHeight / (_stringCount - 1);
    final fretSpacing = fretboardWidth / _fretCount;

    // Hintergrund
    final bgPaint = Paint()..color = const Color(0xFF2D1B00);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_leftPadding, _topPadding, fretboardWidth, fretboardHeight),
        const Radius.circular(4),
      ),
      bgPaint,
    );

    // Sattel
    final saddlePaint = Paint()
      ..color = const Color(0xFFE8D5A3)
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(_leftPadding, _topPadding),
      Offset(_leftPadding, _topPadding + fretboardHeight),
      saddlePaint,
    );

    // Bundstäbe
    final fretPaint = Paint()
      ..color = const Color(0xFFAA8855)
      ..strokeWidth = 1.5;
    for (int f = 1; f <= _fretCount; f++) {
      final x = _leftPadding + f * fretSpacing;
      canvas.drawLine(
        Offset(x, _topPadding),
        Offset(x, _topPadding + fretboardHeight),
        fretPaint,
      );
    }

    // Saiten
    final stringThicknesses = [1.0, 1.2, 1.5, 1.8, 2.2, 2.8];
    for (int s = 0; s < _stringCount; s++) {
      final y = _topPadding + s * stringSpacing;
      final stringPaint = Paint()
        ..color = const Color(0xFFE0C080)
        ..strokeWidth = stringThicknesses[s];
      canvas.drawLine(
        Offset(_leftPadding, y),
        Offset(_leftPadding + fretboardWidth, y),
        stringPaint,
      );
    }
  }

  Color _colorForFinger(int finger) {
    final idx = (finger - 1).clamp(0, _fingerColors.length - 1);
    return _fingerColors[idx];
  }

  void _paintCenteredText(
      Canvas canvas, String text, Offset center, Color color, double fontSize) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(_TransitionPainter old) =>
      old.animationProgress != animationProgress ||
      old.fromPositions != fromPositions ||
      old.toPositions != toPositions;
}
