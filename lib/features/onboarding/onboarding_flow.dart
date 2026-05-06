import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import 'pages/guitar_setup_page.dart';
import 'pages/onboarding_tuner_page.dart';
import 'pages/first_note_page.dart';
import 'pages/profile_setup_page.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _totalPages = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/home/lessons');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: back button + dot indicators + skip button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back_ios),
                      color: AppColors.textSecondary,
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalPages,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: index == _currentPage ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: index == _currentPage
                                ? AppColors.primary
                                : AppColors.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/home/lessons'),
                    child: Text(
                      'Überspringen',
                      style: TextStyle(color: AppColors.textTertiary),
                    ),
                  ),
                ],
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  // Page 1: Combined welcome
                  _CombinedWelcomePage(onNext: _nextPage),
                  // Page 2: Guitar setup
                  GuitarSetupPageContent(onNext: _nextPage),
                  // Page 3: Tuner
                  OnboardingTunerPageContent(onNext: _nextPage),
                  // Page 4: First note
                  FirstNotePage(
                    onCompleted: _nextPage,
                    onSkipped: _nextPage,
                  ),
                  // Page 5: Profile setup
                  ProfileSetupPageContent(onFinish: () {
                    context.go('/home/lessons');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CombinedWelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _CombinedWelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.music_note, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 32),
          const Text(
            'E-Gitarre Leicht',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lerne E-Gitarre mit der Enya XMARI',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 40),
          _FeatureRow(
            icon: Icons.school,
            text: 'Strukturierter Lernplan von Null bis zum ersten Song',
          ),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.emoji_events,
            text: 'XP, Achievements & Streaks halten dich motiviert',
          ),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.bluetooth,
            text: 'Echtzeit-Feedback direkt von deiner Gitarre',
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: const Color(0xFF7C3AED),
            ),
            child: const Text(
              'Los geht\'s',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF7C3AED), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
