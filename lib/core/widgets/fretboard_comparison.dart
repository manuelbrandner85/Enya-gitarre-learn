import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../music_theory/note_colors.dart';
import 'fretboard_widget.dart';

/// Überlagert Soll-Positionen (Ziel) und Ist-Positionen (erkannte Note).
/// Grüner Glow wenn korrekt, roter Pfad von Ist zu Soll wenn verschieden.
class FretboardComparison extends StatefulWidget {
  /// Ziel-Positionen, die der Spieler treffen soll
  final List<FretPosition> targetPositions;

  /// Vom Mikrofon erkannte Position (null = noch nichts erkannt)
  final FretPosition? detectedPosition;

  /// Ob das Widget gerade auf eine Eingabe wartet (Mikrofon aktiv)
  final bool isListening;

  const FretboardComparison({
    super.key,
    required this.targetPositions,
    this.detectedPosition,
    this.isListening = false,
  });

  @override
  State<FretboardComparison> createState() => _FretboardComparisonState();
}

class _FretboardComparisonState extends State<FretboardComparison>
    with SingleTickerProviderStateMixin {
  /// Puls-Animation: läuft, solange isListening aktiv ist
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isListening) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FretboardComparison oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Prüft, ob die erkannte Position mit einer Zielposition übereinstimmt
  bool _isMatch() {
    if (widget.detectedPosition == null) return false;
    final det = widget.detectedPosition!;
    return widget.targetPositions.any(
      (t) => t.string == det.string && t.fret == det.fret,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMatch = _isMatch();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Haupt-Vergleichsanzeige
        SizedBox(
          height: 240,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) {
              return Stack(
                children: [
                  // Hintergrund-Griffbrett (nur zur Orientierung, ohne Positionen)
                  FretboardWidget(
                    highlightedPositions: const [],
                    showFingerNumbers: false,
                  ),

                  // Vergleichs-Overlay mit Ziel + Erkannt + Glow/Pfeil
                  CustomPaint(
                    size: const Size(double.infinity, 240),
                    painter: _ComparisonPainter(
                      targetPositions: widget.targetPositions,
                      detectedPosition: widget.detectedPosition,
                      isMatch: isMatch,
                      glowOpacity: _pulseAnimation.value,
                      isListening: widget.isListening,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // "Höre zu…" Statusleiste mit pulsierendem Mikrofon-Icon
        if (widget.isListening && widget.detectedPosition == null)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) {
              return Opacity(
                opacity: _pulseAnimation.value,
                child: const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, color: Color(0xFF7C3AED), size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Höre zu…',
                        style: TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        // Ergebnis-Label: Treffer oder Abweichung
        if (widget.detectedPosition != null) ...[
          const SizedBox(height: 8),
          _buildResultLabel(isMatch),
        ],
      ],
    );
  }

  Widget _buildResultLabel(bool isMatch) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isMatch ? Icons.check_circle : Icons.adjust,
          size: 16,
          color: isMatch ? const Color(0xFF4CAF50) : const Color(0xFFCF6679),
        ),
        const SizedBox(width: 6),
        Text(
          isMatch ? 'Richtig!' : 'Noch nicht ganz – weiter üben!',
          style: TextStyle(
            color: isMatch ? const Color(0xFF4CAF50) : const Color(0xFFCF6679),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// CustomPainter für Soll-/Ist-Überlagerung auf dem Griffbrett
class _ComparisonPainter extends CustomPainter {
  final List<FretPosition> targetPositions;
  final FretPosition? detectedPosition;
  final bool isMatch;

  /// Aktueller Glow-Opazitätswert der Pulsanimation
  final double glowOpacity;
  final bool isListening;

  // Koordinaten-Konstanten passend zum FretboardWidget (_FretboardPainter)
  static const double _leftPadding = 32.0;
  static const double _topPadding = 20.0;
  static const double _rightPadding = 8.0;
  static const double _bottomPadding = 12.0;
  static const int _fretCount = 5;
  static const int _stringCount = 6;

  const _ComparisonPainter({
    required this.targetPositions,
    required this.detectedPosition,
    required this.isMatch,
    required this.glowOpacity,
    required this.isListening,
  });

  /// Berechnet die Canvas-Koordinaten für eine gegebene FretPosition
  Offset _positionToOffset(FretPosition pos, Size size) {
    final fretboardWidth = size.width - _leftPadding - _rightPadding;
    final fretboardHeight = size.height - _topPadding - _bottomPadding;
    final stringSpacing = fretboardHeight / (_stringCount - 1);
    final fretSpacing = fretboardWidth / _fretCount;

    final stringIndex = (pos.string - 1).clamp(0, 5);
    final y = _topPadding + stringIndex * stringSpacing;

    double x;
    if (pos.fret == 0) {
      x = _leftPadding - 14;
    } else {
      final adjustedFret = pos.fret.clamp(1, _fretCount);
      x = _leftPadding + (adjustedFret - 0.5) * fretSpacing;
    }
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Schicht 1: Ziel-Positionen als gefüllte Kreise
    for (final pos in targetPositions) {
      final center = _positionToOffset(pos, size);
      _drawTargetDot(canvas, center, pos, isMatch);
    }

    // Schicht 2: Erkannte Position als gestrichelter Kreis
    if (detectedPosition != null) {
      final detCenter = _positionToOffset(detectedPosition!, size);
      _drawDetectedDot(canvas, detCenter);

      if (!isMatch) {
        // Verbindungslinie (rot gestrichelt) von Erkannt zu Ziel
        final targetCenter = targetPositions.isNotEmpty
            ? _positionToOffset(targetPositions.first, size)
            : detCenter;
        _drawDashedLine(
          canvas,
          detCenter,
          targetCenter,
          const Color(0xFFCF6679),
        );
      }
    }
  }

  /// Zeichnet einen Ziel-Kreis, ggf. mit grünem Glow (bei Treffer)
  void _drawTargetDot(
      Canvas canvas, Offset center, FretPosition pos, bool matched) {
    // Farbe aus pos.color, andernfalls über NoteColors-basierte Finger-Farbe
    final color = _colorForTarget(pos);

    if (matched) {
      // Grüner Glow-Effekt
      final glowPaint = Paint()
        ..color = const Color(0xFF4CAF50).withOpacity(0.45 * glowOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(center, 18, glowPaint);
    }

    final circlePaint = Paint()
      ..color = matched ? const Color(0xFF4CAF50) : color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 11, circlePaint);

    // Finger-Nummer
    if (pos.finger != null) {
      _paintCenteredText(canvas, '${pos.finger}', center, Colors.white, 11);
    }
  }

  /// Zeichnet den erkannten Dot als gestrichelten Kreis (halbopak)
  void _drawDetectedDot(Canvas canvas, Offset center) {
    const color = Color(0xFF90CAF9);
    _drawDashedCircle(canvas, center, 11, color, 0.5);
  }

  /// Zeichnet einen Kreis mit gestricheltem Rand
  void _drawDashedCircle(
      Canvas canvas, Offset center, double radius, Color color, double opacity) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Gestrichelte Linie manuell über Path-Segmente
    const dashCount = 12;
    const dashAngle = 2 * math.pi / dashCount;
    for (int i = 0; i < dashCount; i += 2) {
      final startAngle = i * dashAngle;
      final endAngle = startAngle + dashAngle * 0.7;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  /// Zeichnet eine gestrichelte Linie zwischen zwei Punkten
  void _drawDashedLine(
      Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.85)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    const dashLength = 6.0;
    const gapLength = 4.0;

    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final length = math.sqrt(dx * dx + dy * dy);
    if (length == 0) return;

    final ux = dx / length;
    final uy = dy / length;

    double traveled = 0.0;
    bool drawing = true;

    while (traveled < length) {
      final segLength =
          drawing ? dashLength : gapLength;
      final end = math.min(traveled + segLength, length);
      if (drawing) {
        canvas.drawLine(
          Offset(from.dx + ux * traveled, from.dy + uy * traveled),
          Offset(from.dx + ux * end, from.dy + uy * end),
          paint,
        );
      }
      traveled = end;
      drawing = !drawing;
    }

    // Kleiner Pfeilkopf am Ende (Ziel-Punkt)
    _drawArrowHead(canvas, to, Offset(ux, uy), color);
  }

  void _drawArrowHead(Canvas canvas, Offset tip, Offset dir, Color color) {
    const arrowLen = 7.0;
    const arrowAngle = 0.45;

    final angle = math.atan2(dir.dy, dir.dx);
    final p1 = Offset(
      tip.dx - arrowLen * math.cos(angle - arrowAngle),
      tip.dy - arrowLen * math.sin(angle - arrowAngle),
    );
    final p2 = Offset(
      tip.dx - arrowLen * math.cos(angle + arrowAngle),
      tip.dy - arrowLen * math.sin(angle + arrowAngle),
    );

    final paint = Paint()
      ..color = color.withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  /// Hilfsfunktion: Text zentriert auf einem Offset malen
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

  /// Liefert eine Farbe für eine Zielposition:
  /// Bevorzugt pos.color, dann Finger-Farbe, Fallback über NoteColors (C=Rot usw.)
  Color _colorForTarget(FretPosition pos) {
    if (pos.color != null) return pos.color!;
    return _fingerColorFor(pos.finger);
  }

  /// Liefert eine Standardfarbe anhand der Fingernummer
  Color _fingerColorFor(int? finger) {
    switch (finger) {
      case 1:
        return NoteColors.forNote('G'); // Blau wie Zeigefinger
      case 2:
        return NoteColors.forNote('F'); // Grün wie Mittelfinger
      case 3:
        return NoteColors.forNote('D'); // Orange wie Ringfinger
      case 4:
        return NoteColors.forNote('C'); // Rot wie kleiner Finger
      default:
        return NoteColors.forNote('A'); // Indigo als Fallback
    }
  }

  @override
  bool shouldRepaint(_ComparisonPainter old) =>
      old.targetPositions != targetPositions ||
      old.detectedPosition != detectedPosition ||
      old.isMatch != isMatch ||
      old.glowOpacity != glowOpacity ||
      old.isListening != isListening;
}
