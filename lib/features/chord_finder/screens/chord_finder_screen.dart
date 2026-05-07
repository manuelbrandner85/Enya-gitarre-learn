import 'package:flutter/material.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/music_theory/chord.dart';
import 'package:enya_gitarre_learn/features/lessons/widgets/chord_diagram_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CHORD FINDER SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ChordFinderScreen extends StatefulWidget {
  const ChordFinderScreen({super.key});

  @override
  State<ChordFinderScreen> createState() => _ChordFinderScreenState();
}

class _ChordFinderScreenState extends State<ChordFinderScreen> {
  // -1 = muted, 0-12 = fret number
  // String order: E2 A2 D3 G3 B3 E4 (index 0 = low E)
  final List<int> _frets = List.filled(6, -1);
  List<String> _results = [];
  String? _selectedChordName;

  static const List<String> _stringLabels = ['E2', 'A2', 'D3', 'G3', 'B3', 'E4'];
  // MIDI offsets from E2 (MIDI 40) for standard tuning
  static const List<int> _stringMidiBase = [40, 45, 50, 55, 59, 64];

  // ── Chord recognition ────────────────────────────────────────────────────

  /// Returns pitch class (0=C, 1=C#, ... 11=B) for a given fret on a string.
  int _pitchClass(int stringIndex, int fret) {
    return (_stringMidiBase[stringIndex] + fret) % 12;
  }

  static const Map<String, List<int>> _chordIntervals = {
    '': [0, 4, 7],          // major
    'm': [0, 3, 7],          // minor
    '7': [0, 4, 7, 10],      // dominant 7
    'maj7': [0, 4, 7, 11],   // major 7
    'm7': [0, 3, 7, 10],     // minor 7
    'sus2': [0, 2, 7],        // sus2
    'sus4': [0, 5, 7],        // sus4
    'dim': [0, 3, 6],         // diminished
    'aug': [0, 4, 8],         // augmented
    '5': [0, 7],              // power chord
    'm7b5': [0, 3, 6, 10],   // half-diminished
    'add9': [0, 2, 4, 7],    // add9
  };

  static const List<String> _noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B',
  ];

  List<String> _findChords(List<int> frets) {
    final playedPitches = <int>{};
    for (int s = 0; s < 6; s++) {
      if (frets[s] >= 0) {
        playedPitches.add(_pitchClass(s, frets[s]));
      }
    }

    if (playedPitches.isEmpty) return [];

    final matches = <String>[];

    for (int root = 0; root < 12; root++) {
      for (final entry in _chordIntervals.entries) {
        final suffix = entry.key;
        final intervals = entry.value;

        final chordTones = intervals.map((i) => (root + i) % 12).toSet();

        // Played notes must all be chord tones (played notes ⊆ chord tones)
        // and at least the root must be present.
        if (playedPitches.isNotEmpty &&
            playedPitches.every((p) => chordTones.contains(p)) &&
            playedPitches.contains(root)) {
          final rootName = _noteNames[root];
          matches.add('$rootName$suffix');
        }
      }
    }

    // De-duplicate while preserving order.
    final seen = <String>{};
    return matches.where(seen.add).toList();
  }

  void _recognize() {
    setState(() {
      _results = _findChords(_frets);
      _selectedChordName = _results.isNotEmpty ? _results.first : null;
    });
  }

  void _reset() {
    setState(() {
      for (int i = 0; i < 6; i++) { _frets[i] = -1; }
      _results = [];
      _selectedChordName = null;
    });
  }

  // ── Known chord lookup ────────────────────────────────────────────────────

  Chord? _chordForName(String name) {
    final all = [...Chord.openChords, ...Chord.powerChords];
    try {
      return all.firstWhere((c) => c.name == name || c.symbol == name);
    } catch (_) {
      return null;
    }
  }

  // ── Build helpers ─────────────────────────────────────────────────────────

  Widget _buildFretInput(int stringIndex) {
    final currentFret = _frets[stringIndex];
    final label = _stringLabels[stringIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // X (muted) button
          _FretButton(
            label: 'X',
            selected: currentFret == -1,
            onTap: () => setState(() {
              _frets[stringIndex] = -1;
              _results = [];
              _selectedChordName = null;
            }),
            isMuted: true,
          ),
          const SizedBox(width: 4),
          // Fret buttons 0-12
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(13, (fret) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _FretButton(
                      label: '$fret',
                      selected: currentFret == fret,
                      onTap: () => setState(() {
                        _frets[stringIndex] = fret;
                        _results = [];
                        _selectedChordName = null;
                      }),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Kein Akkord erkannt – prüfe deine Eingabe.',
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      );
    }

    final selectedChord = _selectedChordName != null
        ? _chordForName(_selectedChordName!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gefundene Akkorde:',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _results.map((name) {
            final isSelected = name == _selectedChordName;
            return GestureDetector(
              onTap: () => setState(() => _selectedChordName = name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.outline,
                  ),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (_selectedChordName != null) ...[
          Center(
            child: selectedChord != null
                ? Column(
                    children: [
                      ChordDiagramWidget(
                        chord: selectedChord,
                        size: 160,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedChord.voicingString,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      _selectedChordName!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final anyNonMuted = _frets.any((f) => f >= 0);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Akkord-Finder',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          if (anyNonMuted)
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 18),
              label: const Text(
                'Zurücksetzen',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation card ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.primaryLight, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Welcher Akkord?\nWähle für jede Saite den gegriffenen Bund aus (0 = offen, X = gedämpft). Tippe auf "Akkord erkennen", um passende Akkordnamen zu erhalten.',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Fretboard input ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saiten-Eingabe',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Von tief (E2) nach hoch (E4)',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(6, (i) => _buildFretInput(i)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Recognize button ─────────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: anyNonMuted ? _recognize : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.outline,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.search, color: AppColors.textPrimary),
              label: const Text(
                'Akkord erkennen',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Results ──────────────────────────────────────────────────────
            if (_results.isNotEmpty || anyNonMuted && _results.isEmpty && _selectedChordName == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: _buildResults(),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FRET BUTTON WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _FretButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isMuted;

  const _FretButton({
    required this.label,
    required this.selected,
    required this.onTap,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (isMuted ? AppColors.error : AppColors.primary)
        : AppColors.cardDark;
    final fg = selected ? AppColors.textPrimary : AppColors.textSecondary;
    final border = selected
        ? (isMuted ? AppColors.error : AppColors.primary)
        : AppColors.outline;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
