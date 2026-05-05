import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';

/// Direction of a strum within a pattern.
enum StrumDirection {
  /// Downstroke ↓
  down,

  /// Upstroke ↑
  up,

  /// Muted strum (palm-muted/scratch) — drawn as X
  mute,

  /// Rest — drawn as underscore
  rest,

  /// Accented down stroke — drawn larger / bold
  accent,
}

/// Visual strumming pattern indicator.
///
/// Shows a row of arrow icons (or X / _) per beat, with a beat counter
/// "1 & 2 & 3 & 4 &" below. The current beat is highlighted with a pulse.
class StrummingPatternWidget extends StatelessWidget {
  final List<StrumDirection> pattern;
  final int currentBeat;
  final double size;

  /// Beats counted per measure. Used to label "1 & 2 &..."
  final int beatsPerMeasure;

  const StrummingPatternWidget({
    super.key,
    required this.pattern,
    required this.currentBeat,
    this.size = 280,
    this.beatsPerMeasure = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (pattern.isEmpty) {
      return SizedBox(
        width: size,
        height: 90,
        child: const Center(
          child: Text(
            'Kein Pattern',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
      );
    }

    // Generate beat counter labels: 1, &, 2, &, ...
    final labels = <String>[];
    for (int i = 0; i < pattern.length; i++) {
      final isDownbeat = i % 2 == 0;
      if (isDownbeat) {
        labels.add('${(i ~/ 2) % beatsPerMeasure + 1}');
      } else {
        labels.add('&');
      }
    }

    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pattern row.
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(pattern.length, (i) {
                return Expanded(
                  child: _StrumCell(
                    direction: pattern[i],
                    isActive: i == currentBeat,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 4),
          // Beat counter row.
          SizedBox(
            height: 22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(labels.length, (i) {
                final isActive = i == currentBeat;
                return Expanded(
                  child: Center(
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textTertiary,
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StrumCell extends StatelessWidget {
  final StrumDirection direction;
  final bool isActive;

  const _StrumCell({required this.direction, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.primary
        : direction == StrumDirection.rest
            ? AppColors.textTertiary
            : AppColors.textPrimary;

    Widget child;
    switch (direction) {
      case StrumDirection.down:
        child = Icon(Icons.arrow_downward, color: color, size: 28);
        break;
      case StrumDirection.up:
        child = Icon(Icons.arrow_upward, color: color, size: 28);
        break;
      case StrumDirection.mute:
        child = Text(
          'X',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        );
        break;
      case StrumDirection.rest:
        child = Text(
          '–',
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        );
        break;
      case StrumDirection.accent:
        child = Icon(Icons.keyboard_double_arrow_down,
            color: color, size: 32);
        break;
    }

    final cell = Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withOpacity(0.18)
            : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.outline,
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Center(child: child),
    );

    if (!isActive) return cell;
    return cell
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 1.0, end: 1.08, duration: 220.ms, curve: Curves.easeOut);
  }
}
