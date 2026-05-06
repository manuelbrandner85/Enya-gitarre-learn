import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/colors.dart';
import '../../core/database/app_database.dart';
import '../../core/gamification/level_manager.dart';
import '../../core/gamification/xp_system.dart';
import '../../core/gamification/streak_tracker.dart';
import '../../core/models/achievement.dart';
import '../../core/providers/app_providers.dart';
import '../../core/utils/constants.dart';

class ProgressDashboardScreen extends ConsumerWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final achievements = ref.watch(achievementsProvider);
    final totalXp = profile?.totalXp ?? 0;
    final level = profile?.level ?? 1;
    final streak = profile?.currentStreak ?? 0;
    final longestStreak = profile?.longestStreak ?? 0;
    final totalMinutes = profile?.totalPracticeMinutes ?? 0;
    final lessonsCompleted = profile?.totalLessonsCompleted ?? 0;
    final modulesCompleted = profile?.totalModulesCompleted ?? 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Mein Fortschritt'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Level card
          _LevelCard(
            level: level,
            totalXp: totalXp,
            xpToNext: XpSystem.xpToNextLevel(totalXp),
            progress: XpSystem.levelProgress(totalXp),
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Streak card
          _StreakCard(
            streak: streak,
            longestStreak: longestStreak,
          ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Stats grid
          _StatsGrid(
            totalMinutes: totalMinutes,
            lessonsCompleted: lessonsCompleted,
            modulesCompleted: modulesCompleted,
            totalNotes: 0,
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 16),

          // Practice chart
          const _PracticeChart().animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 16),

          // Achievements preview
          _AchievementsPreview(
            unlockedCount: achievements.length,
            totalCount: AchievementRegistry.allAchievements.length,
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final int totalXp;
  final int xpToNext;
  final double progress;

  const _LevelCard({
    required this.level,
    required this.totalXp,
    required this.xpToNext,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: LevelManager.levelBadgeGradient(level),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LevelManager.levelBadgeColor(level).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level $level',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                LevelManager.levelTitle(level),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$xpToNext XP bis Level ${level + 1}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            LevelManager.levelIcon(level),
            style: const TextStyle(fontSize: 48),
          ),
        ],
      ),
    );
  }
}

double _streakLevelProgress(int streak) {
  final milestones = [7, 30, 100, 365];
  for (final m in milestones) {
    if (streak < m) return (streak / m).clamp(0.0, 1.0);
  }
  return 1.0;
}

class _StreakCard extends StatelessWidget {
  final int streak;
  final int longestStreak;

  const _StreakCard({required this.streak, required this.longestStreak});

  @override
  Widget build(BuildContext context) {
    final level = StreakTracker.levelForDays(streak);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Text(
            '🔥',
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak Tage Streak',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  level.displayName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: level.color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Längster Streak: $longestStreak Tage',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
              ],
            ),
          ),
          // Next milestone progress
          if (streak < 365)
            CircularPercentIndicator(
              radius: 30,
              lineWidth: 4,
              percent: _streakLevelProgress(streak),
              center: Text(
                '${streak}d',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 10,
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w700,
                ),
              ),
              progressColor: AppColors.streakColor,
              backgroundColor: AppColors.outline,
            ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final int totalMinutes;
  final int lessonsCompleted;
  final int modulesCompleted;
  final int totalNotes;

  const _StatsGrid({
    required this.totalMinutes,
    required this.lessonsCompleted,
    required this.modulesCompleted,
    required this.totalNotes,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('⏱️', '${totalMinutes ~/ 60}h ${totalMinutes % 60}m', 'Übungszeit'),
      ('📚', '$lessonsCompleted', 'Lektionen'),
      ('🎯', '$modulesCompleted', 'Module'),
      ('🎵', '$totalNotes', 'Töne gespielt'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.8,
      children: stats.map((stat) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(stat.$1, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    stat.$2,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                stat.$3,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Provider to load the last 7 days of practice data
final _last7DaysProvider = FutureProvider<List<_DayData>>((ref) async {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final userId = prefs.getString(AppConstants.prefKeyUserId) ?? '';
  if (userId.isEmpty) {
    return List.generate(7, (i) {
      final day = DateTime.now().subtract(Duration(days: 6 - i));
      return _DayData(day: day, minutes: 0);
    });
  }

  final stats = await db.getDailyStats(userId, days: 8);
  final now = DateTime.now();
  final result = <_DayData>[];
  for (int i = 6; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final match = stats.where((s) =>
        !s.date.isBefore(dayStart) && s.date.isBefore(dayEnd));
    final minutes = match.fold<int>(0, (sum, s) => sum + s.practiceMinutes);
    result.add(_DayData(day: day, minutes: minutes));
  }
  return result;
});

class _DayData {
  final DateTime day;
  final int minutes;
  const _DayData({required this.day, required this.minutes});
}

class _PracticeChart extends ConsumerWidget {
  const _PracticeChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(_last7DaysProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Übungsminuten (letzte 7 Tage)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 20),
          asyncData.when(
            loading: () => const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => _buildChart(context, [], []),
            data: (days) {
              final allZero = days.every((d) => d.minutes == 0);
              if (allZero) {
                return _buildMotivationWidget(context);
              }
              final spots = days
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.minutes.toDouble()))
                  .toList();
              final totalMinutes =
                  days.fold<int>(0, (sum, d) => sum + d.minutes);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChart(context, spots, days),
                  const SizedBox(height: 8),
                  Text(
                    'Diese Woche: ${totalMinutes}m · Durchschnitt: ${(totalMinutes / 7).round()}m/Tag',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
      BuildContext context, List<FlSpot> spots, List<_DayData> days) {
    const weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final now = DateTime.now();
    final effectiveSpots = spots.isEmpty
        ? List.generate(7, (i) => FlSpot(i.toDouble(), 0))
        : spots;
    final maxY = effectiveSpots
        .map((s) => s.y)
        .fold<double>(30, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 3).ceilToDouble().clamp(5, double.infinity),
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.outline,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx > 6) return const SizedBox.shrink();
                  final day = now.subtract(Duration(days: 6 - idx));
                  final label = weekdays[day.weekday - 1];
                  return Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                      fontFamily: 'Inter',
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: effectiveSpots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ],
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxY + 5,
        ),
      ),
    );
  }

  Widget _buildMotivationWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.music_note, size: 48, color: Color(0xFF444444)),
        const SizedBox(height: 12),
        const Text(
          'Starte deine erste Übung!',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const Text(
          'Hier siehst du bald deinen Übungsverlauf',
          style: TextStyle(color: Color(0xFF666666), fontSize: 12),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.go('/home/lessons'),
          child: const Text('Jetzt üben'),
        ),
      ],
    );
  }
}

class _AchievementsPreview extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;

  const _AchievementsPreview({
    required this.unlockedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              Text(
                '$unlockedCount / $totalCount',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.outline,
            valueColor: const AlwaysStoppedAnimation(AppColors.achievementColor),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),

          // Preview grid of locked achievements
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AchievementRegistry.allAchievements
                .take(8)
                .map(
                  (a) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariantDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.emoji_events,
                        size: 24,
                        color: a.isSecret
                            ? AppColors.textTertiary
                            : AppColors.achievementColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
