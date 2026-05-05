import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../app/theme/colors.dart';
import '../../core/models/module.dart';

class ModuleOverviewScreen extends ConsumerWidget {
  const ModuleOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ModuleContent.allModules;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Lern-Module'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () {},
            tooltip: 'Achievements',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final module = modules[index];
                  return _ModuleCard(
                    module: module,
                    index: index,
                    onTap: module.isLocked
                        ? null
                        : () => context.go(
                            '/home/lessons/${module.id}/lesson-01'),
                  );
                },
                childCount: modules.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guten Tag! 👋',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    Text(
                      'Weiter lernen',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ],
                ),
              ),
              // Streak badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.streakColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.streakColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '0 Tage',
                      style: TextStyle(
                        color: AppColors.streakColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Overall progress bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gesamtfortschritt',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '0 / 12 Module',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.0,
                        backgroundColor: Colors.black.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.black),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Text(
                      '0',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                    ),
                    Text(
                      'XP',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final Module module;
  final int index;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.module,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = module.isLocked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked ? AppColors.outline : AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Stack(
          children: [
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Module number badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isLocked
                          ? AppColors.surfaceVariantDark
                          : AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isLocked
                          ? const Icon(Icons.lock, color: AppColors.textTertiary, size: 20)
                          : Text(
                              '${module.moduleNumber}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: isLocked
                                    ? AppColors.textTertiary
                                    : AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          module.weekRange,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        if (!isLocked)
                          LinearProgressIndicator(
                            value: module.completionPercentage,
                            backgroundColor: AppColors.outline,
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.primary),
                            borderRadius: BorderRadius.circular(2),
                            minHeight: 4,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _DifficultyDots(difficulty: module.difficulty),
                      const SizedBox(height: 4),
                      if (!isLocked)
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: index * 50))
          .fadeIn()
          .slideX(begin: 0.05),
    );
  }
}

class _DifficultyDots extends StatelessWidget {
  final int difficulty;

  const _DifficultyDots({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < (difficulty / 2).ceil();
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.primary : AppColors.outline,
          ),
        );
      }),
    );
  }
}
