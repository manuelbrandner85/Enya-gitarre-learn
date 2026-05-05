import 'package:freezed_annotation/freezed_annotation.dart';

import 'lesson.dart';

part 'module.freezed.dart';
part 'module.g.dart';

@freezed
class Module with _$Module {
  const factory Module({
    required String id,
    required int moduleNumber,
    required String title,
    required String description,
    required String weekRange,
    @Default(GuitarPreset.clean) GuitarPreset presetRequired,
    @Default(1) int difficulty,
    @Default([]) List<Lesson> lessons,
    @Default([]) List<String> unlockedPresets,
    @Default(true) bool isLocked,
    @Default(0.0) double completionPercentage,
    @Default('') String imageAsset,
    @Default('') String learningGoals,
  }) = _Module;

  factory Module.fromJson(Map<String, dynamic> json) =>
      _$ModuleFromJson(json);

  const Module._();

  /// Returns total XP available in this module
  int get totalXpAvailable =>
      lessons.fold(0, (sum, lesson) => sum + lesson.xpReward);

  /// Returns the number of completed lessons
  int get completedLessons =>
      lessons.where((l) => l.isCompleted).length;

  /// Returns true if all lessons are completed
  bool get isCompleted => completedLessons == lessons.length;

  /// Returns a difficulty label in German
  String get difficultyLabel {
    if (difficulty <= 2) return 'Anfänger';
    if (difficulty <= 5) return 'Fortgeschritten-Anfänger';
    if (difficulty <= 7) return 'Fortgeschritten';
    return 'Experte';
  }

  /// Returns the module icon based on preset/content
  String get iconName {
    switch (presetRequired) {
      case GuitarPreset.clean:
        return 'music_note';
      case GuitarPreset.overdrive:
        return 'bolt';
      case GuitarPreset.distortion:
        return 'electric_bolt';
      case GuitarPreset.highGain:
        return 'whatshot';
      case GuitarPreset.acoustic:
        return 'acoustic_guitar';
      case GuitarPreset.jazz:
        return 'piano';
    }
  }
}

/// Static module content - all 12 modules of the curriculum
class ModuleContent {
  ModuleContent._();

