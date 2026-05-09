import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/database/app_database.dart';
import 'package:enya_gitarre_learn/core/providers/app_providers.dart';
import 'package:enya_gitarre_learn/core/utils/constants.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  late final RecorderController _recorder;
  PlayerController? _player;

  bool _isRecording = false;
  bool _hasRecording = false;
  String? _filePath;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  // Upload-Status und Fehlerzustand
  bool _isUploading = false;
  String? _uploadError;
  String? _pendingUploadTitle;
  int _pendingUploadDuration = 0;

  @override
  void initState() {
    super.initState();
    _recorder = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final mm = d.inMinutes.toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> _toggleRecord() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      _timer?.cancel();
      setState(() {
        _isRecording = false;
        _hasRecording = path != null;
        _filePath = path;
      });
      if (path != null) {
        _player = PlayerController();
        await _player!.preparePlayer(path: path);
      }
    } else {
      final hasPerm = await _recorder.checkPermission();
      if (!hasPerm) return;
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.record(path: path);
      setState(() {
        _isRecording = true;
        _filePath = path;
        _elapsed = Duration.zero;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    }
  }

  Future<void> _discard() async {
    if (_filePath != null) {
      final f = File(_filePath!);
      if (await f.exists()) await f.delete();
    }
    _player?.dispose();
    setState(() {
      _hasRecording = false;
      _filePath = null;
      _elapsed = Duration.zero;
      _player = null;
    });
  }

  Future<void> _save() async {
    final title = await showDialog<String>(
      context: context,
      builder: (_) => _TitleDialog(),
    );
    if (title == null || title.isEmpty || _filePath == null) return;

    final db = ref.read(databaseProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    final userId = prefs.getString(AppConstants.prefKeyUserId) ?? 'guest';
    await db.insertRecording(
      RecordingsTableCompanion.insert(
        id: const Uuid().v4(),
        userId: userId,
        sessionId: const Uuid().v4(),
        filePath: _filePath!,
        durationSeconds: Value(_elapsed.inSeconds),
        title: Value(title),
        createdAt: DateTime.now(),
      ),
    );

    // Lokal gespeichert – UI-Zustand zurücksetzen
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aufnahme gespeichert')),
      );
      setState(() {
        _hasRecording = false;
        _filePath = null;
        _elapsed = Duration.zero;
        _uploadError = null;
      });
    }

    // Upload zu Supabase (best-effort, blockiert niemals lokale Speicherung).
    final filePath = _filePath ?? filePath_local;
    final durationSeconds = _elapsed.inSeconds;
    _pendingUploadTitle = title;
    _pendingUploadDuration = durationSeconds;
    await _uploadToSupabase(filePath, title, durationSeconds);
  }

  // Speichert den Datei-Pfad vor dem Zurücksetzen für den Upload.
  String get filePath_local => _filePath ?? '';

  /// Lädt die Aufnahme zu Supabase hoch und zeigt Fehler-UI bei Misserfolg.
  Future<void> _uploadToSupabase(
      String filePath, String title, int durationSeconds) async {
    if (!mounted) return;
    setState(() {
      _isUploading = true;
      _uploadError = null;
    });
    try {
      final sync = ref.read(supabaseSyncProvider);
      final filename = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await sync.uploadRecording(
        localPath: filePath,
        filename: filename,
        title: title,
        durationSeconds: durationSeconds,
      );
      if (mounted) setState(() => _isUploading = false);
    } catch (e) {
      if (kDebugMode) debugPrint('RecordingScreen: Supabase-Upload fehlgeschlagen: $e');
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadError = 'Upload fehlgeschlagen. Prüfe deine Verbindung.';
        });
      }
    }
  }

  /// Wiederholt den Supabase-Upload nach einem Fehler.
  Future<void> _retryUpload() async {
    final title = _pendingUploadTitle;
    if (title == null || title.isEmpty) return;
    // Letzten lokalen Pfad erneut hochladen — Upload-Retry benötigt den Pfad
    // aus der letzten gespeicherten Aufnahme. Da _filePath nach dem Speichern
    // geleert wurde, suchen wir das neueste m4a-File im Dokumentenverzeichnis.
    final dir = await getApplicationDocumentsDirectory();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.m4a'))
        .toList()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    if (files.isEmpty) {
      if (mounted) {
        setState(() => _uploadError = 'Aufnahme-Datei nicht gefunden.');
      }
      return;
    }
    await _uploadToSupabase(files.first.path, title, _pendingUploadDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aufnahme')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              _format(_elapsed),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 24),
            if (_isRecording)
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: AudioWaveforms(
                  recorderController: _recorder,
                  size: const Size(double.infinity, 84),
                  waveStyle: const WaveStyle(
                    waveColor: AppColors.primary,
                    showMiddleLine: false,
                    extendWaveform: true,
                  ),
                ),
              )
            else if (_hasRecording && _player != null)
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: AudioFileWaveforms(
                  size: const Size(double.infinity, 84),
                  playerController: _player!,
                  waveformType: WaveformType.long,
                  playerWaveStyle: const PlayerWaveStyle(
                    fixedWaveColor: AppColors.textTertiary,
                    liveWaveColor: AppColors.primary,
                  ),
                ),
              )
            else
              Container(
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Bereit zum Aufnehmen',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            const Spacer(),
            Center(
              child: GestureDetector(
                onTap: _toggleRecord,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _isRecording ? AppColors.error : Colors.red,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.white, width: 5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: _isRecording ? 24 : 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_hasRecording && !_isRecording)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _discard,
                      icon: const Icon(Icons.delete),
                      label: const Text('Verwerfen'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save),
                      label: const Text('Speichern'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TitleDialog extends StatefulWidget {
  @override
  State<_TitleDialog> createState() => _TitleDialogState();
}

class _TitleDialogState extends State<_TitleDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Titel der Aufnahme'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'z.B. Mein erstes Solo',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
