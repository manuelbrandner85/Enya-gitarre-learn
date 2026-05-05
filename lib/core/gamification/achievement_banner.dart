import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../models/achievement.dart';
import '../providers/app_providers.dart';

/// Listens to [recentAchievementProvider] and displays a SnackBar whenever a
/// new achievement is auto-unlocked. Wrap the [child] (typically the
/// HomeScreen) with this widget to enable the banner.
class AchievementBannerHost extends ConsumerWidget {
  final Widget child;
  const AchievementBannerHost({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Achievement?>(recentAchievementProvider, (previous, next) {
      if (next == null) return;
      _showBanner(context, ref, next);
    });
    return child;
  }

  void _showBanner(BuildContext context, WidgetRef ref, Achievement a) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.cardDark,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.emoji_events,
                color: AppColors.achievementColor, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🏆 ${a.title} freigeschaltet!',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '+${a.xpReward} XP',
                    style: const TextStyle(
                      color: AppColors.xpColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Anzeigen',
          textColor: AppColors.primary,
          onPressed: () {
            ref.read(recentAchievementProvider.notifier).state = null;
            context.go('/home/progress/achievements');
          },
        ),
      ),
    );

    // Reset shortly after so the next unlock can re-trigger.
    Future.delayed(const Duration(seconds: 6), () {
      if (ref.read(recentAchievementProvider) == a) {
        ref.read(recentAchievementProvider.notifier).state = null;
      }
    });
  }
}
