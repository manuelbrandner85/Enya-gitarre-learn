import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Richtung des Anschlags
enum StrumDirection { down, up, muted }

/// Anschlagstechnik
enum StrumStyle { pick, fingerstyle, hybrid }

/// Finger der rechten Hand (klassische Notation)
enum PickingFinger {
  p, // Daumen (Pulgar)
  i, // Zeigefinger (Índice)
  m, // Mittelfinger (Medio)
  a, // Ringfinger (Anular)
}

/// Stilisierte rechte Hand. Zeigt Anschlag-Richtung und -Technik.
class StrumHandWidget extends StatefulWidget {
  /// Anschlagsrichtung: runter, hoch oder gedämpft
  final StrumDirection direction;

  /// Anschlagstechnik: Plektrum, Fingerpicking oder Hybrid
  final StrumStyle style;

  /// Bei Fingerstyle: welche Finger aktiv (beleuchtet) sind
  final Set<PickingFinger> activeFingers;

  /// Ob die Bewegungsanimation laufen soll
  final bool isAnimating;

  /// Gesamtgröße des Widgets (quadratisch)
  final double size;

  const StrumHandWidget({
    super.key,
    required this.direction,
    this.style = StrumStyle.fingerstyle,
    this.activeFingers = const {},
    this.isAnimating = false,
    this.size = 80,
  });

  @override
  State<StrumHandWidget> createState() => _StrumHandWidgetState();
}

class _StrumHandWidgetState extends State<StrumHandWidget>
    with SingleTickerProviderStateMixin {
  /// Controller für die Pfeilbewegung (10 px auf/ab, 200 ms Periode)
  late final AnimationController _arrowController;
  late final Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _arrowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    if (widget.isAnimating) {
      _arrowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(StrumHandWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _arrowController.repeat(reverse: true);
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _arrowController.stop();
      _arrowController.reset();
    }
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _arrowAnimation,
        builder: (context, _) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _StrumHandPainter(
              direction: widget.direction,
              style: widget.style,
              activeFingers: widget.activeFingers,
              arrowOffset: widget.isAnimating ? _arrowAnimation.value : 0.0,
            ),
          );
        },
      ),
    );
  }
}

/// CustomPainter für die stilisierte Hand-Darstellung
class _StrumHandPainter extends CustomPainter {
  final StrumDirection direction;
  final StrumStyle style;
  final Set<PickingFinger> activeFingers;

  /// Aktuelle y-Verschiebung des Richtungspfeils (Animation)
  final double arrowOffset;

  // Farben
  static const Color _skinColor = Color(0xFFFFDBA4);
  static const Color _skinDark = Color(0xFFE8B87A);
  static const Color _pickColor = Color(0xFFE0C040);
  static const Color _arrowColor = Color(0xFF7C3AED);
  static const Color _activeFingerColor = Color(0xFF2196F3);
  static const Color _inactiveFingerColor = Color(0xFF9E9E9E);
  static const Color _labelColor = Color(0xFF424242);

  const _StrumHandPainter({
    required this.direction,
    required this.style,
    required this.activeFingers,
    required this.arrowOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width / 80.0; // Normalisierung auf 80-px-Basisgröße

    canvas.save();
    canvas.scale(scale);
    final baseSize = 80.0;

    _drawHand(canvas, baseSize);
    _drawFingerLabels(canvas, baseSize);

    if (style == StrumStyle.pick || style == StrumStyle.hybrid) {
      _drawPick(canvas, baseSize);
    }

    _drawDirectionArrow(canvas, baseSize);
    canvas.restore();
  }

  /// Zeichnet den Handumriss: ovale Handfläche + 4 Fingerhöcker + Daumen
  void _drawHand(Canvas canvas, double size) {
    final paint = Paint()
      ..color = _skinColor
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = _skinDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Handfläche: abgerundetes Rechteck, mittig im oberen Bereich
    final palmRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(18, 28, 40, 30),
      const Radius.circular(8),
    );
    canvas.drawRRect(palmRect, paint);
    canvas.drawRRect(palmRect, outlinePaint);

    // 4 Finger (i, m, a, kleiner) als abgerundete Rechtecke oben
    // Finger-Positionen: i=24, m=32, a=40, kleiner=48
    const fingerXPositions = [22.0, 30.0, 38.0, 46.0];
    const fingerLabels = [
      PickingFinger.i,
      PickingFinger.m,
      PickingFinger.a,
      // kleiner Finger ist kein PickingFinger, wird als inaktiv behandelt
    ];

    for (int idx = 0; idx < 4; idx++) {
      final fx = fingerXPositions[idx];
      PickingFinger? finger;
      if (idx < fingerLabels.length) finger = fingerLabels[idx];

      // Fingerhöhe variiert leicht (natürliche Kurve)
      final fingerHeights = [22.0, 24.0, 22.0, 18.0];
      final fingerHeight = fingerHeights[idx];
      final fingerTop = 28.0 - fingerHeight;

      final isActive = finger != null && activeFingers.contains(finger);
      final fingerColor =
          style == StrumStyle.fingerstyle || style == StrumStyle.hybrid
              ? (isActive ? _activeFingerColor : _skinColor)
              : _skinColor;

      final fingerPaint = Paint()
        ..color = fingerColor
        ..style = PaintingStyle.fill;

      final fingerRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(fx, fingerTop, 7, fingerHeight),
        const Radius.circular(3),
      );
      canvas.drawRRect(fingerRect, fingerPaint);
      canvas.drawRRect(fingerRect, outlinePaint);
    }

