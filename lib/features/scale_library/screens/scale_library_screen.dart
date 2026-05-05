import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/music_theory/note.dart';
import 'package:enya_gitarre_learn/core/music_theory/scale.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';
import 'package:enya_gitarre_learn/features/lessons/widgets/fretboard_widget.dart';

const Map<int, String> _germanIntervals = {
  0: 'Prime',
  1: 'kleine Sekunde',
  2: 'große Sekunde',
  3: 'kleine Terz',
  4: 'große Terz',
  5: 'Quarte',
  6: 'Tritonus',
  7: 'Quinte',
  8: 'kleine Sexte',
  9: 'große Sexte',
  10: 'kleine Septime',
  11: 'große Septime',
};

class ScaleLibraryScreen extends ConsumerStatefulWidget {
  const ScaleLibraryScreen({super.key});

  @override
  ConsumerState<ScaleLibraryScreen> createState() =>
      _ScaleLibraryScreenState();
}

class _ScaleLibraryScreenState extends ConsumerState<ScaleLibraryScreen> {
  String _root = 'A';
  ScaleType _type = ScaleType.minorPentatonic;
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Scale get _scale => Scale(
        name: '$_root ${_type.displayName}',
        root: Note(name: _root, octave: 3),
        type: _type,
      );

  Future<void> _play() async {
    try {
      await _player.setAsset(
        'assets/audio/scales/${_root.toLowerCase()}_${_type.name}.mp3',
      );
      await _player.play();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio nicht verfügbar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = _scale;
    final positions = scale.fretboardPositions(0, 12);
    return Scaffold(
      appBar: AppBar(title: const Text('Tonleiter-Bibliothek')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDropdown<String>(
                    label: 'Grundton',
                    value: _root,
                    items: AppConstants.noteNames
                        .map((n) =>
                            DropdownMenuItem(value: n, child: Text(n)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _root = v ?? _root),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDropdown<ScaleType>(
                    label: 'Tonleiter',
                    value: _type,
                    items: ScaleType.values
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.displayName),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _type = v ?? _type),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: FretboardWidget(
                targetPositions: positions,
                mode: FretboardMode.scale,
                startFret: 0,
                endFret: 12,
                showNoteNames: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _play,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Anhören'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Intervalle',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(_type.intervals.length, (i) {
              final semi = _type.intervals[i];
              final note = Note(name: _root, octave: 3).transpose(semi);
              return Card(
                color: AppColors.cardDark,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: i == 0
                        ? AppColors.secondary
                        : AppColors.primary,
                    child: Text(
                      scale.degreeNames[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    _germanIntervals[semi] ?? '$semi Halbtöne',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: Text(
                    note.name,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
