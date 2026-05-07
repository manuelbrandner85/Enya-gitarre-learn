import 'package:flutter/material.dart';

/// Provides finger silhouette paths and drawing helpers for finger indicators
/// on the guitar fretboard.
///
/// Finger numbering:
///   0 = thumb, 1 = index, 2 = middle, 3 = ring, 4 = pinky
class FingerIcons {
  FingerIcons._();

  /// Returns a [Path] representing the silhouette of the given [finger]
  /// centred around [Offset.zero], scaled to fit within [size] × [size].
  ///
  /// [finger] values:
  ///   0 = thumb  – short wide half-arc
  ///   1 = index  – tall thin oval, slightly top-pointed
  ///   2 = middle – tallest oval
  ///   3 = ring   – medium oval
  ///   4 = pinky  – shortest oval
  static Path fingerPath(int finger, double size) {
    final half = size / 2.0;
    final path = Path();

    switch (finger) {
      case 0: // Thumb – short wide half-arc (D-shape rotated sideways)
        {
          final rx = half * 0.95;
          final ry = half * 0.60;
          // Build a half-ellipse (top half = arc from 180° to 0°)
          path.moveTo(-rx, 0);
          path.arcToPoint(
            Offset(rx, 0),
            radius: Radius.elliptical(rx, ry),
            clockwise: false,
          );
          // Flat bottom
          path.lineTo(-rx, 0);
          path.close();
        }
        break;

      case 1: // Index – tall thin oval, top slightly pointed
        {
          final rx = half * 0.38;
          final ry = half * 0.92;
          _pointedOval(path, rx, ry, pointStrength: 0.18);
        }
        break;

      case 2: // Middle – tallest oval
        {
          final rx = half * 0.40;
          final ry = half * 1.00;
          _ovalPath(path, rx, ry);
        }
        break;

      case 3: // Ring – medium oval
        {
          final rx = half * 0.38;
          final ry = half * 0.88;
          _ovalPath(path, rx, ry);
        }
        break;

      case 4: // Pinky – shortest oval
        {
          final rx = half * 0.32;
          final ry = half * 0.70;
          _ovalPath(path, rx, ry);
        }
        break;

      default: // Fallback – plain circle
        path.addOval(Rect.fromCircle(center: Offset.zero, radius: half * 0.5));
    }

    return path;
  }

  /// Draws the finger silhouette at [center] on [canvas], filled with [color]
  /// and outlined with a white 1.5 px stroke.
  static void drawFinger(
    Canvas canvas,
    int finger,
    Offset center,
    double size,
    Color color,
  ) {
    final path = fingerPath(finger, size);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Fill
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // White outline
    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, strokePaint);

    canvas.restore();
  }

  // ────────────────────────────── Private helpers ──────────────────────────────

  /// Plain axis-aligned ellipse centred at origin.
  static void _ovalPath(Path path, double rx, double ry) {
    path.addOval(Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2));
  }

  /// Ellipse with a slight upward point at the top (like a fingertip).
  static void _pointedOval(
    Path path,
    double rx,
    double ry, {
    double pointStrength = 0.15,
  }) {
    // We approximate a pointed-top oval using a cubic bezier.
    final topY = -ry;
    final botY = ry;
    final cpX = rx * 1.0;
    final cpYTop = topY * (1.0 - pointStrength); // pull top control points inward

    path.moveTo(0, topY); // top point
    // Right side: top → bottom
    path.cubicTo(cpX, cpYTop, cpX, -cpYTop, 0, botY);
    // Left side: bottom → top
    path.cubicTo(-cpX, -cpYTop, -cpX, cpYTop, 0, topY);
    path.close();
  }

  // ─────────────────────────── Convenience widget ───────────────────────────

  /// Convenience method: returns a square [CustomPaint] widget that renders
  /// the given finger icon with [color].
  static Widget widget(int finger, double size, Color color) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FingerIconPainter(finger: finger, size: size, color: color),
    );
  }
}

// ────────────────────────────── Internal painter ──────────────────────────────

class _FingerIconPainter extends CustomPainter {
  final int finger;
  final double size;
  final Color color;

  const _FingerIconPainter({
    required this.finger,
    required this.size,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    FingerIcons.drawFinger(
      canvas,
      finger,
      Offset(canvasSize.width / 2, canvasSize.height / 2),
      size,
      color,
    );
  }

  @override
  bool shouldRepaint(_FingerIconPainter old) =>
      old.finger != finger || old.size != size || old.color != color;
}

// ──────────────────────────── Legend row widget ────────────────────────────

/// A horizontal row of four finger icons with German labels.
///
/// Labels: "Zeige" (1), "Mittel" (2), "Ring" (3), "Klein" (4).
class FingerLegendRow extends StatelessWidget {
  final double iconSize;
  final List<Color> fingerColors;

  static const List<String> _labels = ['Zeige', 'Mittel', 'Ring', 'Klein'];
  static const List<int> _fingers = [1, 2, 3, 4];

  const FingerLegendRow({
    super.key,
    this.iconSize = 28.0,
    required this.fingerColors,
  }) : assert(fingerColors.length >= 4, 'Need at least 4 finger colors');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (i) {
        final finger = _fingers[i];
        final color = fingerColors[i];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FingerIcons.widget(finger, iconSize, color),
            const SizedBox(height: 4),
            Text(
              _labels[i],
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$finger',
              style: TextStyle(
                fontSize: 9,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        );
      }),
    );
  }
}
