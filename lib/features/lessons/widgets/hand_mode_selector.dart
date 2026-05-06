import 'package:flutter/material.dart';
import '../../../core/curriculum/hand_isolation.dart';

class HandModeSelector extends StatelessWidget {
  final PracticeHand selected;
  final void Function(PracticeHand) onChanged;

  const HandModeSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Übungsmodus', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: PracticeHand.values.map((h) {
            final isSelected = h == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(h),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF7C3AED).withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF7C3AED) : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(_icon(h), size: 18, color: isSelected ? const Color(0xFF7C3AED) : Colors.grey),
                      const SizedBox(height: 2),
                      Text(
                        _shortLabel(h),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? const Color(0xFF7C3AED) : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (selected != PracticeHand.both) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              selected.xmariTip,
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ),
        ],
      ],
    );
  }

  IconData _icon(PracticeHand h) {
    switch (h) {
      case PracticeHand.both: return Icons.front_hand;
      case PracticeHand.frettingOnly: return Icons.pan_tool;
      case PracticeHand.strummingOnly: return Icons.waves;
    }
  }

  String _shortLabel(PracticeHand h) {
    switch (h) {
      case PracticeHand.both: return 'Beide\nHände';
      case PracticeHand.frettingOnly: return 'Nur\nGreif';
      case PracticeHand.strummingOnly: return 'Nur\nAnschlag';
    }
  }
}
