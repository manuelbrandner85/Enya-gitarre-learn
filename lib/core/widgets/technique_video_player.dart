import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../core/curriculum/technique_videos.dart';

class TechniqueVideoPlayer extends StatelessWidget {
  final GuitarTechnique technique;

  const TechniqueVideoPlayer({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    final video = TechniqueVideos.forTechnique(technique);
    final displayName = video?.titleDe ?? technique.name;
    final description = video?.descriptionDe ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 160,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Center(
            child: Icon(
              Icons.play_circle,
              size: 48,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          displayName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
