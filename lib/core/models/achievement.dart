import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String key,
    required String title,
    required String description,
    @Default('assets/images/achievement_default.png') String iconPath,
    @Default(30) int xpReward,
    @Default(false) bool isSecret,
    DateTime? unlockedAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  const Achievement._();

  bool get isUnlocked => unlockedAt != null;
}

/// All achievement definitions
class AchievementRegistry {
  AchievementRegistry._();

  static const String firstNote = 'first_note';
  static const String firstChord = 'first_chord';
  static const String powerRocker = 'power_rocker';
  static const String songDebut = 'song_debut';
  static const String nightOwl = 'night_owl';
  static const String earlyBird = 'early_bird';
  static const String overdriveUnlocked = 'overdrive_unlocked';
  static const String distortionBeast = 'distortion_beast';
  static const String highGainHero = 'high_gain_hero';
  static const String pentatonicMaster = 'pentatonic_master';
  static const String streak7 = 'streak_7';
  static const String streak30 = 'streak_30';
  static const String streak100 = 'streak_100';
  static const String streak365 = 'streak_365';
  static const String recordingArtist = 'recording_artist';
  static const String barreConqueror = 'barre_conqueror';
  static const String speedDemon = 'speed_demon';
  static const String earMaster = 'ear_master';
  static const String theoryScholar = 'theory_scholar';
  static const String moduleComplete1 = 'module_complete_1';
  static const String moduleComplete6 = 'module_complete_6';
  static const String moduleComplete12 = 'module_complete_12';
  static const String perfectLesson = 'perfect_lesson';
  static const String tenLessons = 'ten_lessons';
  static const String fiftyLessons = 'fifty_lessons';
  static const String hundredLessons = 'hundred_lessons';
  static const String level5 = 'level_5';
  static const String level10 = 'level_10';
  static const String level25 = 'level_25';
  static const String level50 = 'level_50';
  static const String firstRecording = 'first_recording';
  static const String tenRecordings = 'ten_recordings';
  static const String bluesBend = 'blues_bend';
  static const String vibrato = 'vibrato';
  static const String powerChordPerfect = 'power_chord_perfect';
  static const String openChordMaster = 'open_chord_master';
  static const String oneHourPractice = 'one_hour_practice';
  static const String tenHoursPractice = 'ten_hours_practice';
  static const String hundredHoursPractice = 'hundred_hours_practice';
  static const String tunerPro = 'tuner_pro';
  static const String metronomeMaster = 'metronome_master';
  static const String bluetoothConnected = 'bluetooth_connected';
  static const String xmariConnected = 'xmari_connected';
  static const String allPresetsUnlocked = 'all_presets_unlocked';
  static const String weekendWarrior = 'weekend_warrior';
  static const String dailyDedication = 'daily_dedication';
  static const String lateNightJam = 'late_night_jam';
  static const String morningPractice = 'morning_practice';
  static const String socialSharer = 'social_sharer';
  static const String firstFeedback = 'first_feedback';
  static const String secretRiff = 'secret_riff';
  static const String metalGod = 'metal_god';

