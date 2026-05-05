import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/music_theory/chord.dart';
import 'package:enya_gitarre_learn/core/music_theory/scale.dart';
import 'package:enya_gitarre_learn/features/lessons/widgets/chord_diagram_widget.dart';
import 'package:enya_gitarre_learn/features/lessons/widgets/fretboard_widget.dart';

enum _ChordFilter { all, major, minor, seventh, sus, power }

extension on _ChordFilter {
  String get label {
    switch (this) {
      case _ChordFilter.all:
        return 'Alle';
      case _ChordFilter.major:
        return 'Dur';
      case _ChordFilter.minor:
        return 'Moll';
      case _ChordFilter.seventh:
        return '7';
      case _ChordFilter.sus:
        return 'sus';
      case _ChordFilter.power:
        return 'Power';
    }
  }
}

class ChordLibraryScreen extends ConsumerStatefulWidget {
  const ChordLibraryScreen({super.key});

  @override
  ConsumerState<ChordLibraryScreen> createState() => _ChordLibraryScreenState();
}

class _ChordLibraryScreenState extends ConsumerState<ChordLibraryScreen> {
  _ChordFilter _filter = _ChordFilter.all;
  String _query = '';

  List<Chord> get _allChords =>
      [...Chord.openChords, ...Chord.powerChords];

  List<Chord> get _filtered {
    final q = _query.trim().toLowerCase();
    return _allChords.where((c) {
      final matchesFilter = switch (_filter) {
        _ChordFilter.all => true,
        _ChordFilter.major => c.type == ChordType.major,
        _ChordFilter.minor =>
          c.type == ChordType.minor || c.type == ChordType.minor7,
        _ChordFilter.seventh => c.type == ChordType.dominant7 ||
            c.type == ChordType.major7 ||
            c.type == ChordType.minor7,
        _ChordFilter.sus =>
          c.type == ChordType.sus2 || c.type == ChordType.sus4,
        _ChordFilter.power => c.type == ChordType.power,
      };
      final matchesQuery =
          q.isEmpty || c.name.toLowerCase().contains(q) ||
              c.symbol.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chords = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('Akkord-Bibliothek')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Akkord suchen...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _ChordFilter.values
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f.label),
                          selected: _filter == f,
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: chords.isEmpty
                ? const Center(
                    child: Text('Keine Akkorde gefunden'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.74,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: chords.length,
                    itemBuilder: (context, i) {
                      final c = chords[i];
                      return Card(
                        color: AppColors.cardDark,
                        child: ChordDiagramWidget(
                          chord: c,
                          onTap: () => _openSheet(c),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _openSheet(Chord chord) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ChordDetailSheet(chord: chord),
    );
  }
}

class _ChordDetailSheet extends StatefulWidget {
  final Chord chord;
  const _ChordDetailSheet({required this.chord});

  @override
  State<_ChordDetailSheet> createState() => _ChordDetailSheetState();
}

class _ChordDetailSheetState extends State<_ChordDetailSheet> {
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

  Future<void> _play() async {
    try {
      await _player.setAsset(
        'assets/audio/chords/${widget.chord.name.toLowerCase()}.mp3',
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

  List<FretPosition> _positions() {
    final v = widget.chord.voicing;
    final list = <FretPosition>[];
    for (int s = 0; s < v.length; s++) {
      final f = v[s];
      if (f >= 0) {
        list.add(FretPosition(
          string: s,
          fret: f,
          note: widget.chord.root,
          isRoot: false,
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final low = widget.chord.lowestFret;
    final high = widget.chord.highestFret;
    final start = (low > 1 ? low - 1 : 0);
    final end = (high + 2).clamp(start + 5, 22);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.chord.symbol,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ChordDiagramWidget(chord: widget.chord, size: 200),
              const SizedBox(height: 20),
              const Text(
                'Position auf dem Griffbrett',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: FretboardWidget(
                  targetPositions: _positions(),
                  startFret: start,
                  endFret: end,
                  voicing: widget.chord.voicing,
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
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