    // Daumen links: kleiner ovaler Bumper
    final thumbPaint = Paint()
      ..color = activeFingers.contains(PickingFinger.p)
          ? _activeFingerColor
          : _skinColor
      ..style = PaintingStyle.fill;
    final thumbRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(10, 34, 10, 14),
      const Radius.circular(5),
    );
    canvas.drawRRect(thumbRect, thumbPaint);
    canvas.drawRRect(thumbRect, outlinePaint);
  }

  /// Beschriftung unterhalb der Fingerhöcker: p, i, m, a
  void _drawFingerLabels(Canvas canvas, double size) {
    const labels = ['p', 'i', 'm', 'a'];
    const xPositions = [14.0, 24.0, 32.0, 40.0, 48.0];

    // Daumen-Label "p"
    _paintLabel(canvas, 'p', xPositions[0], 50.0);

    // Finger-Labels i, m, a + kleiner
    for (int i = 0; i < 4; i++) {
      final label = i < labels.length - 1 ? labels[i + 1] : '';
      if (label.isNotEmpty) {
        _paintLabel(canvas, label, xPositions[i + 1], 50.0);
      }
    }
  }

  void _paintLabel(Canvas canvas, String text, double x, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: _labelColor,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y));
  }

  /// Zeichnet ein kleines Plektrum-Dreieck zwischen Daumen und Zeigefinger
  void _drawPick(Canvas canvas, double size) {
    final pickPaint = Paint()
      ..color = _pickColor
      ..style = PaintingStyle.fill;
    final pickOutline = Paint()
      ..color = const Color(0xFFA08820)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Dreieck: Spitze nach unten, zwischen Daumen (x≈18) und Zeigefinger (x≈24)
    final path = Path()
      ..moveTo(18, 38)
      ..lineTo(24, 38)
      ..lineTo(21, 44)
      ..close();

    canvas.drawPath(path, pickPaint);
    canvas.drawPath(path, pickOutline);
  }

  /// Zeichnet Richtungspfeil unterhalb der Hand (mit arrowOffset-Animation)
  void _drawDirectionArrow(Canvas canvas, double size) {
    if (direction == StrumDirection.muted) {
      _drawMutedX(canvas);
      return;
    }

    final paint = Paint()
      ..color = _arrowColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = _arrowColor
      ..style = PaintingStyle.fill;

    // Basis-y des Pfeils: unterhalb der Handfläche
    final baseY = direction == StrumDirection.down
        ? 62.0 + arrowOffset
        : 62.0 - arrowOffset;

    if (direction == StrumDirection.down) {
      // Pfeil nach unten: Linie + Pfeilkopf
      canvas.drawLine(
        Offset(40, baseY - 6),
        Offset(40, baseY + 6),
        paint,
      );
      final arrowHead = Path()
        ..moveTo(35, baseY + 2)
        ..lineTo(40, baseY + 8)
        ..lineTo(45, baseY + 2)
        ..close();
      canvas.drawPath(arrowHead, fillPaint);
    } else {
      // Pfeil nach oben: Linie + Pfeilkopf
      canvas.drawLine(
        Offset(40, baseY + 6),
        Offset(40, baseY - 6),
        paint,
      );
      final arrowHead = Path()
        ..moveTo(35, baseY - 2)
        ..lineTo(40, baseY - 8)
        ..lineTo(45, baseY - 2)
        ..close();
      canvas.drawPath(arrowHead, fillPaint);
    }
  }

  /// Zeichnet ein X für "gedämpft"
  void _drawMutedX(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFCF6679)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(34, 62), const Offset(46, 74), paint);
    canvas.drawLine(const Offset(46, 62), const Offset(34, 74), paint);
  }

  @override
  bool shouldRepaint(_StrumHandPainter old) =>
      old.direction != direction ||
      old.style != style ||
      old.activeFingers != activeFingers ||
      old.arrowOffset != arrowOffset;
}
