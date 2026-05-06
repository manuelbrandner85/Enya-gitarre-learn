import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/colors.dart';
import '../../core/bluetooth/bluetooth_service.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/xmari_status_badge.dart';

class QuickPracticeScreen extends ConsumerWidget {
  const QuickPracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final btService = ref.watch(bluetoothServiceProvider);
    final isConnected = btService.currentState.isConnected;
    // ignore: unused_local_variable
    final profile = ref.watch(currentUserProfileProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Minuten-Übung'),
        actions: const [XmariStatusBadge(), SizedBox(width: 8)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Schnell-Übung',
                style:
                    TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('5 Minuten – sofort starten',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isConnected
                    ? AppColors.success.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                      isConnected ? Icons.check_circle : Icons.cable,
                      color: isConnected ? AppColors.success : Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isConnected
                          ? 'XMARI bereit – los geht\'s!'
                          : 'Schnell-Übung funktioniert auch ohne XMARI (Mikrofon). '
                              'Für bestes Ergebnis: XMARI anschließen.',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Schnell-Auswahl
            _QuickOption(
              icon: Icons.replay,
              title: 'Letzte Übung wiederholen',
              subtitle: 'Schnell auf Kurs bleiben',
              onTap: () => context.go('/home/lessons'),
            ),
            const SizedBox(height: 12),
            _QuickOption(
              icon: Icons.music_note,
              title: 'Nächste Lektion',
              subtitle: 'Weiter im Lernplan',
              onTap: () => context.go('/home/lessons'),
            ),
            const SizedBox(height: 12),
            _QuickOption(
              icon: Icons.timer,
              title: 'Stimmübung (2 Min)',
              subtitle: 'XMARI stimmen – clean & schnell',
              onTap: () => context.go('/home/tuner'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/home/lessons'),
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text('Sofort starten',
                    style:
                        TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style:
                const TextStyle(fontSize: 12, color: Colors.white54)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
