import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';
import '../../../core/utils/constants.dart';

class OnboardingTunerPage extends StatelessWidget {
  const OnboardingTunerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: OnboardingTunerPageContent(onNext: null),
    );
  }
}

class OnboardingTunerPageContent extends StatefulWidget {
  final VoidCallback? onNext;

  const OnboardingTunerPageContent({super.key, required this.onNext});

  @override
  State<OnboardingTunerPageContent> createState() =>
      _OnboardingTunerPageContentState();
}

class _OnboardingTunerPageContentState
    extends State<OnboardingTunerPageContent> {
  int _tunedStrings = 0;
  final List<bool> _stringTuned = List.filled(6, false);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 16),

          Text(
            'Gitarre stimmen',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ).animate().fadeIn(),

          const SizedBox(height: 8),

          Text(
            'Stimme alle 6 Saiten deiner Gitarre bevor du anfängst',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 32),

          // Tuner display (simplified for onboarding)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: [
                Text(
                  'Standard-Stimmung',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'E - A - D - G - B - e',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 24),

                // String indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (i) {
                    final stringNames = AppConstants.stringNames;
                    final isTuned = _stringTuned[i];
                    return GestureDetector(
                      onTap: () {
                        if (!isTuned) {
                          setState(() {
                            _stringTuned[i] = true;
                            _tunedStrings++;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTuned
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.surfaceVariantDark,
                          border: Border.all(
                            color: isTuned ? AppColors.primary : AppColors.outline,
                            width: isTuned ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            stringNames[i],
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: isTuned
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 24),

          if (_tunedStrings > 0)
            Text(
              '$_tunedStrings/6 Saiten gestimmt',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ).animate().fadeIn(),

          const SizedBox(height: 24),

          // Info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tippe auf eine Saite, um sie als gestimmt zu markieren. Du kannst auch direkt weitermachen.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 600.ms).fadeIn(),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext ?? () => context.go('/onboarding/profile'),
              child: const Text('Weiter'),
            ),
          ).animate(delay: 800.ms).fadeIn(),

          const SizedBox(height: 16),

          TextButton(
            onPressed: widget.onNext ?? () => context.go('/onboarding/profile'),
            child: Text(
              'Später stimmen',
              style: TextStyle(color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
