import 'package:flutter/material.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/music_theory/chord.dart';
import 'package:enya_gitarre_learn/core/music_theory/fretboard_model.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';

/// A standard vertical chord diagram (4-5 frets visible) like in guitar books.
///
/// Strings are drawn vertically (low E on the left). Frets are drawn horizontally.
/// Filled circles indicate fretted notes (with finger numbers when available),
/// "O" markers above the nut indicate open strings, and "X" markers indicate
/// muted strings. A barre is auto-detected when multiple strings are pressed
/// at the same fret with the same finger.
class ChordDiagramWidget extends StatelessWidget {
  final Chord chord;
  final double size;
  final bool showNoteNames;
  final VoidCallback? onTap;

  /// Optional finger map (string-index -> finger number 1..4).
  /// If null, fingers are inferred heuristically from the voicing.
  final Map<int, int>? fingerMap;

  const ChordDiagramWidget({
    super.key,
    required this.chord,
    this.size = 120,
    this.showNoteNames = false,
    this.onTap,
    this.fingerMap,
  });

  @override
  Widget build(BuildContext context) {
    final w = size;
    final h = size * 1.35;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: w,
        height: h,
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _ChordDiagramPainter(
              chord: chord,
              showNoteNames: showNoteNames,
              fingerMap: fingerMap ?? _inferFingerMap(chord),
            ),
          ),
        ),
      ),
    );
  }

  /// Heuristically infer fingering from a voicing.
  static Map<int, int> _inferFingerMap(Chord chord) {
    final result = <int, int>{};
    final voicing = chord.voicing;

    // Collect (string, fret) for fretted strings only (fret > 0).
    final fretted = <int, int>{};
    for (int s = 0; s < voicing.length; s++) {
      final f = voicing[s];
      if (f > 0) fretted[s] = f;
    }
    if (fretted.isEmpty) return result;

    final lowestFret = fretted.values.reduce((a, b) => a < b ? a : b);

    // Detect a possible barre: same fret on multiple non-adjacent strings (or 2+ strings)
    // and that fret is the lowest fret used.
    final stringsAtLowest =
        fretted.entries.where((e) => e.value == lowestFret).map((e) => e.key).toList()
          ..sort();
    final isBarre = stringsAtLowest.length >= 2 &&
        (stringsAtLowest.last - stringsAtLowest.first) >= 2;

    // Sort the remaining (non-barre) frets ascending and assign fingers 2,3,4.
    final remaining = fretted.entries.where((e) {
      if (!isBarre) return true;
      return e.value != lowestFret;
    }).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Barre uses finger 1.
    if (isBarre) {
      for (final s in stringsAtLowest) {
        result[s] = 1;
      }
    }

    // Assign fingers in increasing order. Start at 1 if no barre, else 2.
    int finger = isBarre ? 2 : 1;
    for (final entry in remaining) {
      if (finger > 4) finger = 4;
      result[entry.key] = finger;
      finger++;
    }
    return result;
  }
}

class _ChordDiagramPainter extends CustomPainter {
  final Chord chord;
  final bool showNoteNames;
  final Map<int, int> fingerMap;

  static const _visibleFrets = 5;

