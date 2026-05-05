import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/colors.dart';
import '../../core/gamification/achievement_banner.dart';
import '../../core/providers/app_providers.dart';
import '../../core/updates/update_check_service.dart';
import '../../core/updates/update_dialog.dart';
import '../../core/utils/constants.dart';
import '../../core/database/app_database.dart';
import '../../core/curriculum/curriculum.dart';

// Tab indices
const int _tabLernen = 0;
const int _tabSongbuch = 1;
const int _tabTuner = 2;
const int _tabMetronome = 3;
const int _tabProgress = 4;
const int _tabSettings = 5;

class HomeScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _updateDialogShown = false;
  String? _lastLessonTitle;

  @override
  void initState() {
    super.initState();
    // Activate the achievement watcher and streak verifier listeners.
    ref.read(achievementWatcherProvider);
    ref.read(streakVerifierProvider);
    _loadLastLesson();
  }

  Future<void> _loadLastLesson() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final userId = prefs.getString(AppConstants.prefKeyUserId);
      if (userId == null) return;
      final db = ref.read(databaseProvider);
      final rows = await db.getAllLessonProgress(userId);
      if (rows.isEmpty) return;
      // Find the most recently attempted lesson
      LessonProgressTableData? latest;
      for (final row in rows) {
        if (latest == null) {
          latest = row;
        } else {
          final rowTime = row.lastAttemptAt ?? row.completedAt;
          final latestTime = latest.lastAttemptAt ?? latest.completedAt;
          if (rowTime != null &&
              (latestTime == null || rowTime.isAfter(latestTime))) {
            latest = row;
          }
        }
      }
      if (latest == null) return;
      final lesson =
          Curriculum.findLesson(latest.moduleId, latest.lessonId);
      if (lesson != null && mounted) {
        setState(() => _lastLessonTitle = lesson.title);
      }
    } catch (_) {
      // Ignore errors; fallback title will be used
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for updates from Supabase app_config.
    ref.listen<AsyncValue<UpdateInfo?>>(updateCheckProvider, (previous, next) {
      final info = next.value;
      if (info == null || _updateDialogShown) return;
      _updateDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) UpdateDialog.show(context, info);
      });
    });

    final currentIndex = widget.navigationShell.currentIndex;
    final showCta = currentIndex == _tabLernen;

    return AchievementBannerHost(
      child: Scaffold(
        body: showCta
            ? Column(
                children: [
                  WeiterUebenCard(
                    lessonTitle:
                        _lastLessonTitle ?? 'Modul 1 – Grundlagen',
                  ),
                  SongbuchCard(
                    onTap: () => _onTabTap(_tabSongbuch),
                  ),
                  Expanded(child: widget.navigationShell),
                ],
              )
            : widget.navigationShell,
        bottomNavigationBar: _buildBottomNavBar(context),
        floatingActionButton: currentIndex == _tabLernen
            ? FloatingActionButton.small(
                heroTag: 'metronome_fab',
                backgroundColor: const Color(0xFF7C3AED),
                onPressed: () => _onTabTap(_tabMetronome),
                tooltip: 'Metronom',
                child: const Icon(Icons.timer_outlined, color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentIndex = widget.navigationShell.currentIndex;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.outline, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.school_outlined,
                activeIcon: Icons.school,
                label: l10n?.tabLessons ?? 'Lernen',
                index: _tabLernen,
                currentIndex: currentIndex,
                onTap: () => _onTabTap(_tabLernen),
              ),
              _SongbuchNavItem(
                currentIndex: currentIndex,
                onTap: () => _onTabTap(_tabSongbuch),
              ),
              _NavItem(
                icon: Icons.tune_outlined,
                activeIcon: Icons.tune,
                label: l10n?.tabTuner ?? 'Stimmgerät',
                index: _tabTuner,
                currentIndex: currentIndex,
                onTap: () => _onTabTap(_tabTuner),
              ),
              _NavItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: l10n?.tabProgress ?? 'Fortschritt',
                index: _tabProgress,
                currentIndex: currentIndex,
                onTap: () => _onTabTap(_tabProgress),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: l10n?.tabSettings ?? 'Einstellungen',
                index: _tabSettings,
                currentIndex: currentIndex,
                onTap: () => _onTabTap(_tabSettings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// FAB-style highlighted nav item for the Songbuch tab (index 1).
class _SongbuchNavItem extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onTap;

  const _SongbuchNavItem({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == _tabSongbuch;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isSelected ? Icons.library_music : Icons.library_music_outlined,
                size: 26,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Songbuch',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card that promotes the Songbuch feature from the Lernen (lessons) tab.
class SongbuchCard extends StatelessWidget {
  final VoidCallback onTap;

  const SongbuchCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.35),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.library_music,
                  size: 24,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Songbuch',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '200 Songs zum Nachspielen',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A prominent "Weiter üben" CTA card shown at the top of the lessons tab.
class WeiterUebenCard extends StatelessWidget {
  final String lessonTitle;

  const WeiterUebenCard({super.key, required this.lessonTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () => context.go('/home/lessons'),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weiter üben',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lessonTitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.play_circle_filled,
                size: 48,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
