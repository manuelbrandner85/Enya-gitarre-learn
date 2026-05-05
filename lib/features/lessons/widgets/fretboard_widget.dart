import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/music_theory/scale.dart';
import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';

/// Display modes for the FretboardWidget.
enum FretboardMode {
  /// Just display target positions.
  display,

  /// Show live played position with glow / pulse.
  realtime,

  /// Show both target (faded) and played (full opacity).
  comparison,

  /// Display scale positions.
  scale,
}

/// Maps a [FretPosition] to a finger number (1-4) for fingering display.
typedef FingerMap = Map<FretPosition, int>;

/// A CustomPainter-based interactive guitar fretboard.
class FretboardWidget extends StatefulWidget {
  final List<FretPosition> targetPositions;
  final FretPosition? livePosition;
  final FretboardMode mode;
  final int startFret;
  final int endFret;
  final bool headstockLeft;
  final void Function(FretPosition)? onTap;
  final bool showNoteNames;
  final FingerMap? fingerMap;

  /// Optional voicing list (per-string fret index, -1 = muted, 0 = open).
  /// If provided the widget will draw open / muted markers at the nut.
  final List<int>? voicing;

  const FretboardWidget({
    super.key,
    required this.targetPositions,
    this.livePosition,
    this.mode = FretboardMode.display,
    this.startFret = 0,
    this.endFret = 12,
    this.headstockLeft = true,
    this.onTap,
    this.showNoteNames = false,
    this.fingerMap,
    this.voicing,
  }) : assert(endFret > startFret);

  @override
  State<FretboardWidget> createState() => _FretboardWidgetState();
}

