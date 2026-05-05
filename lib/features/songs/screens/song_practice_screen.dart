import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
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
    _player.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
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
    setState(() => _isPlaying = true);
    _autoScroll();
  }

  Future<void> _stop() async {
    await _player.stop();
    if (_scroll.hasClients) {
      _scroll.jumpTo(0);
    }
    setState(() => _isPlaying = false);
  }

  void _autoScroll() async {
    while (mounted && _isPlaying && _scroll.hasClients) {
      final max = _scroll.position.maxScrollExtent;
      final cur = _scroll.offset;
      if (cur >= max) break;
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
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.outline),
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
                icon: const Icon(Icons.stop_circle,
                    color: AppColors.error),
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
