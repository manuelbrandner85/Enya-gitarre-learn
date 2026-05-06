import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/theme/colors.dart';
import '../../../core/providers/app_providers.dart';

class ObserverSettingsScreen extends ConsumerStatefulWidget {
  const ObserverSettingsScreen({super.key});

  @override
  ConsumerState<ObserverSettingsScreen> createState() =>
      _ObserverSettingsScreenState();
}

class _ObserverSettingsScreenState
    extends ConsumerState<ObserverSettingsScreen> {
  bool _observerMode = false;

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _observerMode = prefs.getBool('observer_mode') ?? false;
    });
  }

  Future<void> _toggleObserverMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('observer_mode', value);
    setState(() => _observerMode = value);
  }

  void _shareStats(BuildContext context, int minutes, int modules, int streak) {
    final text =
        'Übungsfortschritt (letzte 7 Tage):\n'
        '• Gesamtübungszeit: $minutes Minuten\n'
        '• Abgeschlossene Module: $modules\n'
        '• Aktuelle Streak: $streak Tage';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentUserProfileProvider);
    final profile = profileAsync.value;
    final practiceMinutes = profile?.totalPracticeMinutes ?? 0;
    final completedModules = profile?.totalModulesCompleted ?? 0;
    final streak = profile?.currentStreak ?? 0;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Beobachter-Modus'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Toggle
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.supervisor_account_outlined),
              title: const Text('Beobachter-Modus aktiv'),
              value: _observerMode,
              onChanged: _toggleObserverMode,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Im Beobachter-Modus können Eltern oder Lehrer den Fortschritt ansehen, '
                'ohne Einstellungen zu verändern.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Stats section
          Text(
            'FORTSCHRITT (LETZTE 7 TAGE)',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('Gesamtübungszeit'),
                  trailing: Text(
                    '$practiceMinutes Minuten',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: const Text('Abgeschlossene Module'),
                  trailing: Text(
                    '$completedModules',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.local_fire_department_outlined),
                  title: const Text('Aktuelle Streak'),
                  trailing: Text(
                    '$streak Tage',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Share chip
          Align(
            alignment: Alignment.centerLeft,
            child: ActionChip(
              avatar: const Icon(Icons.share_outlined, size: 18),
              label: const Text('Teilen'),
              onPressed: () => _shareStats(
                context,
                practiceMinutes,
                completedModules,
                streak,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
