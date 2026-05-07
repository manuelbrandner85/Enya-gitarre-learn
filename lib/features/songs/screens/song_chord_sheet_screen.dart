import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/music_theory/chord_transposer.dart';
import 'package:enya_gitarre_learn/features/lessons/widgets/chord_diagram_widget.dart';
import 'package:enya_gitarre_learn/features/songs/providers/song_user_data_provider.dart';
import 'package:enya_gitarre_learn/features/songs/screens/song_library_screen.dart';
import 'package:enya_gitarre_learn/core/music_theory/chord.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class SongChordSheetScreen extends ConsumerStatefulWidget {
  final String songId;

  const SongChordSheetScreen({super.key, required this.songId});

  @override
  ConsumerState<SongChordSheetScreen> createState() =>
      _SongChordSheetScreenState();
}

class _SongChordSheetScreenState extends ConsumerState<SongChordSheetScreen> {
  late final SongData _song;

  int _transposeSteps = 0;
  int _capo = 0;
  bool _stageMode = false;
  bool _autoScroll = false;
  double _scrollSpeed = 1.0;
  Timer? _scrollTimer;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _song = kSongs.firstWhere((s) => s.id == widget.songId);
    _capo = _song.capo;
    // Record as recently viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentlyViewedProvider.notifier).add(widget.songId);
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scroll.dispose();
    // Restore system UI on exit
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ── Transpose / Capo ────────────────────────────────────────────────────────

  String _displayChord(String chord) {
    var c = ChordTransposer.transpose(chord, _transposeSteps);
    if (_capo > 0) c = ChordTransposer.applyCapo(c, _capo);
    return c;
  }

  // ── Auto-scroll ─────────────────────────────────────────────────────────────

