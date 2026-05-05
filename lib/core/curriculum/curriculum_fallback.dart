import 'models/curriculum_models.dart';

/// Built-in fallback curriculum data used when Supabase is unreachable
/// and the local cache is empty or unavailable.
class CurriculumFallback {
  CurriculumFallback._();

  static const List<ModuleModel> modules = [
    ModuleModel(
      id: 'module_1',
      titleDe: 'Dein erster Ton',
      titleEn: 'Your First Note',
      descriptionDe:
          'Lerne, einen sauberen Einzelton zu spielen, und schließe mit deinem ersten Riff ab.',
      descriptionEn:
          'Learn to play a clean single note and finish with your first riff.',
      orderIndex: 1,
      iconName: 'music_note',
      requiredLevel: 1,
      isFree: true,
    ),
    ModuleModel(
      id: 'module_2',
      titleDe: 'Grundtöne & Skalen',
      titleEn: 'Root Notes & Scales',
      descriptionDe:
          'Verstehe Noten auf dem Griffbrett und lerne einfache Skalen.',
      descriptionEn:
          'Understand notes on the fretboard and learn simple scales.',
      orderIndex: 2,
      iconName: 'piano',
      requiredLevel: 3,
    ),
    ModuleModel(
      id: 'module_3',
      titleDe: 'Power Chords & Riffs',
      titleEn: 'Power Chords & Riffs',
      descriptionDe:
          'Lerne Power Chords und spiele dein erstes vollständiges Riff.',
      descriptionEn: 'Learn power chords and play your first complete riff.',
      orderIndex: 3,
      iconName: 'bolt',
      requiredLevel: 5,
      xmariPreset: 'overdrive',
    ),
    ModuleModel(
      id: 'module_4',
      titleDe: 'Melodien & Licks',
      titleEn: 'Melodies & Licks',
      descriptionDe:
          'Entwickle melodisches Spiel mit klassischen Gitarren-Licks.',
      descriptionEn: 'Develop melodic playing with classic guitar licks.',
      orderIndex: 4,
      iconName: 'queue_music',
      requiredLevel: 7,
    ),
  ];
}
