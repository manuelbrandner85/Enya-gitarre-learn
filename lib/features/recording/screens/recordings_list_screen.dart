import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/database/app_database.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';

final _recordingsProvider =
    FutureProvider.autoDispose<List<RecordingsTableData>>((ref) async {
  final db = ref.watch(databaseProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final userId = prefs.getString(AppConstants.prefKeyUserId);
  if (userId == null) return const [];
  return db.getRecordings(userId);
});

class RecordingsListScreen extends ConsumerWidget {
  const RecordingsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordings = ref.watch(_recordingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Aufnahmen')),
      body: recordings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Noch keine Aufnahmen. Drücke Aufnehmen um zu starten.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (_, i) => _RecordingTile(
              recording: items[i],
              onChanged: () => ref.invalidate(_recordingsProvider),
            ),
          );
        },
      ),
    );
  }
}

class _RecordingTile extends ConsumerStatefulWidget {
  final RecordingsTableData recording;
  final VoidCallback onChanged;
  const _RecordingTile({required this.recording, required this.onChanged});

  @override
  ConsumerState<_RecordingTile> createState() => _RecordingTileState();
}

class _RecordingTileState extends ConsumerState<_RecordingTile> {
  late final AudioPlayer _player;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen((s) {
      if (!mounted) return;
      setState(() => _playing = s.playing);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.pause();
    } else {
      try {
        await _player.setFilePath(widget.recording.filePath);
        await _player.play();
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datei nicht gefunden')),
        );
      }
    }
  }

  Future<void> _delete() async {
    final db = ref.read(databaseProvider);
    await db.deleteRecording(widget.recording.id);
    widget.onChanged();
  }

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pfad: ${widget.recording.filePath}')),
    );
  }

  String _fmtDur(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recording;
    return Card(
      color: AppColors.cardDark,
      child: ListTile(
        leading: IconButton(
          onPressed: _toggle,
          icon: Icon(
            _playing ? Icons.pause_circle : Icons.play_circle,
            color: AppColors.primary,
            size: 36,
          ),
        ),
        title: Text(
          r.title.isEmpty ? 'Aufnahme' : r.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${_fmtDur(r.durationSeconds)} · ${DateFormat('dd.MM.yyyy HH:mm').format(r.createdAt)}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share, color: AppColors.accent),
              onPressed: _share,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: _delete,
            ),
          ],
        ),
      ),
    );
  }
}