  void _startScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_scroll.hasClients) return;
      final max = _scroll.position.maxScrollExtent;
      if (_scroll.offset >= max) {
        _stopScroll();
        return;
      }
      _scroll.jumpTo(_scroll.offset + _scrollSpeed * 0.5);
    });
  }

  void _stopScroll() {
    _scrollTimer?.cancel();
    setState(() => _autoScroll = false);
  }

  void _toggleAutoScroll() {
    setState(() => _autoScroll = !_autoScroll);
    if (_autoScroll) {
      _startScroll();
    } else {
      _scrollTimer?.cancel();
    }
  }

  // ── Stage mode ───────────────────────────────────────────────────────────────

  void _toggleStageMode() {
    setState(() => _stageMode = !_stageMode);
    if (_stageMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  // ── Capo dialog ─────────────────────────────────────────────────────────────

  void _showCapoDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => SimpleDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          'Capo',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        children: List.generate(
          8,
          (i) => SimpleDialogOption(
            child: Text(
              i == 0 ? 'Kein Capo' : 'Bund $i',
              style: TextStyle(
                color: _capo == i ? AppColors.primary : AppColors.textPrimary,
                fontWeight:
                    _capo == i ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onPressed: () {
              setState(() => _capo = i);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }

  // ── Chord diagram ────────────────────────────────────────────────────────────

  void _showChordDiagram(BuildContext ctx, String rawChord) {
    final displayed = _displayChord(rawChord);
    // Try to find the chord in the open or power chord lists
    final allChords = [...Chord.openChords, ...Chord.powerChords];
    Chord? found;
    try {
      found = allChords.firstWhere(
        (c) => c.name.toLowerCase() == displayed.toLowerCase(),
      );
    } catch (_) {
      found = null;
    }

    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (found != null) ...[
              ChordDiagramWidget(chord: found, size: 160),
              const SizedBox(height: 8),
              Text(
                found.symbol.isEmpty ? found.name : found.symbol,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ] else ...[
              const Icon(Icons.music_note, color: AppColors.primary, size: 48),
              const SizedBox(height: 12),
              Text(
                displayed,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kein Diagramm verfügbar',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(songFavoritesProvider).contains(widget.songId);

    if (_stageMode) {
      return _buildStageMode(context, isFav);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _SongInfoBar(song: _song, capo: _capo, transposeSteps: _transposeSteps),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _song.sections
                    .map((section) => _buildSection(context, section))
                    .toList(),
              ),
            ),
          ),
          _BottomToolbar(
            isFavorite: isFav,
            autoScroll: _autoScroll,
            scrollSpeed: _scrollSpeed,
            onFavTap: () =>
                ref.read(songFavoritesProvider.notifier).toggle(widget.songId),
            onScrollToggle: _toggleAutoScroll,
            onSpeedChanged: (v) {
              setState(() => _scrollSpeed = v);
              if (_autoScroll) _startScroll();
            },
            onPracticeTap: () =>
                context.push('/home/songbuch/${widget.songId}'),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final transposeLabel = _transposeSteps == 0
        ? '0'
        : _transposeSteps > 0
            ? '+$_transposeSteps'
            : '$_transposeSteps';

    return AppBar(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _song.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _song.artist,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        // Capo button with value label
        TextButton.icon(
          icon: const Icon(Icons.music_note, size: 16),
          label: Text(_capo == 0 ? 'Capo' : 'Capo $_capo'),
          style: TextButton.styleFrom(
            foregroundColor: _capo > 0 ? AppColors.primary : AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onPressed: () => _showCapoDialog(context),
        ),
        // Transpose controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 18),
              tooltip: 'Tiefer',
              onPressed: _transposeSteps > -6 ? () => setState(() => _transposeSteps--) : null,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
            SizedBox(
              width: 32,
              child: Text(
                transposeLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _transposeSteps != 0 ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 18),
              tooltip: 'Höher',
              onPressed: _transposeSteps < 6 ? () => setState(() => _transposeSteps++) : null,
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        // Stage mode
        IconButton(
          icon: const Icon(Icons.fullscreen, size: 22),
          tooltip: 'Bühnen-Modus',
          onPressed: _toggleStageMode,
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, SongSection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.label.toUpperCase() +
                (section.repeats > 1 ? ' ×${section.repeats}' : ''),
            style: const TextStyle(
              color: AppColors.primaryLight,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          _buildBarGrid(context, section),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBarGrid(BuildContext context, SongSection section) {
    String? prevChord;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: section.bars.map((bar) {
        final displayed = _displayChord(bar.chord);
        final isChange = displayed != (prevChord == null
            ? null
            : _displayChord(prevChord!));
        prevChord = bar.chord;
        return _ChordBarWidget(
          chord: displayed,
          beats: bar.beats,
          isChordChange: isChange,
          stageMode: false,
          onTap: () => _showChordDiagram(context, bar.chord),
        );
      }).toList(),
    );
  }

  Widget _buildStageMode(BuildContext context, bool isFav) {
    return GestureDetector(
      onTap: _toggleStageMode,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      _song.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _song.artist,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.fullscreen_exit,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.outline, height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _song.sections.map((section) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.label.toUpperCase() +
                                  (section.repeats > 1
                                      ? ' ×${section.repeats}'
                                      : ''),
                              style: const TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildStageModeBarGrid(section),
                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              _BottomToolbar(
                isFavorite: isFav,
                autoScroll: _autoScroll,
                scrollSpeed: _scrollSpeed,
                onFavTap: () => ref
                    .read(songFavoritesProvider.notifier)
                    .toggle(widget.songId),
                onScrollToggle: _toggleAutoScroll,
                onSpeedChanged: (v) {
                  setState(() => _scrollSpeed = v);
                  if (_autoScroll) _startScroll();
                },
                onPracticeTap: () =>
                    context.push('/home/songbuch/${widget.songId}'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageModeBarGrid(SongSection section) {
    String? prevChord;
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: section.bars.map((bar) {
        final displayed = _displayChord(bar.chord);
        final isChange = displayed !=
            (prevChord == null ? null : _displayChord(prevChord!));
        prevChord = bar.chord;
        return _ChordBarWidget(
          chord: displayed,
          beats: bar.beats,
          isChordChange: isChange,
          stageMode: true,
          onTap: () {},
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SongInfoBar
// ─────────────────────────────────────────────────────────────────────────────

class _SongInfoBar extends StatelessWidget {
  final SongData song;
  final int capo;
  final int transposeSteps;

  const _SongInfoBar({required this.song, required this.capo, required this.transposeSteps});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            if (song.key.isNotEmpty) _InfoChip(label: 'Key: ${song.key}'),
            _InfoChip(label: '${song.bpm} BPM'),
            _InfoChip(label: song.genre),
            _DifficultyChip(difficulty: song.difficulty),
            if (song.tuning != 'Standard')
              _InfoChip(label: song.tuning),
            if (capo > 0) _InfoChip(label: 'Capo $capo', highlight: true),
            if (transposeSteps != 0)
              _InfoChip(
                label: transposeSteps > 0 ? '+$transposeSteps Halbton' : '$transposeSteps Halbton',
                highlight: true,
              ),
          ]
              .expand((w) => [w, const SizedBox(width: 8)])
              .toList()
            ..removeLast(),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final bool highlight;

  const _InfoChip({required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryMuted : AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? AppColors.primary : AppColors.outline,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: highlight ? AppColors.primaryLight : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final int difficulty;

  const _DifficultyChip({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final stars = List.generate(
      5,
      (i) => Icon(
        i < difficulty ? Icons.star : Icons.star_border,
        size: 14,
        color: i < difficulty ? AppColors.warning : AppColors.textTertiary,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: stars),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ChordBarWidget
// ─────────────────────────────────────────────────────────────────────────────

class _ChordBarWidget extends StatelessWidget {
  final String chord;
  final int beats;
  final bool isChordChange;
  final bool stageMode;
  final VoidCallback onTap;

  const _ChordBarWidget({
    required this.chord,
    required this.beats,
    required this.isChordChange,
    required this.stageMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double width = stageMode ? 110 : 80;
    final double height = stageMode ? 88 : 64;
    final double chordFontSize = stageMode ? 24 : 18;
    final double beatFontSize = stageMode ? 13 : 10;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isChordChange ? AppColors.primary : AppColors.outline,
            width: isChordChange ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chord,
              style: TextStyle(
                color: isChordChange
                    ? AppColors.primary
                    : AppColors.textPrimary,
                fontSize: chordFontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              List.generate(beats, (_) => '●').join(' '),
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: beatFontSize,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BottomToolbar
// ─────────────────────────────────────────────────────────────────────────────

class _BottomToolbar extends StatelessWidget {
  final bool isFavorite;
  final bool autoScroll;
  final double scrollSpeed;
  final VoidCallback onFavTap;
  final VoidCallback onScrollToggle;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onPracticeTap;

  const _BottomToolbar({
    required this.isFavorite,
    required this.autoScroll,
    required this.scrollSpeed,
    required this.onFavTap,
    required this.onScrollToggle,
    required this.onSpeedChanged,
    required this.onPracticeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceDark,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Favorite button
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : AppColors.textSecondary,
              ),
              tooltip: isFavorite
                  ? 'Von Favoriten entfernen'
                  : 'Zu Favoriten hinzufügen',
              onPressed: onFavTap,
            ),
            // Auto-scroll toggle
            IconButton(
              icon: Icon(
                autoScroll
                    ? Icons.pause_circle_outlined
                    : Icons.play_circle_outline,
                color: autoScroll ? AppColors.primary : AppColors.textSecondary,
              ),
              tooltip: autoScroll ? 'Scrollen stoppen' : 'Auto-Scroll',
              onPressed: onScrollToggle,
            ),
            // Speed slider (only when scrolling)
            if (autoScroll) ...[
              const Icon(
                Icons.slow_motion_video,
                color: AppColors.textSecondary,
                size: 18,
              ),
              Expanded(
                child: Slider(
                  value: scrollSpeed,
                  min: 0.5,
                  max: 3.0,
                  divisions: 10,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.outline,
                  onChanged: onSpeedChanged,
                ),
              ),
              const Icon(
                Icons.fast_forward,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ] else
              const Spacer(),
            // Practice mode button — labeled for clarity
            TextButton.icon(
              onPressed: onPracticeTap,
              icon: const Icon(Icons.mic, size: 16),
              label: const Text('Üben', style: TextStyle(fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
