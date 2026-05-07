import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';

class BackingTrack {
  final String id;
  final String name;
  final String genre;
  final String key;
  final int bpm;
  final Duration duration;

  const BackingTrack({
    required this.id,
    required this.name,
    required this.genre,
    required this.key,
    required this.bpm,
    required this.duration,
  });
}

const List<BackingTrack> _tracks = [
  BackingTrack(id: 't1', name: 'Blues Shuffle in A', genre: 'Blues', key: 'A', bpm: 90, duration: Duration(minutes: 4)),
  BackingTrack(id: 't2', name: 'Rock Jam in E', genre: 'Rock', key: 'E', bpm: 120, duration: Duration(minutes: 3, seconds: 30)),
  BackingTrack(id: 't3', name: 'Funk Groove in G', genre: 'Funk', key: 'G', bpm: 105, duration: Duration(minutes: 5)),
  BackingTrack(id: 't4', name: 'Metal Riff in D', genre: 'Metal', key: 'D', bpm: 160, duration: Duration(minutes: 4, seconds: 20)),
  BackingTrack(id: 't5', name: 'Pop Ballad in C', genre: 'Pop', key: 'C', bpm: 75, duration: Duration(minutes: 4)),
  BackingTrack(id: 't6', name: 'Jazz Swing in F', genre: 'Jazz', key: 'F', bpm: 130, duration: Duration(minutes: 6)),
  BackingTrack(id: 't7', name: 'Reggae in B', genre: 'Reggae', key: 'B', bpm: 80, duration: Duration(minutes: 4, seconds: 30)),
  BackingTrack(id: 't8', name: 'Country in G', genre: 'Country', key: 'G', bpm: 110, duration: Duration(minutes: 3, seconds: 45)),
  BackingTrack(id: 't9', name: 'Funk Disco in Em', genre: 'Funk', key: 'Em', bpm: 125, duration: Duration(minutes: 5)),
  BackingTrack(id: 't10', name: 'Slow Blues in Bb', genre: 'Blues', key: 'A#', bpm: 60, duration: Duration(minutes: 7)),
  BackingTrack(id: 't11', name: 'Hard Rock in A', genre: 'Rock', key: 'A', bpm: 140, duration: Duration(minutes: 4)),
  BackingTrack(id: 't12', name: 'Thrash Metal in E', genre: 'Metal', key: 'E', bpm: 180, duration: Duration(minutes: 4, seconds: 30)),
];

const _genres = ['Rock', 'Pop', 'Blues', 'Metal', 'Funk', 'Jazz'];
const _bpmRanges = [
  ('Langsam', 0, 90),
  ('Mittel', 90, 130),
  ('Schnell', 130, 999),
];

class BackingTracksScreen extends ConsumerStatefulWidget {
  const BackingTracksScreen({super.key});

  @override
  ConsumerState<BackingTracksScreen> createState() =>
      _BackingTracksScreenState();
}

class _BackingTracksScreenState extends ConsumerState<BackingTracksScreen> {
  final Set<String> _genreF = {};
  final Set<String> _keyF = {};
  String? _bpmRange;

  final AudioPlayer _clickPlayer = AudioPlayer();
  Timer? _beatTimer;
  String? _currentInlineId;
  int _currentBeat = 1;

  @override
  void initState() {
    super.initState();
    _loadClick();
  }

  Future<void> _loadClick() async {
    try {
      await _clickPlayer.setAsset('assets/audio/metronome_click.wav');
    } catch (_) {}
  }

  @override
  void dispose() {
    _beatTimer?.cancel();
    _clickPlayer.dispose();
    super.dispose();
  }

  List<BackingTrack> get _filtered {
    return _tracks.where((t) {
      final g = _genreF.isEmpty || _genreF.contains(t.genre);
      final k = _keyF.isEmpty || _keyF.contains(t.key);
      bool b = true;
      if (_bpmRange != null) {
        final r = _bpmRanges.firstWhere((e) => e.$1 == _bpmRange);
        b = t.bpm >= r.$2 && t.bpm < r.$3;
      }
      return g && k && b;
    }).toList();
  }

  Future<void> _toggleInline(BackingTrack t) async {
    if (_currentInlineId == t.id) {
      _beatTimer?.cancel();
      _beatTimer = null;
      setState(() {
        _currentInlineId = null;
        _currentBeat = 1;
      });
      return;
    }
    _beatTimer?.cancel();
    setState(() {
      _currentInlineId = t.id;
      _currentBeat = 1;
    });
    _startBeat(t.bpm);
  }

