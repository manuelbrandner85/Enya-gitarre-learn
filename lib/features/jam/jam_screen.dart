import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../app/theme/colors.dart';
import '../../core/audio/backing_track_generator.dart';
import '../../core/bluetooth/bluetooth_service.dart';
import '../../core/bluetooth/xmari_constants.dart';
import '../../core/curriculum/pedagogy/learning_rules.dart';
import '../../core/providers/app_providers.dart';
import '../../core/widgets/xmari_status_badge.dart';
import '../../core/music_theory/note_colors.dart';

enum JamGenre { blues, rock, pop, funk }

extension on JamGenre {
  String get label {
    switch (this) {
      case JamGenre.blues:
        return 'Blues';
      case JamGenre.rock:
        return 'Rock';
      case JamGenre.pop:
        return 'Pop';
      case JamGenre.funk:
        return 'Funk';
    }
  }

  XmariSetup get recommendedSetup {
    switch (this) {
      case JamGenre.blues:
        return XmariSetup.overdriveRock;
      case JamGenre.rock:
        return XmariSetup.distortionMetal;
      case JamGenre.pop:
        return XmariSetup.beginnerDefault;
      case JamGenre.funk:
        return const XmariSetup(
          presetName: 'Clean',
          presetIndex: 0,
          pickupPosition: 'Position 2',
          pickupIndex: 2,
          explanation:
              'Clean am Position 2 – der typische Funk-Ton mit leichtem Biss.',
        );
    }
  }

  Color get color {
    switch (this) {
      case JamGenre.blues:
        return AppColors.info;
      case JamGenre.rock:
        return AppColors.fingerRing;
      case JamGenre.pop:
        return AppColors.fingerThumb;
      case JamGenre.funk:
        return AppColors.warning;
    }
  }
}

class JamScreen extends ConsumerStatefulWidget {
  const JamScreen({super.key});

  @override
  ConsumerState<JamScreen> createState() => _JamScreenState();
}

class _JamScreenState extends ConsumerState<JamScreen> {
  JamGenre _genre = JamGenre.blues;
  String _key = 'A';
  int _bpm = 90;
  bool _isPlaying = false;
  bool _isLoadingTrack = false;
  double _trackVolume = 0.6;
  final AudioPlayer _player = AudioPlayer();
  Timer? _beatTimer;
  int _currentBeat = 1;
  int get _beatsPerMeasure => 4;

  String _genreCode(JamGenre g) {
    switch (g) {
      case JamGenre.blues:
        return BackingTrackGenerator.genreBlues;
      case JamGenre.rock:
        return BackingTrackGenerator.genreRock;
      case JamGenre.pop:
        return BackingTrackGenerator.genrePop;
      case JamGenre.funk:
        return BackingTrackGenerator.genreFunk;
    }
  }

  static const List<String> _keys = [
    'A', 'C', 'D', 'E', 'G', 'Am', 'Em', 'Dm'
  ];

  // Pentatonik-Noten für die Jam-Hilfe
  static const Map<String, List<String>> _pentatonicNotes = {
    'A': ['A', 'C', 'D', 'E', 'G'],
    'C': ['C', 'D', 'E', 'G', 'A'],
    'D': ['D', 'E', 'F#', 'A', 'B'],
    'E': ['E', 'G', 'A', 'B', 'D'],
    'G': ['G', 'A', 'B', 'D', 'E'],
    'Am': ['A', 'C', 'D', 'E', 'G'],
    'Em': ['E', 'G', 'A', 'B', 'D'],
    'Dm': ['D', 'F', 'G', 'A', 'C'],
  };

  @override
  void dispose() {
    _beatTimer?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      _beatTimer?.cancel();
      await _player.stop();
      setState(() {
        _isPlaying = false;
        _currentBeat = 1;
      });
      return;
    }

    setState(() => _isLoadingTrack = true);
    try {
      // Backing-Track on-the-fly generieren und im Loop spielen
      final path = await BackingTrackGenerator.generate(
        key: _key,
        bpm: _bpm,
        genre: _genreCode(_genre),
      );
      await _player.setLoopMode(LoopMode.all);
      await _player.setVolume(_trackVolume);
      await _player.setFilePath(path);
      await _player.play();
    } catch (e) {
      // Bei Fehler: Track nicht starten, aber Beat-Timer trotzdem laufen lassen
      // damit die visuelle Anzeige funktioniert
      debugPrint('JamScreen: Backing-Track-Fehler: $e');
    } finally {
      if (mounted) setState(() => _isLoadingTrack = false);
    }