  static List<Achievement> get allAchievements => [
        const Achievement(
          key: firstNote,
          title: 'Erste Note!',
          description: 'Du hast deine erste Note auf der E-Gitarre gespielt.',
          xpReward: 10,
        ),
        const Achievement(
          key: firstChord,
          title: 'Erster Akkord',
          description: 'Du hast deinen ersten Akkord erfolgreich gespielt.',
          xpReward: 20,
        ),
        const Achievement(
          key: powerRocker,
          title: 'Power Rocker',
          description: 'Alle grundlegenden Power Chords gemeistert.',
          xpReward: 50,
        ),
        const Achievement(
          key: songDebut,
          title: 'Song-Debüt',
          description: 'Dein erstes vollständiges Lied gespielt!',
          xpReward: 100,
        ),
        const Achievement(
          key: nightOwl,
          title: 'Nachteule',
          description: 'Nach 22 Uhr geübt. Der Rock schläft nie!',
          xpReward: 20,
          isSecret: true,
        ),
        const Achievement(
          key: earlyBird,
          title: 'Frühaufsteher',
          description: 'Vor 8 Uhr geübt. Morgenstund hat Gold im Mund!',
          xpReward: 20,
          isSecret: true,
        ),
        const Achievement(
          key: overdriveUnlocked,
          title: 'Overdrive Entdeckt',
          description: 'Den Overdrive-Sound zum ersten Mal aktiviert.',
          xpReward: 30,
        ),
        const Achievement(
          key: distortionBeast,
          title: 'Distortion-Biest',
          description: 'Den Distortion-Preset freigeschaltet und genutzt.',
          xpReward: 50,
        ),
        const Achievement(
          key: highGainHero,
          title: 'High Gain Held',
          description: 'Den High-Gain-Sound gemeistert. Metal incoming!',
          xpReward: 75,
        ),
        const Achievement(
          key: pentatonicMaster,
          title: 'Pentatonik-Meister',
          description: 'Die Moll-Pentatonik in allen 5 Positionen gelernt.',
          xpReward: 100,
        ),
        const Achievement(
          key: streak7,
          title: '7 Tage Streak!',
          description: '7 Tage in Folge geübt. Weiter so!',
          xpReward: 50,
        ),
        const Achievement(
          key: streak30,
          title: '30 Tage Streak!',
          description: 'Ein ganzer Monat tägliches Üben. Beeindruckend!',
          xpReward: 200,
        ),
        const Achievement(
          key: streak100,
          title: '100 Tage Streak!',
          description: '100 Tage ununterbrochen geübt. Du bist eine Legende!',
          xpReward: 500,
        ),
        const Achievement(
          key: streak365,
          title: 'Ein Jahr Gitarre!',
          description: '365 Tage Streak! Ein ganzes Jahr Hingabe!',
          xpReward: 1000,
          isSecret: true,
        ),
        const Achievement(
          key: recordingArtist,
          title: 'Recording Artist',
          description: '10 Aufnahmen von dir selbst erstellt.',
          xpReward: 75,
        ),
        const Achievement(
          key: barreConqueror,
          title: 'Barre-Bezwinger',
          description: 'Den ersten Barre-Akkord sauber gespielt.',
          xpReward: 100,
        ),
        const Achievement(
          key: speedDemon,
          title: 'Speed Demon',
          description: 'Eine Übung mit 180 BPM abgeschlossen.',
          xpReward: 100,
          isSecret: true,
        ),
        const Achievement(
          key: earMaster,
          title: 'Gehör-Meister',
          description: '20 Gehörtraining-Übungen erfolgreich abgeschlossen.',
          xpReward: 100,
        ),
        const Achievement(
          key: theoryScholar,
          title: 'Theorie-Gelehrter',
          description: 'Alle Musiktheorie-Lektionen abgeschlossen.',
          xpReward: 150,
        ),
        const Achievement(
          key: moduleComplete1,
          title: 'Modul 1 Abgeschlossen',
          description: 'Das erste Lernmodul vollständig abgeschlossen.',
          xpReward: 100,
        ),
        const Achievement(
          key: moduleComplete6,
          title: 'Halbzeit!',
          description: 'Die ersten 6 Module abgeschlossen. Halbzeit!',
          xpReward: 300,
        ),
        const Achievement(
          key: moduleComplete12,
          title: 'Gitarren-Absolvent',
          description: 'Alle 12 Module abgeschlossen! Herzlichen Glückwunsch!',
          xpReward: 1000,
        ),
        const Achievement(
          key: perfectLesson,
          title: 'Perfekte Lektion',
          description: 'Eine Lektion mit 100% Genauigkeit abgeschlossen.',
          xpReward: 50,
        ),
        const Achievement(
          key: tenLessons,
          title: '10 Lektionen',
          description: '10 Lektionen erfolgreich abgeschlossen.',
          xpReward: 50,
        ),
        const Achievement(
          key: fiftyLessons,
          title: '50 Lektionen',
          description: '50 Lektionen gemeistert!',
          xpReward: 200,
        ),
        const Achievement(
          key: hundredLessons,
          title: '100 Lektionen',
          description: 'Ein wahrer Lernchampion: 100 Lektionen!',
          xpReward: 500,
        ),
        const Achievement(
          key: level5,
          title: 'Level 5!',
          description: 'Level 5 erreicht. Du machst große Fortschritte!',
          xpReward: 50,
        ),
        const Achievement(
          key: level10,
          title: 'Level 10!',
          description: 'Level 10 - Du bist kein Anfänger mehr!',
          xpReward: 100,
        ),
        const Achievement(
          key: level25,
          title: 'Level 25!',
          description: 'Level 25 - Ein erfahrener Gitarrist!',
          xpReward: 250,
        ),
        const Achievement(
          key: level50,
          title: 'Level 50!',
          description: 'Level 50 - Gitarren-Legende!',
          xpReward: 500,
        ),
        const Achievement(
          key: firstRecording,
          title: 'Erste Aufnahme',
          description: 'Dein erstes Spiel aufgenommen!',
          xpReward: 25,
        ),
        const Achievement(
          key: tenRecordings,
          title: 'Studio-Musiker',
          description: '10 Aufnahmen erstellt.',
          xpReward: 75,
        ),
        const Achievement(
          key: bluesBend,
          title: 'Blues-Seele',
          description: 'Dein erstes String Bend gemeistert.',
          xpReward: 50,
        ),
        const Achievement(
          key: powerChordPerfect,
          title: 'Power Chord Perfektionist',
          description: '5 Power Chords in Folge perfekt gespielt.',
          xpReward: 40,
        ),
        const Achievement(
          key: openChordMaster,
          title: 'Open Chord Master',
          description: 'Alle 6 grundlegenden Open Chords gelernt.',
          xpReward: 75,
        ),
        const Achievement(
          key: oneHourPractice,
          title: '1 Stunde Übung',
          description: 'Insgesamt eine Stunde geübt.',
          xpReward: 20,
        ),
        const Achievement(
          key: tenHoursPractice,
          title: '10 Stunden',
          description: '10 Stunden Gesamtübungszeit erreicht.',
          xpReward: 100,
        ),
        const Achievement(
          key: hundredHoursPractice,
          title: '100 Stunden!',
          description: '100 Stunden auf der Gitarre - du bist unaufhaltbar!',
          xpReward: 500,
        ),
        const Achievement(
          key: tunerPro,
          title: 'Tuner-Profi',
          description: 'Die Gitarre 10 Mal mit dem eingebauten Tuner gestimmt.',
          xpReward: 20,
        ),
        const Achievement(
          key: metronomeMaster,
          title: 'Metronom-Meister',
          description: '30 Minuten mit dem Metronom geübt.',
          xpReward: 50,
        ),
        const Achievement(
          key: bluetoothConnected,
          title: 'Verbunden',
          description: 'Erste Bluetooth-Verbindung hergestellt.',
          xpReward: 15,
        ),
        const Achievement(
          key: xmariConnected,
          title: 'XMARI Online',
          description: 'Die Enya XMARI Smart Guitar verbunden.',
          xpReward: 25,
        ),
        const Achievement(
          key: allPresetsUnlocked,
          title: 'Sound-Kollektor',
          description: 'Alle Gitarren-Presets freigeschaltet.',
          xpReward: 100,
        ),
        const Achievement(
          key: weekendWarrior,
          title: 'Wochenend-Krieger',
          description: '5 Wochenenden in Folge geübt.',
          xpReward: 50,
        ),
        const Achievement(
          key: lateNightJam,
          title: 'Late Night Jam',
          description: 'Nach Mitternacht gespielt. Echter Rocker!',
          xpReward: 30,
          isSecret: true,
        ),
        const Achievement(
          key: morningPractice,
          title: 'Morgen-Rocker',
          description: 'Vor 7 Uhr morgens geübt.',
          xpReward: 30,
          isSecret: true,
        ),
        const Achievement(
          key: firstFeedback,
          title: 'Feedback-Geber',
          description: 'Erstes App-Feedback gegeben.',
          xpReward: 20,
        ),
        const Achievement(
          key: secretRiff,
          title: '???',
          description: 'Ein geheimes Easter Egg entdeckt!',
          xpReward: 200,
          isSecret: true,
        ),
        const Achievement(
          key: metalGod,
          title: 'Metal Gott',
          description: 'Modul 10 mit perfekter Genauigkeit abgeschlossen.',
          xpReward: 300,
          isSecret: true,
        ),
      ];

  /// Returns an achievement by key, or null if not found
  static Achievement? findByKey(String key) {
    try {
      return allAchievements.firstWhere((a) => a.key == key);
    } catch (_) {
      return null;
    }
  }
}