  void _startBeat(int bpm) {
    final intervalMs = (60000 / bpm).round();
    _beatTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      if (!mounted) return;
      setState(() => _currentBeat = (_currentBeat % 4) + 1);
      _clickPlayer.seek(Duration.zero).then((_) => _clickPlayer.play());
    });
  }

  String _fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final tracks = _filtered;
    final keys = _tracks.map((t) => t.key).toSet().toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Backing Tracks')),
      body: Column(
        children: [
          _filterRow('Genre', [
            for (final g in _genres)
              FilterChip(
                label: Text(g),
                selected: _genreF.contains(g),
                onSelected: (s) => setState(() {
                  if (s) { _genreF.add(g); } else { _genreF.remove(g); }
                }),
              ),
          ]),
          _filterRow('Tonart', [
            for (final k in keys)
              FilterChip(
                label: Text(k),
                selected: _keyF.contains(k),
                onSelected: (s) => setState(() {
                  if (s) { _keyF.add(k); } else { _keyF.remove(k); }
                }),
              ),
          ]),
          _filterRow('BPM', [
            for (final r in _bpmRanges)
              ChoiceChip(
                label: Text(r.$1),
                selected: _bpmRange == r.$1,
                onSelected: (s) => setState(() => _bpmRange = s ? r.$1 : null),
              ),
          ]),
          const SizedBox(height: 8),
          Expanded(
            child: tracks.isEmpty
                ? const Center(child: Text('Keine Tracks gefunden'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: tracks.length,
                    itemBuilder: (_, i) {
                      final t = tracks[i];
                      final isPlaying = _currentInlineId == t.id;
                      return Card(
                        color: AppColors.cardDark,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: IconButton(
                                iconSize: 36,
                                onPressed: () => _toggleInline(t),
                                icon: Icon(
                                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                t.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${t.genre} · ${t.key} · ${t.bpm} BPM · ${_fmt(t.duration)}',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                              trailing: const Icon(Icons.open_in_full, color: AppColors.accent),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => _BackingTrackPlayer(track: t),
                                ),
                              ),
                            ),
                            if (isPlaying)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(4, (b) {
                                    final active = (b + 1) == _currentBeat;
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 80),
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      width: active ? 18 : 10,
                                      height: active ? 18 : 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: active ? AppColors.primary : AppColors.outline,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterRow(String label, List<Widget> chips) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final c in chips)
                  Padding(padding: const EdgeInsets.only(right: 6), child: c),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackingTrackPlayer extends StatefulWidget {
  final BackingTrack track;
  const _BackingTrackPlayer({required this.track});

  @override
  State<_BackingTrackPlayer> createState() => _BackingTrackPlayerState();
}

class _BackingTrackPlayerState extends State<_BackingTrackPlayer> {
  final AudioPlayer _clickPlayer = AudioPlayer();
  Timer? _beatTimer;
  bool _isPlaying = false;
  bool _loop = false;
  double _bpmFactor = 1.0;
  int _transpose = 0;
  int _currentBeat = 1;

  @override
  void initState() {
    super.initState();
    _loadClick();
  }

  Future<void> _loadClick() async {
    try {
      await _clickPlayer.setAsset('assets/audio/metronome_click.wav');
    } catch (_) {}
  }

  @override
  void dispose() {
    _beatTimer?.cancel();
    _clickPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_isPlaying) {
      _beatTimer?.cancel();
      _beatTimer = null;
      setState(() { _isPlaying = false; _currentBeat = 1; });
    } else {
      setState(() { _isPlaying = true; _currentBeat = 1; });
      _startBeat();
    }
  }

  void _startBeat() {
    _beatTimer?.cancel();
    final effectiveBpm = (widget.track.bpm * _bpmFactor).round();
    final intervalMs = (60000 / effectiveBpm).round();
    _beatTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      if (!mounted) { _beatTimer?.cancel(); return; }
      setState(() => _currentBeat = (_currentBeat % 4) + 1);
      _clickPlayer.seek(Duration.zero).then((_) => _clickPlayer.play());
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.track;
    final effectiveBpm = (t.bpm * _bpmFactor).round();
    return Scaffold(
      appBar: AppBar(title: Text(t.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              t.name,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${t.genre} · ${t.key} · $effectiveBpm BPM',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            // Beat indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (b) {
                final active = _isPlaying && (b + 1) == _currentBeat;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: active ? 28 : 16,
                  height: active ? 28 : 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? AppColors.primary : AppColors.outline,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Center(
              child: IconButton(
                iconSize: 96,
                onPressed: _toggle,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: _loop,
              onChanged: (v) => setState(() => _loop = v),
              title: const Text('Loop', style: TextStyle(color: AppColors.textPrimary)),
              secondary: const Icon(Icons.loop),
            ),
            const SizedBox(height: 8),
            const Text('BPM-Anpassung', style: TextStyle(color: AppColors.textSecondary)),
            Slider(
              min: 0.5,
              max: 1.5,
              value: _bpmFactor,
              divisions: 20,
              label: '$effectiveBpm BPM',
              onChanged: (v) {
                setState(() => _bpmFactor = v);
                if (_isPlaying) _startBeat();
              },
            ),
            Text(
              '$effectiveBpm BPM',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text('Tonart-Transponierung (Halbtöne)', style: TextStyle(color: AppColors.textSecondary)),
            Slider(
              min: -12,
              max: 12,
              value: _transpose.toDouble(),
              divisions: 24,
              label: _transpose >= 0 ? '+$_transpose' : '$_transpose',
              onChanged: (v) => setState(() => _transpose = v.round()),
            ),
            Text(
              _transpose == 0 ? 'Original' : (_transpose > 0 ? '+$_transpose Halbtöne' : '$_transpose Halbtöne'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
