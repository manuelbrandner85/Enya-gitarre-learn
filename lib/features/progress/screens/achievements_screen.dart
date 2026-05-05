import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/models/achievement.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(achievementsProvider);
    final unlockedMap = {for (final a in unlocked) a.key: a};
    final all = AchievementRegistry.allAchievements
        .map((a) => unlockedMap[a.key] ?? a)
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Erfolge'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Alle'),
              Tab(text: 'Freigeschaltet'),
              Tab(text: 'Geheim'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _Grid(items: all),
            _Grid(items: all.where((a) => a.isUnlocked).toList()),
            _Grid(items: all.where((a) => a.isSecret).toList()),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<Achievement> items;
  const _Grid({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Keine Erfolge in dieser Kategorie',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _BadgeTile(achievement: items[i]),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final Achievement achievement;
  const _BadgeTile({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.isUnlocked;
    final isSecretLocked = achievement.isSecret && !unlocked;
    return InkWell(
      onTap: () => _showDetail(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: unlocked ? AppColors.achievementColor : AppColors.outline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: unlocked
                    ? AppColors.achievementColor
                    : AppColors.surfaceVariantDark,
              ),
              child: Icon(
                isSecretLocked
                    ? Icons.help_outline
                    : (unlocked ? Icons.emoji_events : Icons.emoji_events_outlined),
                color: unlocked ? Colors.white : AppColors.textTertiary,
                size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSecretLocked ? '???' : achievement.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: unlocked
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final unlocked = achievement.isUnlocked;
    final isSecretLocked = achievement.isSecret && !unlocked;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked
                  ? AppColors.achievementColor
                  : AppColors.surfaceVariantDark,
            ),
            child: Icon(
              isSecretLocked ? Icons.help_outline : Icons.emoji_events,
              color: unlocked ? Colors.white : AppColors.textTertiary,
              size: 48,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSecretLocked ? 'Geheimer Erfolg' : achievement.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSecretLocked
                  ? 'Spiele weiter, um diesen Erfolg freizuschalten.'
                  : achievement.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: AppColors.xpColor, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${achievement.xpReward} XP',
                  style: const TextStyle(color: AppColors.xpColor),
                ),
              ],
            ),
            if (unlocked && achievement.unlockedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Freigeschaltet am ${DateFormat('dd.MM.yyyy').format(achievement.unlockedAt!)}',
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
}
