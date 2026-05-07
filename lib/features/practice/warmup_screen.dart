import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/theme/colors.dart';
import '../../core/bluetooth/xmari_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/xmari_status_badge.dart';

enum _WarmupStep { stretch, chromatic, openStrings, done }

class WarmupScreen extends ConsumerStatefulWidget {
  const WarmupScreen({super.key});

  @override
  ConsumerState<WarmupScreen> createState() => _WarmupScreenState();
}

class _WarmupScreenState extends ConsumerState<WarmupScreen> {
  static const int _phaseDurationSec = 40;
  static const int _totalDurationSec = _phaseDurationSec * 3;

  _WarmupStep _step = _WarmupStep.stretch;
  int _secondsLeft = _phaseDurationSec;
  int _totalElapsed = 0;
  Timer? _timer;
  bool _xpAwarded = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    // Initial XMARI-Hinweis als SnackBar einblenden.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stelle deine XMARI auf Clean, Position 4'),
          duration: Duration(seconds: 4),
        ),
      );
    });
    _startTimer();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _phaseDurationSec;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _secondsLeft--;
        _totalElapsed = (_step.index * _phaseDurationSec) +
            (_phaseDurationSec - _secondsLeft);
      });
      if (_secondsLeft <= 0) {
        t.cancel();
        _nextStep();
      }
    });
  }

  void _nextStep() {
    switch (_step) {
      case _WarmupStep.stretch:
        setState(() => _step = _WarmupStep.chromatic);
        _startTimer();
        break;
      case _WarmupStep.chromatic:
        setState(() => _step = _WarmupStep.openStrings);
        _startTimer();
        break;
      case _WarmupStep.openStrings:
        _timer?.cancel();
        _totalElapsed = _totalDurationSec;
        setState(() => _step = _WarmupStep.done);
        _awardCompletionXp();
        break;
      case _WarmupStep.done:
        break;
    }
  }

  Future<void> _awardCompletionXp() async {
    if (_xpAwarded) return;
    _xpAwarded = true;
    try {
      await ref.read(currentUserProfileProvider.notifier).addXp(10);
    } catch (_) {
      // Ignorieren – Aufwärmen funktioniert auch ohne XP-Persistenz.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aufwärmen'),
        actions: const [XmariStatusBadge(), SizedBox(width: 8)],
      ),
      body: Column(
        children: [
          // Globaler Fortschrittsbalken über alle 3 Phasen
          if (_step != _WarmupStep.done) ...[
            LinearProgressIndicator(
              value: _totalElapsed / _totalDurationSec,
              minHeight: 4,
              color: const Color(0xFF7C3AED),
              backgroundColor: AppColors.outline,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Phase ${_step.index + 1}/3',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(_totalDurationSec - _totalElapsed).clamp(0, _totalDurationSec)}s gesamt',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  _step == _WarmupStep.done ? _buildDone() : _buildStep(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    final info = _stepInfo;
    return Column(
      children: [
        // Fortschritts-Punkte
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _WarmupStep.values.where((s) => s != _WarmupStep.done).map((s) {
            final done = s.index < _step.index;
            final active = s == _step;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: active ? 24 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: done ? const Color(0xFF4CAF50) : active ? const Color(0xFF7C3AED) : AppColors.outline,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        // Timer
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120, height: 120,
              child: CircularProgressIndicator(
                value: _secondsLeft / 40,
                strokeWidth: 8,
                color: const Color(0xFF7C3AED),
                backgroundColor: AppColors.outline,
              ),
            ),
            Text('$_secondsLeft', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 32),
        Text(info.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(info.description, style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.music_note, color: Color(0xFF4CAF50), size: 16),
              const SizedBox(width: 8),
              Text(info.xmariTip, style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 12)),
            ],
          ),
        ),
        const Spacer(),
        TextButton(onPressed: _nextStep, child: const Text('Überspringen')),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
            child: const Text('Weiter', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildDone() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 80),
        const SizedBox(height: 24),
        const Text('Aufgewärmt!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Deine XMARI und deine Finger sind bereit',
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 24),
        // Zusammenfassung
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            children: [
              _SummaryRow(
                  icon: Icons.timer,
                  label: 'Dauer',
                  value: '${_totalDurationSec ~/ 60}:00 Min'),
              const SizedBox(height: 8),
              _SummaryRow(
                  icon: Icons.fitness_center,
                  label: 'Phasen',
                  value: '3/3 abgeschlossen'),
              const SizedBox(height: 8),
              const _SummaryRow(
                icon: Icons.bolt,
                label: 'XP',
                value: '+10',
                valueColor: Color(0xFFFFD700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.go('/home/lessons'),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED)),
            child: const Text('Zur Lektion',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  ({String title, String description, String xmariTip}) get _stepInfo {
    switch (_step) {
      case _WarmupStep.stretch:
        return (
          title: 'Finger stretchen',
          description: 'Spreize alle Finger weit auseinander, halte 3 Sekunden.\nWiederhol das 5x.\nDann sanft die Handgelenke kreisen.',
          xmariTip: 'Halte deine XMARI noch kurz beiseite – erst Finger aufwärmen!',
        );
      case _WarmupStep.chromatic:
        return (
          title: 'Chromatische Übung',
          description: 'Auf deiner XMARI: Spiele Bund 1-2-3-4 auf jeder Saite. Langsam und bewusst.\nClean-Preset, Pickup Position 4.',
          xmariTip: 'Clean-Preset, Position 4 – du hörst jeden Ton klar im Kopfhörer.',
        );
      case _WarmupStep.openStrings:
        return (
          title: 'Offene Saiten stimmen',
          description: 'Zupfe jede Saite einzeln. Stimmt alles?\nDie App erkennt automatisch ob deine XMARI gestimmt ist.',
          xmariTip: 'USB-C: Die App hört deine XMARI direkt – kein Raten nötig.',
        );
      case _WarmupStep.done:
        return (title: '', description: '', xmariTip: '');
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
