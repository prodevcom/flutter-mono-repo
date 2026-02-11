import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../l10n/generated/onboarding_localizations.dart';
import '../widgets/onboarding_step.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = OnboardingLocalizations.of(context)!;
    final steps = [
      OnboardingStepData(
        title: l10n.step1Title,
        description: l10n.step1Description,
        icon: Icons.explore,
      ),
      OnboardingStepData(
        title: l10n.step2Title,
        description: l10n.step2Description,
        icon: Icons.star,
      ),
      OnboardingStepData(
        title: l10n.step3Title,
        description: l10n.step3Description,
        icon: Icons.check_circle,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: steps.length,
                itemBuilder: (context, index) => OnboardingStep(data: steps[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DsButton(
                    label: l10n.skip,
                    variant: DsButtonVariant.text,
                    onPressed: () => context.router.pushPath(AppRoutes.home),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      steps.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                  DsButton(
                    label: _currentPage == steps.length - 1
                        ? l10n.getStarted
                        : l10n.next,
                    variant: DsButtonVariant.outlined,
                    onPressed: () {
                      if (_currentPage < steps.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.router.pushPath(AppRoutes.login);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
