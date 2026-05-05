import 'package:flutter/material.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';

/// Animated linear progress bar with step dots above it.
///
/// Filled dots represent completed steps, the current step is rendered as a
/// ring, and upcoming steps as outlined dots.
class LessonProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double height;

  const LessonProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clampedTotal = totalSteps <= 0 ? 1 : totalSteps;
    final clampedCurrent = currentStep.clamp(0, clampedTotal);
    final progress = clampedCurrent / clampedTotal;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Step dots.
            SizedBox(
              height: 18,
              width: width,
              child: Stack(
                clipBehavior: Clip.none,
                children: List.generate(clampedTotal, (i) {
                  final pos = clampedTotal == 1
                      ? width / 2
                      : (i / (clampedTotal - 1)) * width;
                  final isCompleted = i < clampedCurrent;
                  final isCurrent = i == clampedCurrent;
                  return Positioned(
                    left: (pos - 9).clamp(0, width - 18),
                    top: 0,
                    child: _StepDot(
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 4),
            // Progress bar.
            ClipRRect(
              borderRadius: BorderRadius.circular(height / 2),
              child: SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Container(color: AppColors.outline),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      width: width * progress,
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isCompleted;
  final bool isCurrent;

  const _StepDot({required this.isCompleted, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? AppColors.primary
            : (isCurrent ? AppColors.surfaceDark : AppColors.outline),
        border: Border.all(
          color: isCurrent ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check, size: 12, color: Colors.white)
          : null,
    );
  }
}
