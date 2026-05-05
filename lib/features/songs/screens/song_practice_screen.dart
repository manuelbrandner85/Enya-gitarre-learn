import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';
import 'package:enya_gitarre_learn/core/music_theory/chord.dart';
import 'package:enya_gitarre_learn/features/lessons/widgets/chord_diagram_widget.dart';
import 'package:enya_gitarre_learn/features/songs/screens/song_library_screen.dart';

class SongPracticeScreen extends ConsumerStatefulWidget {
  final String songId;
  const SongPracticeScreen({super.key, required this.songId});

  @override
  ConsumerState<SongPracticeScreen> createState() => _SongPracticeScreenState();
}

class _SongPracticeScreenState extends ConsumerState<SongPracticeScreen> {
  late final AudioPlayer _player;
  final ScrollController _scroll = ScrollController();
  bool _isPlaying = false;
  bool _backingTrack = true;
  double _tempo = 1.0;

  late final SongData _song;
  late final List<_Bar> _bars;

  // Pitch detection
  final _pitchDetector = PitchDetector();
  StreamSubscription<PitchResult>? _pitchSub;
  PitchResult? _livePitch;
  int _currentBar = 0;

  // Session accuracy tracking
  int _accuracyCount = 0;
  int _accuracyHits = 0;
  double _sessionAccuracy = 0;

