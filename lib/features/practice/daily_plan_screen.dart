import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/colors.dart';
import '../../core/bluetooth/bluetooth_service.dart';
import '../../core/bluetooth/xmari_constants.dart';
import '../../core/curriculum/pedagogy/learning_rules.dart';
import '../../core/practice/daily_plan_generator.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/xmari_status_badge.dart';

class DailyPlanScreen extends ConsumerStatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  ConsumerState<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends ConsumerState<DailyPlanScreen> {
  int _currentBlockIndex = 0;
  late DailyPlan _plan;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(currentUserProfileProvider).value;
    _plan = DailyPlanGenerator.generatePlan(
      userId: profile?.id ?? '',
      completedModules: profile?.totalModulesCompleted ?? 0,
    );
  }

  void _nextBlock() {
    if (_currentBlockIndex < _plan.blocks.length - 1) {
      final nextBlock = _plan.blocks[_currentBlockIndex + 1];
      final currentBlock = _plan.blocks[_currentBlockIndex];
      if (nextBlock.xmariSetup.presetName != currentBlock.xmariSetup.presetName) {
        _showPresetChangeDialog(nextBlock.xmariSetup);
        return;
      }
      setState(() => _currentBlockIndex++);
    }
  }

  void _showPresetChangeDialog(XmariSetup newSetup) {
    final btService = ref.read(bluetoothServiceProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Preset wechseln'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Wechsle jetzt zu: ${newSetup.presetName}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: XmariConstants.presetColor(newSetup.presetIndex)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                btService.currentState.isConnected
                    ? 'Preset wird automatisch per Bluetooth gewechselt...'
                    : 'Drücke den Power-Button der XMARI bis du "${newSetup.presetName}" hörst.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _currentBlockIndex++);
            },
            child: const Text('Preset gewechselt – Weiter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final block = _plan.blocks[_currentBlockIndex];
    final presetColor =
        XmariConstants.presetColor(block.xmariSetup.presetIndex);
    final isLast = _currentBlockIndex == _plan.blocks.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagesplan'),
        actions: const [XmariStatusBadge(), SizedBox(width: 8)],
      ),
      body: Column(
        children: [
          // Fortschrittsbalken
          LinearProgressIndicator(
            value: (_currentBlockIndex + 1) / _plan.blocks.length,
            backgroundColor: AppColors.outline,
            color: AppColors.primary,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Block ${_currentBlockIndex + 1} von ${_plan.blocks.length}',
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(block.title,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(block.description,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 15)),
                  const SizedBox(height: 24),
                  // XMARI-Setup
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: presetColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: presetColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.music_note, color: presetColor),
                        const SizedBox(width: 12),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(block.xmariSetup.presetName,
                                  style: TextStyle(
                                      color: presetColor,
                                      fontWeight: FontWeight.bold)),
                              Text(block.xmariSetup.pickupPosition,
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12)),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${block.durationMinutes} Minuten',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          isLast ? () => Navigator.pop(context) : _nextBlock,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary),
                      child: Text(
                        isLast ? 'Plan abgeschlossen 🎉' : 'Weiter',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
