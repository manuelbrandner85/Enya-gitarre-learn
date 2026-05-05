import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';

enum EarTrainingMode { intervals, chords, scales }

extension on EarTrainingMode {
  String get title {
    switch (this) {
      case EarTrainingMode.intervals:
        return 'Intervall-Training';
      case EarTrainingMode.chords:
        return 'Akkord-Training';
      case EarTrainingMode.scales:
        return 'Tonleiter-Training';
    }
  }

  IconData get icon {
    switch (this) {
      case EarTrainingMode.intervals:
        return Icons.straighten;
      case EarTrainingMode.chords:
        return Icons.queue_music;
      case EarTrainingMode.scales:
        return Icons.linear_scale;
    }
  }
}

const Map<EarTrainingMode, List<String>> _options = {
  EarTrainingMode.intervals: [
    'kleine Sekunde',
    'große Sekunde',
    'kleine Terz',
    'große Terz',
    'Quarte',
    'Tritonus',
    'Quinte',
    'kleine Sexte',
    'große Sexte',
    'kleine Septime',
    'große Septime',
    'Oktave',
  ],
  EarTrainingMode.chords: ['Dur', 'Moll', 'Dominant 7', 'Vermindert', 'Übermäßig', 'Sus4'],
  EarTrainingMode.scales: ['Dur', 'Moll', 'Pentatonik Moll', 'Blues', 'Dorisch', 'Mixolydisch'],
};

class EarTrainingScreen extends ConsumerStatefulWidget {
  const EarTrainingScreen({super.key});

  @override
  ConsumerState<EarTrainingScreen> createState() => _EarTrainingScreenState();
}

class _EarTrainingScreenState extends ConsumerState<EarTrainingScreen> {
  EarTrainingMode? _mode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gehörbildung')),
      body: _mode == null ? _buildMenu() : _GameSession(
        mode: _mode!,
        onExit: () => setState(() => _mode = null),
      ),
    );
  }

  Widget _buildMenu() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final m in EarTrainingMode.values)
          Card(
            color: AppColors.cardDark,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(m.icon, color: Colors.white),
              ),
              title: Text(
                m.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.chevron_right,
                  color: AppColors.textSecondary),
              onTap: () => setState(() => _mode = m),
            ),
          ),
      ],
    );
  }
}

class _GameSession extends ConsumerStatefulWidget {
  final EarTrainingMode mode;
  final VoidCallback onExit;
  const _GameSession({required this.mode, required this.onExit});

  @override
  ConsumerState<_GameSession> createState() => _GameSessionState();
}

class _GameSessionState extends ConsumerState<_GameSession> {
  final _rng = math.Random();
  final AudioPlayer _player = AudioPlayer();

  late List<String> _choices;
  late String _correct;
  String? _selected;
  int _score = 0;
  int _streak = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _next();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _next() {
    final pool = _options[widget.mode]!;
    pool.shuffle(_rng);
    _choices = pool.take(4).toList();
    _correct = _choices[_rng.nextInt(_choices.length)];
    _selected = null;
    _answered = false;
    _play();
    setState(() {});
  }

  Future<void> _play() async {
    try {
      await _player.setAsset(
          'assets/audio/ear/${widget.mode.name}_${_correct.replaceAll(' ', '_').toLowerCase()}.mp3');
      await _player.play();
    } catch (_) {
      // placeholder asset
    }
  }

  void _select(String choice) {
    if (_answered) return;
    final correct = choice == _correct;
    setState(() {
      _selected = choice;
      _answered = true;
      if (correct) {
        _score += 10;
        _streak += 1;
        ref
            .read(currentUserProfileProvider.notifier)
            .addXp(AppConstants.xpEarTrainingCorrect);
      } else {
        _streak = 0;
      }
    });
  }

  Color _buttonColor(String choice) {
    if (!_answered) return AppColors.cardDark;
    if (choice == _correct) return AppColors.success;
    if (choice == _selected) return AppColors.error;
    return AppColors.cardDark;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: widget.onExit,
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                widget.mode.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statBox('Punkte', '$_score', AppColors.xpColor),
              _statBox('Streak', '$_streak', AppColors.streakColor),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _play,
            icon: const Icon(Icons.replay),
            label: const Text('Erneut anhören'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                for (final c in _choices)
                  ElevatedButton(
                    onPressed: _answered ? null : () => _select(c),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor(c),
                      foregroundColor: AppColors.textPrimary,
                      disabledBackgroundColor: _buttonColor(c),
                      disabledForegroundColor: AppColors.textPrimary,
                    ),
                    child: Text(
                      c,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_answered)
            ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Weiter'),
            ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
