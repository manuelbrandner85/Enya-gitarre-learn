import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bluetooth/bluetooth_service.dart';
import '../bluetooth/xmari_constants.dart';
import '../providers/app_providers.dart';

class XmariStatusBadge extends ConsumerWidget {
  const XmariStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final btService = ref.watch(bluetoothServiceProvider);
    final isConnected = btService.currentState.isConnected;

    if (!isConnected) {
      return GestureDetector(
        onTap: () => _showQuickInfo(context, ref),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cable, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text('XMARI', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showQuickInfo(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF4CAF50), width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bluetooth_connected, size: 14, color: Color(0xFF4CAF50)),
            SizedBox(width: 4),
            Text(
              'XMARI',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickInfo(BuildContext context, WidgetRef ref) {
    final btService = ref.read(bluetoothServiceProvider);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'XMARI Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (btService.currentState.isConnected) ...[
              const _InfoRow(
                icon: Icons.bluetooth,
                label: 'Verbindung',
                value: 'Bluetooth LE aktiv',
              ),
              const SizedBox(height: 12),
              const Text(
                'XMARI Presets',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(
                  4,
                  (i) => Chip(
                    label: Text(
                      XmariConstants.presetNames[i],
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor:
                        XmariConstants.presetColors[i].withOpacity(0.2),
                    side: BorderSide(color: XmariConstants.presetColors[i]),
                  ),
                ),
              ),
            ] else
              const _InfoRow(
                icon: Icons.cable,
                label: 'Status',
                value: 'XMARI nicht verbunden',
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
