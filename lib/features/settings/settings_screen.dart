import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app.dart';
import '../../app/theme/colors.dart';
import '../../core/audio/pitch_detector.dart';
import '../../core/utils/constants.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _soundEffects = true;
  bool _notifications = true;
  double _volume = 1.0;
  String _selectedTuning = 'standard';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEffects = prefs.getBool('sound_effects') ?? true;
      _notifications = prefs.getBool('notifications') ?? true;
      _volume = prefs.getDouble('master_volume') ?? 1.0;
      _selectedTuning = prefs.getString(AppConstants.prefKeyMetronomeBpm) ?? 'standard';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is double) await prefs.setDouble(key, value);
    if (value is String) await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          // Profile section
          _SectionHeader(title: 'Profil'),
          _buildProfileTile(),

          // Sound section
          _SectionHeader(title: 'Audio & Sound'),
          _SettingsTile(
            icon: Icons.volume_up_outlined,
            title: 'Soundeffekte',
            trailing: Switch(
              value: _soundEffects,
              onChanged: (v) {
                setState(() => _soundEffects = v);
                _saveSetting('sound_effects', v);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(72, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lautstärke: ${(_volume * 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                Slider(
                  value: _volume,
                  onChanged: (v) {
                    setState(() => _volume = v);
                    _saveSetting('master_volume', v);
                  },
                ),
              ],
            ),
          ),

          // Tuning section
          _SectionHeader(title: 'Stimmung'),
          _buildTuningSelector(),

          // Appearance section
          _SectionHeader(title: 'Erscheinungsbild'),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dunkles Design',
            trailing: Switch(
              value: themeMode == ThemeMode.dark,
              onChanged: (v) {
                ref.read(themeModeProvider.notifier).state =
                    v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),

          // Notifications
          _SectionHeader(title: 'Benachrichtigungen'),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Übungs-Erinnerungen',
            subtitle: 'Tägliche Erinnerung zum Üben',
            trailing: Switch(
              value: _notifications,
              onChanged: (v) {
                setState(() => _notifications = v);
                _saveSetting('notifications', v);
              },
            ),
          ),

          // About section
          _SectionHeader(title: 'Über die App'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Über E-Gitarre Leicht',
            subtitle: 'Version ${AppConstants.appVersion}',
            onTap: () => _showAboutDialog(),
          ),
          _SettingsTile(
            icon: Icons.email_outlined,
            title: 'Support kontaktieren',
            subtitle: AppConstants.supportEmail,
            onTap: () async {
              final uri = Uri.parse('mailto:${AppConstants.supportEmail}');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Datenschutzerklärung',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Nutzungsbedingungen',
            onTap: () {},
          ),

          // Danger zone
          _SectionHeader(title: 'Zurücksetzen'),
          _SettingsTile(
            icon: Icons.restart_alt,
            title: 'Onboarding neu starten',
            subtitle: 'Einrichtungsassistent erneut anzeigen',
            onTap: () => _resetOnboarding(),
            iconColor: AppColors.warning,
          ),
          _SettingsTile(
            icon: Icons.delete_outline,
            title: 'Alle Daten löschen',
            subtitle: 'Warnung: Alle Fortschritte werden gelöscht',
            onTap: () => _showDeleteDialog(),
            iconColor: AppColors.error,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileTile() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gitarren-Neuling',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
                Text(
                  'Level 1 · 0 XP',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTuningSelector() {
    final tunings = TuningType.values;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Standard-Stimmung',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedTuning,
            decoration: const InputDecoration(),
            items: tunings
                .map(
                  (t) => DropdownMenuItem(
                    value: t.name,
                    child: Text(t.displayName),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _selectedTuning = v);
                _saveSetting('preferred_tuning', v);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationLegalese: '© 2025 E-Gitarre Leicht',
      children: [
        const Text(
          'Eine gamifizierte E-Gitarren-Lern-App speziell für die Enya XMARI Smart Guitar.',
        ),
      ],
    );
  }

  Future<void> _resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefKeyOnboardingComplete, false);
    if (mounted) {
      context.go('/onboarding');
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alle Daten löschen?'),
        content: const Text(
            'Diese Aktion kann nicht rückgängig gemacht werden. Alle Fortschritte, Achievements und Einstellungen werden gelöscht.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) context.go('/');
            },
            child: Text(
              'Löschen',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.textSecondary),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios,
                  size: 14, color: AppColors.textTertiary)
              : null),
      onTap: onTap,
    );
  }
}
