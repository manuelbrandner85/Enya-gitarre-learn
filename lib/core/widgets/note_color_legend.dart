import 'package:flutter/material.dart';
import '../music_theory/note_colors.dart';

class NoteColorLegend extends StatelessWidget {
  final bool compact;
  const NoteColorLegend({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    const notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: notes
          .map(
            (n) => Padding(
              padding: EdgeInsets.symmetric(horizontal: compact ? 2 : 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: compact ? 20 : 28,
                    height: compact ? 20 : 28,
                    decoration: BoxDecoration(
                      color: NoteColors.forNote(n),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 2),
                    Text(
                      n,
                      style: const TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
