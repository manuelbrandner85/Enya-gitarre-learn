import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';

class LessonCompleteScreen extends StatefulWidget {
  final String lessonTitle;
  final int xpEarned;
  final double accuracy;
  final List<String> newAchievements;

  const LessonCompleteScreen({
    super.key,
    required this.lessonTitle,
    required this.xpEarned,
    required this.accuracy,
    required this.newAchievements,
  });

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  int get _stars {
    if (widget.accuracy >= 0.98) return 3;
    if (widget.accuracy >= 0.85) return 2;
    if (widget.accuracy >= 0.70) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.xpColor,
                AppColors.accent,
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),

                  // Trophy icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 60,
                      color: Colors.black,
                    ),
                  )
                      .animate()
                      .scale(
                          begin: const Offset(0, 0),
                          duration: 600.ms,
                          curve: Curves.elasticOut)
                      .fadeIn(),

                  const SizedBox(height: 24),

                  Text(
                    'Lektion abgeschlossen!',
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 300.ms)
                      .fadeIn()
                      .slideY(begin: 0.3),

                  const SizedBox(height: 8),

                  Text(
                    widget.lessonTitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(),

                  const SizedBox(height: 32),

                  // Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          i < _stars ? Icons.star : Icons.star_border,
                          color: i < _stars
                              ? AppColors.xpColor
                              : AppColors.textTertiary,
                          size: 40,
                        )
                            .animate(delay: Duration(milliseconds: 500 + (i * 150)))
                            .scale(
                                begin: const Offset(0, 0),
                                curve: Curves.elasticOut)
                            .fadeIn(),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // Stats row
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.percent,
                        value:
                            '${(widget.accuracy * 100).round()}%',
                        label: 'Genauigkeit',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.bolt,
                        value: '+${widget.xpEarned}',
                        label: 'XP',
                        color: AppColors.xpColor,
                      ),
                    ],
                  ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 16),

                  // New achievements
                  if (widget.newAchievements.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.achievementColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.achievementColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events,
                              color: AppColors.achievementColor),
                          const SizedBox(width: 12),
                          Text(
                            '${widget.newAchievements.length} neue Achievement(s)!',
                            style: TextStyle(
                              color: AppColors.achievementColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 900.ms).fadeIn(),

                  const Spacer(),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home/lessons'),
                      child: const Text('Zurück zu den Modulen'),
                    ),
                  ).animate(delay: 1000.ms).fadeIn().slideY(begin: 0.3),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go('/home/lessons'),
                      child: const Text('Nächste Lektion'),
                    ),
                  ).animate(delay: 1100.ms).fadeIn().slideY(begin: 0.3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
