import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../music_theory/note_colors.dart';

/// Position auf dem Griffbrett: `string` 1=hohe E, 6=tiefe E. `fret` 0=leer.
class FretPosition {
  final int string; // 1..6
  final int fret; // 0..22
  const FretPosition({required this.string, required this.fret});

  /// Standard-Stimmung E A D G B E (von tief 6 bis hoch 1).
  static const List<List<String>> standardTuning = [
    // Index 0..5 = Saite 1..6 ; jede Liste enthält [Wurzelnote, MIDI-Offset von E2]
    ['E', '4'], // Saite 1 = hohe E (E4)
    ['B', '3'],
    ['G', '3'],
    ['D', '3'],
    ['A', '2'],
    ['E', '2'], // Saite 6 = tiefe E (E2)
  ];

  /// Liefert den Notennamen (ohne Oktave) an dieser Position.
  String get noteName {
    const semitoneNames = [
      'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
    ];
    // Offene Saiten-Wurzelnoten (Saite 1 → 6 = E B G D A E)
    const openSemitones = [4, 11, 7, 2, 9, 4]; // 0=C, 4=E, 11=B, ...
    final base = openSemitones[string - 1];
    final idx = (base + fret) % 12;
    return semitoneNames[idx];
  }
}

/// Visualisiert ein 6-Saiten-Griffbrett (5 Bünde sichtbar) und markiert
/// optional eine Position. Klickbar, falls onPositionTap gesetzt.
class FretboardQuizWidget extends StatelessWidget {
  /// Markierte Position (Highlight).
  final FretPosition? highlight;

  /// Falls gesetzt, bekommt jeder klickbare Bund einen Tap-Callback.
  final ValueChanged<FretPosition>? onPositionTap;

  /// Erster sichtbarer Bund (für Scroll). Default 0.
  final int startFret;

  /// Anzahl sichtbarer Bünde. Default 5.
  final int fretCount;

  /// Anzeige-Höhe. Default 200.
  final double height;

  const FretboardQuizWidget({
    super.key,
    this.highlight,
    this.onPositionTap,
    this.startFret = 0,
    this.fretCount = 5,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: height,
          width: width,
          child: GestureDetector(
            onTapDown: onPositionTap == null
                ? null
                : (details) {
                    final pos =
                        _hitTest(details.localPosition, width, height);
                    if (pos != null) onPositionTap!(pos);
                  },
            child: CustomPaint(
              painter: _FretboardPainter(
                highlight: highlight,
                startFret: startFret,
                fretCount: fretCount,
              ),
              size: Size(width, height),
            ),
          ),
        );
      },
    );
  }

  FretPosition? _hitTest(Offset pos, double w, double h) {
    final fretWidth = w / fretCount;
    final stringHeight = h / 6;
    final fretIdx = (pos.dx / fretWidth).floor();
    final stringIdx = (pos.dy / stringHeight).floor();
    if (fretIdx < 0 || fretIdx >= fretCount) return null;
    if (stringIdx < 0 || stringIdx >= 6) return null;
    return FretPosition(
      string: stringIdx + 1,
      fret: startFret + fretIdx,
    );
  }
}

class _FretboardPainter extends CustomPainter {
  final FretPosition? highlight;
  final int startFret;
  final int fretCount;

  _FretboardPainter({
    required this.highlight,
    required this.startFret,
    required this.fretCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fretWidth = size.width / fretCount;
    final stringSpacing = size.height / 6;

    // Hintergrund
    final bgPaint = Paint()
      ..color = AppColors.cardDark
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Saiten (horizontal)
    final stringPaint = Paint()
      ..color = AppColors.textSecondary
      ..strokeWidth = 1.5;
    for (int s = 0; s < 6; s++) {
      final y = (s + 0.5) * stringSpacing;
      // Tiefere Saiten dicker
      stringPaint.strokeWidth = 1.0 + (5 - s) * 0.3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), stringPaint);
    }

    // Bünde (vertikal)
    final fretPaint = Paint()
      ..color = AppColors.textTertiary
      ..strokeWidth = 1.5;
    for (int f = 0; f <= fretCount; f++) {
      final x = f * fretWidth;
      // Nut (vor Bund 0/1) dicker
      fretPaint.strokeWidth = (startFret == 0 && f == 0) ? 4.0 : 1.5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), fretPaint);
    }

    // Bund-Marker (Inlays bei 3, 5, 7, 9, 12, 15)
    final inlayPaint = Paint()
      ..color = AppColors.textTertiary.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    const inlays = [3, 5, 7, 9, 12, 15, 17, 19, 21];
    for (final inlayFret in inlays) {
      if (inlayFret > startFret && inlayFret <= startFret + fretCount) {
        final relF = inlayFret - startFret;
        final cx = (relF - 0.5) * fretWidth;
        final cy = size.height / 2;
        canvas.drawCircle(Offset(cx, cy), 4, inlayPaint);
        if (inlayFret == 12) {
          // Doppel-Inlay
          canvas.drawCircle(
              Offset(cx, cy - stringSpacing), 4, inlayPaint);
          canvas.drawCircle(
              Offset(cx, cy + stringSpacing), 4, inlayPaint);
        }
      }
    }

    // Bund-Nummern unten
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int f = 1; f <= fretCount; f++) {
      final actualFret = startFret + f;
      tp.text = TextSpan(
        text: '$actualFret',
        style: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 10,
        ),
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset((f - 0.5) * fretWidth - tp.width / 2, size.height - 12),
      );
    }

    // Highlight
    if (highlight != null) {
      final s = highlight!.string;
      final f = highlight!.fret;
      if (f >= startFret && f <= startFret + fretCount) {
        final cx = f == startFret
            ? -fretWidth * 0.1 // offene Saite leicht links der Nut
            : (f - startFret - 0.5) * fretWidth;
        final cy = (s - 0.5) * stringSpacing;
        final color = NoteColors.forNote(highlight!.noteName);
        // Glühring
        canvas.drawCircle(
          Offset(cx.clamp(8, size.width - 8), cy),
          14,
          Paint()
            ..color = color.withValues(alpha: 0.3)
            ..style = PaintingStyle.fill,
        );
        // Hauptpunkt
        canvas.drawCircle(
          Offset(cx.clamp(8, size.width - 8), cy),
          10,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
        // Punkt-Border weiß
        canvas.drawCircle(
          Offset(cx.clamp(8, size.width - 8), cy),
          10,
          Paint()
            ..color = Colors.white
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FretboardPainter old) =>
      old.highlight != highlight ||
      old.startFret != startFret ||
      old.fretCount != fretCount;
}
