import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/colors.dart';
import 'pages/welcome_page.dart';
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

  /// 3 intro slideshow pages + 5 existing profile-setup pages = 8 total.
  static const int _introPages = 3;
  static const int _totalPages = 8; // 3 intro + 5 existing

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

  bool get _isLastPage => _currentPage == _totalPages - 1;
  bool get _isIntroPage => _currentPage < _introPages;

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
                  // ── Intro slideshow pages (0, 1, 2) ──
                  _IntroSlidePage(
                    icon: Icons.music_note,
                    title: 'Lerne E-Gitarre',
                    subtitle:
                        'Schritt für Schritt mit der Enya XMARI Smart Guitar',
                    buttonLabel: _isLastPage ? 'Loslegen' : 'Weiter',
                    onNext: _nextPage,
                  ),
                  _IntroSlidePage(
                    icon: Icons.emoji_events,
                    title: 'Sammle XP & Achievements',
                    subtitle: 'Bleib motiviert durch Gamification',
                    buttonLabel: _isLastPage ? 'Loslegen' : 'Weiter',
                    onNext: _nextPage,
                  ),
                  _IntroSlidePage(
                    icon: Icons.bluetooth,
                    title: 'Verbinde deine Gitarre',
                    subtitle:
                        'Echtzeit-Feedback direkt vom Instrument',
                    buttonLabel: _isLastPage ? 'Loslegen' : 'Weiter',
                    onNext: _nextPage,
                  ),

                  // ── Existing profile-setup pages (3, 4, 5, 6, 7) ──
                  WelcomePageContent(onNext: _nextPage),
                  GuitarSetupPageContent(onNext: _nextPage),
                  OnboardingTunerPageContent(onNext: _nextPage),
                  FirstNotePage(
                    onCompleted: _nextPage,
                    onSkipped: _nextPage,
                  ),
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

/// A single intro slideshow page with an icon, title, subtitle and a button.
class _IntroSlidePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onNext;

  const _IntroSlidePage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 64),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
