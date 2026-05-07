import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/bluetooth/bluetooth_service.dart';
import '../../../core/bluetooth/xmari_constants.dart';
import '../../../core/curriculum/pedagogy/learning_rules.dart';
import '../../../core/providers/app_providers.dart';
import '../../../app/theme/colors.dart';

class XmariSetupCard extends ConsumerWidget {
  final XmariSetup setup;
  final VoidCallback onDismiss;

  const XmariSetupCard({super.key, required this.setup, required this.onDismiss});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final btService = ref.watch(bluetoothServiceProvider);
    final isConnected = btService.currentState.isConnected;
    final presetColor = XmariConstants.presetColor(setup.presetIndex);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: presetColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: presetColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.music_note, size: 14, color: presetColor),
                      const SizedBox(width: 4),
                      Text(
                        setup.presetName,
                        style: TextStyle(
                          color: presetColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    setup.pickupPosition,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (setup.requiresHeadphones)
                  const Chip(
                    label: Text(
                      '🎧 Kopfhörer',
                      style: TextStyle(fontSize: 11),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              setup.explanation,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            if (setup.toneKnobSuggestion != null) ...[
              const SizedBox(height: 4),
              Text(
                '💡 ${setup.toneKnobSuggestion}',
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
            const SizedBox(height: 12),
            // XMARI-Verbindungsstatus
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isConnected
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isConnected ? Icons.check_circle : Icons.cable,
                    size: 16,
                    color: isConnected
                        ? const Color(0xFF4CAF50)
                        : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isConnected
                          ? 'XMARI verbunden ✓'
                          : 'Schließe deine XMARI via USB-C an für bestes Audio',
                      style: TextStyle(
                        fontSize: 12,
                        color: isConnected
                            ? const Color(0xFF4CAF50)
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDismiss,
                child: const Text('Verstanden – Los geht\'s!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
