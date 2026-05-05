// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTableTable extends UserProfilesTable
    with TableInfo<$UserProfilesTableTable, UserProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _totalXpMeta =
      const VerificationMeta('totalXp');
  @override
  late final GeneratedColumn<int> totalXp = GeneratedColumn<int>(
      'total_xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currentStreakMeta =
      const VerificationMeta('currentStreak');
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
      'current_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _longestStreakMeta =
      const VerificationMeta('longestStreak');
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
      'longest_streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastPracticeDateMeta =
      const VerificationMeta('lastPracticeDate');
  @override
  late final GeneratedColumn<DateTime> lastPracticeDate =
      GeneratedColumn<DateTime>('last_practice_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _totalPracticeMinutesMeta =
      const VerificationMeta('totalPracticeMinutes');
  @override
  late final GeneratedColumn<int> totalPracticeMinutes = GeneratedColumn<int>(
      'total_practice_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalLessonsCompletedMeta =
      const VerificationMeta('totalLessonsCompleted');
  @override
  late final GeneratedColumn<int> totalLessonsCompleted = GeneratedColumn<int>(
      'total_lessons_completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalModulesCompletedMeta =
      const VerificationMeta('totalModulesCompleted');
  @override
  late final GeneratedColumn<int> totalModulesCompleted = GeneratedColumn<int>(
      'total_modules_completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unlockedAchievementsJsonMeta =
      const VerificationMeta('unlockedAchievementsJson');
  @override
  late final GeneratedColumn<String> unlockedAchievementsJson =
      GeneratedColumn<String>('unlocked_achievements_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _unlockedPresetsJsonMeta =
      const VerificationMeta('unlockedPresetsJson');
  @override
  late final GeneratedColumn<String> unlockedPresetsJson =
      GeneratedColumn<String>('unlocked_presets_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _completedLessonIdsJsonMeta =
      const VerificationMeta('completedLessonIdsJson');
  @override
  late final GeneratedColumn<String> completedLessonIdsJson =
      GeneratedColumn<String>('completed_lesson_ids_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _completedModuleIdsJsonMeta =
      const VerificationMeta('completedModuleIdsJson');
  @override
  late final GeneratedColumn<String> completedModuleIdsJson =
      GeneratedColumn<String>('completed_module_ids_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
      'onboarding_complete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("onboarding_complete" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _preferredTuningMeta =
      const VerificationMeta('preferredTuning');
  @override
  late final GeneratedColumn<String> preferredTuning = GeneratedColumn<String>(
      'preferred_tuning', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('standard'));
  static const VerificationMeta _isDarkModeMeta =
      const VerificationMeta('isDarkMode');
  @override
  late final GeneratedColumn<bool> isDarkMode = GeneratedColumn<bool>(
      'is_dark_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_dark_mode" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _soundEffectsEnabledMeta =
      const VerificationMeta('soundEffectsEnabled');
  @override
  late final GeneratedColumn<bool> soundEffectsEnabled = GeneratedColumn<bool>(
      'sound_effects_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sound_effects_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _masterVolumeMeta =
      const VerificationMeta('masterVolume');
  @override
  late final GeneratedColumn<double> masterVolume = GeneratedColumn<double>(
      'master_volume', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('de'));
  static const VerificationMeta _isGuestMeta =
      const VerificationMeta('isGuest');
  @override
  late final GeneratedColumn<bool> isGuest = GeneratedColumn<bool>(
      'is_guest', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_guest" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        email,
        avatarUrl,
        totalXp,
        level,
        currentStreak,
        longestStreak,
        lastPracticeDate,
        totalPracticeMinutes,
        totalLessonsCompleted,
        totalModulesCompleted,
        unlockedAchievementsJson,
        unlockedPresetsJson,
        completedLessonIdsJson,
        completedModuleIdsJson,
        onboardingComplete,
        preferredTuning,
        isDarkMode,
        notificationsEnabled,
        soundEffectsEnabled,
        masterVolume,
        language,
        isGuest,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserProfilesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('total_xp')) {
      context.handle(_totalXpMeta,
          totalXp.isAcceptableOrUnknown(data['total_xp']!, _totalXpMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('current_streak')) {
      context.handle(
          _currentStreakMeta,
          currentStreak.isAcceptableOrUnknown(
              data['current_streak']!, _currentStreakMeta));
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
          _longestStreakMeta,
          longestStreak.isAcceptableOrUnknown(
              data['longest_streak']!, _longestStreakMeta));
    }
    if (data.containsKey('last_practice_date')) {
      context.handle(
          _lastPracticeDateMeta,
          lastPracticeDate.isAcceptableOrUnknown(
              data['last_practice_date']!, _lastPracticeDateMeta));
    }
    if (data.containsKey('total_practice_minutes')) {
      context.handle(
          _totalPracticeMinutesMeta,
          totalPracticeMinutes.isAcceptableOrUnknown(
              data['total_practice_minutes']!, _totalPracticeMinutesMeta));
    }
    if (data.containsKey('total_lessons_completed')) {
      context.handle(
          _totalLessonsCompletedMeta,
          totalLessonsCompleted.isAcceptableOrUnknown(
              data['total_lessons_completed']!, _totalLessonsCompletedMeta));
    }
    if (data.containsKey('total_modules_completed')) {
      context.handle(
          _totalModulesCompletedMeta,
          totalModulesCompleted.isAcceptableOrUnknown(
              data['total_modules_completed']!, _totalModulesCompletedMeta));
    }
    if (data.containsKey('unlocked_achievements_json')) {
      context.handle(
          _unlockedAchievementsJsonMeta,
          unlockedAchievementsJson.isAcceptableOrUnknown(
              data['unlocked_achievements_json']!,
              _unlockedAchievementsJsonMeta));
    }
    if (data.containsKey('unlocked_presets_json')) {
      context.handle(
          _unlockedPresetsJsonMeta,
          unlockedPresetsJson.isAcceptableOrUnknown(
              data['unlocked_presets_json']!, _unlockedPresetsJsonMeta));
    }
    if (data.containsKey('completed_lesson_ids_json')) {
      context.handle(
          _completedLessonIdsJsonMeta,
          completedLessonIdsJson.isAcceptableOrUnknown(
              data['completed_lesson_ids_json']!, _completedLessonIdsJsonMeta));
    }
    if (data.containsKey('completed_module_ids_json')) {
      context.handle(
          _completedModuleIdsJsonMeta,
          completedModuleIdsJson.isAcceptableOrUnknown(
              data['completed_module_ids_json']!, _completedModuleIdsJsonMeta));
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
          _onboardingCompleteMeta,
          onboardingComplete.isAcceptableOrUnknown(
              data['onboarding_complete']!, _onboardingCompleteMeta));
    }
    if (data.containsKey('preferred_tuning')) {
      context.handle(
          _preferredTuningMeta,
          preferredTuning.isAcceptableOrUnknown(
              data['preferred_tuning']!, _preferredTuningMeta));
    }
    if (data.containsKey('is_dark_mode')) {
      context.handle(
          _isDarkModeMeta,
          isDarkMode.isAcceptableOrUnknown(
              data['is_dark_mode']!, _isDarkModeMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    if (data.containsKey('sound_effects_enabled')) {
      context.handle(
          _soundEffectsEnabledMeta,
          soundEffectsEnabled.isAcceptableOrUnknown(
              data['sound_effects_enabled']!, _soundEffectsEnabledMeta));
    }
    if (data.containsKey('master_volume')) {
      context.handle(
          _masterVolumeMeta,
          masterVolume.isAcceptableOrUnknown(
              data['master_volume']!, _masterVolumeMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('is_guest')) {
      context.handle(_isGuestMeta,
          isGuest.isAcceptableOrUnknown(data['is_guest']!, _isGuestMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfilesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url'])!,
      totalXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_xp'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      currentStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_streak'])!,
      longestStreak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}longest_streak'])!,
      lastPracticeDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_practice_date']),
      totalPracticeMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_practice_minutes'])!,
      totalLessonsCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_lessons_completed'])!,
      totalModulesCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_modules_completed'])!,
      unlockedAchievementsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unlocked_achievements_json'])!,
      unlockedPresetsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unlocked_presets_json'])!,
      completedLessonIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}completed_lesson_ids_json'])!,
      completedModuleIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}completed_module_ids_json'])!,
      onboardingComplete: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}onboarding_complete'])!,
      preferredTuning: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}preferred_tuning'])!,
      isDarkMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dark_mode'])!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
      soundEffectsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}sound_effects_enabled'])!,
      masterVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}master_volume'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      isGuest: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_guest'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $UserProfilesTableTable createAlias(String alias) {
    return $UserProfilesTableTable(attachedDatabase, alias);
  }
}

class UserProfilesTableData extends DataClass
    implements Insertable<UserProfilesTableData> {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;
  final int totalXp;
  final int level;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastPracticeDate;
  final int totalPracticeMinutes;
  final int totalLessonsCompleted;
  final int totalModulesCompleted;
  final String unlockedAchievementsJson;
  final String unlockedPresetsJson;
  final String completedLessonIdsJson;
  final String completedModuleIdsJson;
  final bool onboardingComplete;
  final String preferredTuning;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool soundEffectsEnabled;
  final double masterVolume;
  final String language;
  final bool isGuest;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const UserProfilesTableData(
      {required this.id,
      required this.username,
      required this.email,
      required this.avatarUrl,
      required this.totalXp,
      required this.level,
      required this.currentStreak,
      required this.longestStreak,
      this.lastPracticeDate,
      required this.totalPracticeMinutes,
      required this.totalLessonsCompleted,
      required this.totalModulesCompleted,
      required this.unlockedAchievementsJson,
      required this.unlockedPresetsJson,
      required this.completedLessonIdsJson,
      required this.completedModuleIdsJson,
      required this.onboardingComplete,
      required this.preferredTuning,
      required this.isDarkMode,
      required this.notificationsEnabled,
      required this.soundEffectsEnabled,
      required this.masterVolume,
      required this.language,
      required this.isGuest,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['email'] = Variable<String>(email);
    map['avatar_url'] = Variable<String>(avatarUrl);
    map['total_xp'] = Variable<int>(totalXp);
    map['level'] = Variable<int>(level);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastPracticeDate != null) {
      map['last_practice_date'] = Variable<DateTime>(lastPracticeDate);
    }
    map['total_practice_minutes'] = Variable<int>(totalPracticeMinutes);
    map['total_lessons_completed'] = Variable<int>(totalLessonsCompleted);
    map['total_modules_completed'] = Variable<int>(totalModulesCompleted);
    map['unlocked_achievements_json'] =
        Variable<String>(unlockedAchievementsJson);
    map['unlocked_presets_json'] = Variable<String>(unlockedPresetsJson);
    map['completed_lesson_ids_json'] = Variable<String>(completedLessonIdsJson);
    map['completed_module_ids_json'] = Variable<String>(completedModuleIdsJson);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['preferred_tuning'] = Variable<String>(preferredTuning);
    map['is_dark_mode'] = Variable<bool>(isDarkMode);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['sound_effects_enabled'] = Variable<bool>(soundEffectsEnabled);
    map['master_volume'] = Variable<double>(masterVolume);
    map['language'] = Variable<String>(language);
    map['is_guest'] = Variable<bool>(isGuest);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesTableCompanion(
      id: Value(id),
      username: Value(username),
      email: Value(email),
      avatarUrl: Value(avatarUrl),
      totalXp: Value(totalXp),
      level: Value(level),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastPracticeDate: lastPracticeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPracticeDate),
      totalPracticeMinutes: Value(totalPracticeMinutes),
      totalLessonsCompleted: Value(totalLessonsCompleted),
      totalModulesCompleted: Value(totalModulesCompleted),
      unlockedAchievementsJson: Value(unlockedAchievementsJson),
      unlockedPresetsJson: Value(unlockedPresetsJson),
      completedLessonIdsJson: Value(completedLessonIdsJson),
      completedModuleIdsJson: Value(completedModuleIdsJson),
      onboardingComplete: Value(onboardingComplete),
      preferredTuning: Value(preferredTuning),
      isDarkMode: Value(isDarkMode),
      notificationsEnabled: Value(notificationsEnabled),
      soundEffectsEnabled: Value(soundEffectsEnabled),
      masterVolume: Value(masterVolume),
      language: Value(language),
      isGuest: Value(isGuest),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserProfilesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfilesTableData(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      email: serializer.fromJson<String>(json['email']),
      avatarUrl: serializer.fromJson<String>(json['avatarUrl']),
      totalXp: serializer.fromJson<int>(json['totalXp']),
      level: serializer.fromJson<int>(json['level']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastPracticeDate:
          serializer.fromJson<DateTime?>(json['lastPracticeDate']),
      totalPracticeMinutes:
          serializer.fromJson<int>(json['totalPracticeMinutes']),
      totalLessonsCompleted:
          serializer.fromJson<int>(json['totalLessonsCompleted']),
      totalModulesCompleted:
          serializer.fromJson<int>(json['totalModulesCompleted']),
      unlockedAchievementsJson:
          serializer.fromJson<String>(json['unlockedAchievementsJson']),
      unlockedPresetsJson:
          serializer.fromJson<String>(json['unlockedPresetsJson']),
      completedLessonIdsJson:
          serializer.fromJson<String>(json['completedLessonIdsJson']),
      completedModuleIdsJson:
          serializer.fromJson<String>(json['completedModuleIdsJson']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      preferredTuning: serializer.fromJson<String>(json['preferredTuning']),
      isDarkMode: serializer.fromJson<bool>(json['isDarkMode']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
      soundEffectsEnabled:
          serializer.fromJson<bool>(json['soundEffectsEnabled']),
      masterVolume: serializer.fromJson<double>(json['masterVolume']),
      language: serializer.fromJson<String>(json['language']),
      isGuest: serializer.fromJson<bool>(json['isGuest']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'email': serializer.toJson<String>(email),
      'avatarUrl': serializer.toJson<String>(avatarUrl),
      'totalXp': serializer.toJson<int>(totalXp),
      'level': serializer.toJson<int>(level),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastPracticeDate': serializer.toJson<DateTime?>(lastPracticeDate),
      'totalPracticeMinutes': serializer.toJson<int>(totalPracticeMinutes),
      'totalLessonsCompleted': serializer.toJson<int>(totalLessonsCompleted),
      'totalModulesCompleted': serializer.toJson<int>(totalModulesCompleted),
      'unlockedAchievementsJson':
          serializer.toJson<String>(unlockedAchievementsJson),
      'unlockedPresetsJson': serializer.toJson<String>(unlockedPresetsJson),
      'completedLessonIdsJson':
          serializer.toJson<String>(completedLessonIdsJson),
      'completedModuleIdsJson':
          serializer.toJson<String>(completedModuleIdsJson),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'preferredTuning': serializer.toJson<String>(preferredTuning),
      'isDarkMode': serializer.toJson<bool>(isDarkMode),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'soundEffectsEnabled': serializer.toJson<bool>(soundEffectsEnabled),
      'masterVolume': serializer.toJson<double>(masterVolume),
      'language': serializer.toJson<String>(language),
      'isGuest': serializer.toJson<bool>(isGuest),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserProfilesTableData copyWith(
          {String? id,
          String? username,
          String? email,
          String? avatarUrl,
          int? totalXp,
          int? level,
          int? currentStreak,
          int? longestStreak,
          Value<DateTime?> lastPracticeDate = const Value.absent(),
          int? totalPracticeMinutes,
          int? totalLessonsCompleted,
          int? totalModulesCompleted,
          String? unlockedAchievementsJson,
          String? unlockedPresetsJson,
          String? completedLessonIdsJson,
          String? completedModuleIdsJson,
          bool? onboardingComplete,
          String? preferredTuning,
          bool? isDarkMode,
          bool? notificationsEnabled,
          bool? soundEffectsEnabled,
          double? masterVolume,
          String? language,
          bool? isGuest,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      UserProfilesTableData(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        totalXp: totalXp ?? this.totalXp,
        level: level ?? this.level,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastPracticeDate: lastPracticeDate.present
            ? lastPracticeDate.value
            : this.lastPracticeDate,
        totalPracticeMinutes: totalPracticeMinutes ?? this.totalPracticeMinutes,
        totalLessonsCompleted:
            totalLessonsCompleted ?? this.totalLessonsCompleted,
        totalModulesCompleted:
            totalModulesCompleted ?? this.totalModulesCompleted,
        unlockedAchievementsJson:
            unlockedAchievementsJson ?? this.unlockedAchievementsJson,
        unlockedPresetsJson: unlockedPresetsJson ?? this.unlockedPresetsJson,
        completedLessonIdsJson:
            completedLessonIdsJson ?? this.completedLessonIdsJson,
        completedModuleIdsJson:
            completedModuleIdsJson ?? this.completedModuleIdsJson,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
        preferredTuning: preferredTuning ?? this.preferredTuning,
        isDarkMode: isDarkMode ?? this.isDarkMode,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
        masterVolume: masterVolume ?? this.masterVolume,
        language: language ?? this.language,
        isGuest: isGuest ?? this.isGuest,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  UserProfilesTableData copyWithCompanion(UserProfilesTableCompanion data) {
    return UserProfilesTableData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      totalXp: data.totalXp.present ? data.totalXp.value : this.totalXp,
      level: data.level.present ? data.level.value : this.level,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastPracticeDate: data.lastPracticeDate.present
          ? data.lastPracticeDate.value
          : this.lastPracticeDate,
      totalPracticeMinutes: data.totalPracticeMinutes.present
          ? data.totalPracticeMinutes.value
          : this.totalPracticeMinutes,
      totalLessonsCompleted: data.totalLessonsCompleted.present
          ? data.totalLessonsCompleted.value
          : this.totalLessonsCompleted,
      totalModulesCompleted: data.totalModulesCompleted.present
          ? data.totalModulesCompleted.value
          : this.totalModulesCompleted,
      unlockedAchievementsJson: data.unlockedAchievementsJson.present
          ? data.unlockedAchievementsJson.value
          : this.unlockedAchievementsJson,
      unlockedPresetsJson: data.unlockedPresetsJson.present
          ? data.unlockedPresetsJson.value
          : this.unlockedPresetsJson,
      completedLessonIdsJson: data.completedLessonIdsJson.present
          ? data.completedLessonIdsJson.value
          : this.completedLessonIdsJson,
      completedModuleIdsJson: data.completedModuleIdsJson.present
          ? data.completedModuleIdsJson.value
          : this.completedModuleIdsJson,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      preferredTuning: data.preferredTuning.present
          ? data.preferredTuning.value
          : this.preferredTuning,
      isDarkMode:
          data.isDarkMode.present ? data.isDarkMode.value : this.isDarkMode,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      soundEffectsEnabled: data.soundEffectsEnabled.present
          ? data.soundEffectsEnabled.value
          : this.soundEffectsEnabled,
      masterVolume: data.masterVolume.present
          ? data.masterVolume.value
          : this.masterVolume,
      language: data.language.present ? data.language.value : this.language,
      isGuest: data.isGuest.present ? data.isGuest.value : this.isGuest,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastPracticeDate: $lastPracticeDate, ')
          ..write('totalPracticeMinutes: $totalPracticeMinutes, ')
          ..write('totalLessonsCompleted: $totalLessonsCompleted, ')
          ..write('totalModulesCompleted: $totalModulesCompleted, ')
          ..write('unlockedAchievementsJson: $unlockedAchievementsJson, ')
          ..write('unlockedPresetsJson: $unlockedPresetsJson, ')
          ..write('completedLessonIdsJson: $completedLessonIdsJson, ')
          ..write('completedModuleIdsJson: $completedModuleIdsJson, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('preferredTuning: $preferredTuning, ')
          ..write('isDarkMode: $isDarkMode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('soundEffectsEnabled: $soundEffectsEnabled, ')
          ..write('masterVolume: $masterVolume, ')
          ..write('language: $language, ')
          ..write('isGuest: $isGuest, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        username,
        email,
        avatarUrl,
        totalXp,
        level,
        currentStreak,
        longestStreak,
        lastPracticeDate,
        totalPracticeMinutes,
        totalLessonsCompleted,
        totalModulesCompleted,
        unlockedAchievementsJson,
        unlockedPresetsJson,
        completedLessonIdsJson,
        completedModuleIdsJson,
        onboardingComplete,
        preferredTuning,
        isDarkMode,
        notificationsEnabled,
        soundEffectsEnabled,
        masterVolume,
        language,
        isGuest,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfilesTableData &&
          other.id == this.id &&
          other.username == this.username &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl &&
          other.totalXp == this.totalXp &&
          other.level == this.level &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastPracticeDate == this.lastPracticeDate &&
          other.totalPracticeMinutes == this.totalPracticeMinutes &&
          other.totalLessonsCompleted == this.totalLessonsCompleted &&
          other.totalModulesCompleted == this.totalModulesCompleted &&
          other.unlockedAchievementsJson == this.unlockedAchievementsJson &&
          other.unlockedPresetsJson == this.unlockedPresetsJson &&
          other.completedLessonIdsJson == this.completedLessonIdsJson &&
          other.completedModuleIdsJson == this.completedModuleIdsJson &&
          other.onboardingComplete == this.onboardingComplete &&
          other.preferredTuning == this.preferredTuning &&
          other.isDarkMode == this.isDarkMode &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.soundEffectsEnabled == this.soundEffectsEnabled &&
          other.masterVolume == this.masterVolume &&
          other.language == this.language &&
          other.isGuest == this.isGuest &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesTableCompanion
    extends UpdateCompanion<UserProfilesTableData> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> email;
  final Value<String> avatarUrl;
  final Value<int> totalXp;
  final Value<int> level;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime?> lastPracticeDate;
  final Value<int> totalPracticeMinutes;
  final Value<int> totalLessonsCompleted;
  final Value<int> totalModulesCompleted;
  final Value<String> unlockedAchievementsJson;
  final Value<String> unlockedPresetsJson;
  final Value<String> completedLessonIdsJson;
  final Value<String> completedModuleIdsJson;
  final Value<bool> onboardingComplete;
  final Value<String> preferredTuning;
  final Value<bool> isDarkMode;
  final Value<bool> notificationsEnabled;
  final Value<bool> soundEffectsEnabled;
  final Value<double> masterVolume;
  final Value<String> language;
  final Value<bool> isGuest;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UserProfilesTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.level = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastPracticeDate = const Value.absent(),
    this.totalPracticeMinutes = const Value.absent(),
    this.totalLessonsCompleted = const Value.absent(),
    this.totalModulesCompleted = const Value.absent(),
    this.unlockedAchievementsJson = const Value.absent(),
    this.unlockedPresetsJson = const Value.absent(),
    this.completedLessonIdsJson = const Value.absent(),
    this.completedModuleIdsJson = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.preferredTuning = const Value.absent(),
    this.isDarkMode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.soundEffectsEnabled = const Value.absent(),
    this.masterVolume = const Value.absent(),
    this.language = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesTableCompanion.insert({
    required String id,
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.totalXp = const Value.absent(),
    this.level = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastPracticeDate = const Value.absent(),
    this.totalPracticeMinutes = const Value.absent(),
    this.totalLessonsCompleted = const Value.absent(),
    this.totalModulesCompleted = const Value.absent(),
    this.unlockedAchievementsJson = const Value.absent(),
    this.unlockedPresetsJson = const Value.absent(),
    this.completedLessonIdsJson = const Value.absent(),
    this.completedModuleIdsJson = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.preferredTuning = const Value.absent(),
    this.isDarkMode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.soundEffectsEnabled = const Value.absent(),
    this.masterVolume = const Value.absent(),
    this.language = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UserProfilesTableData> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? email,
    Expression<String>? avatarUrl,
    Expression<int>? totalXp,
    Expression<int>? level,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastPracticeDate,
    Expression<int>? totalPracticeMinutes,
    Expression<int>? totalLessonsCompleted,
    Expression<int>? totalModulesCompleted,
    Expression<String>? unlockedAchievementsJson,
    Expression<String>? unlockedPresetsJson,
    Expression<String>? completedLessonIdsJson,
    Expression<String>? completedModuleIdsJson,
    Expression<bool>? onboardingComplete,
    Expression<String>? preferredTuning,
    Expression<bool>? isDarkMode,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? soundEffectsEnabled,
    Expression<double>? masterVolume,
    Expression<String>? language,
    Expression<bool>? isGuest,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (totalXp != null) 'total_xp': totalXp,
      if (level != null) 'level': level,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastPracticeDate != null) 'last_practice_date': lastPracticeDate,
      if (totalPracticeMinutes != null)
        'total_practice_minutes': totalPracticeMinutes,
      if (totalLessonsCompleted != null)
        'total_lessons_completed': totalLessonsCompleted,
      if (totalModulesCompleted != null)
        'total_modules_completed': totalModulesCompleted,
      if (unlockedAchievementsJson != null)
        'unlocked_achievements_json': unlockedAchievementsJson,
      if (unlockedPresetsJson != null)
        'unlocked_presets_json': unlockedPresetsJson,
      if (completedLessonIdsJson != null)
        'completed_lesson_ids_json': completedLessonIdsJson,
      if (completedModuleIdsJson != null)
        'completed_module_ids_json': completedModuleIdsJson,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (preferredTuning != null) 'preferred_tuning': preferredTuning,
      if (isDarkMode != null) 'is_dark_mode': isDarkMode,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (soundEffectsEnabled != null)
        'sound_effects_enabled': soundEffectsEnabled,
      if (masterVolume != null) 'master_volume': masterVolume,
      if (language != null) 'language': language,
      if (isGuest != null) 'is_guest': isGuest,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? email,
      Value<String>? avatarUrl,
      Value<int>? totalXp,
      Value<int>? level,
      Value<int>? currentStreak,
      Value<int>? longestStreak,
      Value<DateTime?>? lastPracticeDate,
      Value<int>? totalPracticeMinutes,
      Value<int>? totalLessonsCompleted,
      Value<int>? totalModulesCompleted,
      Value<String>? unlockedAchievementsJson,
      Value<String>? unlockedPresetsJson,
      Value<String>? completedLessonIdsJson,
      Value<String>? completedModuleIdsJson,
      Value<bool>? onboardingComplete,
      Value<String>? preferredTuning,
      Value<bool>? isDarkMode,
      Value<bool>? notificationsEnabled,
      Value<bool>? soundEffectsEnabled,
      Value<double>? masterVolume,
      Value<String>? language,
      Value<bool>? isGuest,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return UserProfilesTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      totalPracticeMinutes: totalPracticeMinutes ?? this.totalPracticeMinutes,
      totalLessonsCompleted:
          totalLessonsCompleted ?? this.totalLessonsCompleted,
      totalModulesCompleted:
          totalModulesCompleted ?? this.totalModulesCompleted,
      unlockedAchievementsJson:
          unlockedAchievementsJson ?? this.unlockedAchievementsJson,
      unlockedPresetsJson: unlockedPresetsJson ?? this.unlockedPresetsJson,
      completedLessonIdsJson:
          completedLessonIdsJson ?? this.completedLessonIdsJson,
      completedModuleIdsJson:
          completedModuleIdsJson ?? this.completedModuleIdsJson,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      preferredTuning: preferredTuning ?? this.preferredTuning,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      masterVolume: masterVolume ?? this.masterVolume,
      language: language ?? this.language,
      isGuest: isGuest ?? this.isGuest,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (totalXp.present) {
      map['total_xp'] = Variable<int>(totalXp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastPracticeDate.present) {
      map['last_practice_date'] = Variable<DateTime>(lastPracticeDate.value);
    }
    if (totalPracticeMinutes.present) {
      map['total_practice_minutes'] = Variable<int>(totalPracticeMinutes.value);
    }
    if (totalLessonsCompleted.present) {
      map['total_lessons_completed'] =
          Variable<int>(totalLessonsCompleted.value);
    }
    if (totalModulesCompleted.present) {
      map['total_modules_completed'] =
          Variable<int>(totalModulesCompleted.value);
    }
    if (unlockedAchievementsJson.present) {
      map['unlocked_achievements_json'] =
          Variable<String>(unlockedAchievementsJson.value);
    }
    if (unlockedPresetsJson.present) {
      map['unlocked_presets_json'] =
          Variable<String>(unlockedPresetsJson.value);
    }
    if (completedLessonIdsJson.present) {
      map['completed_lesson_ids_json'] =
          Variable<String>(completedLessonIdsJson.value);
    }
    if (completedModuleIdsJson.present) {
      map['completed_module_ids_json'] =
          Variable<String>(completedModuleIdsJson.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (preferredTuning.present) {
      map['preferred_tuning'] = Variable<String>(preferredTuning.value);
    }
    if (isDarkMode.present) {
      map['is_dark_mode'] = Variable<bool>(isDarkMode.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (soundEffectsEnabled.present) {
      map['sound_effects_enabled'] = Variable<bool>(soundEffectsEnabled.value);
    }
    if (masterVolume.present) {
      map['master_volume'] = Variable<double>(masterVolume.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (isGuest.present) {
      map['is_guest'] = Variable<bool>(isGuest.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('totalXp: $totalXp, ')
          ..write('level: $level, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastPracticeDate: $lastPracticeDate, ')
          ..write('totalPracticeMinutes: $totalPracticeMinutes, ')
          ..write('totalLessonsCompleted: $totalLessonsCompleted, ')
          ..write('totalModulesCompleted: $totalModulesCompleted, ')
          ..write('unlockedAchievementsJson: $unlockedAchievementsJson, ')
          ..write('unlockedPresetsJson: $unlockedPresetsJson, ')
          ..write('completedLessonIdsJson: $completedLessonIdsJson, ')
          ..write('completedModuleIdsJson: $completedModuleIdsJson, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('preferredTuning: $preferredTuning, ')
          ..write('isDarkMode: $isDarkMode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('soundEffectsEnabled: $soundEffectsEnabled, ')
          ..write('masterVolume: $masterVolume, ')
          ..write('language: $language, ')
          ..write('isGuest: $isGuest, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ModuleProgressTableTable extends ModuleProgressTable
    with TableInfo<$ModuleProgressTableTable, ModuleProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModuleProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _moduleIdMeta =
      const VerificationMeta('moduleId');
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
      'module_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isUnlockedMeta =
      const VerificationMeta('isUnlocked');
  @override
  late final GeneratedColumn<bool> isUnlocked = GeneratedColumn<bool>(
      'is_unlocked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_unlocked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completionPercentageMeta =
      const VerificationMeta('completionPercentage');
  @override
  late final GeneratedColumn<double> completionPercentage =
      GeneratedColumn<double>('completion_percentage', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _xpEarnedMeta =
      const VerificationMeta('xpEarned');
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
      'xp_earned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastAccessedAtMeta =
      const VerificationMeta('lastAccessedAt');
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>('last_accessed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        moduleId,
        userId,
        isUnlocked,
        isCompleted,
        completionPercentage,
        xpEarned,
        startedAt,
        completedAt,
        lastAccessedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'module_progress_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ModuleProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('module_id')) {
      context.handle(_moduleIdMeta,
          moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta));
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_unlocked')) {
      context.handle(
          _isUnlockedMeta,
          isUnlocked.isAcceptableOrUnknown(
              data['is_unlocked']!, _isUnlockedMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('completion_percentage')) {
      context.handle(
          _completionPercentageMeta,
          completionPercentage.isAcceptableOrUnknown(
              data['completion_percentage']!, _completionPercentageMeta));
    }
    if (data.containsKey('xp_earned')) {
      context.handle(_xpEarnedMeta,
          xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
          _lastAccessedAtMeta,
          lastAccessedAt.isAcceptableOrUnknown(
              data['last_accessed_at']!, _lastAccessedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {moduleId, userId};
  @override
  ModuleProgressTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModuleProgressTableData(
      moduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      isUnlocked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_unlocked'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      completionPercentage: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}completion_percentage'])!,
      xpEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_earned'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      lastAccessedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_accessed_at']),
    );
  }

  @override
  $ModuleProgressTableTable createAlias(String alias) {
    return $ModuleProgressTableTable(attachedDatabase, alias);
  }
}

class ModuleProgressTableData extends DataClass
    implements Insertable<ModuleProgressTableData> {
  final String moduleId;
  final String userId;
  final bool isUnlocked;
  final bool isCompleted;
  final double completionPercentage;
  final int xpEarned;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? lastAccessedAt;
  const ModuleProgressTableData(
      {required this.moduleId,
      required this.userId,
      required this.isUnlocked,
      required this.isCompleted,
      required this.completionPercentage,
      required this.xpEarned,
      this.startedAt,
      this.completedAt,
      this.lastAccessedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['module_id'] = Variable<String>(moduleId);
    map['user_id'] = Variable<String>(userId);
    map['is_unlocked'] = Variable<bool>(isUnlocked);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['completion_percentage'] = Variable<double>(completionPercentage);
    map['xp_earned'] = Variable<int>(xpEarned);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || lastAccessedAt != null) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt);
    }
    return map;
  }

  ModuleProgressTableCompanion toCompanion(bool nullToAbsent) {
    return ModuleProgressTableCompanion(
      moduleId: Value(moduleId),
      userId: Value(userId),
      isUnlocked: Value(isUnlocked),
      isCompleted: Value(isCompleted),
      completionPercentage: Value(completionPercentage),
      xpEarned: Value(xpEarned),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      lastAccessedAt: lastAccessedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAccessedAt),
    );
  }

  factory ModuleProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModuleProgressTableData(
      moduleId: serializer.fromJson<String>(json['moduleId']),
      userId: serializer.fromJson<String>(json['userId']),
      isUnlocked: serializer.fromJson<bool>(json['isUnlocked']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completionPercentage:
          serializer.fromJson<double>(json['completionPercentage']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      lastAccessedAt: serializer.fromJson<DateTime?>(json['lastAccessedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'moduleId': serializer.toJson<String>(moduleId),
      'userId': serializer.toJson<String>(userId),
      'isUnlocked': serializer.toJson<bool>(isUnlocked),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completionPercentage': serializer.toJson<double>(completionPercentage),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'lastAccessedAt': serializer.toJson<DateTime?>(lastAccessedAt),
    };
  }

  ModuleProgressTableData copyWith(
          {String? moduleId,
          String? userId,
          bool? isUnlocked,
          bool? isCompleted,
          double? completionPercentage,
          int? xpEarned,
          Value<DateTime?> startedAt = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          Value<DateTime?> lastAccessedAt = const Value.absent()}) =>
      ModuleProgressTableData(
        moduleId: moduleId ?? this.moduleId,
        userId: userId ?? this.userId,
        isUnlocked: isUnlocked ?? this.isUnlocked,
        isCompleted: isCompleted ?? this.isCompleted,
        completionPercentage: completionPercentage ?? this.completionPercentage,
        xpEarned: xpEarned ?? this.xpEarned,
        startedAt: startedAt.present ? startedAt.value : this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        lastAccessedAt:
            lastAccessedAt.present ? lastAccessedAt.value : this.lastAccessedAt,
      );
  ModuleProgressTableData copyWithCompanion(ModuleProgressTableCompanion data) {
    return ModuleProgressTableData(
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      userId: data.userId.present ? data.userId.value : this.userId,
      isUnlocked:
          data.isUnlocked.present ? data.isUnlocked.value : this.isUnlocked,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      completionPercentage: data.completionPercentage.present
          ? data.completionPercentage.value
          : this.completionPercentage,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModuleProgressTableData(')
          ..write('moduleId: $moduleId, ')
          ..write('userId: $userId, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastAccessedAt: $lastAccessedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(moduleId, userId, isUnlocked, isCompleted,
      completionPercentage, xpEarned, startedAt, completedAt, lastAccessedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModuleProgressTableData &&
          other.moduleId == this.moduleId &&
          other.userId == this.userId &&
          other.isUnlocked == this.isUnlocked &&
          other.isCompleted == this.isCompleted &&
          other.completionPercentage == this.completionPercentage &&
          other.xpEarned == this.xpEarned &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.lastAccessedAt == this.lastAccessedAt);
}

class ModuleProgressTableCompanion
    extends UpdateCompanion<ModuleProgressTableData> {
  final Value<String> moduleId;
  final Value<String> userId;
  final Value<bool> isUnlocked;
  final Value<bool> isCompleted;
  final Value<double> completionPercentage;
  final Value<int> xpEarned;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> lastAccessedAt;
  final Value<int> rowid;
  const ModuleProgressTableCompanion({
    this.moduleId = const Value.absent(),
    this.userId = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ModuleProgressTableCompanion.insert({
    required String moduleId,
    required String userId,
    this.isUnlocked = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completionPercentage = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : moduleId = Value(moduleId),
        userId = Value(userId);
  static Insertable<ModuleProgressTableData> custom({
    Expression<String>? moduleId,
    Expression<String>? userId,
    Expression<bool>? isUnlocked,
    Expression<bool>? isCompleted,
    Expression<double>? completionPercentage,
    Expression<int>? xpEarned,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? lastAccessedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (moduleId != null) 'module_id': moduleId,
      if (userId != null) 'user_id': userId,
      if (isUnlocked != null) 'is_unlocked': isUnlocked,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completionPercentage != null)
        'completion_percentage': completionPercentage,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ModuleProgressTableCompanion copyWith(
      {Value<String>? moduleId,
      Value<String>? userId,
      Value<bool>? isUnlocked,
      Value<bool>? isCompleted,
      Value<double>? completionPercentage,
      Value<int>? xpEarned,
      Value<DateTime?>? startedAt,
      Value<DateTime?>? completedAt,
      Value<DateTime?>? lastAccessedAt,
      Value<int>? rowid}) {
    return ModuleProgressTableCompanion(
      moduleId: moduleId ?? this.moduleId,
      userId: userId ?? this.userId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      xpEarned: xpEarned ?? this.xpEarned,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (isUnlocked.present) {
      map['is_unlocked'] = Variable<bool>(isUnlocked.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completionPercentage.present) {
      map['completion_percentage'] =
          Variable<double>(completionPercentage.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModuleProgressTableCompanion(')
          ..write('moduleId: $moduleId, ')
          ..write('userId: $userId, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completionPercentage: $completionPercentage, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTableTable extends LessonProgressTable
    with TableInfo<$LessonProgressTableTable, LessonProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moduleIdMeta =
      const VerificationMeta('moduleId');
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
      'module_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bestAccuracyMeta =
      const VerificationMeta('bestAccuracy');
  @override
  late final GeneratedColumn<double> bestAccuracy = GeneratedColumn<double>(
      'best_accuracy', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
      'stars', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _xpEarnedMeta =
      const VerificationMeta('xpEarned');
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
      'xp_earned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        lessonId,
        userId,
        moduleId,
        isCompleted,
        bestAccuracy,
        stars,
        attempts,
        xpEarned,
        completedAt,
        lastAttemptAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LessonProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(_moduleIdMeta,
          moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta));
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('best_accuracy')) {
      context.handle(
          _bestAccuracyMeta,
          bestAccuracy.isAcceptableOrUnknown(
              data['best_accuracy']!, _bestAccuracyMeta));
    }
    if (data.containsKey('stars')) {
      context.handle(
          _starsMeta, stars.isAcceptableOrUnknown(data['stars']!, _starsMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('xp_earned')) {
      context.handle(_xpEarnedMeta,
          xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lessonId, userId};
  @override
  LessonProgressTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressTableData(
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      moduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_id'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      bestAccuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}best_accuracy'])!,
      stars: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stars'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      xpEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_earned'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
    );
  }

  @override
  $LessonProgressTableTable createAlias(String alias) {
    return $LessonProgressTableTable(attachedDatabase, alias);
  }
}

class LessonProgressTableData extends DataClass
    implements Insertable<LessonProgressTableData> {
  final String lessonId;
  final String userId;
  final String moduleId;
  final bool isCompleted;
  final double bestAccuracy;
  final int stars;
  final int attempts;
  final int xpEarned;
  final DateTime? completedAt;
  final DateTime? lastAttemptAt;
  const LessonProgressTableData(
      {required this.lessonId,
      required this.userId,
      required this.moduleId,
      required this.isCompleted,
      required this.bestAccuracy,
      required this.stars,
      required this.attempts,
      required this.xpEarned,
      this.completedAt,
      this.lastAttemptAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    map['user_id'] = Variable<String>(userId);
    map['module_id'] = Variable<String>(moduleId);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['best_accuracy'] = Variable<double>(bestAccuracy);
    map['stars'] = Variable<int>(stars);
    map['attempts'] = Variable<int>(attempts);
    map['xp_earned'] = Variable<int>(xpEarned);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  LessonProgressTableCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressTableCompanion(
      lessonId: Value(lessonId),
      userId: Value(userId),
      moduleId: Value(moduleId),
      isCompleted: Value(isCompleted),
      bestAccuracy: Value(bestAccuracy),
      stars: Value(stars),
      attempts: Value(attempts),
      xpEarned: Value(xpEarned),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory LessonProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressTableData(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      userId: serializer.fromJson<String>(json['userId']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      bestAccuracy: serializer.fromJson<double>(json['bestAccuracy']),
      stars: serializer.fromJson<int>(json['stars']),
      attempts: serializer.fromJson<int>(json['attempts']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'userId': serializer.toJson<String>(userId),
      'moduleId': serializer.toJson<String>(moduleId),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'bestAccuracy': serializer.toJson<double>(bestAccuracy),
      'stars': serializer.toJson<int>(stars),
      'attempts': serializer.toJson<int>(attempts),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  LessonProgressTableData copyWith(
          {String? lessonId,
          String? userId,
          String? moduleId,
          bool? isCompleted,
          double? bestAccuracy,
          int? stars,
          int? attempts,
          int? xpEarned,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<DateTime?> lastAttemptAt = const Value.absent()}) =>
      LessonProgressTableData(
        lessonId: lessonId ?? this.lessonId,
        userId: userId ?? this.userId,
        moduleId: moduleId ?? this.moduleId,
        isCompleted: isCompleted ?? this.isCompleted,
        bestAccuracy: bestAccuracy ?? this.bestAccuracy,
        stars: stars ?? this.stars,
        attempts: attempts ?? this.attempts,
        xpEarned: xpEarned ?? this.xpEarned,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
      );
  LessonProgressTableData copyWithCompanion(LessonProgressTableCompanion data) {
    return LessonProgressTableData(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      userId: data.userId.present ? data.userId.value : this.userId,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      bestAccuracy: data.bestAccuracy.present
          ? data.bestAccuracy.value
          : this.bestAccuracy,
      stars: data.stars.present ? data.stars.value : this.stars,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressTableData(')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId, ')
          ..write('moduleId: $moduleId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('bestAccuracy: $bestAccuracy, ')
          ..write('stars: $stars, ')
          ..write('attempts: $attempts, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lessonId, userId, moduleId, isCompleted,
      bestAccuracy, stars, attempts, xpEarned, completedAt, lastAttemptAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressTableData &&
          other.lessonId == this.lessonId &&
          other.userId == this.userId &&
          other.moduleId == this.moduleId &&
          other.isCompleted == this.isCompleted &&
          other.bestAccuracy == this.bestAccuracy &&
          other.stars == this.stars &&
          other.attempts == this.attempts &&
          other.xpEarned == this.xpEarned &&
          other.completedAt == this.completedAt &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class LessonProgressTableCompanion
    extends UpdateCompanion<LessonProgressTableData> {
  final Value<String> lessonId;
  final Value<String> userId;
  final Value<String> moduleId;
  final Value<bool> isCompleted;
  final Value<double> bestAccuracy;
  final Value<int> stars;
  final Value<int> attempts;
  final Value<int> xpEarned;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<int> rowid;
  const LessonProgressTableCompanion({
    this.lessonId = const Value.absent(),
    this.userId = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.bestAccuracy = const Value.absent(),
    this.stars = const Value.absent(),
    this.attempts = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonProgressTableCompanion.insert({
    required String lessonId,
    required String userId,
    required String moduleId,
    this.isCompleted = const Value.absent(),
    this.bestAccuracy = const Value.absent(),
    this.stars = const Value.absent(),
    this.attempts = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : lessonId = Value(lessonId),
        userId = Value(userId),
        moduleId = Value(moduleId);
  static Insertable<LessonProgressTableData> custom({
    Expression<String>? lessonId,
    Expression<String>? userId,
    Expression<String>? moduleId,
    Expression<bool>? isCompleted,
    Expression<double>? bestAccuracy,
    Expression<int>? stars,
    Expression<int>? attempts,
    Expression<int>? xpEarned,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (userId != null) 'user_id': userId,
      if (moduleId != null) 'module_id': moduleId,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (bestAccuracy != null) 'best_accuracy': bestAccuracy,
      if (stars != null) 'stars': stars,
      if (attempts != null) 'attempts': attempts,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (completedAt != null) 'completed_at': completedAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonProgressTableCompanion copyWith(
      {Value<String>? lessonId,
      Value<String>? userId,
      Value<String>? moduleId,
      Value<bool>? isCompleted,
      Value<double>? bestAccuracy,
      Value<int>? stars,
      Value<int>? attempts,
      Value<int>? xpEarned,
      Value<DateTime?>? completedAt,
      Value<DateTime?>? lastAttemptAt,
      Value<int>? rowid}) {
    return LessonProgressTableCompanion(
      lessonId: lessonId ?? this.lessonId,
      userId: userId ?? this.userId,
      moduleId: moduleId ?? this.moduleId,
      isCompleted: isCompleted ?? this.isCompleted,
      bestAccuracy: bestAccuracy ?? this.bestAccuracy,
      stars: stars ?? this.stars,
      attempts: attempts ?? this.attempts,
      xpEarned: xpEarned ?? this.xpEarned,
      completedAt: completedAt ?? this.completedAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (bestAccuracy.present) {
      map['best_accuracy'] = Variable<double>(bestAccuracy.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressTableCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId, ')
          ..write('moduleId: $moduleId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('bestAccuracy: $bestAccuracy, ')
          ..write('stars: $stars, ')
          ..write('attempts: $attempts, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('completedAt: $completedAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseResultsTableTable extends ExerciseResultsTable
    with TableInfo<$ExerciseResultsTableTable, ExerciseResultsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseResultsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesPlayedMeta =
      const VerificationMeta('notesPlayed');
  @override
  late final GeneratedColumn<int> notesPlayed = GeneratedColumn<int>(
      'notes_played', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  @override
  late final GeneratedColumn<bool> passed = GeneratedColumn<bool>(
      'passed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("passed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        exerciseId,
        lessonId,
        userId,
        sessionId,
        accuracy,
        durationSeconds,
        notesPlayed,
        passed,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_results_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExerciseResultsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('notes_played')) {
      context.handle(
          _notesPlayedMeta,
          notesPlayed.isAcceptableOrUnknown(
              data['notes_played']!, _notesPlayedMeta));
    }
    if (data.containsKey('passed')) {
      context.handle(_passedMeta,
          passed.isAcceptableOrUnknown(data['passed']!, _passedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseResultsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseResultsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      notesPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notes_played'])!,
      passed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}passed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $ExerciseResultsTableTable createAlias(String alias) {
    return $ExerciseResultsTableTable(attachedDatabase, alias);
  }
}

class ExerciseResultsTableData extends DataClass
    implements Insertable<ExerciseResultsTableData> {
  final int id;
  final String exerciseId;
  final String lessonId;
  final String userId;
  final String sessionId;
  final double accuracy;
  final int durationSeconds;
  final int notesPlayed;
  final bool passed;
  final DateTime completedAt;
  const ExerciseResultsTableData(
      {required this.id,
      required this.exerciseId,
      required this.lessonId,
      required this.userId,
      required this.sessionId,
      required this.accuracy,
      required this.durationSeconds,
      required this.notesPlayed,
      required this.passed,
      required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['user_id'] = Variable<String>(userId);
    map['session_id'] = Variable<String>(sessionId);
    map['accuracy'] = Variable<double>(accuracy);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['notes_played'] = Variable<int>(notesPlayed);
    map['passed'] = Variable<bool>(passed);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  ExerciseResultsTableCompanion toCompanion(bool nullToAbsent) {
    return ExerciseResultsTableCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      lessonId: Value(lessonId),
      userId: Value(userId),
      sessionId: Value(sessionId),
      accuracy: Value(accuracy),
      durationSeconds: Value(durationSeconds),
      notesPlayed: Value(notesPlayed),
      passed: Value(passed),
      completedAt: Value(completedAt),
    );
  }

  factory ExerciseResultsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseResultsTableData(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      notesPlayed: serializer.fromJson<int>(json['notesPlayed']),
      passed: serializer.fromJson<bool>(json['passed']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'lessonId': serializer.toJson<String>(lessonId),
      'userId': serializer.toJson<String>(userId),
      'sessionId': serializer.toJson<String>(sessionId),
      'accuracy': serializer.toJson<double>(accuracy),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'notesPlayed': serializer.toJson<int>(notesPlayed),
      'passed': serializer.toJson<bool>(passed),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  ExerciseResultsTableData copyWith(
          {int? id,
          String? exerciseId,
          String? lessonId,
          String? userId,
          String? sessionId,
          double? accuracy,
          int? durationSeconds,
          int? notesPlayed,
          bool? passed,
          DateTime? completedAt}) =>
      ExerciseResultsTableData(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        lessonId: lessonId ?? this.lessonId,
        userId: userId ?? this.userId,
        sessionId: sessionId ?? this.sessionId,
        accuracy: accuracy ?? this.accuracy,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        notesPlayed: notesPlayed ?? this.notesPlayed,
        passed: passed ?? this.passed,
        completedAt: completedAt ?? this.completedAt,
      );
  ExerciseResultsTableData copyWithCompanion(
      ExerciseResultsTableCompanion data) {
    return ExerciseResultsTableData(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      notesPlayed:
          data.notesPlayed.present ? data.notesPlayed.value : this.notesPlayed,
      passed: data.passed.present ? data.passed.value : this.passed,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseResultsTableData(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('accuracy: $accuracy, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('notesPlayed: $notesPlayed, ')
          ..write('passed: $passed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, lessonId, userId, sessionId,
      accuracy, durationSeconds, notesPlayed, passed, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseResultsTableData &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.lessonId == this.lessonId &&
          other.userId == this.userId &&
          other.sessionId == this.sessionId &&
          other.accuracy == this.accuracy &&
          other.durationSeconds == this.durationSeconds &&
          other.notesPlayed == this.notesPlayed &&
          other.passed == this.passed &&
          other.completedAt == this.completedAt);
}

class ExerciseResultsTableCompanion
    extends UpdateCompanion<ExerciseResultsTableData> {
  final Value<int> id;
  final Value<String> exerciseId;
  final Value<String> lessonId;
  final Value<String> userId;
  final Value<String> sessionId;
  final Value<double> accuracy;
  final Value<int> durationSeconds;
  final Value<int> notesPlayed;
  final Value<bool> passed;
  final Value<DateTime> completedAt;
  const ExerciseResultsTableCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.notesPlayed = const Value.absent(),
    this.passed = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  ExerciseResultsTableCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseId,
    required String lessonId,
    required String userId,
    required String sessionId,
    this.accuracy = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.notesPlayed = const Value.absent(),
    this.passed = const Value.absent(),
    required DateTime completedAt,
  })  : exerciseId = Value(exerciseId),
        lessonId = Value(lessonId),
        userId = Value(userId),
        sessionId = Value(sessionId),
        completedAt = Value(completedAt);
  static Insertable<ExerciseResultsTableData> custom({
    Expression<int>? id,
    Expression<String>? exerciseId,
    Expression<String>? lessonId,
    Expression<String>? userId,
    Expression<String>? sessionId,
    Expression<double>? accuracy,
    Expression<int>? durationSeconds,
    Expression<int>? notesPlayed,
    Expression<bool>? passed,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (accuracy != null) 'accuracy': accuracy,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (notesPlayed != null) 'notes_played': notesPlayed,
      if (passed != null) 'passed': passed,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  ExerciseResultsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? exerciseId,
      Value<String>? lessonId,
      Value<String>? userId,
      Value<String>? sessionId,
      Value<double>? accuracy,
      Value<int>? durationSeconds,
      Value<int>? notesPlayed,
      Value<bool>? passed,
      Value<DateTime>? completedAt}) {
    return ExerciseResultsTableCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      lessonId: lessonId ?? this.lessonId,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      accuracy: accuracy ?? this.accuracy,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notesPlayed: notesPlayed ?? this.notesPlayed,
      passed: passed ?? this.passed,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (notesPlayed.present) {
      map['notes_played'] = Variable<int>(notesPlayed.value);
    }
    if (passed.present) {
      map['passed'] = Variable<bool>(passed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseResultsTableCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('lessonId: $lessonId, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('accuracy: $accuracy, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('notesPlayed: $notesPlayed, ')
          ..write('passed: $passed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $SpacedRepetitionItemsTableTable extends SpacedRepetitionItemsTable
    with
        TableInfo<$SpacedRepetitionItemsTableTable,
            SpacedRepetitionItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpacedRepetitionItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
      'item_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextReviewDateMeta =
      const VerificationMeta('nextReviewDate');
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>('next_review_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastReviewDateMeta =
      const VerificationMeta('lastReviewDate');
  @override
  late final GeneratedColumn<DateTime> lastReviewDate =
      GeneratedColumn<DateTime>('last_review_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastQualityMeta =
      const VerificationMeta('lastQuality');
  @override
  late final GeneratedColumn<int> lastQuality = GeneratedColumn<int>(
      'last_quality', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        itemType,
        itemId,
        easeFactor,
        intervalDays,
        repetitions,
        nextReviewDate,
        lastReviewDate,
        lastQuality
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spaced_repetition_items_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SpacedRepetitionItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta));
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
          _nextReviewDateMeta,
          nextReviewDate.isAcceptableOrUnknown(
              data['next_review_date']!, _nextReviewDateMeta));
    } else if (isInserting) {
      context.missing(_nextReviewDateMeta);
    }
    if (data.containsKey('last_review_date')) {
      context.handle(
          _lastReviewDateMeta,
          lastReviewDate.isAcceptableOrUnknown(
              data['last_review_date']!, _lastReviewDateMeta));
    }
    if (data.containsKey('last_quality')) {
      context.handle(
          _lastQualityMeta,
          lastQuality.isAcceptableOrUnknown(
              data['last_quality']!, _lastQualityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpacedRepetitionItemsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpacedRepetitionItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_type'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
      nextReviewDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_review_date'])!,
      lastReviewDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_review_date']),
      lastQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_quality'])!,
    );
  }

  @override
  $SpacedRepetitionItemsTableTable createAlias(String alias) {
    return $SpacedRepetitionItemsTableTable(attachedDatabase, alias);
  }
}

class SpacedRepetitionItemsTableData extends DataClass
    implements Insertable<SpacedRepetitionItemsTableData> {
  final String id;
  final String userId;
  final String itemType;
  final String itemId;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final DateTime nextReviewDate;
  final DateTime? lastReviewDate;
  final int lastQuality;
  const SpacedRepetitionItemsTableData(
      {required this.id,
      required this.userId,
      required this.itemType,
      required this.itemId,
      required this.easeFactor,
      required this.intervalDays,
      required this.repetitions,
      required this.nextReviewDate,
      this.lastReviewDate,
      required this.lastQuality});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['item_type'] = Variable<String>(itemType);
    map['item_id'] = Variable<String>(itemId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    map['repetitions'] = Variable<int>(repetitions);
    map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    if (!nullToAbsent || lastReviewDate != null) {
      map['last_review_date'] = Variable<DateTime>(lastReviewDate);
    }
    map['last_quality'] = Variable<int>(lastQuality);
    return map;
  }

  SpacedRepetitionItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SpacedRepetitionItemsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      itemType: Value(itemType),
      itemId: Value(itemId),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      repetitions: Value(repetitions),
      nextReviewDate: Value(nextReviewDate),
      lastReviewDate: lastReviewDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewDate),
      lastQuality: Value(lastQuality),
    );
  }

  factory SpacedRepetitionItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpacedRepetitionItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      itemType: serializer.fromJson<String>(json['itemType']),
      itemId: serializer.fromJson<String>(json['itemId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      nextReviewDate: serializer.fromJson<DateTime>(json['nextReviewDate']),
      lastReviewDate: serializer.fromJson<DateTime?>(json['lastReviewDate']),
      lastQuality: serializer.fromJson<int>(json['lastQuality']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'itemType': serializer.toJson<String>(itemType),
      'itemId': serializer.toJson<String>(itemId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'repetitions': serializer.toJson<int>(repetitions),
      'nextReviewDate': serializer.toJson<DateTime>(nextReviewDate),
      'lastReviewDate': serializer.toJson<DateTime?>(lastReviewDate),
      'lastQuality': serializer.toJson<int>(lastQuality),
    };
  }

  SpacedRepetitionItemsTableData copyWith(
          {String? id,
          String? userId,
          String? itemType,
          String? itemId,
          double? easeFactor,
          int? intervalDays,
          int? repetitions,
          DateTime? nextReviewDate,
          Value<DateTime?> lastReviewDate = const Value.absent(),
          int? lastQuality}) =>
      SpacedRepetitionItemsTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        itemType: itemType ?? this.itemType,
        itemId: itemId ?? this.itemId,
        easeFactor: easeFactor ?? this.easeFactor,
        intervalDays: intervalDays ?? this.intervalDays,
        repetitions: repetitions ?? this.repetitions,
        nextReviewDate: nextReviewDate ?? this.nextReviewDate,
        lastReviewDate:
            lastReviewDate.present ? lastReviewDate.value : this.lastReviewDate,
        lastQuality: lastQuality ?? this.lastQuality,
      );
  SpacedRepetitionItemsTableData copyWithCompanion(
      SpacedRepetitionItemsTableCompanion data) {
    return SpacedRepetitionItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
      lastReviewDate: data.lastReviewDate.present
          ? data.lastReviewDate.value
          : this.lastReviewDate,
      lastQuality:
          data.lastQuality.present ? data.lastQuality.value : this.lastQuality,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpacedRepetitionItemsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('lastReviewDate: $lastReviewDate, ')
          ..write('lastQuality: $lastQuality')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, itemType, itemId, easeFactor,
      intervalDays, repetitions, nextReviewDate, lastReviewDate, lastQuality);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpacedRepetitionItemsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.repetitions == this.repetitions &&
          other.nextReviewDate == this.nextReviewDate &&
          other.lastReviewDate == this.lastReviewDate &&
          other.lastQuality == this.lastQuality);
}

class SpacedRepetitionItemsTableCompanion
    extends UpdateCompanion<SpacedRepetitionItemsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> itemType;
  final Value<String> itemId;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<int> repetitions;
  final Value<DateTime> nextReviewDate;
  final Value<DateTime?> lastReviewDate;
  final Value<int> lastQuality;
  final Value<int> rowid;
  const SpacedRepetitionItemsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.lastReviewDate = const Value.absent(),
    this.lastQuality = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpacedRepetitionItemsTableCompanion.insert({
    required String id,
    required String userId,
    required String itemType,
    required String itemId,
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    required DateTime nextReviewDate,
    this.lastReviewDate = const Value.absent(),
    this.lastQuality = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        itemType = Value(itemType),
        itemId = Value(itemId),
        nextReviewDate = Value(nextReviewDate);
  static Insertable<SpacedRepetitionItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? itemType,
    Expression<String>? itemId,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<int>? repetitions,
    Expression<DateTime>? nextReviewDate,
    Expression<DateTime>? lastReviewDate,
    Expression<int>? lastQuality,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (repetitions != null) 'repetitions': repetitions,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (lastReviewDate != null) 'last_review_date': lastReviewDate,
      if (lastQuality != null) 'last_quality': lastQuality,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpacedRepetitionItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? itemType,
      Value<String>? itemId,
      Value<double>? easeFactor,
      Value<int>? intervalDays,
      Value<int>? repetitions,
      Value<DateTime>? nextReviewDate,
      Value<DateTime?>? lastReviewDate,
      Value<int>? lastQuality,
      Value<int>? rowid}) {
    return SpacedRepetitionItemsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      lastReviewDate: lastReviewDate ?? this.lastReviewDate,
      lastQuality: lastQuality ?? this.lastQuality,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (lastReviewDate.present) {
      map['last_review_date'] = Variable<DateTime>(lastReviewDate.value);
    }
    if (lastQuality.present) {
      map['last_quality'] = Variable<int>(lastQuality.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpacedRepetitionItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('lastReviewDate: $lastReviewDate, ')
          ..write('lastQuality: $lastQuality, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTableTable extends AchievementsTable
    with TableInfo<$AchievementsTableTable, AchievementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unlockedAtMeta =
      const VerificationMeta('unlockedAt');
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
      'unlocked_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, userId, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AchievementsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
          _unlockedAtMeta,
          unlockedAt.isAcceptableOrUnknown(
              data['unlocked_at']!, _unlockedAtMeta));
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key, userId};
  @override
  AchievementsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementsTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      unlockedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unlocked_at'])!,
    );
  }

  @override
  $AchievementsTableTable createAlias(String alias) {
    return $AchievementsTableTable(attachedDatabase, alias);
  }
}

class AchievementsTableData extends DataClass
    implements Insertable<AchievementsTableData> {
  final String key;
  final String userId;
  final DateTime unlockedAt;
  const AchievementsTableData(
      {required this.key, required this.userId, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['user_id'] = Variable<String>(userId);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  AchievementsTableCompanion toCompanion(bool nullToAbsent) {
    return AchievementsTableCompanion(
      key: Value(key),
      userId: Value(userId),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory AchievementsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementsTableData(
      key: serializer.fromJson<String>(json['key']),
      userId: serializer.fromJson<String>(json['userId']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'userId': serializer.toJson<String>(userId),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  AchievementsTableData copyWith(
          {String? key, String? userId, DateTime? unlockedAt}) =>
      AchievementsTableData(
        key: key ?? this.key,
        userId: userId ?? this.userId,
        unlockedAt: unlockedAt ?? this.unlockedAt,
      );
  AchievementsTableData copyWithCompanion(AchievementsTableCompanion data) {
    return AchievementsTableData(
      key: data.key.present ? data.key.value : this.key,
      userId: data.userId.present ? data.userId.value : this.userId,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableData(')
          ..write('key: $key, ')
          ..write('userId: $userId, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, userId, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementsTableData &&
          other.key == this.key &&
          other.userId == this.userId &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsTableCompanion
    extends UpdateCompanion<AchievementsTableData> {
  final Value<String> key;
  final Value<String> userId;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const AchievementsTableCompanion({
    this.key = const Value.absent(),
    this.userId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsTableCompanion.insert({
    required String key,
    required String userId,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        userId = Value(userId),
        unlockedAt = Value(unlockedAt);
  static Insertable<AchievementsTableData> custom({
    Expression<String>? key,
    Expression<String>? userId,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (userId != null) 'user_id': userId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsTableCompanion copyWith(
      {Value<String>? key,
      Value<String>? userId,
      Value<DateTime>? unlockedAt,
      Value<int>? rowid}) {
    return AchievementsTableCompanion(
      key: key ?? this.key,
      userId: userId ?? this.userId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableCompanion(')
          ..write('key: $key, ')
          ..write('userId: $userId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeSessionsTableTable extends PracticeSessionsTable
    with TableInfo<$PracticeSessionsTableTable, PracticeSessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lessonsCompletedJsonMeta =
      const VerificationMeta('lessonsCompletedJson');
  @override
  late final GeneratedColumn<String> lessonsCompletedJson =
      GeneratedColumn<String>('lessons_completed_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _exercisesCompletedJsonMeta =
      const VerificationMeta('exercisesCompletedJson');
  @override
  late final GeneratedColumn<String> exercisesCompletedJson =
      GeneratedColumn<String>('exercises_completed_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _xpEarnedMeta =
      const VerificationMeta('xpEarned');
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
      'xp_earned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _averageAccuracyMeta =
      const VerificationMeta('averageAccuracy');
  @override
  late final GeneratedColumn<double> averageAccuracy = GeneratedColumn<double>(
      'average_accuracy', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesPlayedMeta =
      const VerificationMeta('notesPlayed');
  @override
  late final GeneratedColumn<int> notesPlayed = GeneratedColumn<int>(
      'notes_played', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _chordsPlayedMeta =
      const VerificationMeta('chordsPlayed');
  @override
  late final GeneratedColumn<int> chordsPlayed = GeneratedColumn<int>(
      'chords_played', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currentModuleIdMeta =
      const VerificationMeta('currentModuleId');
  @override
  late final GeneratedColumn<String> currentModuleId = GeneratedColumn<String>(
      'current_module_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _currentLessonIdMeta =
      const VerificationMeta('currentLessonId');
  @override
  late final GeneratedColumn<String> currentLessonId = GeneratedColumn<String>(
      'current_lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _achievementsUnlockedJsonMeta =
      const VerificationMeta('achievementsUnlockedJson');
  @override
  late final GeneratedColumn<String> achievementsUnlockedJson =
      GeneratedColumn<String>('achievements_unlocked_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _wasRecordedMeta =
      const VerificationMeta('wasRecorded');
  @override
  late final GeneratedColumn<bool> wasRecorded = GeneratedColumn<bool>(
      'was_recorded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("was_recorded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _recordingPathMeta =
      const VerificationMeta('recordingPath');
  @override
  late final GeneratedColumn<String> recordingPath = GeneratedColumn<String>(
      'recording_path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        startTime,
        endTime,
        durationSeconds,
        lessonsCompletedJson,
        exercisesCompletedJson,
        xpEarned,
        averageAccuracy,
        notesPlayed,
        chordsPlayed,
        currentModuleId,
        currentLessonId,
        isActive,
        achievementsUnlockedJson,
        wasRecorded,
        recordingPath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_sessions_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PracticeSessionsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('lessons_completed_json')) {
      context.handle(
          _lessonsCompletedJsonMeta,
          lessonsCompletedJson.isAcceptableOrUnknown(
              data['lessons_completed_json']!, _lessonsCompletedJsonMeta));
    }
    if (data.containsKey('exercises_completed_json')) {
      context.handle(
          _exercisesCompletedJsonMeta,
          exercisesCompletedJson.isAcceptableOrUnknown(
              data['exercises_completed_json']!, _exercisesCompletedJsonMeta));
    }
    if (data.containsKey('xp_earned')) {
      context.handle(_xpEarnedMeta,
          xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta));
    }
    if (data.containsKey('average_accuracy')) {
      context.handle(
          _averageAccuracyMeta,
          averageAccuracy.isAcceptableOrUnknown(
              data['average_accuracy']!, _averageAccuracyMeta));
    }
    if (data.containsKey('notes_played')) {
      context.handle(
          _notesPlayedMeta,
          notesPlayed.isAcceptableOrUnknown(
              data['notes_played']!, _notesPlayedMeta));
    }
    if (data.containsKey('chords_played')) {
      context.handle(
          _chordsPlayedMeta,
          chordsPlayed.isAcceptableOrUnknown(
              data['chords_played']!, _chordsPlayedMeta));
    }
    if (data.containsKey('current_module_id')) {
      context.handle(
          _currentModuleIdMeta,
          currentModuleId.isAcceptableOrUnknown(
              data['current_module_id']!, _currentModuleIdMeta));
    }
    if (data.containsKey('current_lesson_id')) {
      context.handle(
          _currentLessonIdMeta,
          currentLessonId.isAcceptableOrUnknown(
              data['current_lesson_id']!, _currentLessonIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('achievements_unlocked_json')) {
      context.handle(
          _achievementsUnlockedJsonMeta,
          achievementsUnlockedJson.isAcceptableOrUnknown(
              data['achievements_unlocked_json']!,
              _achievementsUnlockedJsonMeta));
    }
    if (data.containsKey('was_recorded')) {
      context.handle(
          _wasRecordedMeta,
          wasRecorded.isAcceptableOrUnknown(
              data['was_recorded']!, _wasRecordedMeta));
    }
    if (data.containsKey('recording_path')) {
      context.handle(
          _recordingPathMeta,
          recordingPath.isAcceptableOrUnknown(
              data['recording_path']!, _recordingPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeSessionsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeSessionsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      lessonsCompletedJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}lessons_completed_json'])!,
      exercisesCompletedJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}exercises_completed_json'])!,
      xpEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_earned'])!,
      averageAccuracy: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}average_accuracy'])!,
      notesPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notes_played'])!,
      chordsPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chords_played'])!,
      currentModuleId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_module_id'])!,
      currentLessonId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}current_lesson_id'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      achievementsUnlockedJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}achievements_unlocked_json'])!,
      wasRecorded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}was_recorded'])!,
      recordingPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recording_path'])!,
    );
  }

  @override
  $PracticeSessionsTableTable createAlias(String alias) {
    return $PracticeSessionsTableTable(attachedDatabase, alias);
  }
}

class PracticeSessionsTableData extends DataClass
    implements Insertable<PracticeSessionsTableData> {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final String lessonsCompletedJson;
  final String exercisesCompletedJson;
  final int xpEarned;
  final double averageAccuracy;
  final int notesPlayed;
  final int chordsPlayed;
  final String currentModuleId;
  final String currentLessonId;
  final bool isActive;
  final String achievementsUnlockedJson;
  final bool wasRecorded;
  final String recordingPath;
  const PracticeSessionsTableData(
      {required this.id,
      required this.userId,
      required this.startTime,
      this.endTime,
      required this.durationSeconds,
      required this.lessonsCompletedJson,
      required this.exercisesCompletedJson,
      required this.xpEarned,
      required this.averageAccuracy,
      required this.notesPlayed,
      required this.chordsPlayed,
      required this.currentModuleId,
      required this.currentLessonId,
      required this.isActive,
      required this.achievementsUnlockedJson,
      required this.wasRecorded,
      required this.recordingPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['lessons_completed_json'] = Variable<String>(lessonsCompletedJson);
    map['exercises_completed_json'] = Variable<String>(exercisesCompletedJson);
    map['xp_earned'] = Variable<int>(xpEarned);
    map['average_accuracy'] = Variable<double>(averageAccuracy);
    map['notes_played'] = Variable<int>(notesPlayed);
    map['chords_played'] = Variable<int>(chordsPlayed);
    map['current_module_id'] = Variable<String>(currentModuleId);
    map['current_lesson_id'] = Variable<String>(currentLessonId);
    map['is_active'] = Variable<bool>(isActive);
    map['achievements_unlocked_json'] =
        Variable<String>(achievementsUnlockedJson);
    map['was_recorded'] = Variable<bool>(wasRecorded);
    map['recording_path'] = Variable<String>(recordingPath);
    return map;
  }

  PracticeSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return PracticeSessionsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      durationSeconds: Value(durationSeconds),
      lessonsCompletedJson: Value(lessonsCompletedJson),
      exercisesCompletedJson: Value(exercisesCompletedJson),
      xpEarned: Value(xpEarned),
      averageAccuracy: Value(averageAccuracy),
      notesPlayed: Value(notesPlayed),
      chordsPlayed: Value(chordsPlayed),
      currentModuleId: Value(currentModuleId),
      currentLessonId: Value(currentLessonId),
      isActive: Value(isActive),
      achievementsUnlockedJson: Value(achievementsUnlockedJson),
      wasRecorded: Value(wasRecorded),
      recordingPath: Value(recordingPath),
    );
  }

  factory PracticeSessionsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      lessonsCompletedJson:
          serializer.fromJson<String>(json['lessonsCompletedJson']),
      exercisesCompletedJson:
          serializer.fromJson<String>(json['exercisesCompletedJson']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      averageAccuracy: serializer.fromJson<double>(json['averageAccuracy']),
      notesPlayed: serializer.fromJson<int>(json['notesPlayed']),
      chordsPlayed: serializer.fromJson<int>(json['chordsPlayed']),
      currentModuleId: serializer.fromJson<String>(json['currentModuleId']),
      currentLessonId: serializer.fromJson<String>(json['currentLessonId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      achievementsUnlockedJson:
          serializer.fromJson<String>(json['achievementsUnlockedJson']),
      wasRecorded: serializer.fromJson<bool>(json['wasRecorded']),
      recordingPath: serializer.fromJson<String>(json['recordingPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'lessonsCompletedJson': serializer.toJson<String>(lessonsCompletedJson),
      'exercisesCompletedJson':
          serializer.toJson<String>(exercisesCompletedJson),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'averageAccuracy': serializer.toJson<double>(averageAccuracy),
      'notesPlayed': serializer.toJson<int>(notesPlayed),
      'chordsPlayed': serializer.toJson<int>(chordsPlayed),
      'currentModuleId': serializer.toJson<String>(currentModuleId),
      'currentLessonId': serializer.toJson<String>(currentLessonId),
      'isActive': serializer.toJson<bool>(isActive),
      'achievementsUnlockedJson':
          serializer.toJson<String>(achievementsUnlockedJson),
      'wasRecorded': serializer.toJson<bool>(wasRecorded),
      'recordingPath': serializer.toJson<String>(recordingPath),
    };
  }

  PracticeSessionsTableData copyWith(
          {String? id,
          String? userId,
          DateTime? startTime,
          Value<DateTime?> endTime = const Value.absent(),
          int? durationSeconds,
          String? lessonsCompletedJson,
          String? exercisesCompletedJson,
          int? xpEarned,
          double? averageAccuracy,
          int? notesPlayed,
          int? chordsPlayed,
          String? currentModuleId,
          String? currentLessonId,
          bool? isActive,
          String? achievementsUnlockedJson,
          bool? wasRecorded,
          String? recordingPath}) =>
      PracticeSessionsTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        startTime: startTime ?? this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        lessonsCompletedJson: lessonsCompletedJson ?? this.lessonsCompletedJson,
        exercisesCompletedJson:
            exercisesCompletedJson ?? this.exercisesCompletedJson,
        xpEarned: xpEarned ?? this.xpEarned,
        averageAccuracy: averageAccuracy ?? this.averageAccuracy,
        notesPlayed: notesPlayed ?? this.notesPlayed,
        chordsPlayed: chordsPlayed ?? this.chordsPlayed,
        currentModuleId: currentModuleId ?? this.currentModuleId,
        currentLessonId: currentLessonId ?? this.currentLessonId,
        isActive: isActive ?? this.isActive,
        achievementsUnlockedJson:
            achievementsUnlockedJson ?? this.achievementsUnlockedJson,
        wasRecorded: wasRecorded ?? this.wasRecorded,
        recordingPath: recordingPath ?? this.recordingPath,
      );
  PracticeSessionsTableData copyWithCompanion(
      PracticeSessionsTableCompanion data) {
    return PracticeSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      lessonsCompletedJson: data.lessonsCompletedJson.present
          ? data.lessonsCompletedJson.value
          : this.lessonsCompletedJson,
      exercisesCompletedJson: data.exercisesCompletedJson.present
          ? data.exercisesCompletedJson.value
          : this.exercisesCompletedJson,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      averageAccuracy: data.averageAccuracy.present
          ? data.averageAccuracy.value
          : this.averageAccuracy,
      notesPlayed:
          data.notesPlayed.present ? data.notesPlayed.value : this.notesPlayed,
      chordsPlayed: data.chordsPlayed.present
          ? data.chordsPlayed.value
          : this.chordsPlayed,
      currentModuleId: data.currentModuleId.present
          ? data.currentModuleId.value
          : this.currentModuleId,
      currentLessonId: data.currentLessonId.present
          ? data.currentLessonId.value
          : this.currentLessonId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      achievementsUnlockedJson: data.achievementsUnlockedJson.present
          ? data.achievementsUnlockedJson.value
          : this.achievementsUnlockedJson,
      wasRecorded:
          data.wasRecorded.present ? data.wasRecorded.value : this.wasRecorded,
      recordingPath: data.recordingPath.present
          ? data.recordingPath.value
          : this.recordingPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('lessonsCompletedJson: $lessonsCompletedJson, ')
          ..write('exercisesCompletedJson: $exercisesCompletedJson, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('averageAccuracy: $averageAccuracy, ')
          ..write('notesPlayed: $notesPlayed, ')
          ..write('chordsPlayed: $chordsPlayed, ')
          ..write('currentModuleId: $currentModuleId, ')
          ..write('currentLessonId: $currentLessonId, ')
          ..write('isActive: $isActive, ')
          ..write('achievementsUnlockedJson: $achievementsUnlockedJson, ')
          ..write('wasRecorded: $wasRecorded, ')
          ..write('recordingPath: $recordingPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      startTime,
      endTime,
      durationSeconds,
      lessonsCompletedJson,
      exercisesCompletedJson,
      xpEarned,
      averageAccuracy,
      notesPlayed,
      chordsPlayed,
      currentModuleId,
      currentLessonId,
      isActive,
      achievementsUnlockedJson,
      wasRecorded,
      recordingPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeSessionsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationSeconds == this.durationSeconds &&
          other.lessonsCompletedJson == this.lessonsCompletedJson &&
          other.exercisesCompletedJson == this.exercisesCompletedJson &&
          other.xpEarned == this.xpEarned &&
          other.averageAccuracy == this.averageAccuracy &&
          other.notesPlayed == this.notesPlayed &&
          other.chordsPlayed == this.chordsPlayed &&
          other.currentModuleId == this.currentModuleId &&
          other.currentLessonId == this.currentLessonId &&
          other.isActive == this.isActive &&
          other.achievementsUnlockedJson == this.achievementsUnlockedJson &&
          other.wasRecorded == this.wasRecorded &&
          other.recordingPath == this.recordingPath);
}

class PracticeSessionsTableCompanion
    extends UpdateCompanion<PracticeSessionsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> durationSeconds;
  final Value<String> lessonsCompletedJson;
  final Value<String> exercisesCompletedJson;
  final Value<int> xpEarned;
  final Value<double> averageAccuracy;
  final Value<int> notesPlayed;
  final Value<int> chordsPlayed;
  final Value<String> currentModuleId;
  final Value<String> currentLessonId;
  final Value<bool> isActive;
  final Value<String> achievementsUnlockedJson;
  final Value<bool> wasRecorded;
  final Value<String> recordingPath;
  final Value<int> rowid;
  const PracticeSessionsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.lessonsCompletedJson = const Value.absent(),
    this.exercisesCompletedJson = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.averageAccuracy = const Value.absent(),
    this.notesPlayed = const Value.absent(),
    this.chordsPlayed = const Value.absent(),
    this.currentModuleId = const Value.absent(),
    this.currentLessonId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.achievementsUnlockedJson = const Value.absent(),
    this.wasRecorded = const Value.absent(),
    this.recordingPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PracticeSessionsTableCompanion.insert({
    required String id,
    required String userId,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.lessonsCompletedJson = const Value.absent(),
    this.exercisesCompletedJson = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.averageAccuracy = const Value.absent(),
    this.notesPlayed = const Value.absent(),
    this.chordsPlayed = const Value.absent(),
    this.currentModuleId = const Value.absent(),
    this.currentLessonId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.achievementsUnlockedJson = const Value.absent(),
    this.wasRecorded = const Value.absent(),
    this.recordingPath = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        startTime = Value(startTime);
  static Insertable<PracticeSessionsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? durationSeconds,
    Expression<String>? lessonsCompletedJson,
    Expression<String>? exercisesCompletedJson,
    Expression<int>? xpEarned,
    Expression<double>? averageAccuracy,
    Expression<int>? notesPlayed,
    Expression<int>? chordsPlayed,
    Expression<String>? currentModuleId,
    Expression<String>? currentLessonId,
    Expression<bool>? isActive,
    Expression<String>? achievementsUnlockedJson,
    Expression<bool>? wasRecorded,
    Expression<String>? recordingPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (lessonsCompletedJson != null)
        'lessons_completed_json': lessonsCompletedJson,
      if (exercisesCompletedJson != null)
        'exercises_completed_json': exercisesCompletedJson,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (averageAccuracy != null) 'average_accuracy': averageAccuracy,
      if (notesPlayed != null) 'notes_played': notesPlayed,
      if (chordsPlayed != null) 'chords_played': chordsPlayed,
      if (currentModuleId != null) 'current_module_id': currentModuleId,
      if (currentLessonId != null) 'current_lesson_id': currentLessonId,
      if (isActive != null) 'is_active': isActive,
      if (achievementsUnlockedJson != null)
        'achievements_unlocked_json': achievementsUnlockedJson,
      if (wasRecorded != null) 'was_recorded': wasRecorded,
      if (recordingPath != null) 'recording_path': recordingPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PracticeSessionsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<DateTime>? startTime,
      Value<DateTime?>? endTime,
      Value<int>? durationSeconds,
      Value<String>? lessonsCompletedJson,
      Value<String>? exercisesCompletedJson,
      Value<int>? xpEarned,
      Value<double>? averageAccuracy,
      Value<int>? notesPlayed,
      Value<int>? chordsPlayed,
      Value<String>? currentModuleId,
      Value<String>? currentLessonId,
      Value<bool>? isActive,
      Value<String>? achievementsUnlockedJson,
      Value<bool>? wasRecorded,
      Value<String>? recordingPath,
      Value<int>? rowid}) {
    return PracticeSessionsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      lessonsCompletedJson: lessonsCompletedJson ?? this.lessonsCompletedJson,
      exercisesCompletedJson:
          exercisesCompletedJson ?? this.exercisesCompletedJson,
      xpEarned: xpEarned ?? this.xpEarned,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      notesPlayed: notesPlayed ?? this.notesPlayed,
      chordsPlayed: chordsPlayed ?? this.chordsPlayed,
      currentModuleId: currentModuleId ?? this.currentModuleId,
      currentLessonId: currentLessonId ?? this.currentLessonId,
      isActive: isActive ?? this.isActive,
      achievementsUnlockedJson:
          achievementsUnlockedJson ?? this.achievementsUnlockedJson,
      wasRecorded: wasRecorded ?? this.wasRecorded,
      recordingPath: recordingPath ?? this.recordingPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (lessonsCompletedJson.present) {
      map['lessons_completed_json'] =
          Variable<String>(lessonsCompletedJson.value);
    }
    if (exercisesCompletedJson.present) {
      map['exercises_completed_json'] =
          Variable<String>(exercisesCompletedJson.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (averageAccuracy.present) {
      map['average_accuracy'] = Variable<double>(averageAccuracy.value);
    }
    if (notesPlayed.present) {
      map['notes_played'] = Variable<int>(notesPlayed.value);
    }
    if (chordsPlayed.present) {
      map['chords_played'] = Variable<int>(chordsPlayed.value);
    }
    if (currentModuleId.present) {
      map['current_module_id'] = Variable<String>(currentModuleId.value);
    }
    if (currentLessonId.present) {
      map['current_lesson_id'] = Variable<String>(currentLessonId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (achievementsUnlockedJson.present) {
      map['achievements_unlocked_json'] =
          Variable<String>(achievementsUnlockedJson.value);
    }
    if (wasRecorded.present) {
      map['was_recorded'] = Variable<bool>(wasRecorded.value);
    }
    if (recordingPath.present) {
      map['recording_path'] = Variable<String>(recordingPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('lessonsCompletedJson: $lessonsCompletedJson, ')
          ..write('exercisesCompletedJson: $exercisesCompletedJson, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('averageAccuracy: $averageAccuracy, ')
          ..write('notesPlayed: $notesPlayed, ')
          ..write('chordsPlayed: $chordsPlayed, ')
          ..write('currentModuleId: $currentModuleId, ')
          ..write('currentLessonId: $currentLessonId, ')
          ..write('isActive: $isActive, ')
          ..write('achievementsUnlockedJson: $achievementsUnlockedJson, ')
          ..write('wasRecorded: $wasRecorded, ')
          ..write('recordingPath: $recordingPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordingsTableTable extends RecordingsTable
    with TableInfo<$RecordingsTableTable, RecordingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonIdMeta =
      const VerificationMeta('lessonId');
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
      'lesson_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        sessionId,
        lessonId,
        filePath,
        durationSeconds,
        title,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recordings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecordingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(_lessonIdMeta,
          lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      lessonId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lesson_id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RecordingsTableTable createAlias(String alias) {
    return $RecordingsTableTable(attachedDatabase, alias);
  }
}

class RecordingsTableData extends DataClass
    implements Insertable<RecordingsTableData> {
  final String id;
  final String userId;
  final String sessionId;
  final String lessonId;
  final String filePath;
  final int durationSeconds;
  final String title;
  final DateTime createdAt;
  const RecordingsTableData(
      {required this.id,
      required this.userId,
      required this.sessionId,
      required this.lessonId,
      required this.filePath,
      required this.durationSeconds,
      required this.title,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['session_id'] = Variable<String>(sessionId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['file_path'] = Variable<String>(filePath);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecordingsTableCompanion toCompanion(bool nullToAbsent) {
    return RecordingsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      sessionId: Value(sessionId),
      lessonId: Value(lessonId),
      filePath: Value(filePath),
      durationSeconds: Value(durationSeconds),
      title: Value(title),
      createdAt: Value(createdAt),
    );
  }

  factory RecordingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordingsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sessionId': serializer.toJson<String>(sessionId),
      'lessonId': serializer.toJson<String>(lessonId),
      'filePath': serializer.toJson<String>(filePath),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecordingsTableData copyWith(
          {String? id,
          String? userId,
          String? sessionId,
          String? lessonId,
          String? filePath,
          int? durationSeconds,
          String? title,
          DateTime? createdAt}) =>
      RecordingsTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        sessionId: sessionId ?? this.sessionId,
        lessonId: lessonId ?? this.lessonId,
        filePath: filePath ?? this.filePath,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
      );
  RecordingsTableData copyWithCompanion(RecordingsTableCompanion data) {
    return RecordingsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordingsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('lessonId: $lessonId, ')
          ..write('filePath: $filePath, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, sessionId, lessonId, filePath,
      durationSeconds, title, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordingsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sessionId == this.sessionId &&
          other.lessonId == this.lessonId &&
          other.filePath == this.filePath &&
          other.durationSeconds == this.durationSeconds &&
          other.title == this.title &&
          other.createdAt == this.createdAt);
}

class RecordingsTableCompanion extends UpdateCompanion<RecordingsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sessionId;
  final Value<String> lessonId;
  final Value<String> filePath;
  final Value<int> durationSeconds;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecordingsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordingsTableCompanion.insert({
    required String id,
    required String userId,
    required String sessionId,
    this.lessonId = const Value.absent(),
    required String filePath,
    this.durationSeconds = const Value.absent(),
    this.title = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        sessionId = Value(sessionId),
        filePath = Value(filePath),
        createdAt = Value(createdAt);
  static Insertable<RecordingsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sessionId,
    Expression<String>? lessonId,
    Expression<String>? filePath,
    Expression<int>? durationSeconds,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (filePath != null) 'file_path': filePath,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordingsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? sessionId,
      Value<String>? lessonId,
      Value<String>? filePath,
      Value<int>? durationSeconds,
      Value<String>? title,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return RecordingsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      lessonId: lessonId ?? this.lessonId,
      filePath: filePath ?? this.filePath,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordingsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('lessonId: $lessonId, ')
          ..write('filePath: $filePath, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyStatsTableTable extends DailyStatsTable
    with TableInfo<$DailyStatsTableTable, DailyStatsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _practiceMinutesMeta =
      const VerificationMeta('practiceMinutes');
  @override
  late final GeneratedColumn<int> practiceMinutes = GeneratedColumn<int>(
      'practice_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _xpEarnedMeta =
      const VerificationMeta('xpEarned');
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
      'xp_earned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lessonsCompletedMeta =
      const VerificationMeta('lessonsCompleted');
  @override
  late final GeneratedColumn<int> lessonsCompleted = GeneratedColumn<int>(
      'lessons_completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesPlayedMeta =
      const VerificationMeta('notesPlayed');
  @override
  late final GeneratedColumn<int> notesPlayed = GeneratedColumn<int>(
      'notes_played', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _streakMaintainedMeta =
      const VerificationMeta('streakMaintained');
  @override
  late final GeneratedColumn<bool> streakMaintained = GeneratedColumn<bool>(
      'streak_maintained', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("streak_maintained" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        date,
        practiceMinutes,
        xpEarned,
        lessonsCompleted,
        notesPlayed,
        streakMaintained
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stats_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyStatsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('practice_minutes')) {
      context.handle(
          _practiceMinutesMeta,
          practiceMinutes.isAcceptableOrUnknown(
              data['practice_minutes']!, _practiceMinutesMeta));
    }
    if (data.containsKey('xp_earned')) {
      context.handle(_xpEarnedMeta,
          xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta));
    }
    if (data.containsKey('lessons_completed')) {
      context.handle(
          _lessonsCompletedMeta,
          lessonsCompleted.isAcceptableOrUnknown(
              data['lessons_completed']!, _lessonsCompletedMeta));
    }
    if (data.containsKey('notes_played')) {
      context.handle(
          _notesPlayedMeta,
          notesPlayed.isAcceptableOrUnknown(
              data['notes_played']!, _notesPlayedMeta));
    }
    if (data.containsKey('streak_maintained')) {
      context.handle(
          _streakMaintainedMeta,
          streakMaintained.isAcceptableOrUnknown(
              data['streak_maintained']!, _streakMaintainedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, date};
  @override
  DailyStatsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStatsTableData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      practiceMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}practice_minutes'])!,
      xpEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_earned'])!,
      lessonsCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lessons_completed'])!,
      notesPlayed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notes_played'])!,
      streakMaintained: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}streak_maintained'])!,
    );
  }

  @override
  $DailyStatsTableTable createAlias(String alias) {
    return $DailyStatsTableTable(attachedDatabase, alias);
  }
}

class DailyStatsTableData extends DataClass
    implements Insertable<DailyStatsTableData> {
  final String userId;
  final DateTime date;
  final int practiceMinutes;
  final int xpEarned;
  final int lessonsCompleted;
  final int notesPlayed;
  final bool streakMaintained;
  const DailyStatsTableData(
      {required this.userId,
      required this.date,
      required this.practiceMinutes,
      required this.xpEarned,
      required this.lessonsCompleted,
      required this.notesPlayed,
      required this.streakMaintained});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['date'] = Variable<DateTime>(date);
    map['practice_minutes'] = Variable<int>(practiceMinutes);
    map['xp_earned'] = Variable<int>(xpEarned);
    map['lessons_completed'] = Variable<int>(lessonsCompleted);
    map['notes_played'] = Variable<int>(notesPlayed);
    map['streak_maintained'] = Variable<bool>(streakMaintained);
    return map;
  }

  DailyStatsTableCompanion toCompanion(bool nullToAbsent) {
    return DailyStatsTableCompanion(
      userId: Value(userId),
      date: Value(date),
      practiceMinutes: Value(practiceMinutes),
      xpEarned: Value(xpEarned),
      lessonsCompleted: Value(lessonsCompleted),
      notesPlayed: Value(notesPlayed),
      streakMaintained: Value(streakMaintained),
    );
  }

  factory DailyStatsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStatsTableData(
      userId: serializer.fromJson<String>(json['userId']),
      date: serializer.fromJson<DateTime>(json['date']),
      practiceMinutes: serializer.fromJson<int>(json['practiceMinutes']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      lessonsCompleted: serializer.fromJson<int>(json['lessonsCompleted']),
      notesPlayed: serializer.fromJson<int>(json['notesPlayed']),
      streakMaintained: serializer.fromJson<bool>(json['streakMaintained']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'date': serializer.toJson<DateTime>(date),
      'practiceMinutes': serializer.toJson<int>(practiceMinutes),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'lessonsCompleted': serializer.toJson<int>(lessonsCompleted),
      'notesPlayed': serializer.toJson<int>(notesPlayed),
      'streakMaintained': serializer.toJson<bool>(streakMaintained),
    };
  }

  DailyStatsTableData copyWith(
          {String? userId,
          DateTime? date,
          int? practiceMinutes,
          int? xpEarned,
          int? lessonsCompleted,
          int? notesPlayed,
          bool? streakMaintained}) =>
      DailyStatsTableData(
        userId: userId ?? this.userId,
        date: date ?? this.date,
        practiceMinutes: practiceMinutes ?? this.practiceMinutes,
        xpEarned: xpEarned ?? this.xpEarned,
        lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
        notesPlayed: notesPlayed ?? this.notesPlayed,
        streakMaintained: streakMaintained ?? this.streakMaintained,
      );
  DailyStatsTableData copyWithCompanion(DailyStatsTableCompanion data) {
    return DailyStatsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      practiceMinutes: data.practiceMinutes.present
          ? data.practiceMinutes.value
          : this.practiceMinutes,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      lessonsCompleted: data.lessonsCompleted.present
          ? data.lessonsCompleted.value
          : this.lessonsCompleted,
      notesPlayed:
          data.notesPlayed.present ? data.notesPlayed.value : this.notesPlayed,
      streakMaintained: data.streakMaintained.present
          ? data.streakMaintained.value
          : this.streakMaintained,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsTableData(')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('practiceMinutes: $practiceMinutes, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('lessonsCompleted: $lessonsCompleted, ')
          ..write('notesPlayed: $notesPlayed, ')
          ..write('streakMaintained: $streakMaintained')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, date, practiceMinutes, xpEarned,
      lessonsCompleted, notesPlayed, streakMaintained);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStatsTableData &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.practiceMinutes == this.practiceMinutes &&
          other.xpEarned == this.xpEarned &&
          other.lessonsCompleted == this.lessonsCompleted &&
          other.notesPlayed == this.notesPlayed &&
          other.streakMaintained == this.streakMaintained);
}

class DailyStatsTableCompanion extends UpdateCompanion<DailyStatsTableData> {
  final Value<String> userId;
  final Value<DateTime> date;
  final Value<int> practiceMinutes;
  final Value<int> xpEarned;
  final Value<int> lessonsCompleted;
  final Value<int> notesPlayed;
  final Value<bool> streakMaintained;
  final Value<int> rowid;
  const DailyStatsTableCompanion({
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.practiceMinutes = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.lessonsCompleted = const Value.absent(),
    this.notesPlayed = const Value.absent(),
    this.streakMaintained = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStatsTableCompanion.insert({
    required String userId,
    required DateTime date,
    this.practiceMinutes = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.lessonsCompleted = const Value.absent(),
    this.notesPlayed = const Value.absent(),
    this.streakMaintained = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        date = Value(date);
  static Insertable<DailyStatsTableData> custom({
    Expression<String>? userId,
    Expression<DateTime>? date,
    Expression<int>? practiceMinutes,
    Expression<int>? xpEarned,
    Expression<int>? lessonsCompleted,
    Expression<int>? notesPlayed,
    Expression<bool>? streakMaintained,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (practiceMinutes != null) 'practice_minutes': practiceMinutes,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (lessonsCompleted != null) 'lessons_completed': lessonsCompleted,
      if (notesPlayed != null) 'notes_played': notesPlayed,
      if (streakMaintained != null) 'streak_maintained': streakMaintained,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStatsTableCompanion copyWith(
      {Value<String>? userId,
      Value<DateTime>? date,
      Value<int>? practiceMinutes,
      Value<int>? xpEarned,
      Value<int>? lessonsCompleted,
      Value<int>? notesPlayed,
      Value<bool>? streakMaintained,
      Value<int>? rowid}) {
    return DailyStatsTableCompanion(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      practiceMinutes: practiceMinutes ?? this.practiceMinutes,
      xpEarned: xpEarned ?? this.xpEarned,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      notesPlayed: notesPlayed ?? this.notesPlayed,
      streakMaintained: streakMaintained ?? this.streakMaintained,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (practiceMinutes.present) {
      map['practice_minutes'] = Variable<int>(practiceMinutes.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (lessonsCompleted.present) {
      map['lessons_completed'] = Variable<int>(lessonsCompleted.value);
    }
    if (notesPlayed.present) {
      map['notes_played'] = Variable<int>(notesPlayed.value);
    }
    if (streakMaintained.present) {
      map['streak_maintained'] = Variable<bool>(streakMaintained.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('practiceMinutes: $practiceMinutes, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('lessonsCompleted: $lessonsCompleted, ')
          ..write('notesPlayed: $notesPlayed, ')
          ..write('streakMaintained: $streakMaintained, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTableTable userProfilesTable =
      $UserProfilesTableTable(this);
  late final $ModuleProgressTableTable moduleProgressTable =
      $ModuleProgressTableTable(this);
  late final $LessonProgressTableTable lessonProgressTable =
      $LessonProgressTableTable(this);
  late final $ExerciseResultsTableTable exerciseResultsTable =
      $ExerciseResultsTableTable(this);
  late final $SpacedRepetitionItemsTableTable spacedRepetitionItemsTable =
      $SpacedRepetitionItemsTableTable(this);
  late final $AchievementsTableTable achievementsTable =
      $AchievementsTableTable(this);
  late final $PracticeSessionsTableTable practiceSessionsTable =
      $PracticeSessionsTableTable(this);
  late final $RecordingsTableTable recordingsTable =
      $RecordingsTableTable(this);
  late final $DailyStatsTableTable dailyStatsTable =
      $DailyStatsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userProfilesTable,
        moduleProgressTable,
        lessonProgressTable,
        exerciseResultsTable,
        spacedRepetitionItemsTable,
        achievementsTable,
        practiceSessionsTable,
        recordingsTable,
        dailyStatsTable
      ];
}

typedef $$UserProfilesTableTableCreateCompanionBuilder
    = UserProfilesTableCompanion Function({
  required String id,
  Value<String> username,
  Value<String> email,
  Value<String> avatarUrl,
  Value<int> totalXp,
  Value<int> level,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastPracticeDate,
  Value<int> totalPracticeMinutes,
  Value<int> totalLessonsCompleted,
  Value<int> totalModulesCompleted,
  Value<String> unlockedAchievementsJson,
  Value<String> unlockedPresetsJson,
  Value<String> completedLessonIdsJson,
  Value<String> completedModuleIdsJson,
  Value<bool> onboardingComplete,
  Value<String> preferredTuning,
  Value<bool> isDarkMode,
  Value<bool> notificationsEnabled,
  Value<bool> soundEffectsEnabled,
  Value<double> masterVolume,
  Value<String> language,
  Value<bool> isGuest,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$UserProfilesTableTableUpdateCompanionBuilder
    = UserProfilesTableCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> email,
  Value<String> avatarUrl,
  Value<int> totalXp,
  Value<int> level,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastPracticeDate,
  Value<int> totalPracticeMinutes,
  Value<int> totalLessonsCompleted,
  Value<int> totalModulesCompleted,
  Value<String> unlockedAchievementsJson,
  Value<String> unlockedPresetsJson,
  Value<String> completedLessonIdsJson,
  Value<String> completedModuleIdsJson,
  Value<bool> onboardingComplete,
  Value<String> preferredTuning,
  Value<bool> isDarkMode,
  Value<bool> notificationsEnabled,
  Value<bool> soundEffectsEnabled,
  Value<double> masterVolume,
  Value<String> language,
  Value<bool> isGuest,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$UserProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPracticeDate => $composableBuilder(
      column: $table.lastPracticeDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPracticeMinutes => $composableBuilder(
      column: $table.totalPracticeMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalLessonsCompleted => $composableBuilder(
      column: $table.totalLessonsCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalModulesCompleted => $composableBuilder(
      column: $table.totalModulesCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unlockedAchievementsJson => $composableBuilder(
      column: $table.unlockedAchievementsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unlockedPresetsJson => $composableBuilder(
      column: $table.unlockedPresetsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completedLessonIdsJson => $composableBuilder(
      column: $table.completedLessonIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completedModuleIdsJson => $composableBuilder(
      column: $table.completedModuleIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
      column: $table.onboardingComplete,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredTuning => $composableBuilder(
      column: $table.preferredTuning,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDarkMode => $composableBuilder(
      column: $table.isDarkMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get soundEffectsEnabled => $composableBuilder(
      column: $table.soundEffectsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get masterVolume => $composableBuilder(
      column: $table.masterVolume, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isGuest => $composableBuilder(
      column: $table.isGuest, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalXp => $composableBuilder(
      column: $table.totalXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPracticeDate => $composableBuilder(
      column: $table.lastPracticeDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPracticeMinutes => $composableBuilder(
      column: $table.totalPracticeMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalLessonsCompleted => $composableBuilder(
      column: $table.totalLessonsCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalModulesCompleted => $composableBuilder(
      column: $table.totalModulesCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unlockedAchievementsJson => $composableBuilder(
      column: $table.unlockedAchievementsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unlockedPresetsJson => $composableBuilder(
      column: $table.unlockedPresetsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completedLessonIdsJson => $composableBuilder(
      column: $table.completedLessonIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completedModuleIdsJson => $composableBuilder(
      column: $table.completedModuleIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
      column: $table.onboardingComplete,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredTuning => $composableBuilder(
      column: $table.preferredTuning,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDarkMode => $composableBuilder(
      column: $table.isDarkMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get soundEffectsEnabled => $composableBuilder(
      column: $table.soundEffectsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get masterVolume => $composableBuilder(
      column: $table.masterVolume,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isGuest => $composableBuilder(
      column: $table.isGuest, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<int> get totalXp =>
      $composableBuilder(column: $table.totalXp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
      column: $table.currentStreak, builder: (column) => column);

  GeneratedColumn<int> get longestStreak => $composableBuilder(
      column: $table.longestStreak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPracticeDate => $composableBuilder(
      column: $table.lastPracticeDate, builder: (column) => column);

  GeneratedColumn<int> get totalPracticeMinutes => $composableBuilder(
      column: $table.totalPracticeMinutes, builder: (column) => column);

  GeneratedColumn<int> get totalLessonsCompleted => $composableBuilder(
      column: $table.totalLessonsCompleted, builder: (column) => column);

  GeneratedColumn<int> get totalModulesCompleted => $composableBuilder(
      column: $table.totalModulesCompleted, builder: (column) => column);

  GeneratedColumn<String> get unlockedAchievementsJson => $composableBuilder(
      column: $table.unlockedAchievementsJson, builder: (column) => column);

  GeneratedColumn<String> get unlockedPresetsJson => $composableBuilder(
      column: $table.unlockedPresetsJson, builder: (column) => column);

  GeneratedColumn<String> get completedLessonIdsJson => $composableBuilder(
      column: $table.completedLessonIdsJson, builder: (column) => column);

  GeneratedColumn<String> get completedModuleIdsJson => $composableBuilder(
      column: $table.completedModuleIdsJson, builder: (column) => column);

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
      column: $table.onboardingComplete, builder: (column) => column);

  GeneratedColumn<String> get preferredTuning => $composableBuilder(
      column: $table.preferredTuning, builder: (column) => column);

  GeneratedColumn<bool> get isDarkMode => $composableBuilder(
      column: $table.isDarkMode, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  GeneratedColumn<bool> get soundEffectsEnabled => $composableBuilder(
      column: $table.soundEffectsEnabled, builder: (column) => column);

  GeneratedColumn<double> get masterVolume => $composableBuilder(
      column: $table.masterVolume, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<bool> get isGuest =>
      $composableBuilder(column: $table.isGuest, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTableTable,
    UserProfilesTableData,
    $$UserProfilesTableTableFilterComposer,
    $$UserProfilesTableTableOrderingComposer,
    $$UserProfilesTableTableAnnotationComposer,
    $$UserProfilesTableTableCreateCompanionBuilder,
    $$UserProfilesTableTableUpdateCompanionBuilder,
    (
      UserProfilesTableData,
      BaseReferences<_$AppDatabase, $UserProfilesTableTable,
          UserProfilesTableData>
    ),
    UserProfilesTableData,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableTableManager(
      _$AppDatabase db, $UserProfilesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> avatarUrl = const Value.absent(),
            Value<int> totalXp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastPracticeDate = const Value.absent(),
            Value<int> totalPracticeMinutes = const Value.absent(),
            Value<int> totalLessonsCompleted = const Value.absent(),
            Value<int> totalModulesCompleted = const Value.absent(),
            Value<String> unlockedAchievementsJson = const Value.absent(),
            Value<String> unlockedPresetsJson = const Value.absent(),
            Value<String> completedLessonIdsJson = const Value.absent(),
            Value<String> completedModuleIdsJson = const Value.absent(),
            Value<bool> onboardingComplete = const Value.absent(),
            Value<String> preferredTuning = const Value.absent(),
            Value<bool> isDarkMode = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<bool> soundEffectsEnabled = const Value.absent(),
            Value<double> masterVolume = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<bool> isGuest = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfilesTableCompanion(
            id: id,
            username: username,
            email: email,
            avatarUrl: avatarUrl,
            totalXp: totalXp,
            level: level,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastPracticeDate: lastPracticeDate,
            totalPracticeMinutes: totalPracticeMinutes,
            totalLessonsCompleted: totalLessonsCompleted,
            totalModulesCompleted: totalModulesCompleted,
            unlockedAchievementsJson: unlockedAchievementsJson,
            unlockedPresetsJson: unlockedPresetsJson,
            completedLessonIdsJson: completedLessonIdsJson,
            completedModuleIdsJson: completedModuleIdsJson,
            onboardingComplete: onboardingComplete,
            preferredTuning: preferredTuning,
            isDarkMode: isDarkMode,
            notificationsEnabled: notificationsEnabled,
            soundEffectsEnabled: soundEffectsEnabled,
            masterVolume: masterVolume,
            language: language,
            isGuest: isGuest,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> username = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> avatarUrl = const Value.absent(),
            Value<int> totalXp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> currentStreak = const Value.absent(),
            Value<int> longestStreak = const Value.absent(),
            Value<DateTime?> lastPracticeDate = const Value.absent(),
            Value<int> totalPracticeMinutes = const Value.absent(),
            Value<int> totalLessonsCompleted = const Value.absent(),
            Value<int> totalModulesCompleted = const Value.absent(),
            Value<String> unlockedAchievementsJson = const Value.absent(),
            Value<String> unlockedPresetsJson = const Value.absent(),
            Value<String> completedLessonIdsJson = const Value.absent(),
            Value<String> completedModuleIdsJson = const Value.absent(),
            Value<bool> onboardingComplete = const Value.absent(),
            Value<String> preferredTuning = const Value.absent(),
            Value<bool> isDarkMode = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<bool> soundEffectsEnabled = const Value.absent(),
            Value<double> masterVolume = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<bool> isGuest = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfilesTableCompanion.insert(
            id: id,
            username: username,
            email: email,
            avatarUrl: avatarUrl,
            totalXp: totalXp,
            level: level,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastPracticeDate: lastPracticeDate,
            totalPracticeMinutes: totalPracticeMinutes,
            totalLessonsCompleted: totalLessonsCompleted,
            totalModulesCompleted: totalModulesCompleted,
            unlockedAchievementsJson: unlockedAchievementsJson,
            unlockedPresetsJson: unlockedPresetsJson,
            completedLessonIdsJson: completedLessonIdsJson,
            completedModuleIdsJson: completedModuleIdsJson,
            onboardingComplete: onboardingComplete,
            preferredTuning: preferredTuning,
            isDarkMode: isDarkMode,
            notificationsEnabled: notificationsEnabled,
            soundEffectsEnabled: soundEffectsEnabled,
            masterVolume: masterVolume,
            language: language,
            isGuest: isGuest,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTableTable,
    UserProfilesTableData,
    $$UserProfilesTableTableFilterComposer,
    $$UserProfilesTableTableOrderingComposer,
    $$UserProfilesTableTableAnnotationComposer,
    $$UserProfilesTableTableCreateCompanionBuilder,
    $$UserProfilesTableTableUpdateCompanionBuilder,
    (
      UserProfilesTableData,
      BaseReferences<_$AppDatabase, $UserProfilesTableTable,
          UserProfilesTableData>
    ),
    UserProfilesTableData,
    PrefetchHooks Function()>;
typedef $$ModuleProgressTableTableCreateCompanionBuilder
    = ModuleProgressTableCompanion Function({
  required String moduleId,
  required String userId,
  Value<bool> isUnlocked,
  Value<bool> isCompleted,
  Value<double> completionPercentage,
  Value<int> xpEarned,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<DateTime?> lastAccessedAt,
  Value<int> rowid,
});
typedef $$ModuleProgressTableTableUpdateCompanionBuilder
    = ModuleProgressTableCompanion Function({
  Value<String> moduleId,
  Value<String> userId,
  Value<bool> isUnlocked,
  Value<bool> isCompleted,
  Value<double> completionPercentage,
  Value<int> xpEarned,
  Value<DateTime?> startedAt,
  Value<DateTime?> completedAt,
  Value<DateTime?> lastAccessedAt,
  Value<int> rowid,
});

class $$ModuleProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $ModuleProgressTableTable> {
  $$ModuleProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnFilters(column));
}

class $$ModuleProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ModuleProgressTableTable> {
  $$ModuleProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$ModuleProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModuleProgressTableTable> {
  $$ModuleProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get isUnlocked => $composableBuilder(
      column: $table.isUnlocked, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<double> get completionPercentage => $composableBuilder(
      column: $table.completionPercentage, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt, builder: (column) => column);
}

class $$ModuleProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ModuleProgressTableTable,
    ModuleProgressTableData,
    $$ModuleProgressTableTableFilterComposer,
    $$ModuleProgressTableTableOrderingComposer,
    $$ModuleProgressTableTableAnnotationComposer,
    $$ModuleProgressTableTableCreateCompanionBuilder,
    $$ModuleProgressTableTableUpdateCompanionBuilder,
    (
      ModuleProgressTableData,
      BaseReferences<_$AppDatabase, $ModuleProgressTableTable,
          ModuleProgressTableData>
    ),
    ModuleProgressTableData,
    PrefetchHooks Function()> {
  $$ModuleProgressTableTableTableManager(
      _$AppDatabase db, $ModuleProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModuleProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModuleProgressTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModuleProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> moduleId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<bool> isUnlocked = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<double> completionPercentage = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime?> lastAccessedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModuleProgressTableCompanion(
            moduleId: moduleId,
            userId: userId,
            isUnlocked: isUnlocked,
            isCompleted: isCompleted,
            completionPercentage: completionPercentage,
            xpEarned: xpEarned,
            startedAt: startedAt,
            completedAt: completedAt,
            lastAccessedAt: lastAccessedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String moduleId,
            required String userId,
            Value<bool> isUnlocked = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<double> completionPercentage = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<DateTime?> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime?> lastAccessedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ModuleProgressTableCompanion.insert(
            moduleId: moduleId,
            userId: userId,
            isUnlocked: isUnlocked,
            isCompleted: isCompleted,
            completionPercentage: completionPercentage,
            xpEarned: xpEarned,
            startedAt: startedAt,
            completedAt: completedAt,
            lastAccessedAt: lastAccessedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ModuleProgressTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ModuleProgressTableTable,
    ModuleProgressTableData,
    $$ModuleProgressTableTableFilterComposer,
    $$ModuleProgressTableTableOrderingComposer,
    $$ModuleProgressTableTableAnnotationComposer,
    $$ModuleProgressTableTableCreateCompanionBuilder,
    $$ModuleProgressTableTableUpdateCompanionBuilder,
    (
      ModuleProgressTableData,
      BaseReferences<_$AppDatabase, $ModuleProgressTableTable,
          ModuleProgressTableData>
    ),
    ModuleProgressTableData,
    PrefetchHooks Function()>;
typedef $$LessonProgressTableTableCreateCompanionBuilder
    = LessonProgressTableCompanion Function({
  required String lessonId,
  required String userId,
  required String moduleId,
  Value<bool> isCompleted,
  Value<double> bestAccuracy,
  Value<int> stars,
  Value<int> attempts,
  Value<int> xpEarned,
  Value<DateTime?> completedAt,
  Value<DateTime?> lastAttemptAt,
  Value<int> rowid,
});
typedef $$LessonProgressTableTableUpdateCompanionBuilder
    = LessonProgressTableCompanion Function({
  Value<String> lessonId,
  Value<String> userId,
  Value<String> moduleId,
  Value<bool> isCompleted,
  Value<double> bestAccuracy,
  Value<int> stars,
  Value<int> attempts,
  Value<int> xpEarned,
  Value<DateTime?> completedAt,
  Value<DateTime?> lastAttemptAt,
  Value<int> rowid,
});

class $$LessonProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bestAccuracy => $composableBuilder(
      column: $table.bestAccuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));
}

class $$LessonProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleId => $composableBuilder(
      column: $table.moduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bestAccuracy => $composableBuilder(
      column: $table.bestAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stars => $composableBuilder(
      column: $table.stars, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));
}

class $$LessonProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<double> get bestAccuracy => $composableBuilder(
      column: $table.bestAccuracy, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);
}

class $$LessonProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonProgressTableTable,
    LessonProgressTableData,
    $$LessonProgressTableTableFilterComposer,
    $$LessonProgressTableTableOrderingComposer,
    $$LessonProgressTableTableAnnotationComposer,
    $$LessonProgressTableTableCreateCompanionBuilder,
    $$LessonProgressTableTableUpdateCompanionBuilder,
    (
      LessonProgressTableData,
      BaseReferences<_$AppDatabase, $LessonProgressTableTable,
          LessonProgressTableData>
    ),
    LessonProgressTableData,
    PrefetchHooks Function()> {
  $$LessonProgressTableTableTableManager(
      _$AppDatabase db, $LessonProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> lessonId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> moduleId = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<double> bestAccuracy = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressTableCompanion(
            lessonId: lessonId,
            userId: userId,
            moduleId: moduleId,
            isCompleted: isCompleted,
            bestAccuracy: bestAccuracy,
            stars: stars,
            attempts: attempts,
            xpEarned: xpEarned,
            completedAt: completedAt,
            lastAttemptAt: lastAttemptAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String lessonId,
            required String userId,
            required String moduleId,
            Value<bool> isCompleted = const Value.absent(),
            Value<double> bestAccuracy = const Value.absent(),
            Value<int> stars = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LessonProgressTableCompanion.insert(
            lessonId: lessonId,
            userId: userId,
            moduleId: moduleId,
            isCompleted: isCompleted,
            bestAccuracy: bestAccuracy,
            stars: stars,
            attempts: attempts,
            xpEarned: xpEarned,
            completedAt: completedAt,
            lastAttemptAt: lastAttemptAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LessonProgressTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonProgressTableTable,
    LessonProgressTableData,
    $$LessonProgressTableTableFilterComposer,
    $$LessonProgressTableTableOrderingComposer,
    $$LessonProgressTableTableAnnotationComposer,
    $$LessonProgressTableTableCreateCompanionBuilder,
    $$LessonProgressTableTableUpdateCompanionBuilder,
    (
      LessonProgressTableData,
      BaseReferences<_$AppDatabase, $LessonProgressTableTable,
          LessonProgressTableData>
    ),
    LessonProgressTableData,
    PrefetchHooks Function()>;
typedef $$ExerciseResultsTableTableCreateCompanionBuilder
    = ExerciseResultsTableCompanion Function({
  Value<int> id,
  required String exerciseId,
  required String lessonId,
  required String userId,
  required String sessionId,
  Value<double> accuracy,
  Value<int> durationSeconds,
  Value<int> notesPlayed,
  Value<bool> passed,
  required DateTime completedAt,
});
typedef $$ExerciseResultsTableTableUpdateCompanionBuilder
    = ExerciseResultsTableCompanion Function({
  Value<int> id,
  Value<String> exerciseId,
  Value<String> lessonId,
  Value<String> userId,
  Value<String> sessionId,
  Value<double> accuracy,
  Value<int> durationSeconds,
  Value<int> notesPlayed,
  Value<bool> passed,
  Value<DateTime> completedAt,
});

class $$ExerciseResultsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseResultsTableTable> {
  $$ExerciseResultsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get passed => $composableBuilder(
      column: $table.passed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$ExerciseResultsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseResultsTableTable> {
  $$ExerciseResultsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get passed => $composableBuilder(
      column: $table.passed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$ExerciseResultsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseResultsTableTable> {
  $$ExerciseResultsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => column);

  GeneratedColumn<bool> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$ExerciseResultsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseResultsTableTable,
    ExerciseResultsTableData,
    $$ExerciseResultsTableTableFilterComposer,
    $$ExerciseResultsTableTableOrderingComposer,
    $$ExerciseResultsTableTableAnnotationComposer,
    $$ExerciseResultsTableTableCreateCompanionBuilder,
    $$ExerciseResultsTableTableUpdateCompanionBuilder,
    (
      ExerciseResultsTableData,
      BaseReferences<_$AppDatabase, $ExerciseResultsTableTable,
          ExerciseResultsTableData>
    ),
    ExerciseResultsTableData,
    PrefetchHooks Function()> {
  $$ExerciseResultsTableTableTableManager(
      _$AppDatabase db, $ExerciseResultsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseResultsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseResultsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseResultsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<double> accuracy = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<int> notesPlayed = const Value.absent(),
            Value<bool> passed = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
          }) =>
              ExerciseResultsTableCompanion(
            id: id,
            exerciseId: exerciseId,
            lessonId: lessonId,
            userId: userId,
            sessionId: sessionId,
            accuracy: accuracy,
            durationSeconds: durationSeconds,
            notesPlayed: notesPlayed,
            passed: passed,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String exerciseId,
            required String lessonId,
            required String userId,
            required String sessionId,
            Value<double> accuracy = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<int> notesPlayed = const Value.absent(),
            Value<bool> passed = const Value.absent(),
            required DateTime completedAt,
          }) =>
              ExerciseResultsTableCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            lessonId: lessonId,
            userId: userId,
            sessionId: sessionId,
            accuracy: accuracy,
            durationSeconds: durationSeconds,
            notesPlayed: notesPlayed,
            passed: passed,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExerciseResultsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ExerciseResultsTableTable,
        ExerciseResultsTableData,
        $$ExerciseResultsTableTableFilterComposer,
        $$ExerciseResultsTableTableOrderingComposer,
        $$ExerciseResultsTableTableAnnotationComposer,
        $$ExerciseResultsTableTableCreateCompanionBuilder,
        $$ExerciseResultsTableTableUpdateCompanionBuilder,
        (
          ExerciseResultsTableData,
          BaseReferences<_$AppDatabase, $ExerciseResultsTableTable,
              ExerciseResultsTableData>
        ),
        ExerciseResultsTableData,
        PrefetchHooks Function()>;
typedef $$SpacedRepetitionItemsTableTableCreateCompanionBuilder
    = SpacedRepetitionItemsTableCompanion Function({
  required String id,
  required String userId,
  required String itemType,
  required String itemId,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<int> repetitions,
  required DateTime nextReviewDate,
  Value<DateTime?> lastReviewDate,
  Value<int> lastQuality,
  Value<int> rowid,
});
typedef $$SpacedRepetitionItemsTableTableUpdateCompanionBuilder
    = SpacedRepetitionItemsTableCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> itemType,
  Value<String> itemId,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<int> repetitions,
  Value<DateTime> nextReviewDate,
  Value<DateTime?> lastReviewDate,
  Value<int> lastQuality,
  Value<int> rowid,
});

class $$SpacedRepetitionItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SpacedRepetitionItemsTableTable> {
  $$SpacedRepetitionItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
      column: $table.nextReviewDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReviewDate => $composableBuilder(
      column: $table.lastReviewDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastQuality => $composableBuilder(
      column: $table.lastQuality, builder: (column) => ColumnFilters(column));
}

class $$SpacedRepetitionItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SpacedRepetitionItemsTableTable> {
  $$SpacedRepetitionItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
      column: $table.nextReviewDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReviewDate => $composableBuilder(
      column: $table.lastReviewDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastQuality => $composableBuilder(
      column: $table.lastQuality, builder: (column) => ColumnOrderings(column));
}

class $$SpacedRepetitionItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpacedRepetitionItemsTableTable> {
  $$SpacedRepetitionItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => column);

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
      column: $table.nextReviewDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewDate => $composableBuilder(
      column: $table.lastReviewDate, builder: (column) => column);

  GeneratedColumn<int> get lastQuality => $composableBuilder(
      column: $table.lastQuality, builder: (column) => column);
}

class $$SpacedRepetitionItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpacedRepetitionItemsTableTable,
    SpacedRepetitionItemsTableData,
    $$SpacedRepetitionItemsTableTableFilterComposer,
    $$SpacedRepetitionItemsTableTableOrderingComposer,
    $$SpacedRepetitionItemsTableTableAnnotationComposer,
    $$SpacedRepetitionItemsTableTableCreateCompanionBuilder,
    $$SpacedRepetitionItemsTableTableUpdateCompanionBuilder,
    (
      SpacedRepetitionItemsTableData,
      BaseReferences<_$AppDatabase, $SpacedRepetitionItemsTableTable,
          SpacedRepetitionItemsTableData>
    ),
    SpacedRepetitionItemsTableData,
    PrefetchHooks Function()> {
  $$SpacedRepetitionItemsTableTableTableManager(
      _$AppDatabase db, $SpacedRepetitionItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpacedRepetitionItemsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SpacedRepetitionItemsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpacedRepetitionItemsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> itemType = const Value.absent(),
            Value<String> itemId = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<DateTime> nextReviewDate = const Value.absent(),
            Value<DateTime?> lastReviewDate = const Value.absent(),
            Value<int> lastQuality = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpacedRepetitionItemsTableCompanion(
            id: id,
            userId: userId,
            itemType: itemType,
            itemId: itemId,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            repetitions: repetitions,
            nextReviewDate: nextReviewDate,
            lastReviewDate: lastReviewDate,
            lastQuality: lastQuality,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String itemType,
            required String itemId,
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            required DateTime nextReviewDate,
            Value<DateTime?> lastReviewDate = const Value.absent(),
            Value<int> lastQuality = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpacedRepetitionItemsTableCompanion.insert(
            id: id,
            userId: userId,
            itemType: itemType,
            itemId: itemId,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            repetitions: repetitions,
            nextReviewDate: nextReviewDate,
            lastReviewDate: lastReviewDate,
            lastQuality: lastQuality,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SpacedRepetitionItemsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SpacedRepetitionItemsTableTable,
        SpacedRepetitionItemsTableData,
        $$SpacedRepetitionItemsTableTableFilterComposer,
        $$SpacedRepetitionItemsTableTableOrderingComposer,
        $$SpacedRepetitionItemsTableTableAnnotationComposer,
        $$SpacedRepetitionItemsTableTableCreateCompanionBuilder,
        $$SpacedRepetitionItemsTableTableUpdateCompanionBuilder,
        (
          SpacedRepetitionItemsTableData,
          BaseReferences<_$AppDatabase, $SpacedRepetitionItemsTableTable,
              SpacedRepetitionItemsTableData>
        ),
        SpacedRepetitionItemsTableData,
        PrefetchHooks Function()>;
typedef $$AchievementsTableTableCreateCompanionBuilder
    = AchievementsTableCompanion Function({
  required String key,
  required String userId,
  required DateTime unlockedAt,
  Value<int> rowid,
});
typedef $$AchievementsTableTableUpdateCompanionBuilder
    = AchievementsTableCompanion Function({
  Value<String> key,
  Value<String> userId,
  Value<DateTime> unlockedAt,
  Value<int> rowid,
});

class $$AchievementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnFilters(column));
}

class $$AchievementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => ColumnOrderings(column));
}

class $$AchievementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
      column: $table.unlockedAt, builder: (column) => column);
}

class $$AchievementsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AchievementsTableTable,
    AchievementsTableData,
    $$AchievementsTableTableFilterComposer,
    $$AchievementsTableTableOrderingComposer,
    $$AchievementsTableTableAnnotationComposer,
    $$AchievementsTableTableCreateCompanionBuilder,
    $$AchievementsTableTableUpdateCompanionBuilder,
    (
      AchievementsTableData,
      BaseReferences<_$AppDatabase, $AchievementsTableTable,
          AchievementsTableData>
    ),
    AchievementsTableData,
    PrefetchHooks Function()> {
  $$AchievementsTableTableTableManager(
      _$AppDatabase db, $AchievementsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> unlockedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsTableCompanion(
            key: key,
            userId: userId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String userId,
            required DateTime unlockedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AchievementsTableCompanion.insert(
            key: key,
            userId: userId,
            unlockedAt: unlockedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AchievementsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AchievementsTableTable,
    AchievementsTableData,
    $$AchievementsTableTableFilterComposer,
    $$AchievementsTableTableOrderingComposer,
    $$AchievementsTableTableAnnotationComposer,
    $$AchievementsTableTableCreateCompanionBuilder,
    $$AchievementsTableTableUpdateCompanionBuilder,
    (
      AchievementsTableData,
      BaseReferences<_$AppDatabase, $AchievementsTableTable,
          AchievementsTableData>
    ),
    AchievementsTableData,
    PrefetchHooks Function()>;
typedef $$PracticeSessionsTableTableCreateCompanionBuilder
    = PracticeSessionsTableCompanion Function({
  required String id,
  required String userId,
  required DateTime startTime,
  Value<DateTime?> endTime,
  Value<int> durationSeconds,
  Value<String> lessonsCompletedJson,
  Value<String> exercisesCompletedJson,
  Value<int> xpEarned,
  Value<double> averageAccuracy,
  Value<int> notesPlayed,
  Value<int> chordsPlayed,
  Value<String> currentModuleId,
  Value<String> currentLessonId,
  Value<bool> isActive,
  Value<String> achievementsUnlockedJson,
  Value<bool> wasRecorded,
  Value<String> recordingPath,
  Value<int> rowid,
});
typedef $$PracticeSessionsTableTableUpdateCompanionBuilder
    = PracticeSessionsTableCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<DateTime> startTime,
  Value<DateTime?> endTime,
  Value<int> durationSeconds,
  Value<String> lessonsCompletedJson,
  Value<String> exercisesCompletedJson,
  Value<int> xpEarned,
  Value<double> averageAccuracy,
  Value<int> notesPlayed,
  Value<int> chordsPlayed,
  Value<String> currentModuleId,
  Value<String> currentLessonId,
  Value<bool> isActive,
  Value<String> achievementsUnlockedJson,
  Value<bool> wasRecorded,
  Value<String> recordingPath,
  Value<int> rowid,
});

class $$PracticeSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTableTable> {
  $$PracticeSessionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonsCompletedJson => $composableBuilder(
      column: $table.lessonsCompletedJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exercisesCompletedJson => $composableBuilder(
      column: $table.exercisesCompletedJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get averageAccuracy => $composableBuilder(
      column: $table.averageAccuracy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chordsPlayed => $composableBuilder(
      column: $table.chordsPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentModuleId => $composableBuilder(
      column: $table.currentModuleId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentLessonId => $composableBuilder(
      column: $table.currentLessonId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get achievementsUnlockedJson => $composableBuilder(
      column: $table.achievementsUnlockedJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get wasRecorded => $composableBuilder(
      column: $table.wasRecorded, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordingPath => $composableBuilder(
      column: $table.recordingPath, builder: (column) => ColumnFilters(column));
}

class $$PracticeSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTableTable> {
  $$PracticeSessionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonsCompletedJson => $composableBuilder(
      column: $table.lessonsCompletedJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exercisesCompletedJson => $composableBuilder(
      column: $table.exercisesCompletedJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get averageAccuracy => $composableBuilder(
      column: $table.averageAccuracy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chordsPlayed => $composableBuilder(
      column: $table.chordsPlayed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentModuleId => $composableBuilder(
      column: $table.currentModuleId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentLessonId => $composableBuilder(
      column: $table.currentLessonId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get achievementsUnlockedJson => $composableBuilder(
      column: $table.achievementsUnlockedJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get wasRecorded => $composableBuilder(
      column: $table.wasRecorded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordingPath => $composableBuilder(
      column: $table.recordingPath,
      builder: (column) => ColumnOrderings(column));
}

class $$PracticeSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTableTable> {
  $$PracticeSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<String> get lessonsCompletedJson => $composableBuilder(
      column: $table.lessonsCompletedJson, builder: (column) => column);

  GeneratedColumn<String> get exercisesCompletedJson => $composableBuilder(
      column: $table.exercisesCompletedJson, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<double> get averageAccuracy => $composableBuilder(
      column: $table.averageAccuracy, builder: (column) => column);

  GeneratedColumn<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => column);

  GeneratedColumn<int> get chordsPlayed => $composableBuilder(
      column: $table.chordsPlayed, builder: (column) => column);

  GeneratedColumn<String> get currentModuleId => $composableBuilder(
      column: $table.currentModuleId, builder: (column) => column);

  GeneratedColumn<String> get currentLessonId => $composableBuilder(
      column: $table.currentLessonId, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get achievementsUnlockedJson => $composableBuilder(
      column: $table.achievementsUnlockedJson, builder: (column) => column);

  GeneratedColumn<bool> get wasRecorded => $composableBuilder(
      column: $table.wasRecorded, builder: (column) => column);

  GeneratedColumn<String> get recordingPath => $composableBuilder(
      column: $table.recordingPath, builder: (column) => column);
}

class $$PracticeSessionsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PracticeSessionsTableTable,
    PracticeSessionsTableData,
    $$PracticeSessionsTableTableFilterComposer,
    $$PracticeSessionsTableTableOrderingComposer,
    $$PracticeSessionsTableTableAnnotationComposer,
    $$PracticeSessionsTableTableCreateCompanionBuilder,
    $$PracticeSessionsTableTableUpdateCompanionBuilder,
    (
      PracticeSessionsTableData,
      BaseReferences<_$AppDatabase, $PracticeSessionsTableTable,
          PracticeSessionsTableData>
    ),
    PracticeSessionsTableData,
    PrefetchHooks Function()> {
  $$PracticeSessionsTableTableTableManager(
      _$AppDatabase db, $PracticeSessionsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeSessionsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeSessionsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeSessionsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<String> lessonsCompletedJson = const Value.absent(),
            Value<String> exercisesCompletedJson = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<double> averageAccuracy = const Value.absent(),
            Value<int> notesPlayed = const Value.absent(),
            Value<int> chordsPlayed = const Value.absent(),
            Value<String> currentModuleId = const Value.absent(),
            Value<String> currentLessonId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> achievementsUnlockedJson = const Value.absent(),
            Value<bool> wasRecorded = const Value.absent(),
            Value<String> recordingPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PracticeSessionsTableCompanion(
            id: id,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            durationSeconds: durationSeconds,
            lessonsCompletedJson: lessonsCompletedJson,
            exercisesCompletedJson: exercisesCompletedJson,
            xpEarned: xpEarned,
            averageAccuracy: averageAccuracy,
            notesPlayed: notesPlayed,
            chordsPlayed: chordsPlayed,
            currentModuleId: currentModuleId,
            currentLessonId: currentLessonId,
            isActive: isActive,
            achievementsUnlockedJson: achievementsUnlockedJson,
            wasRecorded: wasRecorded,
            recordingPath: recordingPath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required DateTime startTime,
            Value<DateTime?> endTime = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<String> lessonsCompletedJson = const Value.absent(),
            Value<String> exercisesCompletedJson = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<double> averageAccuracy = const Value.absent(),
            Value<int> notesPlayed = const Value.absent(),
            Value<int> chordsPlayed = const Value.absent(),
            Value<String> currentModuleId = const Value.absent(),
            Value<String> currentLessonId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> achievementsUnlockedJson = const Value.absent(),
            Value<bool> wasRecorded = const Value.absent(),
            Value<String> recordingPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PracticeSessionsTableCompanion.insert(
            id: id,
            userId: userId,
            startTime: startTime,
            endTime: endTime,
            durationSeconds: durationSeconds,
            lessonsCompletedJson: lessonsCompletedJson,
            exercisesCompletedJson: exercisesCompletedJson,
            xpEarned: xpEarned,
            averageAccuracy: averageAccuracy,
            notesPlayed: notesPlayed,
            chordsPlayed: chordsPlayed,
            currentModuleId: currentModuleId,
            currentLessonId: currentLessonId,
            isActive: isActive,
            achievementsUnlockedJson: achievementsUnlockedJson,
            wasRecorded: wasRecorded,
            recordingPath: recordingPath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PracticeSessionsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $PracticeSessionsTableTable,
        PracticeSessionsTableData,
        $$PracticeSessionsTableTableFilterComposer,
        $$PracticeSessionsTableTableOrderingComposer,
        $$PracticeSessionsTableTableAnnotationComposer,
        $$PracticeSessionsTableTableCreateCompanionBuilder,
        $$PracticeSessionsTableTableUpdateCompanionBuilder,
        (
          PracticeSessionsTableData,
          BaseReferences<_$AppDatabase, $PracticeSessionsTableTable,
              PracticeSessionsTableData>
        ),
        PracticeSessionsTableData,
        PrefetchHooks Function()>;
typedef $$RecordingsTableTableCreateCompanionBuilder = RecordingsTableCompanion
    Function({
  required String id,
  required String userId,
  required String sessionId,
  Value<String> lessonId,
  required String filePath,
  Value<int> durationSeconds,
  Value<String> title,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RecordingsTableTableUpdateCompanionBuilder = RecordingsTableCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> sessionId,
  Value<String> lessonId,
  Value<String> filePath,
  Value<int> durationSeconds,
  Value<String> title,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RecordingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecordingsTableTable> {
  $$RecordingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RecordingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordingsTableTable> {
  $$RecordingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonId => $composableBuilder(
      column: $table.lessonId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RecordingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordingsTableTable> {
  $$RecordingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecordingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecordingsTableTable,
    RecordingsTableData,
    $$RecordingsTableTableFilterComposer,
    $$RecordingsTableTableOrderingComposer,
    $$RecordingsTableTableAnnotationComposer,
    $$RecordingsTableTableCreateCompanionBuilder,
    $$RecordingsTableTableUpdateCompanionBuilder,
    (
      RecordingsTableData,
      BaseReferences<_$AppDatabase, $RecordingsTableTable, RecordingsTableData>
    ),
    RecordingsTableData,
    PrefetchHooks Function()> {
  $$RecordingsTableTableTableManager(
      _$AppDatabase db, $RecordingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> lessonId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecordingsTableCompanion(
            id: id,
            userId: userId,
            sessionId: sessionId,
            lessonId: lessonId,
            filePath: filePath,
            durationSeconds: durationSeconds,
            title: title,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String sessionId,
            Value<String> lessonId = const Value.absent(),
            required String filePath,
            Value<int> durationSeconds = const Value.absent(),
            Value<String> title = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RecordingsTableCompanion.insert(
            id: id,
            userId: userId,
            sessionId: sessionId,
            lessonId: lessonId,
            filePath: filePath,
            durationSeconds: durationSeconds,
            title: title,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecordingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecordingsTableTable,
    RecordingsTableData,
    $$RecordingsTableTableFilterComposer,
    $$RecordingsTableTableOrderingComposer,
    $$RecordingsTableTableAnnotationComposer,
    $$RecordingsTableTableCreateCompanionBuilder,
    $$RecordingsTableTableUpdateCompanionBuilder,
    (
      RecordingsTableData,
      BaseReferences<_$AppDatabase, $RecordingsTableTable, RecordingsTableData>
    ),
    RecordingsTableData,
    PrefetchHooks Function()>;
typedef $$DailyStatsTableTableCreateCompanionBuilder = DailyStatsTableCompanion
    Function({
  required String userId,
  required DateTime date,
  Value<int> practiceMinutes,
  Value<int> xpEarned,
  Value<int> lessonsCompleted,
  Value<int> notesPlayed,
  Value<bool> streakMaintained,
  Value<int> rowid,
});
typedef $$DailyStatsTableTableUpdateCompanionBuilder = DailyStatsTableCompanion
    Function({
  Value<String> userId,
  Value<DateTime> date,
  Value<int> practiceMinutes,
  Value<int> xpEarned,
  Value<int> lessonsCompleted,
  Value<int> notesPlayed,
  Value<bool> streakMaintained,
  Value<int> rowid,
});

class $$DailyStatsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStatsTableTable> {
  $$DailyStatsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get practiceMinutes => $composableBuilder(
      column: $table.practiceMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lessonsCompleted => $composableBuilder(
      column: $table.lessonsCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get streakMaintained => $composableBuilder(
      column: $table.streakMaintained,
      builder: (column) => ColumnFilters(column));
}

class $$DailyStatsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStatsTableTable> {
  $$DailyStatsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get practiceMinutes => $composableBuilder(
      column: $table.practiceMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lessonsCompleted => $composableBuilder(
      column: $table.lessonsCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get streakMaintained => $composableBuilder(
      column: $table.streakMaintained,
      builder: (column) => ColumnOrderings(column));
}

class $$DailyStatsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStatsTableTable> {
  $$DailyStatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get practiceMinutes => $composableBuilder(
      column: $table.practiceMinutes, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<int> get lessonsCompleted => $composableBuilder(
      column: $table.lessonsCompleted, builder: (column) => column);

  GeneratedColumn<int> get notesPlayed => $composableBuilder(
      column: $table.notesPlayed, builder: (column) => column);

  GeneratedColumn<bool> get streakMaintained => $composableBuilder(
      column: $table.streakMaintained, builder: (column) => column);
}

class $$DailyStatsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyStatsTableTable,
    DailyStatsTableData,
    $$DailyStatsTableTableFilterComposer,
    $$DailyStatsTableTableOrderingComposer,
    $$DailyStatsTableTableAnnotationComposer,
    $$DailyStatsTableTableCreateCompanionBuilder,
    $$DailyStatsTableTableUpdateCompanionBuilder,
    (
      DailyStatsTableData,
      BaseReferences<_$AppDatabase, $DailyStatsTableTable, DailyStatsTableData>
    ),
    DailyStatsTableData,
    PrefetchHooks Function()> {
  $$DailyStatsTableTableTableManager(
      _$AppDatabase db, $DailyStatsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> practiceMinutes = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<int> lessonsCompleted = const Value.absent(),
            Value<int> notesPlayed = const Value.absent(),
            Value<bool> streakMaintained = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyStatsTableCompanion(
            userId: userId,
            date: date,
            practiceMinutes: practiceMinutes,
            xpEarned: xpEarned,
            lessonsCompleted: lessonsCompleted,
            notesPlayed: notesPlayed,
            streakMaintained: streakMaintained,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required DateTime date,
            Value<int> practiceMinutes = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<int> lessonsCompleted = const Value.absent(),
            Value<int> notesPlayed = const Value.absent(),
            Value<bool> streakMaintained = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyStatsTableCompanion.insert(
            userId: userId,
            date: date,
            practiceMinutes: practiceMinutes,
            xpEarned: xpEarned,
            lessonsCompleted: lessonsCompleted,
            notesPlayed: notesPlayed,
            streakMaintained: streakMaintained,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyStatsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyStatsTableTable,
    DailyStatsTableData,
    $$DailyStatsTableTableFilterComposer,
    $$DailyStatsTableTableOrderingComposer,
    $$DailyStatsTableTableAnnotationComposer,
    $$DailyStatsTableTableCreateCompanionBuilder,
    $$DailyStatsTableTableUpdateCompanionBuilder,
    (
      DailyStatsTableData,
      BaseReferences<_$AppDatabase, $DailyStatsTableTable, DailyStatsTableData>
    ),
    DailyStatsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableTableManager get userProfilesTable =>
      $$UserProfilesTableTableTableManager(_db, _db.userProfilesTable);
  $$ModuleProgressTableTableTableManager get moduleProgressTable =>
      $$ModuleProgressTableTableTableManager(_db, _db.moduleProgressTable);
  $$LessonProgressTableTableTableManager get lessonProgressTable =>
      $$LessonProgressTableTableTableManager(_db, _db.lessonProgressTable);
  $$ExerciseResultsTableTableTableManager get exerciseResultsTable =>
      $$ExerciseResultsTableTableTableManager(_db, _db.exerciseResultsTable);
  $$SpacedRepetitionItemsTableTableTableManager
      get spacedRepetitionItemsTable =>
          $$SpacedRepetitionItemsTableTableTableManager(
              _db, _db.spacedRepetitionItemsTable);
  $$AchievementsTableTableTableManager get achievementsTable =>
      $$AchievementsTableTableTableManager(_db, _db.achievementsTable);
  $$PracticeSessionsTableTableTableManager get practiceSessionsTable =>
      $$PracticeSessionsTableTableTableManager(_db, _db.practiceSessionsTable);
  $$RecordingsTableTableTableManager get recordingsTable =>
      $$RecordingsTableTableTableManager(_db, _db.recordingsTable);
  $$DailyStatsTableTableTableManager get dailyStatsTable =>
      $$DailyStatsTableTableTableManager(_db, _db.dailyStatsTable);
}
