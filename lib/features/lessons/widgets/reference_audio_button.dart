import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../core/audio/reference_audio_service.dart';

final _referenceAudioProvider = Provider<ReferenceAudioService>((ref) {
  final service = ReferenceAudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

class ReferenceAudioButton extends ConsumerWidget {
  final String note; // e.g. 'E4'
  final String label; // e.g. 'Referenzton hören'

  const ReferenceAudioButton({
    super.key,
    required this.note,
    this.label = 'Referenzton',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => ref.read(_referenceAudioProvider).playNote(note),
      icon: const Icon(Icons.play_circle_outline),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary.withOpacity(0.6)),
      ),
    );
  }
}
