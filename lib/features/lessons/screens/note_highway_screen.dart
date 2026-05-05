import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../core/audio/pitch_detector.dart';
import '../widgets/note_highway_widget.dart';

/// Full-screen wrapper around [NoteHighwayWidget].
class NoteHighwayScreen extends StatefulWidget {
  final String songTitle;
  final List<HighwayNote> notes;
  final int bpm;
  final Stream<PitchResult> pitchStream;
  final VoidCallback? onExit;

  const NoteHighwayScreen({
    super.key,
    required this.songTitle,
    required this.notes,
    required this.bpm,
    required this.pitchStream,
    this.onExit,
  });

  @override
  State<NoteHighwayScreen> createState() => _NoteHighwayScreenState();
}

class _NoteHighwayScreenState extends State<NoteHighwayScreen> {
  bool _paused = false;
  HighwayResult? _result;

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _onComplete(HighwayResult r) {
    if (!mounted) return;
    setState(() => _result = r);
    _showResultSheet(r);
  }

  Future<void> _showResultSheet(HighwayResult r) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ResultSheet(
        result: r,
        onClose: () {
          Navigator.of(ctx).pop();
          widget.onExit?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        title: Text(
          widget.songTitle,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: widget.onExit ?? () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _paused ? Icons.play_arrow : Icons.pause,
              color: AppColors.textPrimary,
            ),
            onPressed: _togglePause,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: NoteHighwayWidget(
              notes: widget.notes,
              bpm: widget.bpm,
              pitchStream: widget.pitchStream,
              onComplete: _onComplete,
            ),
          ),
          if (_paused)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.pause_circle_filled,
                        size: 96,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pausiert',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _togglePause,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Weiter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResultSheet extends StatelessWidget {
  final HighwayResult result;
  final VoidCallback onClose;

  const _ResultSheet({required this.result, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final accPct = (result.accuracy * 100).toStringAsFixed(1);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Song beendet!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _row('Score', result.score.toString(), AppColors.xpColor),
            _row('Genauigkeit', '$accPct %', AppColors.primary),
            _row('Treffer', result.hitCount.toString(), AppColors.success),
            _row('Verfehlt', result.missCount.toString(), AppColors.error),
            _row('Perfect', result.perfectCount.toString(), AppColors.xpColor),
            _row('Great', result.greatCount.toString(), AppColors.primary),
            _row('Good', result.goodCount.toString(), AppColors.accent),
            _row('Max Combo', 'x${result.maxCombo}', AppColors.secondary),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Fertig',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