  static List<Module> get allModules => [
        Module(
          id: 'module-01',
          moduleNumber: 1,
          title: 'Erste Töne',
          description: 'Lerne die Grundlagen der E-Gitarre kennen und spiele deine ersten Töne auf der Enya XMARI.',
          weekRange: 'Woche 1-2',
          presetRequired: GuitarPreset.clean,
          difficulty: 1,
          isLocked: false,
          learningGoals: 'Gitarre halten, erste Saiten zupfen, saubere Töne erzeugen',
          unlockedPresets: ['clean'],
        ),
        Module(
          id: 'module-02',
          moduleNumber: 2,
          title: 'Power Chords',
          description: 'Die Geheimwaffe des Rock! Power Chords sind einfach zu spielen und klingen sofort nach E-Gitarre.',
          weekRange: 'Woche 3-4',
          presetRequired: GuitarPreset.overdrive,
          difficulty: 2,
          isLocked: true,
          learningGoals: 'E5, A5, D5, G5 Power Chords, Übungslied',
          unlockedPresets: ['overdrive'],
        ),
        Module(
          id: 'module-03',
          moduleNumber: 3,
          title: 'Open Chords',
          description: 'Lerne die wichtigsten offenen Akkorde: Em, Am, E, D, G und C.',
          weekRange: 'Woche 5-7',
          presetRequired: GuitarPreset.clean,
          difficulty: 3,
          isLocked: true,
          learningGoals: 'Em, Am, E, D, G, C Akkorde, Akkordwechsel',
          unlockedPresets: [],
        ),
        Module(
          id: 'module-04',
          moduleNumber: 4,
          title: 'Moll Pentatonik',
          description: 'Die Tonleiter für Blues und Rock-Soli. Beginne deine Reise als Leadgitarrist!',
          weekRange: 'Woche 8-9',
          presetRequired: GuitarPreset.overdrive,
          difficulty: 4,
          isLocked: true,
          learningGoals: 'Am Pentatonik Position 1, einfache Licks',
          unlockedPresets: [],
        ),
        Module(
          id: 'module-05',
          moduleNumber: 5,
          title: 'Barre Akkorde',
          description: 'Der große Sprung: Barre-Akkorde eröffnen die volle Griffbreite des Griffbretts.',
          weekRange: 'Woche 10-12',
          presetRequired: GuitarPreset.clean,
          difficulty: 5,
          isLocked: true,
          learningGoals: 'F-Dur Barre, B-Moll Barre, Akkordwechsel',
          unlockedPresets: [],
        ),
        Module(
          id: 'module-06',
          moduleNumber: 6,
          title: 'Blues Tonleiter & Bends',
          description: 'Lerne die Blues-Tonleiter und die Technik des String Bending für emotionale Soli.',
          weekRange: 'Woche 13-15',
          presetRequired: GuitarPreset.overdrive,
          difficulty: 6,
          isLocked: true,
          learningGoals: 'Blues-Tonleiter, Bending, Vibrato-Grundlagen',
          unlockedPresets: [],
        ),
        Module(
          id: 'module-07',
          moduleNumber: 7,
          title: 'Distortion & Metal Basics',
          description: 'Zeit für Heavy Sounds! Entdecke Distortion und die Grundlagen des Metal-Spiels.',
          weekRange: 'Woche 16-18',
          presetRequired: GuitarPreset.distortion,
          difficulty: 7,
          isLocked: true,
          learningGoals: 'Distortion-Sound, Palm Muting, schnelle Power Chords',
          unlockedPresets: ['distortion'],
        ),
        Module(
          id: 'module-08',
          moduleNumber: 8,
          title: 'Rhythmik & Strumming',
          description: 'Vertiefe dein Rhythmusgefühl mit verschiedenen Strumming-Patterns und Synkopen.',
          weekRange: 'Woche 19-20',
          presetRequired: GuitarPreset.clean,
          difficulty: 6,
          isLocked: true,
          learningGoals: 'Strumming Patterns, Synkopen, Muting-Techniken',
          unlockedPresets: [],
        ),
        Module(
          id: 'module-09',
          moduleNumber: 9,
          title: 'Dur Pentatonik & Soli',
          description: 'Die Dur-Pentatonik für Country und Rock-Soli. Kombiniere mit der Moll-Pentatonik.',
          weekRange: 'Woche 21-23',
          presetRequired: GuitarPreset.overdrive,
          difficulty: 7,
          isLocked: true,
          learningGoals: 'G-Dur Pentatonik, Skalen verbinden, eigene Licks',
          unlockedPresets: [],
        ),
        Module(
          id: 'module-10',
          moduleNumber: 10,
          title: 'High Gain & Metal Riffs',
          description: 'Entfessle die volle Power der E-Gitarre mit High-Gain-Sounds und komplexen Metal-Riffs.',
          weekRange: 'Woche 24-26',
          presetRequired: GuitarPreset.highGain,
          difficulty: 8,
          isLocked: true,
          learningGoals: 'High Gain Sound, 16tel-Picking, Metal-Riffs',
          unlockedPresets: ['highGain'],
        ),
        Module(
          id: 'module-11',
          moduleNumber: 11,
          title: 'Gehörtraining & Improvisation',
          description: 'Trainiere dein Gehör und lerne, über Akkorde zu improvisieren.',
          weekRange: 'Woche 27-29',
          presetRequired: GuitarPreset.clean,
          difficulty: 8,
          isLocked: true,
          learningGoals: 'Intervalle erkennen, Akkorde hören, freie Improvisation',
          unlockedPresets: [],
        ),
        Module(
          id: 'module-12',
          moduleNumber: 12,
          title: 'Dein eigener Song',
          description: 'Das große Finale! Kompositions-Grundlagen und Recording mit der Enya XMARI.',
          weekRange: 'Woche 30-32',
          presetRequired: GuitarPreset.overdrive,
          difficulty: 9,
          isLocked: true,
          learningGoals: 'Song-Struktur, Akkordfolgen, Recording, Mixing-Grundlagen',
          unlockedPresets: [],
        ),
      ];
}