  static const _chordNotes = <String, List<String>>{
    'C': ['C', 'E', 'G'],
    'Cm': ['C', 'Eb', 'G'],
    'D': ['D', 'F#', 'A'],
    'Dm': ['D', 'F', 'A'],
    'E': ['E', 'G#', 'B'],
    'Em': ['E', 'G', 'B'],
    'F': ['F', 'A', 'C'],
    'Fm': ['F', 'Ab', 'C'],
    'G': ['G', 'B', 'D'],
    'Gm': ['G', 'Bb', 'D'],
    'A': ['A', 'C#', 'E'],
    'Am': ['A', 'C', 'E'],
    'B': ['B', 'D#', 'F#'],
    'Bm': ['B', 'D', 'F#'],
    'A7': ['A', 'C#', 'E', 'G'],
    'E7': ['E', 'G#', 'B', 'D'],
    'D7': ['D', 'F#', 'A', 'C'],
    'G7': ['G', 'B', 'D', 'F'],
    'C7': ['C', 'E', 'G', 'Bb'],
    'B7': ['B', 'D#', 'F#', 'A'],
    'F#m': ['F#', 'A', 'C#'],
    'C#m': ['C#', 'E', 'G#'],
    'G#m': ['G#', 'B', 'D#'],
    'Bb': ['Bb', 'D', 'F'],
    'Eb': ['Eb', 'G', 'Bb'],
    'Ab': ['Ab', 'C', 'Eb'],
    'E5': ['E', 'B'],
    'A5': ['A', 'E'],
    'G5': ['G', 'D'],
    'D5': ['D', 'A'],
    'C5': ['C', 'G'],
    'B5': ['B', 'F#'],
  };

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _song = kSongs.firstWhere(
      (s) => s.id == widget.songId,
      orElse: () => kSongs.first,
    );
    _bars = _generateBars(_song);
  }

  static List<_Bar> _generateBars(SongData s) {
    final out = <_Bar>[];
    for (int i = 0; i < 8; i++) {
      out.add(_Bar(
        index: i + 1,
        chord: s.chords[i % s.chords.length],
        beats: 4,
      ));
    }
    return out;
  }

  @override
  void dispose() {
    _pitchSub?.cancel();
    _pitchDetector.dispose();
    _player.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _startPitchDetection() async {
    await _pitchDetector.start();
    _pitchSub = _pitchDetector.pitchStream.listen((result) {
      if (!mounted) return;
      setState(() {
        _livePitch = result;
        if (result.isValid && _bars.isNotEmpty) {
          final expectedChord = _bars[_currentBar].chord;
          final expectedNotes = _chordNotes[expectedChord] ?? [];
          final isMatch = expectedNotes.contains(result.noteName);
          _accuracyCount++;
          if (isMatch) _accuracyHits++;
          if (_accuracyCount > 0) {
            _sessionAccuracy = (_accuracyHits / _accuracyCount) * 100;
          }
        }
      });
    });
  }

  Future<void> _stopPitchDetection() async {
    await _pitchSub?.cancel();
    _pitchSub = null;
    await _pitchDetector.stop();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
      await _stopPitchDetection();
      setState(() => _isPlaying = false);
      return;
    }
    if (_backingTrack) {
      try {
        await _player.setAsset('assets/audio/songs/${_song.id}.mp3');
        await _player.setSpeed(_tempo);
        await _player.play();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backing-Track nicht verfügbar')),
          );
        }
      }
    }
    // Reset session stats for new play session
    setState(() {
      _isPlaying = true;
      _livePitch = null;
      _accuracyCount = 0;
      _accuracyHits = 0;
      _sessionAccuracy = 0;
      _currentBar = 0;
    });
    await _startPitchDetection();
    _autoScroll();
  }

  Future<void> _stop() async {
    await _player.stop();
    await _stopPitchDetection();
    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }
    final hits = _accuracyHits;
    final total = _accuracyCount;
    final pct = total > 0 ? (_sessionAccuracy).toStringAsFixed(0) : '0';
    setState(() {
      _isPlaying = false;
      _currentBar = 0;
      _livePitch = null;
    });
    if (mounted && total > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Session: $pct% Genauigkeit ($hits Treffer von $total)'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _autoScroll() async {
    int barIdx = 0;
    while (mounted && _isPlaying && _scroll.hasClients) {
      final max = _scroll.position.maxScrollExtent;
      final cur = _scroll.offset;
      if (cur >= max) break;
      if (barIdx < _bars.length) {
        setState(() => _currentBar = barIdx);
        barIdx++;
      }
      await _scroll.animateTo(
        (cur + 60).clamp(0, max),
        duration: Duration(milliseconds: (1500 / _tempo).round()),
        curve: Curves.linear,
      );
    }
  }

  Chord? _chordFor(String name) {
    final all = [...Chord.openChords, ...Chord.powerChords];
    try {
      return all.firstWhere((c) => c.name == name);
    } catch (_) {
      return null;
    }
  }

  Widget _buildPitchFeedback() {
    if (_livePitch == null || !_livePitch!.isValid) {
      return Card(
        color: Colors.grey[900],
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            const Icon(Icons.mic, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              _isPlaying
                  ? 'Spielen → Feedback erscheint hier'
                  : 'Drücke Play und spiele mit',
              style: const TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            if (_accuracyCount > 0)
              Text(
                '${_sessionAccuracy.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ]),
        ),
      );
    }

    final expectedChord = _bars.isNotEmpty ? _bars[_currentBar].chord : '';
    final expectedNotes = _chordNotes[expectedChord] ?? [];
    final detected = _livePitch!.noteName;
    final isMatch = expectedNotes.contains(detected);
    final isRoot =
        expectedNotes.isNotEmpty && detected == expectedNotes.first;

    final color = isMatch
        ? Colors.green
        : (isRoot ? Colors.orange : Colors.red[300]!);

    return Card(
      color: color.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Du spielst',
                  style: TextStyle(color: Colors.white54, fontSize: 11)),
              Text(
                _livePitch!.fullNoteName,
                style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ]),
            Column(children: [
              Icon(
                isMatch ? Icons.check_circle : Icons.radio_button_unchecked,
                color: color,
                size: 28,
              ),
              if (_accuracyCount > 0)
                Text(
                  '${_sessionAccuracy.toStringAsFixed(0)}%',
                  style: TextStyle(color: color, fontSize: 11),
                ),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('Erwartet',
                  style: TextStyle(color: Colors.white54, fontSize: 11)),
              Text(
                expectedChord.isEmpty ? '—' : expectedChord,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uniqueChords =
        _song.chords.map(_chordFor).whereType<Chord>().toList();
    return Scaffold(
      appBar: AppBar(title: Text(_song.title)),
      body: Column(
        children: [
          Container(
            color: AppColors.surfaceDark,
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: uniqueChords.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChordDiagramWidget(
                  chord: uniqueChords[i],
                  size: 110,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _bars.length,
              itemBuilder: (_, i) {
                final b = _bars[i];
                final isActive = _isPlaying && i == _currentBar;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive ? AppColors.primary : AppColors.outline,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Takt ${b.index}',
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        b.chord,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${b.beats}/4',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildPitchFeedback(),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 48,
                onPressed: _togglePlay,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                iconSize: 40,
                onPressed: _stop,
                icon: const Icon(Icons.stop_circle, color: AppColors.error),
              ),
              Column(
                children: [
                  const Text('Backing',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  Switch(
                    value: _backingTrack,
                    onChanged: (v) => setState(() => _backingTrack = v),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.speed, color: AppColors.textSecondary),
              Expanded(
                child: Slider(
                  min: 0.5,
                  max: 1.0,
                  divisions: 10,
                  value: _tempo,
                  label: '${(_tempo * 100).round()}%',
                  onChanged: (v) {
                    setState(() => _tempo = v);
                    _player.setSpeed(v);
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${(_tempo * 100).round()}%',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar {
  final int index;
  final String chord;
  final int beats;
  const _Bar({required this.index, required this.chord, required this.beats});
}
