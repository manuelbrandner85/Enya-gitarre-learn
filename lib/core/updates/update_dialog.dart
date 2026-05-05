import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/colors.dart';
import 'update_check_service.dart';

class UpdateDialog extends StatelessWidget {
  final UpdateInfo info;

  const UpdateDialog({super.key, required this.info});

  static Future<void> show(BuildContext context, UpdateInfo info) {
    return showDialog<void>(
      context: context,
      barrierDismissible: !info.isForced,
      builder: (_) => PopScope(
        canPop: !info.isForced,
        child: UpdateDialog(info: info),
      ),
    );
  }

  Future<void> _openApk(BuildContext context) async {
    final url = info.apkUrl;
    if (url.isEmpty) return;
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download fehlgeschlagen: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceDark,
      title: Row(
        children: [
          const Icon(Icons.system_update, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              info.isForced
                  ? 'Update erforderlich'
                  : 'Update verfügbar',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version ${info.latestVersion} ist verfügbar.',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (info.changelog.isNotEmpty) ...[
              const Text(
                'Was ist neu:',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                info.changelog,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
            ],
            if (info.isForced)
              const Text(
                'Diese Aktualisierung ist erforderlich, um die App weiter zu nutzen.',
                style: TextStyle(color: AppColors.error),
              ),
          ],
        ),
      ),
      actions: [
        if (!info.isForced)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Später'),
          ),
        ElevatedButton(
          onPressed: () => _openApk(context),
          child: const Text('Jetzt aktualisieren'),
        ),
      ],
    );
  }
}