  _ChordDiagramPainter({
    required this.chord,
    required this.showNoteNames,
    required this.fingerMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final voicing = chord.voicing;
    final lowest = chord.lowestFret;
    final highest = chord.highestFret;
    // Decide displayed range. If chord starts above fret 1, slide.
    int startFret;
    if (lowest <= 1 || highest <= _visibleFrets) {
      startFret = 0; // Show open chord with nut.
    } else {
      startFret = lowest - 1;
    }
    final endFret = startFret + _visibleFrets;

    // Layout
    final titleHeight = 22.0;
    final markerHeight = 16.0; // for X/O above nut
    final fretNumWidth = 20.0;
    final boardLeft = fretNumWidth + 10;
    final boardRight = size.width - 10;
    final boardTop = titleHeight + markerHeight + 4;
    final boardBottom = size.height - 14;
    final boardWidth = boardRight - boardLeft;
    final boardHeight = boardBottom - boardTop;

    // Title (chord name)
    final titlePainter = TextPainter(
      text: TextSpan(
        text: chord.symbol.isEmpty ? chord.name : chord.symbol,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    titlePainter.paint(
      canvas,
      Offset((size.width - titlePainter.width) / 2, 0),
    );

    // String x-positions (6 strings, low E on left).
    final stringSpacing = boardWidth / 5;
    final stringXs = List.generate(6, (i) => boardLeft + i * stringSpacing);

    // Fret y-positions (visibleFrets frets shown).
    final fretSpacing = boardHeight / _visibleFrets;
    final fretYs = List.generate(_visibleFrets + 1, (i) => boardTop + i * fretSpacing);

    // Draw nut (thick) if startFret == 0
    final nutPaint = Paint()
      ..color = AppColors.fretboardInlay
      ..strokeWidth = 5.0;
    final fretLinePaint = Paint()
      ..color = AppColors.fretboardFret
      ..strokeWidth = 1.5;
    if (startFret == 0) {
      canvas.drawLine(
        Offset(boardLeft - 0.5, boardTop),
        Offset(boardRight + 0.5, boardTop),
        nutPaint,
      );
    } else {
      canvas.drawLine(
        Offset(boardLeft, boardTop),
        Offset(boardRight, boardTop),
        fretLinePaint,
      );
      // Show fret number on the left next to the first visible fret area.
      final fretNumPainter = TextPainter(
        text: TextSpan(
          text: '${startFret + 1}',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      fretNumPainter.paint(
        canvas,
        Offset(boardLeft - fretNumPainter.width - 6,
            boardTop + fretSpacing / 2 - fretNumPainter.height / 2),
      );
    }

    // Draw remaining horizontal fret lines.
    for (int i = 1; i <= _visibleFrets; i++) {
      canvas.drawLine(
        Offset(boardLeft, fretYs[i]),
        Offset(boardRight, fretYs[i]),
        fretLinePaint,
      );
    }

    // Draw vertical strings.
    final stringPaint = Paint()
      ..color = AppColors.stringColor
      ..strokeWidth = 1.2;
    for (int s = 0; s < 6; s++) {
      canvas.drawLine(
        Offset(stringXs[s], boardTop),
        Offset(stringXs[s], boardBottom),
        stringPaint,
      );
    }

    // Draw open / muted markers above nut.
    for (int s = 0; s < 6; s++) {
      final f = voicing[s];
      final cx = stringXs[s];
      final cy = boardTop - markerHeight / 2 - 2;
      if (f == -1) {
        // Muted -> X
        final p = Paint()
          ..color = AppColors.mutedStringColor
          ..strokeWidth = 1.5;
        const r = 4.0;
        canvas.drawLine(Offset(cx - r, cy - r), Offset(cx + r, cy + r), p);
        canvas.drawLine(Offset(cx - r, cy + r), Offset(cx + r, cy - r), p);
      } else if (f == 0) {
        // Open -> O
        final p = Paint()
          ..color = AppColors.openStringColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(Offset(cx, cy), 5, p);
      }
    }

    // Detect barre: multiple strings at the same fret using the same finger.
    final barreFret = _detectBarre();
    if (barreFret != null) {
      final fretSlot = barreFret - startFret;
      if (fretSlot >= 1 && fretSlot <= _visibleFrets) {
        final cy = boardTop + (fretSlot - 0.5) * fretSpacing;
        final stringsAtBarre = <int>[];
        for (int s = 0; s < 6; s++) {
          if (voicing[s] == barreFret && fingerMap[s] == 1) {
            stringsAtBarre.add(s);
          }
        }
        if (stringsAtBarre.length >= 2) {
          stringsAtBarre.sort();
          final left = stringXs[stringsAtBarre.first];
          final right = stringXs[stringsAtBarre.last];
          final paint = Paint()..color = AppColors.fingerIndex;
          final rect = RRect.fromRectAndRadius(
            Rect.fromLTRB(left - 8, cy - 8, right + 8, cy + 8),
            const Radius.circular(8),
          );
          canvas.drawRRect(rect, paint);
        }
      }
    }

    // Draw filled finger circles for fretted notes.
    for (int s = 0; s < 6; s++) {
      final f = voicing[s];
      if (f <= 0) continue;
      final fretSlot = f - startFret;
      if (fretSlot < 1 || fretSlot > _visibleFrets) continue;
      final cx = stringXs[s];
      final cy = boardTop + (fretSlot - 0.5) * fretSpacing;
      final finger = fingerMap[s];

      // Skip drawing dot if it's part of barre rectangle (covered already).
      if (barreFret != null && f == barreFret && finger == 1) {
        // Draw a small label centered on the barre at this string anyway? Skip extra.
        continue;
      }

      final color = _fingerColor(finger);
      final fill = Paint()..color = color;
      canvas.drawCircle(Offset(cx, cy), 9, fill);

      final stroke = Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(Offset(cx, cy), 9, stroke);

      String label;
      if (showNoteNames) {
        final note = FretboardModel.noteAt(s, f);
        label = note.name;
      } else if (finger != null) {
        label = '$finger';
      } else {
        label = '';
      }
      if (label.isNotEmpty) {
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
      }
    }

    // String name labels at bottom (E A D G B e).
    for (int s = 0; s < 6; s++) {
      final tp = TextPainter(
        text: TextSpan(
          text: AppConstants.stringNames[s],
          style: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(stringXs[s] - tp.width / 2, boardBottom + 2));
    }
  }

  int? _detectBarre() {
    // Find a fret at which 2+ strings are pressed and assigned to finger 1.
    final byFret = <int, List<int>>{};
    for (int s = 0; s < chord.voicing.length; s++) {
      final f = chord.voicing[s];
      if (f > 0 && fingerMap[s] == 1) {
        byFret.putIfAbsent(f, () => []).add(s);
      }
    }
    int? bestFret;
    int bestCount = 0;
    byFret.forEach((fret, strings) {
      if (strings.length >= 2 && strings.length > bestCount) {
        bestCount = strings.length;
        bestFret = fret;
      }
    });
    return bestFret;
  }

  static Color _fingerColor(int? finger) {
    switch (finger) {
      case 1:
        return AppColors.fingerIndex;
      case 2:
        return AppColors.fingerMiddle;
      case 3:
        return AppColors.fingerRing;
      case 4:
        return AppColors.fingerPinky;
      default:
        return AppColors.primary;
    }
  }

  @override
  bool shouldRepaint(covariant _ChordDiagramPainter old) {
    return old.chord != chord ||
        old.showNoteNames != showNoteNames ||
        old.fingerMap != fingerMap;
  }
}
