import 'package:flutter/material.dart';

class FretPosition {
  final int string; // 1-6, 1=hohe E, 6=tiefe E
  final int fret; // 0=leer, 1+=Bund
  final int? finger; // 1=Zeigefinger, 2=Mittel, 3=Ring, 4=kleiner
  final Color? color;
  final bool isTarget;
  const FretPosition(
      {required this.string,
      required this.fret,
      this.finger,
      this.color,
      this.isTarget = false});
}

class FretboardWidget extends StatefulWidget {
  final List<FretPosition> highlightedPositions;
  final FretPosition? activePosition;
  final int fretCount;
  final int startFret;
  final bool showFingerNumbers;
  final bool showNoteNames;
  final void Function(int string, int fret)? onTap;

  const FretboardWidget({
    super.key,
    required this.highlightedPositions,
    this.activePosition,
    this.fretCount = 5,
    this.startFret = 0,
    this.showFingerNumbers = true,
    this.showNoteNames = false,
    this.onTap,
  });

  // Hilfsmethoden für Notenpositionen
  static List<FretPosition> positionsForNote(String noteName) {
    switch (noteName) {
      case 'E2':
        return [const FretPosition(string: 6, fret: 0)];
      case 'F2':
        return [const FretPosition(string: 6, fret: 1)];
      case 'G2':
        return [const FretPosition(string: 6, fret: 3)];
      case 'A2':
        return [const FretPosition(string: 5, fret: 0)];
      case 'B2':
        return [const FretPosition(string: 5, fret: 2)];
      case 'C3':
        return [const FretPosition(string: 5, fret: 3)];
      case 'D3':
        return [const FretPosition(string: 4, fret: 0)];
      case 'E3':
        return [const FretPosition(string: 4, fret: 2)];
      case 'F3':
        return [const FretPosition(string: 4, fret: 3)];
      case 'G3':
        return [const FretPosition(string: 3, fret: 0)];
      case 'A3':
        return [const FretPosition(string: 3, fret: 2)];
      case 'B3':
        return [const FretPosition(string: 2, fret: 0)];
      case 'C4':
        return [const FretPosition(string: 2, fret: 1, finger: 1)];
      case 'D4':
        return [const FretPosition(string: 2, fret: 3, finger: 3)];
      case 'E4':
        return [const FretPosition(string: 1, fret: 0)];
      default:
        return [];
    }
  }

  static List<FretPosition> positionsForChord(String chordName) {
    switch (chordName) {
      case 'Em':
        return [
          const FretPosition(string: 5, fret: 2, finger: 2),
          const FretPosition(string: 4, fret: 2, finger: 3),
        ];
      case 'Am':
        return [
          const FretPosition(string: 4, fret: 2, finger: 2),
          const FretPosition(string: 3, fret: 2, finger: 3),
          const FretPosition(string: 2, fret: 1, finger: 1),
        ];
      case 'D':
        return [
          const FretPosition(string: 3, fret: 2, finger: 1),
          const FretPosition(string: 2, fret: 3, finger: 3),
          const FretPosition(string: 1, fret: 2, finger: 2),
        ];
      case 'G':
        return [
          const FretPosition(string: 6, fret: 3, finger: 2),
          const FretPosition(string: 5, fret: 2, finger: 1),
          const FretPosition(string: 1, fret: 3, finger: 3),
        ];
      case 'C':
        return [
          const FretPosition(string: 5, fret: 3, finger: 3),
          const FretPosition(string: 4, fret: 2, finger: 2),
          const FretPosition(string: 2, fret: 1, finger: 1),
        ];
      case 'A':
        return [
          const FretPosition(string: 4, fret: 2, finger: 1),
          const FretPosition(string: 3, fret: 2, finger: 2),
          const FretPosition(string: 2, fret: 2, finger: 3),
        ];
      case 'E':
        return [
          const FretPosition(string: 5, fret: 2, finger: 2),
          const FretPosition(string: 4, fret: 2, finger: 3),
          const FretPosition(string: 3, fret: 1, finger: 1),
        ];
      case 'F':
        return [
          const FretPosition(string: 6, fret: 1, finger: 1),
          const FretPosition(string: 5, fret: 1, finger: 1),
          const FretPosition(string: 4, fret: 3, finger: 3),
          const FretPosition(string: 3, fret: 3, finger: 4),
          const FretPosition(string: 2, fret: 2, finger: 2),
          const FretPosition(string: 1, fret: 1, finger: 1),
        ];
      case 'Bm':
        return [
          const FretPosition(string: 5, fret: 2, finger: 1),
          const FretPosition(string: 4, fret: 4, finger: 3),
          const FretPosition(string: 3, fret: 4, finger: 4),
          const FretPosition(string: 2, fret: 3, finger: 2),
          const FretPosition(string: 1, fret: 2, finger: 1),
        ];
      default:
        return [];
    }
  }

  @override
  State<FretboardWidget> createState() => _FretboardWidgetState();
}

