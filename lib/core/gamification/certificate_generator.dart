import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

class CertificateDisplayPage extends ConsumerWidget {
  final Certificate certificate;

  const CertificateDisplayPage({super.key, required this.certificate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cert = certificate;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text('Zertifikat'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => CertificateGenerator.share(cert),
            tooltip: 'Teilen',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: const Color(0xFF1A1A2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: cert.primaryColor, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cert.primaryColor.withOpacity(0.15),
                    ),
                    child: Icon(cert.icon, size: 44, color: cert.primaryColor),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    cert.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: cert.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cert.subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: cert.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cert.primaryColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      cert.xmariNote,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    DateFormat('dd. MMMM yyyy', 'de').format(cert.earnedAt),
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => CertificateGenerator.share(cert),
                      icon: const Icon(Icons.share),
                      label: const Text('Zertifikat teilen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cert.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
