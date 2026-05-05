class AppConstants {
  AppConstants._();

  // Audio Processing
  static const int sampleRate = 44100;
  static const int bufferSize = 8192;
  static const double minPitchPrecision = 0.85;
  static const double a4ReferenceHz = 440.0;
  static const int midiA4 = 69;

  // Guitar Specs
  static const int fretCount = 22;
  static const int stringCount = 6;

  // Note Names
  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B',
  ];

  static const List<String> noteNamesFlat = [
    'C', 'Db', 'D', 'Eb', 'E', 'F',
    'Gb', 'G', 'Ab', 'A', 'Bb', 'B',
  ];

  // Standard tuning open string MIDI notes (string 0 = low E)
  static const List<int> standardTuningMidi = [40, 45, 50, 55, 59, 64];

  // Standard tuning open string frequencies
  static const List<double> standardTuningHz = [
    82.41,  // E2 - Low E (string 0)
    110.00, // A2 - A string (string 1)
    146.83, // D3 - D string (string 2)
    196.00, // G3 - G string (string 3)
    246.94, // B3 - B string (string 4)
    329.63, // E4 - High E (string 5)
  ];

  // String names
  static const List<String> stringNames = ['E', 'A', 'D', 'G', 'B', 'e'];

  // Tuner
  static const double inTuneCentsThreshold = 5.0;
  static const double almostInTuneCentsThreshold = 15.0;

  // Metronome
  static const int minBpm = 40;
  static const int maxBpm = 240;
  static const int defaultBpm = 120;

  // XP System
  static const int xpDailyLogin = 10;
  static const int xpLessonComplete = 50;
  static const int xpPerfectAccuracy = 25;
  static const int xpFirstTry = 15;
  static const int xpSongMastered = 200;
  static const int xpAchievementUnlocked = 30;
  static const int xpStreakBonus = 5;
  static const int xpStreakMilestone7 = 50;
  static const int xpStreakMilestone30 = 200;
  static const int xpStreakMilestone100 = 500;
  static const int xpModuleComplete = 150;
  static const int xpNewChordLearned = 20;
  static const int xpNewScaleLearned = 20;
  static const int xpPracticeSession = 10;
  static const int xpRecordingMade = 15;
  static const int xpEarTrainingCorrect = 8;

  // Level Formula: level = floor(sqrt(totalXp / 100))
  static const double levelXpDivisor = 100.0;

  // Accuracy Thresholds
  static const double accuracyBronze = 0.60;
  static const double accuracySilver = 0.75;
  static const double accuracyGold = 0.90;
  static const double accuracyPerfect = 0.98;
  static const double defaultTargetAccuracy = 0.75;

  // Modules
  static const int totalModules = 12;
  static const int lessonsPerModule = 5;

  // Practice Session
  static const int minSessionDurationSeconds = 60;
  static const int maxSessionDurationMinutes = 120;

  // Spaced Repetition
  static const double defaultEaseFactor = 2.5;
  static const int defaultIntervalDays = 1;
  static const double minEaseFactor = 1.3;

  // Bluetooth
  static const String xmariDeviceNamePrefix = 'Enya XMARI';
  static const String xmariServiceUuid = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';

  // Asset Paths
  static const String audioPath = 'assets/audio/';
  static const String imagesPath = 'assets/images/';
  static const String animationsPath = 'assets/animations/';
  static const String fontsPath = 'assets/fonts/';

  // App Info
  static const String appName = 'E-Gitarre Leicht';
  static const String appNameShort = 'EGL';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@enya-gitarre-leicht.de';

  // SharedPreferences Keys
  static const String prefKeyOnboardingComplete = 'onboarding_complete';
  static const String prefKeyUserId = 'user_id';
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyLastPracticeDate = 'last_practice_date';
  static const String prefKeyCurrentStreak = 'current_streak';
  static const String prefKeyTotalXp = 'total_xp';
  static const String prefKeyMetronomeBpm = 'metronome_bpm';
  static const String prefKeyMetronomeSound = 'metronome_sound';

  // Animations durations
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animExtraSlow = Duration(milliseconds: 800);
}