class _FretboardWidgetState extends State<FretboardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, _) {
        return GestureDetector(
          onTapDown: widget.onTap == null
              ? null
              : (details) {
                  // Tap-Erkennung via Position
                },
          child: CustomPaint(
            size: const Size(double.infinity, 160),
            painter: _FretboardPainter(
              highlightedPositions: widget.highlightedPositions,
              activePosition: widget.activePosition,
              fretCount: widget.fretCount,
              startFret: widget.startFret,
              showFingerNumbers: widget.showFingerNumbers,
              glowOpacity: _glowAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class _FretboardPainter extends CustomPainter {
  final List<FretPosition> highlightedPositions;
  final FretPosition? activePosition;
  final int fretCount;
  final int startFret;
  final bool showFingerNumbers;
  final double glowOpacity;

  static const List<double> _stringThicknesses = [
    1.0,
    1.2,
    1.5,
    1.8,
    2.2,
    2.8
  ];
  static const List<String> _stringNames = ['e', 'B', 'G', 'D', 'A', 'E'];
  static const List<Color> _fingerColors = [
    Color(0xFF2196F3), // 1: blau
    Color(0xFF4CAF50), // 2: grün
    Color(0xFFFF9800), // 3: orange
    Color(0xFFF44336), // 4: rot
  ];

  const _FretboardPainter({
    required this.highlightedPositions,
    required this.activePosition,
    required this.fretCount,
    required this.startFret,
    required this.showFingerNumbers,
    required this.glowOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 32.0;
    const topPadding = 20.0;
    const bottomPadding = 12.0;
    const rightPadding = 8.0;

    final fretboardWidth = size.width - leftPadding - rightPadding;
    final fretboardHeight = size.height - topPadding - bottomPadding;
    final stringSpacing = fretboardHeight / 5;
    final fretSpacing = fretboardWidth / fretCount;

    // Hintergrund
    final bgPaint = Paint()..color = const Color(0xFF2D1B00);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(leftPadding, topPadding, fretboardWidth, fretboardHeight),
        const Radius.circular(4),
      ),
      bgPaint,
    );

    // Sattel (Bund 0 links)
    final saddlePaint = Paint()
      ..color = const Color(0xFFE8D5A3)
      ..strokeWidth = startFret == 0 ? 4 : 2;
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, topPadding + fretboardHeight),
      saddlePaint,
    );

    // Bundstäbe
    final fretPaint = Paint()
      ..color = const Color(0xFFAA8855)
      ..strokeWidth = 1.5;
    for (int f = 1; f <= fretCount; f++) {
      final x = leftPadding + f * fretSpacing;
      canvas.drawLine(
          Offset(x, topPadding), Offset(x, topPadding + fretboardHeight), fretPaint);
    }

    // Inlay-Dots
    final inlayFrets = <int>[3, 5, 7, 9];
    final dotPaint = Paint()
      ..color = const Color(0xFF8B6914).withOpacity(0.5);
    for (final f in inlayFrets) {
      if (f >= startFret + 1 && f <= startFret + fretCount) {
        final fretIdx = f - startFret;
        final x = leftPadding + (fretIdx - 0.5) * fretSpacing;
        final y = topPadding + fretboardHeight / 2;
        canvas.drawCircle(Offset(x, y), 4, dotPaint);
      }
    }

    // Saiten
    for (int s = 0; s < 6; s++) {
      final y = topPadding + s * stringSpacing;
      final stringPaint = Paint()
        ..color = const Color(0xFFE0C080)
        ..strokeWidth = _stringThicknesses[s];
      canvas.drawLine(
          Offset(leftPadding, y), Offset(leftPadding + fretboardWidth, y), stringPaint);

      // Saiten-Name links
      final textPainter = TextPainter(
        text: TextSpan(
          text: _stringNames[s],
          style: const TextStyle(
              color: Color(0xFF888888), fontSize: 10, fontFamily: 'monospace'),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(2, y - textPainter.height / 2));
    }

    // Bund-Nummern oben
    for (int f = 0; f <= fretCount; f++) {
      final fretNum = startFret + f;
      if (fretNum == 0) continue;
      final x = leftPadding + (f - 0.5) * fretSpacing;
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$fretNum',
          style: const TextStyle(color: Color(0xFF666666), fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, 2));
    }

    // Finger-Positionen zeichnen
    for (final pos in highlightedPositions) {
      _drawFingerDot(canvas, pos, leftPadding, topPadding, fretSpacing,
          stringSpacing, false);
    }
    if (activePosition != null) {
      _drawFingerDot(canvas, activePosition!, leftPadding, topPadding,
          fretSpacing, stringSpacing, true);
    }
  }

  void _drawFingerDot(Canvas canvas, FretPosition pos, double leftPadding,
      double topPadding, double fretSpacing, double stringSpacing, bool isActive) {
    final stringIndex = pos.string - 1;
    if (stringIndex < 0 || stringIndex > 5) return;

    final y = topPadding + stringIndex * stringSpacing;
    double x;
    if (pos.fret == 0) {
      x = leftPadding - 14;
    } else {
      final adjustedFret = pos.fret - startFret;
      if (adjustedFret < 1 || adjustedFret > fretCount) return;
      x = leftPadding + (adjustedFret - 0.5) * fretSpacing;
    }

    final fingerIndex = (pos.finger ?? 1) - 1;
    final color = pos.color ??
        (fingerIndex >= 0 && fingerIndex < 4
            ? _fingerColors[fingerIndex]
            : Colors.white);

    // Glow für aktive Position
    if (isActive) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3 * glowOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(x, y), 16, glowPaint);
    }

    // Kreis
    final circlePaint = Paint()..color = color;
    canvas.drawCircle(Offset(x, y), 10, circlePaint);

    // Finger-Nummer
    if (showFingerNumbers && pos.finger != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${pos.finger}',
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(_FretboardPainter old) =>
      old.glowOpacity != glowOpacity ||
      old.highlightedPositions != highlightedPositions ||
      old.activePosition != activePosition;
}
