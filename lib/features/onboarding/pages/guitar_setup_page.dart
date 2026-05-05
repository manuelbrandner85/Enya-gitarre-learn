import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/colors.dart';

class GuitarSetupPage extends StatelessWidget {
  const GuitarSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: GuitarSetupPageContent(onNext: null),
    );
  }
}

class GuitarSetupPageContent extends ConsumerStatefulWidget {
  final VoidCallback? onNext;

  const GuitarSetupPageContent({super.key, required this.onNext});

  @override
  ConsumerState<GuitarSetupPageContent> createState() =>
      _GuitarSetupPageContentState();
}

class _GuitarSetupPageContentState
    extends ConsumerState<GuitarSetupPageContent> {
  ConnectionMode _selectedMode = ConnectionMode.microphone;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Text(
            'Gitarre einrichten',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ).animate().fadeIn().slideY(begin: -0.2),

          const SizedBox(height: 8),

          Text(
            'Wie möchtest du deine Gitarre verbinden?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ).animate(delay: 200.ms).fadeIn(),

          const SizedBox(height: 32),

          // Connection options
          _buildConnectionOption(
            icon: Icons.usb,
            title: 'USB OTG (Empfohlen)',
            subtitle: 'Direkte Verbindung für bestes Audio-Signal',
            mode: ConnectionMode.usb,
            color: AppColors.primary,
          ),

          const SizedBox(height: 12),

          _buildConnectionOption(
            icon: Icons.bluetooth,
            title: 'Bluetooth',
            subtitle: 'Kabellos verbinden',
            mode: ConnectionMode.bluetooth,
            color: AppColors.accent,
          ),

          const SizedBox(height: 12),

          _buildConnectionOption(
            icon: Icons.mic,
            title: 'Mikrofon',
            subtitle: 'Gitarre über Gerätmikrofon aufnehmen',
            mode: ConnectionMode.microphone,
            color: AppColors.secondary,
          ),

          const SizedBox(height: 32),

          if (_selectedMode == ConnectionMode.bluetooth) ...[
            _buildBluetoothSection(),
            const SizedBox(height: 24),
          ],

          if (_selectedMode == ConnectionMode.usb) ...[
            _buildUsbSection(),
            const SizedBox(height: 24),
          ],

          if (_selectedMode == ConnectionMode.microphone) ...[
            _buildMicSection(),
            const SizedBox(height: 24),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext ?? () => context.go('/onboarding/tuner'),
              child: const Text('Weiter'),
            ),
          ).animate(delay: 600.ms).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildConnectionOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required ConnectionMode mode,
    required Color color,
  }) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _selectedMode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : AppColors.surfaceVariantDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
      ),
    ).animate(delay: const Duration(milliseconds: 300)).fadeIn().slideX(begin: 0.1);
  }

  Widget _buildBluetoothSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bluetooth-Gerät suchen',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _isSearching
                ? null
                : () {
                    setState(() => _isSearching = true);
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) setState(() => _isSearching = false);
                    });
                  },
            icon: _isSearching
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Icon(Icons.search),
            label: Text(_isSearching ? 'Suche läuft...' : 'Suchen'),
          ),
        ],
      ),
    );
  }

  Widget _buildUsbSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          const Icon(Icons.usb, size: 48, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            'Verbinde die Enya XMARI über das mitgelieferte USB-Kabel mit deinem Gerät.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMicSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Das Mikrofon kann Hintergrundgeräusche aufnehmen. Für beste Ergebnisse ruhige Umgebung wählen.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

enum ConnectionMode { usb, bluetooth, microphone }
