enum SongReadiness { ready, challenging, tooHard }

class SongReadinessInfo {
  final SongReadiness readiness;
  final List<String> missingSkills;
  final String recommendedPreset;
  final String recommendedPickup;
  final String? tuningNote;

  const SongReadinessInfo({
    required this.readiness,
    required this.missingSkills,
    required this.recommendedPreset,
    required this.recommendedPickup,
    this.tuningNote,
  });
}

class SongDifficultyPredictor {
  SongDifficultyPredictor._();

  static SongReadinessInfo evaluate({
    required List<String> songChords,
    required int songDifficulty,
    required int completedModules,
    required List<String> knownChords,
  }) {
    final missing = songChords.where((c) => !knownChords.contains(c)).toList();
    final SongReadiness readiness;
    if (missing.isEmpty && completedModules >= songDifficulty * 3) {
      readiness = SongReadiness.ready;
    } else if (missing.length <= 2 && completedModules >= songDifficulty * 2) {
      readiness = SongReadiness.challenging;
    } else {
      readiness = SongReadiness.tooHard;
    }

    final preset = songDifficulty >= 3 ? 'Distortion' : songDifficulty >= 2 ? 'Overdrive' : 'Clean';
    final pickup = songDifficulty >= 3 ? 'Position 1 (Bridge)' : 'Position 3';

    return SongReadinessInfo(
      readiness: readiness,
      missingSkills: missing,
      recommendedPreset: preset,
      recommendedPickup: pickup,
    );
  }
}