class _FretboardWidgetState extends State<FretboardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap(Offset localPos, Size size) {
    if (widget.onTap == null) return;
    final layout = _FretboardLayout(
      size: size,
      startFret: widget.startFret,
      endFret: widget.endFret,
      headstockLeft: widget.headstockLeft,
    );
    final hit = layout.hitTest(localPos);
    if (hit != null) {
      final note = _noteAt(hit.$1, hit.$2);
      widget.onTap!(FretPosition(
        string: hit.$1,
        fret: hit.$2,
        note: note,
        isRoot: false,
      ));
    }
  }

  static dynamic _noteAt(int string, int fret) {
    // Lazy import to avoid circular dependency.
    final openMidi = AppConstants.standardTuningMidi[string];
    return _midiToNote(openMidi + fret);
  }

  static dynamic _midiToNote(int midi) {
    final clamped = midi.clamp(0, 127);
    final noteIdx = clamped % 12;
    final octave = (clamped ~/ 12) - 1;
    return _NoteShim(AppConstants.noteNames[noteIdx], octave);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => _handleTap(details.localPosition, size),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                return CustomPaint(
                  size: size,
                  painter: _FretboardPainter(
                    targetPositions: widget.targetPositions,
                    livePosition: widget.livePosition,
                    mode: widget.mode,
                    startFret: widget.startFret,
                    endFret: widget.endFret,
                    headstockLeft: widget.headstockLeft,
                    showNoteNames: widget.showNoteNames,
                    fingerMap: widget.fingerMap,
                    voicing: widget.voicing,
                    pulse: _pulseController.value,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Tiny shim to avoid importing Note from outside this file's scope just for
/// constructing replacement notes during taps. We re-construct using the same
/// shape as music_theory/note.dart.
class _NoteShim {
  final String name;
  final int octave;
  const _NoteShim(this.name, this.octave);
}

class _FretboardLayout {
  final Size size;
  final int startFret;
  final int endFret;
  final bool headstockLeft;

  late final double topMargin;
  late final double bottomMargin;
  late final double leftMargin;
  late final double rightMargin;
  late final double boardWidth;
  late final double boardHeight;
  late final List<double> fretXs; // X coordinate of each fret line, including nut
  late final List<double> stringYs; // Y coordinate of each of the 6 strings

  _FretboardLayout({
    required this.size,
    required this.startFret,
    required this.endFret,
    required this.headstockLeft,
  }) {
    topMargin = 18;
    bottomMargin = 28;
    leftMargin = 22;
    rightMargin = 14;
    boardWidth = math.max(0, size.width - leftMargin - rightMargin);
    boardHeight = math.max(0, size.height - topMargin - bottomMargin);

    // Compute fret widths using rule of 17.817 (proportional spacing).
    final fretCount = endFret - startFret;
    final widths = <double>[];
    double cur = 1.0;
    for (int i = 0; i < fretCount; i++) {
      widths.add(cur);
      cur = cur * (1 - 1 / 17.817);
    }
    final totalUnits = widths.fold<double>(0, (a, b) => a + b);
    final scale = totalUnits == 0 ? 0.0 : boardWidth / totalUnits;

    fretXs = [leftMargin];
    double x = leftMargin;
    for (final w in widths) {
      x += w * scale;
      fretXs.add(x);
    }

    if (!headstockLeft) {
      // Mirror x positions about the center of board.
      final xs = fretXs.map((v) => leftMargin + boardWidth - (v - leftMargin)).toList();
      fretXs
        ..clear()
        ..addAll(xs.reversed);
    }

    final stringSpacing = boardHeight / 5;
    stringYs = List.generate(6, (i) => topMargin + i * stringSpacing);
  }

  /// Returns x coordinate for the visual center of [fret] (between fret-1 and fret).
  double xForFret(int fret) {
    if (fret < startFret) return fretXs.first;
    if (fret > endFret) return fretXs.last;
    if (fret == startFret) {
      // open or nut: place slightly left of nut line.
      return headstockLeft ? fretXs.first - 12 : fretXs.first + 12;
    }
    final idx = fret - startFret;
    final left = fretXs[idx - 1];
    final right = fretXs[idx];
    return (left + right) / 2;
  }

  double yForString(int string) {
    // String 0 = low E, drawn at bottom (typical fretboard view) — but app
    // convention here uses string 0 (low E) at TOP because that matches most
    // Flutter horizontal fretboards used in lesson UIs. Keep low E at TOP.
    return stringYs[string];
  }

  /// Returns (string, fret) under [pos] if any.
  (int, int)? hitTest(Offset pos) {
    // Find nearest string.
    int? bestString;
    double bestDy = double.infinity;
    for (int s = 0; s < 6; s++) {
      final dy = (stringYs[s] - pos.dy).abs();
      if (dy < bestDy) {
        bestDy = dy;
        bestString = s;
      }
    }
    if (bestString == null) return null;
    if (bestDy > 24) return null;

    // Find fret. If pos.dx < first fretX, it's open (startFret).
    if (headstockLeft) {
      if (pos.dx < fretXs.first) return (bestString, startFret);
      for (int i = 1; i < fretXs.length; i++) {
        if (pos.dx <= fretXs[i]) return (bestString, startFret + i);
      }
      return (bestString, endFret);
    } else {
      if (pos.dx > fretXs.first) return (bestString, startFret);
      for (int i = 1; i < fretXs.length; i++) {
        if (pos.dx >= fretXs[i]) return (bestString, startFret + i);
      }
      return (bestString, endFret);
    }
  }
}

class _FretboardPainter extends CustomPainter {
  final List<FretPosition> targetPositions;
  final FretPosition? livePosition;
  final FretboardMode mode;
  final int startFret;
  final int endFret;
  final bool headstockLeft;
  final bool showNoteNames;
  final FingerMap? fingerMap;
  final List<int>? voicing;
  final double pulse;

  static const _stringWidths = <double>[4.0, 3.4, 2.8, 2.2, 1.8, 1.5];
  static const _inlayFrets = <int>[3, 5, 7, 9, 15, 17, 19, 21];
  static const _doubleInlayFrets = <int>[12];

  _FretboardPainter({
    required this.targetPositions,
    required this.livePosition,
    required this.mode,
    required this.startFret,
    required this.endFret,
    required this.headstockLeft,
    required this.showNoteNames,
    required this.fingerMap,
    required this.voicing,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _FretboardLayout(
      size: size,
      startFret: startFret,
      endFret: endFret,
      headstockLeft: headstockLeft,
    );

    _paintBoard(canvas, layout);
    _paintInlays(canvas, layout);
    _paintFrets(canvas, layout);
    _paintStrings(canvas, layout);
    _paintFretNumbers(canvas, layout);
    _paintVoicingMarkers(canvas, layout);
    _paintTargetPositions(canvas, layout);
    _paintLivePosition(canvas, layout);
  }

  void _paintBoard(Canvas canvas, _FretboardLayout l) {
    final paint = Paint()..color = AppColors.fretboardWood;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(l.leftMargin - 2, l.topMargin - 6,
            l.boardWidth + 4, l.boardHeight + 12),
        const Radius.circular(6),
      ),
      paint,
    );
  }

  void _paintInlays(Canvas canvas, _FretboardLayout l) {
    final paint = Paint()..color = AppColors.fretboardInlay.withOpacity(0.65);
    final centerY = l.topMargin + l.boardHeight / 2;

    for (int f = startFret + 1; f <= endFret; f++) {
      if (_inlayFrets.contains(f)) {
        final cx = l.xForFret(f);
        canvas.drawCircle(Offset(cx, centerY), 6, paint);
      } else if (_doubleInlayFrets.contains(f)) {
        final cx = l.xForFret(f);
        final yTop = l.topMargin + l.boardHeight * 0.28;
        final yBot = l.topMargin + l.boardHeight * 0.72;
        canvas.drawCircle(Offset(cx, yTop), 6, paint);
        canvas.drawCircle(Offset(cx, yBot), 6, paint);
      }
    }
  }

  void _paintFrets(Canvas canvas, _FretboardLayout l) {
    final fretPaint = Paint()
      ..color = AppColors.fretboardFret
      ..strokeWidth = 2.0;
    final nutPaint = Paint()
      ..color = AppColors.fretboardInlay
      ..strokeWidth = 6.0;

    for (int i = 0; i < l.fretXs.length; i++) {
      final x = l.fretXs[i];
      final isNut = (i == 0 && startFret == 0);
      final p = isNut ? nutPaint : fretPaint;
      canvas.drawLine(
        Offset(x, l.topMargin),
        Offset(x, l.topMargin + l.boardHeight),
        p,
      );
    }
  }

  void _paintStrings(Canvas canvas, _FretboardLayout l) {
    for (int s = 0; s < 6; s++) {
      final paint = Paint()
        ..color = AppColors.stringColor
        ..strokeWidth = _stringWidths[s];
      final y = l.yForString(s);
      canvas.drawLine(
        Offset(l.leftMargin, y),
        Offset(l.leftMargin + l.boardWidth, y),
        paint,
      );
    }
  }

  void _paintFretNumbers(Canvas canvas, _FretboardLayout l) {
    final textStyle = TextStyle(
      color: AppColors.textTertiary,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    for (int f = startFret; f <= endFret; f++) {
      if (f == 0) continue;
      final x = l.xForFret(f);
      final tp = TextPainter(
        text: TextSpan(text: '$f', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x - tp.width / 2, l.topMargin + l.boardHeight + 6),
      );
    }
  }

  void _paintVoicingMarkers(Canvas canvas, _FretboardLayout l) {
    final v = voicing;
    if (v == null) return;
    for (int s = 0; s < v.length && s < 6; s++) {
      final fret = v[s];
      final y = l.yForString(s);
      final markerX = headstockLeft ? l.leftMargin - 12 : l.leftMargin + l.boardWidth + 12;
      if (fret == -1) {
        // Muted -> X
        final paint = Paint()
          ..color = AppColors.mutedStringColor
          ..strokeWidth = 2.0;
        const r = 5.0;
        canvas.drawLine(Offset(markerX - r, y - r), Offset(markerX + r, y + r), paint);
        canvas.drawLine(Offset(markerX - r, y + r), Offset(markerX + r, y - r), paint);
      } else if (fret == 0) {
        // Open -> empty circle
        final paint = Paint()
          ..color = AppColors.openStringColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(Offset(markerX, y), 6, paint);
      }
    }
  }

  void _paintTargetPositions(Canvas canvas, _FretboardLayout l) {
    if (mode == FretboardMode.realtime) return;
    final opacity = mode == FretboardMode.comparison ? 0.5 : 1.0;
    for (final p in targetPositions) {
      if (p.fret < startFret || p.fret > endFret) continue;
      _drawFingerDot(canvas, l, p, opacity, false);
    }
  }

  void _paintLivePosition(Canvas canvas, _FretboardLayout l) {
    final p = livePosition;
    if (p == null) return;
    if (p.fret < startFret || p.fret > endFret) return;
    _drawFingerDot(canvas, l, p, 1.0, true);
  }

  void _drawFingerDot(Canvas canvas, _FretboardLayout l, FretPosition p,
      double opacity, bool live) {
    final cx = l.xForFret(p.fret);
    final cy = l.yForString(p.string);
    final finger = fingerMap?[p];
    Color color;
    switch (finger) {
      case 1:
        color = AppColors.fingerIndex;
        break;
      case 2:
        color = AppColors.fingerMiddle;
        break;
      case 3:
        color = AppColors.fingerRing;
        break;
      case 4:
        color = AppColors.fingerPinky;
        break;
      default:
        color = p.isRoot ? AppColors.secondary : AppColors.primary;
    }

    if (p.fret == 0) {
      // open string at nut: empty circle
      final paint = Paint()
        ..color = AppColors.openStringColor.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      final markerX = headstockLeft ? l.leftMargin - 12 : l.leftMargin + l.boardWidth + 12;
      canvas.drawCircle(Offset(markerX, cy), 7, paint);
      return;
    }

    final radius = 11.0;

    if (live) {
      final glowAlpha = 0.25 + 0.45 * pulse;
      final glow = Paint()
        ..color = color.withOpacity(glowAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
      canvas.drawCircle(Offset(cx, cy), radius + 6 * pulse, glow);
    }

    final fill = Paint()..color = color.withOpacity(opacity);
    canvas.drawCircle(Offset(cx, cy), radius, fill);

    final stroke = Paint()
      ..color = Colors.white.withOpacity(0.8 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(cx, cy), radius, stroke);

    final label = showNoteNames
        ? p.note.name
        : (finger != null ? '$finger' : '');
    if (label.isEmpty) return;

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white.withOpacity(opacity),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _FretboardPainter old) {
    return old.targetPositions != targetPositions ||
        old.livePosition != livePosition ||
        old.mode != mode ||
        old.startFret != startFret ||
        old.endFret != endFret ||
        old.headstockLeft != headstockLeft ||
        old.showNoteNames != showNoteNames ||
        old.fingerMap != fingerMap ||
        old.voicing != voicing ||
        old.pulse != pulse;
  }
}

/// Helper extension to produce a finger-color from a finger number.
Color fingerColor(int finger) {
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

/// Re-export PitchResult for callers that import this file.
typedef LivePitch = PitchResult;
