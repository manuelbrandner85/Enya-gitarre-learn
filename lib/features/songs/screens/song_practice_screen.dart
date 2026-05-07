import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';
import 'package:enya_gitarre_learn/core/audio/reference_audio_service.dart';
import 'package:enya_gitarre_learn/core/music_theory/chord.dart';
import 'package:enya_gitarre_learn/features/lessons/widgets/chord_diagram_widget.dart';
import 'package:enya_gitarre_learn/features/songs/screens/song_library_screen.dart';

enum _PracticeMode { practice, playAlong }

class SongPracticeScreen extends ConsumerStatefulWidget {
  final String songId;
  const SongPracticeScreen({super.key, required this.songId});

  @override
  ConsumerState<SongPracticeScreen> createState() => _SongPracticeScreenState();
}

class _SongPracticeScreenState extends ConsumerState<SongPracticeScreen>
    with TickerProviderStateMixin {
  late final AudioPlayer _player;
  final ScrollController _scroll = ScrollController();

  bool _isPlaying = false;
  bool _backingTrack = true;
  bool _usingClickFallback = false;
  double _tempo = 1.0;
  _PracticeMode _mode = _PracticeMode.practice;

  late final SongData _song;

  // Flattened bar list for playback
  late final List<_PlayBar> _playBars;
  int _currentBarIdx = 0;

  // Beat counter
  int _currentBeat = 0;
  Timer? _beatTimer;
  Timer? _barTimer;

  final _referenceAudio = ReferenceAudioService();

  // Pitch detection
  final _pitchDetector = PitchDetector();
  StreamSubscription<PitchResult>? _pitchSub;
  PitchResult? _livePitch;

  // Session accuracy
  int _accuracyCount = 0;
  int _accuracyHits = 0;
  double _sessionAccuracy = 0;

  // Best accuracy (from SharedPreferences)
  double _bestAccuracy = 0;

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
    'F5': ['F', 'C'],
    'F#5': ['F#', 'C#'],
    'Bb5': ['Bb', 'F'],
    'G#5': ['G#', 'D#'],
    'C#5': ['C#', 'G#'],
    'Db5': ['Db', 'Ab'],
    'Ab5': ['Ab', 'Eb'],
    'D#5': ['D#', 'A#'],
  };

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _song = kSongs.firstWhere(
      (s) => s.id == widget.songId,
      orElse: () => kSongs.first,
    );
    _playBars = _flattenBars(_song);
    _loadBestAccuracy();
    _initClickPlayer();
  }

  Future<void> _initClickPlayer() async {
    try {
      await _player.setAsset('assets/audio/metronome_click.wav');
    } catch (_) {}
  }

  Future<void> _loadBestAccuracy() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bestAccuracy = prefs.getDouble('song_accuracy_${_song.id}') ?? 0.0;
    });
  }

  Future<void> _saveBestAccuracy(double acc) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getDouble('song_accuracy_${_song.id}') ?? 0.0;
    if (acc > current) {
      await prefs.setDouble('song_accuracy_${_song.id}', acc);
      setState(() => _bestAccuracy = acc);
    }
  }

  static List<_PlayBar> _flattenBars(SongData song) {
    final out = <_PlayBar>[];
    for (final section in song.sections) {
      for (int r = 0; r < section.repeats; r++) {
        for (int bi = 0; bi < section.bars.length; bi++) {
          final bar = section.bars[bi];
          out.add(_PlayBar(
            chord: bar.chord,
            beats: bar.beats,
            sectionLabel: bi == 0 && r == 0 ? section.label : null,
            sectionRepeats: section.repeats,
          ));
        }
      }
    }
    return out;
  }

  @override
  void dispose() {
    _beatTimer?.cancel();
    _barTimer?.cancel();
    _pitchSub?.cancel();
    _pitchDetector.dispose();
    _player.dispose();
    _referenceAudio.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _startPitchDetection() async {
    await _pitchDetector.start();
    _pitchSub = _pitchDetector.pitchStream.listen((result) {
      if (!mounted) return;
      setState(() {
        _livePitch = result;
        if (result.isValid && _playBars.isNotEmpty) {
          final expectedChord = _playBars[_currentBarIdx].chord;
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

  void _startBeatTimer() {
    _beatTimer?.cancel();
    final beatMs = (60000 / _song.bpm / _tempo).round();
    _beatTimer = Timer.periodic(Duration(milliseconds: beatMs), (_) {
      if (!mounted) return;
      setState(() {
        _currentBeat = (_currentBeat + 1) % 4;
      });
      if (_usingClickFallback) {
        _player.seek(Duration.zero).then((_) => _player.play());
      }
    });
  }

  void _startBarTimer() {
    _barTimer?.cancel();
    if (_mode != _PracticeMode.playAlong) return;
    final barMs = (60000 / _song.bpm * 4 / _tempo).round();
    _barTimer = Timer.periodic(Duration(milliseconds: barMs), (_) {
      if (!mounted || !_isPlaying) return;
      _advanceBar();
    });
  }

  void _advanceBar() {
    if (_playBars.isEmpty) return;
    setState(() {
      _currentBarIdx = (_currentBarIdx + 1) % _playBars.length;
    });
    _scrollToCurrentBar();
  }

  void _scrollToCurrentBar() {
    if (!_scroll.hasClients) return;
    // Approximately 72px per bar card
    final targetOffset = (_currentBarIdx * 72.0).clamp(
      0.0,
      _scroll.position.maxScrollExtent,
    );
    _scroll.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
      await _stopPitchDetection();
      _beatTimer?.cancel();
      _barTimer?.cancel();
      setState(() => _isPlaying = false);
      return;
    }
    if (_backingTrack) {
      try {
        await _player.setAsset('assets/audio/songs/${_song.id}.mp3');
        await _player.setSpeed(_tempo);
        await _player.play();
        _usingClickFallback = false;
      } catch (_) {
        // No pre-recorded backing track — use metronome click as beat reference
        await _initClickPlayer();
        _usingClickFallback = true;
      }
    }
    setState(() {
      _isPlaying = true;
      _livePitch = null;
      _accuracyCount = 0;
      _accuracyHits = 0;
      _sessionAccuracy = 0;
      _currentBarIdx = 0;
      _currentBeat = 0;
    });
    await _startPitchDetection();
    _startBeatTimer();
    _startBarTimer();
  }

  Future<void> _stop() async {
    await _player.stop();
    await _stopPitchDetection();
    _beatTimer?.cancel();
    _barTimer?.cancel();
    if (_scroll.hasClients) _scroll.jumpTo(0);

    final pct = _accuracyCount > 0 ? _sessionAccuracy : 0.0;
    if (pct > 0) await _saveBestAccuracy(pct);

    final hits = _accuracyHits;
    final total = _accuracyCount;
    setState(() {
      _isPlaying = false;
      _currentBarIdx = 0;
      _currentBeat = 0;
      _livePitch = null;
    });
    if (mounted && total > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Session: ${pct.toStringAsFixed(0)}% Genauigkeit ($hits Treffer von $total)'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _nextBarManual() {
    if (_mode != _PracticeMode.practice) return;
    _advanceBar();
  }

  Chord? _chordFor(String name) {
    final all = [...Chord.openChords, ...Chord.powerChords];
    try {
      return all.firstWhere((c) => c.name == name);
    } catch (_) {
      return null;
    }
  }

  int _starsForAccuracy(double acc) {
    if (acc >= 90) return 3;
    if (acc >= 75) return 2;
    if (acc >= 50) return 1;
    return 0;
  }

  Widget _buildStarRating(int stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Icon(
          i < stars ? Icons.star : Icons.star_border,
          size: 18,
          color: AppColors.xpColor,
        ),
      ),
    );
  }

  Widget _buildBeatCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isActive = i == _currentBeat && _isPlaying;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 18 : 12,
          height: isActive ? 18 : 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.outline,
          ),
          child: Center(
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textTertiary,
                fontSize: isActive ? 10 : 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStrumPattern() {
    final pattern = _song.strumPattern;
    final chars = pattern.split('');
    // Calculate which char index corresponds to current beat position
    // Each beat maps to 2 chars in the pattern (e.g. 'D·')
    final beatCharWidth = chars.length > 0 ? (chars.length / 4).ceil() : 2;
    final activeStart = _isPlaying ? _currentBeat * beatCharWidth : -1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(chars.length, (i) {
        final ch = chars[i];
        final isActive = _isPlaying &&
            i >= activeStart &&
            i < activeStart + beatCharWidth;
        Color color;
        if (!isActive) {
          color = AppColors.textTertiary;
        } else if (ch == 'D') {
          color = AppColors.primary;
        } else if (ch == 'U') {
          color = AppColors.secondary;
        } else {
          color = AppColors.textSecondary;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            ch == '·' ? '·' : ch,
            style: TextStyle(
              color: color,
              fontSize: isActive ? 20 : 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentChordPanel() {
    if (_playBars.isEmpty) return const SizedBox.shrink();
    final currentChordName = _playBars[_currentBarIdx].chord;
    final nextChordName = _playBars.length > 1
        ? _playBars[(_currentBarIdx + 1) % _playBars.length].chord
        : null;
    final currentChord = _chordFor(currentChordName);
    final nextChord = nextChordName != null ? _chordFor(nextChordName) : null;

    return Container(
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current chord (large)
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentChordName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.volume_up,
                          color: AppColors.primary, size: 22),
                      tooltip: 'Akkord hören',
                      onPressed: () =>
                          _referenceAudio.playChord(currentChordName),
                    ),
                  ],
                ),
                if (currentChord != null)
                  ChordDiagramWidget(chord: currentChord, size: 160)
                else
                  SizedBox(
                    height: 216,
                    child: Center(
                      child: Text(
                        currentChordName,
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Next chord (small)
          if (nextChord != null || nextChordName != null)
            Column(
              children: [
                const Text(
                  'Als nächstes:',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (nextChord != null)
                  ChordDiagramWidget(chord: nextChord, size: 80)
                else
                  SizedBox(
                    height: 108,
                    child: Center(
                      child: Text(
                        nextChordName ?? '',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                Text(
                  nextChordName ?? '',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSectionList() {
    // Group bars by section for display
    final sectionWidgets = <Widget>[];
    for (final section in _song.sections) {
      sectionWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4, left: 4),
          child: Text(
            '${section.label.toUpperCase()} ×${section.repeats}',
            style: const TextStyle(
              color: AppColors.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
      sectionWidgets.add(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(section.bars.length, (bi) {
              final bar = section.bars[bi];
              // Find if this bar is the currently active one
              bool isActive = false;
              if (_isPlaying && _playBars.isNotEmpty) {
                final activeBar = _playBars[_currentBarIdx];
                isActive = activeBar.chord == bar.chord &&
                    activeBar.sectionLabel == (bi == 0 ? section.label : null);
              }
              return Container(
                margin: const EdgeInsets.only(right: 8, bottom: 4),
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.outline,
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Takt ${bi + 1}',
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      bar.chord,
                      style: TextStyle(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isActive)
                      const Icon(Icons.circle, size: 6, color: AppColors.primary),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    }

    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: sectionWidgets,
    );
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

    final expectedChord =
        _playBars.isNotEmpty ? _playBars[_currentBarIdx].chord : '';
    final expectedNotes = _chordNotes[expectedChord] ?? [];
    final detected = _livePitch!.noteName;
    final isMatch = expectedNotes.contains(detected);
    final isRoot =
        expectedNotes.isNotEmpty && detected == expectedNotes.first;

    final color = isMatch
        ? Colors.green
        : (isRoot ? Colors.orange : Colors.red[300]!);

    return Card(
      color: color.withValues(alpha: 0.15),
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

  Widget _buildControls() {
    return Container(
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Stop
              IconButton(
                iconSize: 40,
                onPressed: _stop,
                icon: const Icon(Icons.stop_circle, color: AppColors.error),
                tooltip: 'Stop',
              ),
              // Play/Pause
              IconButton(
                iconSize: 52,
                onPressed: _togglePlay,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: AppColors.primary,
                ),
                tooltip: _isPlaying ? 'Pause' : 'Play',
              ),
              // Next bar (only in practice mode)
              if (_mode == _PracticeMode.practice)
                IconButton(
                  iconSize: 40,
                  onPressed: _isPlaying ? _nextBarManual : null,
                  icon: Icon(
                    Icons.skip_next,
                    color: _isPlaying
                        ? AppColors.textSecondary
                        : AppColors.textDisabled,
                  ),
                  tooltip: 'Nächster Akkord',
                ),
              // Backing track switch
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Backing',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 11)),
                  Switch(
                    value: _backingTrack,
                    onChanged: (v) => setState(() => _backingTrack = v),
                  ),
                ],
              ),
            ],
          ),
          // Tempo slider
          Row(
            children: [
              const Icon(Icons.speed, color: AppColors.textSecondary, size: 18),
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
                    if (_isPlaying) {
                      _startBeatTimer();
                      _startBarTimer();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 46,
                child: Text(
                  '${(_tempo * 100).round()}%',
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bestStars = _starsForAccuracy(_bestAccuracy);

    return Scaffold(
      appBar: AppBar(
        title: Text(_song.title),
        actions: [
          // Genre chip
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _song.genre,
              style: const TextStyle(
                color: AppColors.primaryLight,
                fontSize: 12,
              ),
            ),
          ),
          // BPM display
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                '${_song.bpm} BPM',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mode toggle + song info row
          Container(
            color: AppColors.surfaceDark,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    // Mode toggle
                    Expanded(
                      child: SegmentedButton<_PracticeMode>(
                        segments: const [
                          ButtonSegment(
                            value: _PracticeMode.practice,
                            label: Text('Üben'),
                            icon: Icon(Icons.touch_app, size: 16),
                          ),
                          ButtonSegment(
                            value: _PracticeMode.playAlong,
                            label: Text('Mitspielen'),
                            icon: Icon(Icons.play_circle_outline, size: 16),
                          ),
                        ],
                        selected: {_mode},
                        onSelectionChanged: (s) {
                          if (_isPlaying) return;
                          setState(() => _mode = s.first);
                        },
                        style: ButtonStyle(
                          textStyle: WidgetStateProperty.all(
                            const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Best stars
                    _buildStarRating(bestStars),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (_song.key.isNotEmpty) ...[
                      const Icon(Icons.music_note,
                          size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 2),
                      Text('Tonart: ${_song.key}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(width: 12),
                    ],
                    if (_song.capo > 0) ...[
                      Text('Capo: ${_song.capo}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(width: 12),
                    ],
                    Text('${_song.bpm} BPM',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          // Current chord diagram
          _buildCurrentChordPanel(),
          // Beat counter
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildBeatCounter(),
          ),
          // Strum pattern
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildStrumPattern(),
          ),
          const Divider(height: 1, color: AppColors.outline),
          // Section list
          Expanded(child: _buildSectionList()),
          // Pitch feedback
          _buildPitchFeedback(),
          // Controls
          _buildControls(),
        ],
      ),
    );
  }
}

class _PlayBar {
  final String chord;
  final int beats;
  final String? sectionLabel;
  final int sectionRepeats;
  const _PlayBar({
    required this.chord,
    required this.beats,
    this.sectionLabel,
    this.sectionRepeats = 1,
  });
}
