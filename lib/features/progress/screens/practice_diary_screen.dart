import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/database/app_database.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';

final _dailyStatsProvider =
    FutureProvider.autoDispose<List<DailyStatsTableData>>((ref) async {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final userId = prefs.getString(AppConstants.prefKeyUserId);
  if (userId == null) return const [];
  return db.getDailyStats(userId, days: 90);
});

class PracticeDiaryScreen extends ConsumerWidget {
  const PracticeDiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(_dailyStatsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Übungs-Tagebuch')),
      body: stats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (items) {
          final byDate = <DateTime, DailyStatsTableData>{};
          for (final s in items) {
            final d = DateTime(s.date.year, s.date.month, s.date.day);
            byDate[d] = s;
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Letzte 90 Tage',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _Heatmap(byDate: byDate),
              const SizedBox(height: 24),
              const Text(
                'Übungssitzungen',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Noch keine Übungssitzungen erfasst.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ...items.map((s) => _SessionTile(stats: s)),
            ],
          );
        },
      ),
    );
  }
}

class _Heatmap extends StatelessWidget {
  final Map<DateTime, DailyStatsTableData> byDate;
  const _Heatmap({required this.byDate});

  Color _intensity(int minutes) {
    if (minutes <= 0) return AppColors.surfaceVariantDark;
    if (minutes < 10) return AppColors.primary.withOpacity(0.3);
    if (minutes < 30) return AppColors.primary.withOpacity(0.55);
    if (minutes < 60) return AppColors.primary.withOpacity(0.8);
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 89));
    final cells = List.generate(90, (i) {
      final d = start.add(Duration(days: i));
      return d;
    });
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: cells.length,
      itemBuilder: (_, i) {
        final d = cells[i];
        final key = DateTime(d.year, d.month, d.day);
        final stat = byDate[key];
        final mins = stat?.practiceMinutes ?? 0;
        return Tooltip(
          message:
              '${DateFormat('dd.MM').format(d)} · $mins Min',
          child: Container(
            decoration: BoxDecoration(
              color: _intensity(mins),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      },
    );
  }
}

class _SessionTile extends StatelessWidget {
  final DailyStatsTableData stats;
  const _SessionTile({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardDark,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.calendar_today, color: Colors.white),
        ),
        title: Text(
          DateFormat('EEEE, dd.MM.yyyy', 'de').format(stats.date),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${stats.practiceMinutes} Min · ${stats.lessonsCompleted} Lektionen',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            Text(
              '${stats.xpEarned} XP · ${stats.notesPlayed} Noten',
              style: const TextStyle(
                color: AppColors.xpColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: stats.streakMaintained
            ? const Icon(Icons.local_fire_department,
                color: AppColors.streakColor)
            : null,
      ),
    );
  }
}
