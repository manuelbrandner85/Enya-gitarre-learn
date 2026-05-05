import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';
import 'package:enya_gitarre_learn/core/music_theory/note.dart';

/// Real-time pitch feedback widget.
///
/// Renders the detected note name (large), an octave subscript, a circular
/// accuracy ring, and a cents needle. Includes status text in German.
class RealTimeFeedbackWidget extends StatelessWidget {
  final PitchResult? result;
  final Note? targetNote;

  const RealTimeFeedbackWidget({
    super.key,
    required this.result,
    this.targetNote,
  });

  @override
  Widget build(BuildContext context) {
    final r = result;
    final hasResult = r != null && r.isValid;

    final accuracy = hasResult ? r.accuracy / 100.0 : 0.0;
    final centsOff = hasResult ? r.centsOff : 0.0;
    final ringColor = _ringColor(accuracy);

    final noteName = hasResult ? r.noteName : '--';
    final octave = hasResult ? r.octave : 0;

    final status = _statusText(
      hasResult: hasResult,
      accuracy: accuracy,
      centsOff: centsOff,
      detected: hasResult ? Note(name: r.noteName, octave: r.octave) : null,
      target: targetNote,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ringColor.withOpacity(hasResult ? 0.18 : 0.04),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ringColor.withOpacity(0.35), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Accuracy ring with note name in the middle.
          CircularPercentIndicator(
            radius: 90,
            lineWidth: 10,
            percent: accuracy.clamp(0.0, 1.0),
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 250,
            backgroundColor: AppColors.outline,
            progressColor: ringColor,
            circularStrokeCap: CircularStrokeCap.round,
            center: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  noteName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ).animate(key: ValueKey('note_$noteName')).fadeIn(
                      duration: 180.ms,
                    ),
                if (hasResult)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '$octave',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Cents needle bar.
          _CentsNeedleBar(centsOff: centsOff, active: hasResult),

          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              status,
              key: ValueKey(status),
              style: TextStyle(
                color: ringColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (hasResult) ...[
            const SizedBox(height: 4),
            Text(
              '${centsOff.toStringAsFixed(1)} cents · ${r.frequency.toStringAsFixed(1)} Hz',
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _ringColor(double accuracy) {
    if (accuracy >= 0.85) return AppColors.success;
    if (accuracy >= 0.60) return AppColors.warning;
    return AppColors.error;
  }

  String _statusText({
    required bool hasResult,
    required double accuracy,
    required double centsOff,
    required Note? detected,
    required Note? target,
  }) {
    if (!hasResult) return 'Spiele eine Note';
    if (target != null && detected != null && !detected.isEnharmonicWith(target)) {
      // Wrong note entirely. Suggest "wrong string" if frequency mismatched class.
      return 'Falsche Note';
    }
    if (accuracy >= 0.95) return 'Perfekt!';
    if (accuracy >= 0.80) return 'Fast!';
    if (centsOff > 0) return 'Etwas zu hoch';
    if (centsOff < 0) return 'Etwas zu tief';
    return 'Weiter so!';
  }
}

class _CentsNeedleBar extends StatelessWidget {
  final double centsOff;
  final bool active;

  const _CentsNeedleBar({required this.centsOff, required this.active});

  @override
  Widget build(BuildContext context) {
    final clamped = centsOff.clamp(-50.0, 50.0);
    return SizedBox(
      height: 36,
      child: CustomPaint(
        size: const Size(double.infinity, 36),
        painter: _CentsNeedlePainter(cents: clamped, active: active),
      ),
    );
  }
}

class _CentsNeedlePainter extends CustomPainter {
  final double cents;
  final bool active;

  _CentsNeedlePainter({required this.cents, required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final left = 8.0;
    final right = size.width - 8;
    final width = right - left;

    // Background bar.
    final barPaint = Paint()
      ..color = AppColors.outline
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(left, centerY), Offset(right, centerY), barPaint);

    // Tick marks at -50, -25, 0, +25, +50.
    final tickPaint = Paint()
      ..color = AppColors.textTertiary
      ..strokeWidth = 1.2;
    final ticks = [-50, -25, 0, 25, 50];
    for (final t in ticks) {
      final x = left + ((t + 50) / 100.0) * width;
      final h = t == 0 ? 10.0 : 6.0;
      canvas.drawLine(Offset(x, centerY - h), Offset(x, centerY + h), tickPaint);
    }

    // Center "0" highlight zone.
    final greenZone = Paint()..color = AppColors.success.withOpacity(0.35);
    final zL = left + (45 / 100.0) * width;
    final zR = left + (55 / 100.0) * width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(zL, centerY - 3, zR, centerY + 3),
        const Radius.circular(2),
      ),
      greenZone,
    );

    if (!active) return;

    // Needle.
    final x = left + ((cents + 50) / 100.0) * width;
    final color = cents.abs() <= 5
        ? AppColors.success
        : cents.abs() <= 15
            ? AppColors.warning
            : AppColors.error;
    final needle = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x, centerY - 14), Offset(x, centerY + 14), needle);
    final dot = Paint()..color = color;
    canvas.drawCircle(Offset(x, centerY), 5, dot);
  }

  @override
  bool shouldRepaint(covariant _CentsNeedlePainter old) =>
      old.cents != cents || old.active != active;
}

