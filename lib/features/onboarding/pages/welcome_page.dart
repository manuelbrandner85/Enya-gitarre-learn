import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: WelcomePageContent(onNext: null),
      ),
    );
  }
}

class WelcomePageContent extends StatelessWidget {
  final VoidCallback? onNext;

  const WelcomePageContent({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero icon
          Container(
            width: 140,
            height: 140,
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
              Icons.electric_bolt,
              size: 72,
              color: Colors.black,
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .scale(begin: const Offset(0.3, 0.3), curve: Curves.elasticOut),

          const SizedBox(height: 48),

          Text(
            'Willkommen!',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 300.ms)
              .fadeIn()
              .slideY(begin: 0.3),

          const SizedBox(height: 16),

          Text(
            'Lerne E-Gitarre spielen mit deiner\nEnya XMARI Smart Guitar',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 500.ms)
              .fadeIn(),

          const SizedBox(height: 48),

          // Feature highlights
          ..._buildFeatures(context),

          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext ?? () => context.go('/onboarding/welcome'),
              child: const Text('Los geht\'s!'),
            ),
          )
              .animate(delay: 900.ms)
              .fadeIn()
              .slideY(begin: 0.3),
        ],
      ),
    );
  }

  List<Widget> _buildFeatures(BuildContext context) {
    final features = [
      (Icons.music_note, 'Gamifiziertes Lernen', '12 Module mit über 60 Lektionen'),
      (Icons.tune, 'Smart-Gitarren-Integration', 'Verbinde deine Enya XMARI direkt'),
      (Icons.emoji_events, 'Achievements & XP', 'Sammle Erfahrungspunkte und Erfolge'),
    ];

    return features
        .asMap()
        .entries
        .map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(entry.value.$1, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.value.$2,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                      Text(
                        entry.value.$3,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate(delay: Duration(milliseconds: 600 + (entry.key * 100)))
              .fadeIn()
              .slideX(begin: -0.2),
        )
        .toList();
  }
}
