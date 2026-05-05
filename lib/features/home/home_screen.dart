import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import '../../core/gamification/achievement_banner.dart';
import '../../core/providers/app_providers.dart';
import '../../core/updates/update_check_service.dart';
import '../../core/updates/update_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _updateDialogShown = false;

  @override
  void initState() {
    super.initState();
    // Activate the achievement watcher and streak verifier listeners.
    ref.read(achievementWatcherProvider);
    ref.read(streakVerifierProvider);
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

    return AchievementBannerHost(
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                index: 0,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: () => _onTabTap(0),
              ),
              _NavItem(
                icon: Icons.tune_outlined,
                activeIcon: Icons.tune,
                label: l10n?.tabTuner ?? 'Stimmgerät',
                index: 1,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: () => _onTabTap(1),
              ),
              _NavItem(
                icon: Icons.timer_outlined,
                activeIcon: Icons.timer,
                label: l10n?.tabMetronome ?? 'Metronom',
                index: 2,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: () => _onTabTap(2),
              ),
              _NavItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart,
                label: l10n?.tabProgress ?? 'Fortschritt',
                index: 3,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: () => _onTabTap(3),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: l10n?.tabSettings ?? 'Einstellungen',
                index: 4,
                currentIndex: widget.navigationShell.currentIndex,
                onTap: () => _onTabTap(4),
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
