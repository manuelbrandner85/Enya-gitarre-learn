import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/models/lesson.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';

class _PresetMeta {
  final GuitarPreset preset;
  final Color color;
  final String unlockCondition;
  final List<String> instructions;
  const _PresetMeta({
    required this.preset,
    required this.color,
    required this.unlockCondition,
    required this.instructions,
  });
}

const List<_PresetMeta> _presetMetas = [
  _PresetMeta(
    preset: GuitarPreset.clean,
    color: AppColors.presetClean,
    unlockCondition: 'Von Beginn an verfügbar',
    instructions: [
      '1. Schalte die XMARI Smart Guitar ein.',
      '2. Drücke kurz die TONE-Taste.',
      '3. Die LED leuchtet BLAU für Clean.',
      '4. Spiele eine Saite, um den Sound zu testen.',
    ],
  ),
  _PresetMeta(
    preset: GuitarPreset.overdrive,
    color: AppColors.presetOverdrive,
    unlockCondition: 'Schließe Modul 4 ab',
    instructions: [
      '1. Halte die TONE-Taste 2 Sekunden gedrückt.',
      '2. Wähle den zweiten Slot mit der NEXT-Taste.',
      '3. Die LED leuchtet ORANGE für Overdrive.',
      '4. Stelle den Gain mit dem Regler ein.',
    ],
  ),
  _PresetMeta(
    preset: GuitarPreset.distortion,
    color: AppColors.presetDistortion,
    unlockCondition: 'Schließe Modul 7 ab',
    instructions: [
      '1. Halte die TONE-Taste 2 Sekunden gedrückt.',
      '2. Drücke NEXT zweimal.',
      '3. Die LED leuchtet ROT für Distortion.',
      '4. Pass die Mitten mit dem MID-Regler an.',
    ],
  ),
  _PresetMeta(
    preset: GuitarPreset.highGain,
    color: AppColors.presetHighGain,
    unlockCondition: 'Schließe Modul 10 ab',
    instructions: [
      '1. Halte die TONE-Taste 2 Sekunden gedrückt.',
      '2. Drücke NEXT dreimal.',
      '3. Die LED leuchtet LILA für High-Gain.',
      '4. Aktiviere den Noise Gate mit der GATE-Taste.',
    ],
  ),
];

class XmariPresetManagerScreen extends ConsumerWidget {
  const XmariPresetManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);
    final unlocked = profile.value?.unlockedPresets ?? const <String>[];
    final completedModules =
        ref.watch(moduleProgressProvider).completedModuleIds.length;

    return Scaffold(
      appBar: AppBar(title: const Text('XMARI Presets')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _presetMetas.length,
        itemBuilder: (_, i) {
          final m = _presetMetas[i];
          final isUnlocked =
              m.preset == GuitarPreset.clean ||
                  unlocked.contains(m.preset.name);
          return _PresetCard(
            meta: m,
            unlocked: isUnlocked,
            completedModules: completedModules,
          );
        },
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final _PresetMeta meta;
  final bool unlocked;
  final int completedModules;
  const _PresetCard({
    required this.meta,
    required this.unlocked,
    required this.completedModules,
  });

  int get _requiredModules {
    switch (meta.preset) {
      case GuitarPreset.overdrive:
        return 4;
      case GuitarPreset.distortion:
        return 7;
      case GuitarPreset.highGain:
        return 10;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardDark,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => unlocked
            ? _showInstructions(context)
            : _showProgress(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                meta.color.withOpacity(unlocked ? 0.6 : 0.2),
                AppColors.cardDark,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: meta.color,
                child: Icon(
                  unlocked ? Icons.check : Icons.lock,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      meta.preset.displayName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta.preset.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      unlocked
                          ? 'Freigeschaltet'
                          : meta.unlockCondition,
                      style: TextStyle(
                        color: unlocked
                            ? AppColors.success
                            : AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                unlocked ? Icons.chevron_right : Icons.lock_outline,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta.preset.displayName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'XMARI Tasten-Anleitung:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            for (final step in meta.instructions)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle,
                        color: meta.color, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showProgress(BuildContext context) {
    final required = _requiredModules;
    final progress = required == 0 ? 1.0 : (completedModules / required).clamp(0.0, 1.0);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(meta.preset.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meta.unlockCondition),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.outline,
              color: meta.color,
            ),
            const SizedBox(height: 8),
            Text('$completedModules / $required Module abgeschlossen'),
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
