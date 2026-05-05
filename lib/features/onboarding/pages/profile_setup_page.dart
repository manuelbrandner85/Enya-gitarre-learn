import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/theme/colors.dart';
import '../../../core/utils/constants.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: ProfileSetupPageContent(onFinish: () => context.go('/home/lessons')),
    );
  }
}

class ProfileSetupPageContent extends ConsumerStatefulWidget {
  final VoidCallback onFinish;

  const ProfileSetupPageContent({super.key, required this.onFinish});

  @override
  ConsumerState<ProfileSetupPageContent> createState() =>
      _ProfileSetupPageContentState();
}

class _ProfileSetupPageContentState
    extends ConsumerState<ProfileSetupPageContent> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedExperience = 'beginner';
  bool _isSaving = false;

  final List<(String, String, String)> _experienceLevels = [
    ('beginner', 'Anfänger', 'Ich habe noch nie Gitarre gespielt'),
    ('some', 'Etwas Erfahrung', 'Ich kenne ein paar Akkorde'),
    ('intermediate', 'Fortgeschritten', 'Ich spiele seit einiger Zeit'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.prefKeyOnboardingComplete, true);
      await prefs.setString('username', _nameController.text.trim());
      await prefs.setString('experience', _selectedExperience);

      if (mounted) {
        widget.onFinish();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Text(
              'Profil erstellen',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ).animate().fadeIn().slideY(begin: -0.2),

            const SizedBox(height: 8),

            Text(
              'Damit wir deinen Lernplan anpassen können',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 32),

            // Avatar selection (simplified)
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.backgroundDark, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 300.ms).fadeIn().scale(begin: const Offset(0.5, 0.5)),

            const SizedBox(height: 32),

            // Name field
            Text(
              'Dein Name',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'z.B. Max Rockstar',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Bitte gib einen Namen ein';
                }
                if (value.trim().length < 2) {
                  return 'Name muss mindestens 2 Zeichen lang sein';
                }
                return null;
              },
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 24),

            // Experience level
            Text(
              'Erfahrungslevel',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 12),

            ..._experienceLevels.asMap().entries.map((entry) {
              final (key, title, subtitle) = entry.value;
              final isSelected = _selectedExperience == key;
              return GestureDetector(
                onTap: () => setState(() => _selectedExperience = key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            Text(
                              subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ).animate(delay: Duration(milliseconds: 500 + (entry.key * 100))).fadeIn().slideX(begin: 0.1);
            }),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text('Loslegen!'),
              ),
            ).animate(delay: 900.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}
