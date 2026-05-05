import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';

/// A classic analog tuner needle widget.
///
/// Renders a semicircular dial with tick marks and a needle that smoothly
/// rotates between -50° and +50° based on the [centsOff] value.
class TunerNeedleWidget extends StatefulWidget {
  final double centsOff;
  final bool isInTune;
  final double size;

  const TunerNeedleWidget({
    super.key,
    required this.centsOff,
    required this.isInTune,
    this.size = 280,
  });

  @override
  State<TunerNeedleWidget> createState() => _TunerNeedleWidgetState();
}

class _TunerNeedleWidgetState extends State<TunerNeedleWidget>
    with TickerProviderStateMixin {
  late final AnimationController _angleController;
  late Tween<double> _angleTween;
  late Animation<double> _angleAnim;

  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _angleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _angleTween = Tween<double>(begin: 0, end: _targetAngle(widget.centsOff));
    _angleAnim = _angleTween.animate(
      CurvedAnimation(parent: _angleController, curve: Curves.easeOut),
    );
    _angleController.forward();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.isInTune) _glowController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant TunerNeedleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.centsOff != widget.centsOff) {
      _angleTween = Tween<double>(
        begin: _angleAnim.value,
        end: _targetAngle(widget.centsOff),
      );
      _angleAnim = _angleTween.animate(
        CurvedAnimation(parent: _angleController, curve: Curves.easeOut),
      );
      _angleController
        ..reset()
        ..forward();
    }
    if (widget.isInTune && !_glowController.isAnimating) {
      _glowController.repeat(reverse: true);
    } else if (!widget.isInTune && _glowController.isAnimating) {
      _glowController
        ..stop()
        ..value = 0;
    }
  }

  double _targetAngle(double cents) {
    // Map -50..+50 cents to -50°..+50° (in radians).
    final clamped = cents.clamp(-50.0, 50.0);
    return clamped * math.pi / 180.0;
  }

  @override
  void dispose() {
    _angleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.62,
      child: AnimatedBuilder(
        animation: Listenable.merge([_angleAnim, _glowController]),
        builder: (context, _) {
          return CustomPaint(
            painter: _TunerNeedlePainter(
              angle: _angleAnim.value,
              isInTune: widget.isInTune,
              glow: _glowController.value,
            ),
          );
        },
      ),
    );
  }
}

class _TunerNeedlePainter extends CustomPainter {
  final double angle; // radians, -50°..+50°
  final bool isInTune;
  final double glow;

  _TunerNeedlePainter({
    required this.angle,
    required this.isInTune,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    // Pivot near the bottom of the canvas.
    final cy = h * 0.92;
    final radius = math.min(w * 0.45, h * 0.85);

    // Background arc.
    final bgArcPaint = Paint()
      ..color = AppColors.surfaceVariantDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);
    final start = -math.pi / 2 - (50 * math.pi / 180);
    final sweep = (100 * math.pi / 180);
    canvas.drawArc(rect, start, sweep, false, bgArcPaint);

    // Color zones.
    void zone(double fromCents, double toCents, Color color) {
      final s = -math.pi / 2 + (fromCents * math.pi / 180);
      final sw = (toCents - fromCents) * math.pi / 180;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, s, sw, false, paint);
    }

    zone(-50, -10, AppColors.error);
    zone(-10, -5, AppColors.warning);
    zone(-5, 5, AppColors.success);
    zone(5, 10, AppColors.warning);
    zone(10, 50, AppColors.error);

    // Glow when in tune.
    if (isInTune) {
      final glowPaint = Paint()
        ..color = AppColors.success.withOpacity(0.25 + 0.35 * glow)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawArc(
        rect,
        -math.pi / 2 - (5 * math.pi / 180),
        (10 * math.pi / 180),
        false,
        glowPaint,
      );
    }

    // Tick marks.
    final tickPaint = Paint()
      ..color = AppColors.textSecondary
      ..strokeWidth = 1.5;
    final majorTicks = [-50, -25, -10, 0, 10, 25, 50];
    final minorTicks = [-40, -30, -20, -15, -5, 5, 15, 20, 30, 40];

    void drawTick(double cents, double length, Paint paint) {
      final a = -math.pi / 2 + (cents * math.pi / 180);
      final inner = radius - 12;
      final outer = radius + length;
      final p1 = Offset(cx + math.cos(a) * inner, cy + math.sin(a) * inner);
      final p2 = Offset(cx + math.cos(a) * outer, cy + math.sin(a) * outer);
      canvas.drawLine(p1, p2, paint);
    }

    for (final t in minorTicks) {
      drawTick(t.toDouble(), -2, tickPaint);
    }
    final majorPaint = Paint()
      ..color = AppColors.textPrimary
      ..strokeWidth = 2.0;
    for (final t in majorTicks) {
      drawTick(t.toDouble(), 4, majorPaint);
      // Label.
      final a = -math.pi / 2 + (t * math.pi / 180);
      final lx = cx + math.cos(a) * (radius + 22);
      final ly = cy + math.sin(a) * (radius + 22);
      final txt = t > 0 ? '+$t' : '$t';
      final tp = TextPainter(
        text: TextSpan(
          text: txt,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(lx - tp.width / 2, ly - tp.height / 2));
    }

    // Needle.
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    final needleColor = isInTune
        ? AppColors.success
        : angle.abs() < (5 * math.pi / 180)
            ? AppColors.success
            : angle.abs() < (10 * math.pi / 180)
                ? AppColors.warning
                : AppColors.error;
    final needlePath = Path()
      ..moveTo(-3, 0)
      ..lineTo(3, 0)
      ..lineTo(1, -radius + 8)
      ..lineTo(-1, -radius + 8)
      ..close();
    final needlePaint = Paint()..color = needleColor;
    canvas.drawPath(needlePath, needlePaint);
    canvas.restore();

    // Pivot dot.
    final dotPaint = Paint()..color = AppColors.textPrimary;
    canvas.drawCircle(Offset(cx, cy), 8, dotPaint);
    final innerDot = Paint()..color = AppColors.surfaceDark;
    canvas.drawCircle(Offset(cx, cy), 4, innerDot);
  }

  @override
  bool shouldRepaint(covariant _TunerNeedlePainter old) {
    return old.angle != angle || old.isInTune != isInTune || old.glow != glow;
  }
}
