import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/music_theory/scale.dart';

import 'fretboard_widget.dart';

/// Close-up illustration of finger placement on the fretboard.
///
/// Renders a small slice of the fretboard around the relevant frets and
/// highlights the active finger with a pulsing glow. Useful inside lesson
/// tutorial steps where a single fingering needs to be emphasized.
class FingerPositionWidget extends StatelessWidget {
  final List<FretPosition> positions;
  final int activeFinger;

  /// Map of FretPosition -> finger number 1..4.
  final Map<FretPosition, int> fingers;

  /// Optional custom title above the diagram.
  final String? title;

  const FingerPositionWidget({
    super.key,
    required this.positions,
    required this.activeFinger,
    required this.fingers,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Determine fret window around the positions (with 1-fret margin).
    final frets = positions.map((p) => p.fret).toList();
    final minFret = frets.reduce((a, b) => a < b ? a : b);
    final maxFret = frets.reduce((a, b) => a > b ? a : b);
    final start = (minFret - 1).clamp(0, 22);
    final end = (maxFret + 1).clamp(start + 2, 22);

    // Find the active position (first one that maps to activeFinger).
    FretPosition? activePos;
    fingers.forEach((pos, finger) {
      if (finger == activeFinger && activePos == null) {
        activePos = pos;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
        ],
        // Active finger badge.
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FingerBadge(finger: activeFinger).animate(
                  onPlay: (c) => c.repeat(reverse: true),
                ).scaleXY(
                  begin: 1.0,
                  end: 1.12,
                  duration: 700.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(width: 10),
            Text(
              _fingerLabel(activeFinger),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (activePos != null) ...[
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Text(
                'Saite ${activePos!.string + 1} · Bund ${activePos!.fret}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Mini fretboard close-up.
        SizedBox(
          height: 160,
          child: FretboardWidget(
            targetPositions: positions,
            mode: FretboardMode.display,
            startFret: start,
            endFret: end,
            showNoteNames: false,
            fingerMap: fingers,
          ),
        ),
      ],
    );
  }

  String _fingerLabel(int finger) {
    switch (finger) {
      case 1:
        return 'Zeigefinger';
      case 2:
        return 'Mittelfinger';
      case 3:
        return 'Ringfinger';
      case 4:
        return 'Kleiner Finger';
      default:
        return 'Finger $finger';
    }
  }
}

class _FingerBadge extends StatelessWidget {
  final int finger;
  const _FingerBadge({required this.finger});

  @override
  Widget build(BuildContext context) {
    final color = fingerColor(finger);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.55),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$finger',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
