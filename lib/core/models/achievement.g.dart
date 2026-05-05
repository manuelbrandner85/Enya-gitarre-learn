// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      key: json['key'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String? ??
          'assets/images/achievement_default.png',
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 30,
      isSecret: json['isSecret'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'description': instance.description,
      'iconPath': instance.iconPath,
      'xpReward': instance.xpReward,
      'isSecret': instance.isSecret,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
    };
