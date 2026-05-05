import 'package:flutter/material.dart';

import 'package:enya_gitarre_learn/app/theme/colors.dart';
import 'package:enya_gitarre_learn/core/audio/pitch_detector.dart';
import 'package:enya_gitarre_learn/core/audio/tuner_service.dart';
import 'package:enya_gitarre_learn/core/music_theory/note.dart';

/// A row of six string buttons used in the tuner UI.
///
/// Strings are displayed in playing order: low E (string 0) on the left,
/// high E (string 5) on the right. The active string is highlighted with the
/// primary color, and tuned strings show a green checkmark.
class StringSelectorWidget extends StatelessWidget {
  final TuningType tuning;
  final int? activeString;
  final Set<int> tunedStrings;
  final void Function(int)? onStringTap;

  const StringSelectorWidget({
    super.key,
    required this.tuning,
    required this.activeString,
    required this.tunedStrings,
    this.onStringTap,
  });

  @override
  Widget build(BuildContext context) {
    final midis = tuning.midiNotes;
    return SizedBox(
      height: 88,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (i) {
          final note = Note.fromMidi(midis[i]);
          final isActive = activeString == i;
          final isTuned = tunedStrings.contains(i);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _StringButton(
                stringIndex: i,
                noteName: note.name,
                octave: note.octave,
                isActive: isActive,
                isTuned: isTuned,
                onTap: onStringTap == null ? null : () => onStringTap!(i),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _StringButton extends StatelessWidget {
  final int stringIndex;
  final String noteName;
  final int octave;
  final bool isActive;
  final bool isTuned;
  final VoidCallback? onTap;

  const _StringButton({
    required this.stringIndex,
    required this.noteName,
    required this.octave,
    required this.isActive,
    required this.isTuned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color border;
    final Color textColor;
    if (isActive) {
      bg = AppColors.primary;
      border = AppColors.primary;
      textColor = Colors.white;
    } else if (isTuned) {
      bg = AppColors.success.withOpacity(0.18);
      border = AppColors.success;
      textColor = AppColors.success;
    } else {
      bg = AppColors.cardDark;
      border = AppColors.outline;
      textColor = AppColors.textPrimary;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      noteName,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'S${stringIndex + 1}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isTuned)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
