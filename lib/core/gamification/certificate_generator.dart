import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
  final String username;
  final String presetName;
  final double? accuracy;
  String? imagePath;

  Certificate({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.xmariNote,
    required this.primaryColor,
    required this.icon,
    required this.earnedAt,
    required this.username,
    required this.presetName,
    this.accuracy,
    this.imagePath,
  });
}

class CertificateGenerator {
  CertificateGenerator._();

  static Certificate generate({
    required CertificateType type,
    required String username,
    required String presetName,
    double? accuracy,
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
          username: username,
          presetName: presetName,
          accuracy: accuracy,
        );
      case CertificateType.firstSong:
        return Certificate(
          type: type,
          title: 'Erster Song gespielt!',
          subtitle: '$username hat seinen ersten Song gemeistert',
          xmariNote: 'Aufgeführt auf der Enya XMARI Smart Guitar',
          primaryColor: const Color(0xFFFFD700),
          icon: Icons.music_note,
          earnedAt: DateTime.now(),
          username: username,
          presetName: presetName,
          accuracy: accuracy,
        );
      case CertificateType.allPresetsUnlocked:
        return Certificate(
          type: type,
          title: 'Alle Sounds freigeschaltet!',
          subtitle:
              '$username beherrscht Clean, Overdrive, Distortion & High-Gain',
          xmariNote: 'Vollständig freigeschaltet auf der Enya XMARI',
          primaryColor: const Color(0xFF9C27B0),
          icon: Icons.star,
          earnedAt: DateTime.now(),
          username: username,
          presetName: presetName,
          accuracy: accuracy,
        );
      case CertificateType.streak30:
        return Certificate(
          type: type,
          title: '30-Tage-Streak!',
          subtitle: '$username übt seit 30 Tagen täglich',
          xmariNote: 'Trainiert mit der Enya XMARI Smart Guitar',
          primaryColor: const Color(0xFFFF6B35),
          icon: Icons.local_fire_department,
          earnedAt: DateTime.now(),
          username: username,
          presetName: presetName,
          accuracy: accuracy,
        );
      case CertificateType.hundredHours:
        return Certificate(
          type: type,
          title: '100 Stunden geübt!',
          subtitle: '$username hat 100 Übungs-Stunden erreicht',
          xmariNote: 'Gespielt auf der Enya XMARI – Echte Hingabe',
          primaryColor: const Color(0xFF00BCD4),
          icon: Icons.access_time,
          earnedAt: DateTime.now(),
          username: username,
          presetName: presetName,
          accuracy: accuracy,
        );
      case CertificateType.firstJam:
        return Certificate(
          type: type,
          title: 'Erste Jam-Session!',
          subtitle: '$username hat die erste Improvisation gemeistert',
          xmariNote: 'Frei gespielt auf der Enya XMARI Smart Guitar',
          primaryColor: const Color(0xFF4CAF50),
          icon: Icons.queue_music,
          earnedAt: DateTime.now(),
          username: username,
          presetName: presetName,
          accuracy: accuracy,
        );
    }
  }

  // ── Bild-Rendering via dart:ui Canvas ────────────────────────────────────

  /// Rendert das Zertifikat als 1080×1920 PNG-Bild und speichert es in
  /// einem temporären Verzeichnis. Liefert den Pfad zurück.
  static Future<String> renderToImage(Certificate cert) async {
    const w = 1080.0;
    const h = 1920.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h));

    // Hintergrund-Gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
      ).createShader(const Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(const Rect.fromLTWH(0, 0, w, h), bgPaint);

    // Goldener Außen-Rahmen
    const gold = Color(0xFFFFD700);
    final framePaint = Paint()
      ..color = gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawRect(const Rect.fromLTWH(40, 40, w - 80, h - 80), framePaint);
    final innerFramePaint = Paint()
      ..color = gold.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(const Rect.fromLTWH(60, 60, w - 120, h - 120), innerFramePaint);

    // Note-Symbole als Dekoration (Ecken)
    _drawDecorativeNotes(canvas, w, h, gold.withValues(alpha: 0.15));

    // Header: ZERTIFIKAT
    _drawText(
      canvas: canvas,
      text: 'ZERTIFIKAT',
      x: w / 2,
      y: 220,
      style: const TextStyle(
        color: gold,
        fontSize: 86,
        fontWeight: FontWeight.w900,
        letterSpacing: 8,
      ),
      align: TextAlign.center,
      maxWidth: w - 200,
    );

    // Kleine Linie unter dem Header
    final linePaint = Paint()
      ..color = gold
      ..strokeWidth = 3;
    canvas.drawLine(Offset(w / 2 - 100, 320), Offset(w / 2 + 100, 320), linePaint);

    // Subtitle: "Hiermit wird bestätigt"
    _drawText(
      canvas: canvas,
      text: 'Hiermit wird bestätigt, dass',
      x: w / 2,
      y: 440,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 36,
        fontStyle: FontStyle.italic,
      ),
      align: TextAlign.center,
      maxWidth: w - 200,
    );

    // Username
    _drawText(
      canvas: canvas,
      text: cert.username,
      x: w / 2,
      y: 540,
      style: TextStyle(
        color: cert.primaryColor,
        fontSize: 70,
        fontWeight: FontWeight.bold,
      ),
      align: TextAlign.center,
      maxWidth: w - 200,
    );

    // Achievement / Modul-Name
    _drawText(
      canvas: canvas,
      text: cert.title,
      x: w / 2,
      y: 720,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 48,
        fontWeight: FontWeight.w600,
      ),
      align: TextAlign.center,
      maxWidth: w - 200,
    );

    _drawText(
      canvas: canvas,
      text: cert.subtitle,
      x: w / 2,
      y: 830,
      style: const TextStyle(color: Colors.white60, fontSize: 28),
      align: TextAlign.center,
      maxWidth: w - 240,
    );

    // Accuracy-Wert wenn vorhanden
    if (cert.accuracy != null) {
      final pct = (cert.accuracy! * 100).round();
      _drawText(
        canvas: canvas,
        text: 'Genauigkeit: $pct%',
        x: w / 2,
        y: 1020,
        style: TextStyle(
          color: cert.primaryColor,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
        align: TextAlign.center,
        maxWidth: w - 200,
      );
    }

    // XMARI-Preset-Badge (farbcodiert nach Preset)
    final presetBadgeColor = _presetColor(cert.presetName);
    final badgeRect = Rect.fromCenter(center: Offset(w / 2, 1180), width: 600, height: 90);
    canvas.drawRRect(
      RRect.fromRectAndRadius(badgeRect, const Radius.circular(45)),
      Paint()
        ..color = presetBadgeColor.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(badgeRect, const Radius.circular(45)),
      Paint()
        ..color = presetBadgeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    _drawText(
      canvas: canvas,
      text: 'XMARI Preset: ${cert.presetName}',
      x: w / 2,
      y: 1180,
      style: TextStyle(
        color: presetBadgeColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      align: TextAlign.center,
      maxWidth: 580,
      yIsCenter: true,
    );

    // Datum
    final dateStr = DateFormat('dd. MMMM yyyy', 'de_DE').format(cert.earnedAt);
    _drawText(
      canvas: canvas,
      text: dateStr,
      x: w / 2,
      y: 1380,
      style: const TextStyle(color: Colors.white54, fontSize: 30),
      align: TextAlign.center,
      maxWidth: w - 200,
    );

    // Footer
    _drawText(
      canvas: canvas,
      text: 'E-Gitarre Leicht – Enya XMARI Smart Guitar',
      x: w / 2,
      y: h - 180,
      style: TextStyle(color: gold.withValues(alpha: 0.7), fontSize: 26),
      align: TextAlign.center,
      maxWidth: w - 200,
    );
    _drawText(
      canvas: canvas,
      text: '🎸 #EnyaXMARI #EGitarreLeicht',
      x: w / 2,
      y: h - 130,
      style: const TextStyle(color: Colors.white38, fontSize: 22),
      align: TextAlign.center,
      maxWidth: w - 200,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(w.toInt(), h.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = bytes!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/zertifikat_${cert.type.name}_${DateTime.now().millisecondsSinceEpoch}.png';
    await File(path).writeAsBytes(pngBytes);
    cert.imagePath = path;
    return path;
  }

  /// Teilt das Zertifikat als Bild via share_plus.
  static Future<void> shareImage(Certificate cert) async {
    final path = cert.imagePath ?? await renderToImage(cert);
    await Share.shareXFiles(
      [XFile(path, mimeType: 'image/png')],
      subject: cert.title,
      text: '🎸 ${cert.title}\n${cert.subtitle}\n#EnyaXMARI #EGitarreLeicht',
    );
  }

  /// Speichert das Zertifikat im Application-Documents-Verzeichnis.
  static Future<String> saveToDocuments(Certificate cert) async {
    final imgPath = cert.imagePath ?? await renderToImage(cert);
    final docs = await getApplicationDocumentsDirectory();
    final filename =
        'zertifikat_${cert.type.name}_${DateTime.now().millisecondsSinceEpoch}.png';
    final destPath = '${docs.path}/$filename';
    await File(imgPath).copy(destPath);
    return destPath;
  }

  /// Reiner Text-Share (Fallback ohne Bild).
  static Future<void> share(Certificate cert) async {
    final text =
        '🎸 ${cert.title}\n${cert.subtitle}\n${cert.xmariNote}\n\n#EnyaXMARI #EGitarreLeicht';
    await Share.share(text);
  }

  // ── Hilfsmethoden ────────────────────────────────────────────────────────

  static Color _presetColor(String preset) {
    switch (preset.toLowerCase()) {
      case 'clean':
        return const Color(0xFF4CAF50);
      case 'overdrive':
        return const Color(0xFFFF9800);
      case 'distortion':
        return const Color(0xFFE91E63);
      case 'high gain':
      case 'highgain':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  static void _drawText({
    required Canvas canvas,
    required String text,
    required double x,
    required double y,
    required TextStyle style,
    required TextAlign align,
    required double maxWidth,
    bool yIsCenter = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: align,
      textDirection: ui.TextDirection.ltr,
    );
    tp.layout(maxWidth: maxWidth);
    final dx = align == TextAlign.center ? x - tp.width / 2 : x;
    final dy = yIsCenter ? y - tp.height / 2 : y;
    tp.paint(canvas, Offset(dx, dy));
  }

  static void _drawDecorativeNotes(
      Canvas canvas, double w, double h, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // Sehr einfache Note-Köpfe in den Ecken
    canvas.drawCircle(Offset(120, 120), 14, paint);
    canvas.drawCircle(Offset(w - 120, 120), 14, paint);
    canvas.drawCircle(Offset(120, h - 120), 14, paint);
    canvas.drawCircle(Offset(w - 120, h - 120), 14, paint);
    // Stiele
    final stem = Paint()
      ..color = color
      ..strokeWidth = 3;
    canvas.drawLine(Offset(134, 120), Offset(134, 80), stem);
    canvas.drawLine(Offset(w - 106, 120), Offset(w - 106, 80), stem);
    canvas.drawLine(Offset(134, h - 120), Offset(134, h - 160), stem);
    canvas.drawLine(Offset(w - 106, h - 120), Offset(w - 106, h - 160), stem);
  }
}

class CertificateDisplayPage extends ConsumerStatefulWidget {
  final Certificate certificate;

  const CertificateDisplayPage({super.key, required this.certificate});

  @override
  ConsumerState<CertificateDisplayPage> createState() =>
      _CertificateDisplayPageState();
}

class _CertificateDisplayPageState
    extends ConsumerState<CertificateDisplayPage> {
  String? _imagePath;
  bool _rendering = true;

  @override
  void initState() {
    super.initState();
    _renderInBackground();
  }

  Future<void> _renderInBackground() async {
    try {
      final path =
          await CertificateGenerator.renderToImage(widget.certificate);
      if (!mounted) return;
      setState(() {
        _imagePath = path;
        _rendering = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _rendering = false);
    }
  }

  Future<void> _share() async {
    await CertificateGenerator.shareImage(widget.certificate);
  }

  Future<void> _save() async {
    final path =
        await CertificateGenerator.saveToDocuments(widget.certificate);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Zertifikat gespeichert: $path')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cert = widget.certificate;
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text('Zertifikat'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: _rendering
                      ? const CircularProgressIndicator()
                      : _imagePath != null
                          ? InteractiveViewer(
                              child: Image.file(
                                File(_imagePath!),
                                fit: BoxFit.contain,
                              ),
                            )
                          : _FallbackCard(cert: cert),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _rendering ? null : _share,
                      icon: const Icon(Icons.share),
                      label: const Text('Teilen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cert.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _rendering ? null : _save,
                      icon: const Icon(Icons.download),
                      label: const Text('Speichern'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cert.primaryColor,
                        side: BorderSide(color: cert.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Karten-Fallback falls die PNG-Generierung fehlschlägt.
class _FallbackCard extends StatelessWidget {
  final Certificate cert;
  const _FallbackCard({required this.cert});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Icon(cert.icon, size: 64, color: cert.primaryColor),
            const SizedBox(height: 16),
            Text(
              cert.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cert.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              cert.subtitle,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat('dd. MMMM yyyy', 'de_DE').format(cert.earnedAt),
              style: const TextStyle(color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}