    if (!mounted) return;
    setState(() => _isPlaying = true);

    final intervalMs = (60000 / _bpm).round();
    _beatTimer = Timer.periodic(Duration(milliseconds: intervalMs), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _currentBeat = (_currentBeat % _beatsPerMeasure) + 1;
      });
    });
  }

  Future<void> _restartTrackForNewParams() async {
    if (!_isPlaying) return;
    _beatTimer?.cancel();
    await _player.stop();
    setState(() {
      _isPlaying = false;
      _currentBeat = 1;
    });
    await _togglePlay();
  }

  @override
  Widget build(BuildContext context) {
    final btService = ref.watch(bluetoothServiceProvider);
    final isConnected = btService.currentState.isConnected;
    final setup = _genre.recommendedSetup;
    final presetColor = XmariConstants.presetColor(setup.presetIndex);
    final safeNotes = _pentatonicNotes[_key] ?? _pentatonicNotes['A']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jam-Modus'),
        actions: const [XmariStatusBadge(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Genre-Auswahl
            const Text('Genre',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: JamGenre.values.map((g) {
                  final isSelected = g == _genre;
                  return GestureDetector(
                    onTap: () async {
                      setState(() => _genre = g);
                      await _restartTrackForNewParams();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? g.color.withOpacity(0.2)
                            : AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                                isSelected ? g.color : AppColors.outline),
                      ),
                      child: Text(
                        g.label,
                        style: TextStyle(
                          color: isSelected
                              ? g.color
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Tonart & BPM
            Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tonart',
                            style:
                                TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: _key,
                          items: _keys
                              .map((k) => DropdownMenuItem(
                                  value: k, child: Text(k)))
                              .toList(),
                          onChanged: (v) async {
                            if (v != null) {
                              setState(() => _key = v);
                              await _restartTrackForNewParams();
                            }
                          },
                        ),
                      ]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BPM: $_bpm',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Slider(
                          value: _bpm.toDouble(),
                          min: 60,
                          max: 160,
                          divisions: 20,
                          onChanged: (v) {
                            setState(() => _bpm = v.round());
                          },
                          onChangeEnd: (_) async {
                            await _restartTrackForNewParams();
                          },
                        ),
                      ]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lautstärke des Backing-Tracks
            Row(
              children: [
                const Icon(Icons.volume_down, size: 18, color: Colors.white54),
                Expanded(
                  child: Slider(
                    value: _trackVolume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) {
                      setState(() => _trackVolume = v);
                      _player.setVolume(v);
                    },
                  ),
                ),
                const Icon(Icons.volume_up, size: 18, color: Colors.white54),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${(_trackVolume * 100).round()}%',
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // XMARI-Empfehlung
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: presetColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: presetColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.music_note, color: presetColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Empfohlen: ${setup.presetName}, ${setup.pickupPosition}',
                              style: TextStyle(
                                  color: presetColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          Text(setup.explanation,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white54)),
                        ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Sichere Noten (Pentatonik)
            const Text('Sichere Noten (Pentatonik)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: safeNotes
                  .map((n) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: NoteColors.forNoteWithOpacity(n, 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: NoteColors.forNote(n)),
                        ),
                        child: Text(n,
                            style: TextStyle(
                                color: NoteColors.forNote(n),
                                fontWeight: FontWeight.bold)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            // XMARI-Kopfhörer-Hinweis
            if (isConnected)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.headphones,
                        color: AppColors.success, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'XMARI verbunden: Du hörst Backing-Track + dein Spiel zusammen im Kopfhörer!',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Beat indicator
            if (_isPlaying)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_beatsPerMeasure, (i) {
                  final isActive = (i + 1) == _currentBeat;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: isActive ? 24 : 14,
                    height: isActive ? 24 : 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? _genre.color : AppColors.outline,
                    ),
                  );
                }),
              ),
            const SizedBox(height: 16),
            // Play Button
            Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: ElevatedButton(
                  onPressed: _isLoadingTrack ? null : _togglePlay,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor:
                        _isPlaying ? AppColors.error : AppColors.primary,
                  ),
                  child: _isLoadingTrack
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          _isPlaying ? Icons.stop : Icons.play_arrow,
                          size: 36,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
