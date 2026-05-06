import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

enum CertificateType {
  moduleCompleted,
  firstSong,
  hundredHours,
  streak30,
  allPresetsUnlocked,
  firstJam,
}

class Certificate {
  final CertificateType type;
  final String title;
  final String subtitle;
  final String xmariNote;
  final Color primaryColor;
  final IconData icon;
  final DateTime earnedAt;

  const Certificate({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.xmariNote,
    required this.primaryColor,
    required this.icon,
    required this.earnedAt,
  });
}

class CertificateGenerator {
  CertificateGenerator._();

  static Certificate generate({
    required CertificateType type,
    required String username,
    required String presetName,
  }) {
    switch (type) {
      case CertificateType.moduleCompleted:
        return Certificate(
          type: type,
          title: 'Modul abgeschlossen!',
          subtitle: '$username hat ein weiteres Modul gemeistert',
          xmariNote: 'Gespielt auf der Enya XMARI – $presetName Sound',
          primaryColor: const Color(0xFF7C3AED),
          icon: Icons.school,
          earnedAt: DateTime.now(),
        );
      case CertificateType.firstSong:
        return Certificate(
          type: type,
          title: 'Erster Song gespielt!',
          subtitle: '$username hat seinen ersten vollständigen Song gespielt',
          xmariNote: 'Aufgeführt auf der Enya XMARI Smart Guitar',
          primaryColor: const Color(0xFFFFD700),
          icon: Icons.music_note,
          earnedAt: DateTime.now(),
        );
      case CertificateType.allPresetsUnlocked:
        return Certificate(
          type: type,
          title: 'Alle Sounds freigeschaltet!',
          subtitle: '$username beherrscht Clean, Overdrive, Distortion & High-Gain',
          xmariNote: 'Vollständig freigeschaltet auf der Enya XMARI Smart Guitar',
          primaryColor: const Color(0xFF9C27B0),
          icon: Icons.star,
          earnedAt: DateTime.now(),
        );
      default:
        return Certificate(
          type: type,
          title: 'Meilenstein erreicht!',
          subtitle: '$username macht großartige Fortschritte',
          xmariNote: 'Gespielt auf der Enya XMARI Smart Guitar',
          primaryColor: const Color(0xFF4CAF50),
          icon: Icons.emoji_events,
          earnedAt: DateTime.now(),
        );
    }
  }

  static Future<void> share(Certificate cert) async {
    final text = '🎸 ${cert.title}\n${cert.subtitle}\n${cert.xmariNote}\n\n#EnyaXMARI #EGitarreLe­icht';
    await Share.share(text);
  }
}
