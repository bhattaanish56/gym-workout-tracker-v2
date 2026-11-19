import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'welcome_step_screen.dart';
import 'about_you_step_screen.dart';
import 'body_details_step_screen.dart';
import 'fitness_goal_step_screen.dart';
import 'experience_step_screen.dart';
import 'lifestyle_step_screen.dart';
import 'training_preferences_step_screen.dart';
import 'fitness_blueprint_screen.dart';
import 'confirmation_step_screen.dart';
import '../providers/onboarding_providers.dart';

class OnboardingCoordinatorScreen extends ConsumerStatefulWidget {
  const OnboardingCoordinatorScreen({super.key});

  @override
  ConsumerState<OnboardingCoordinatorScreen> createState() =>
      _OnboardingCoordinatorScreenState();
}

class _OnboardingCoordinatorScreenState
    extends ConsumerState<OnboardingCoordinatorScreen> {
  int _currentStep = 0;

  final List<String> _stepTitles = [
    'Welcome',
    'About You',
    'Body Details',
    'Fitness Goal',
    'Experience',
    'Lifestyle',
    'Training',
    'Blueprint',
    'Confirm',
  ];

  @override
  void initState() {
    super.initState();
    // Load saved progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedStep = ref.read(onboardingStateProvider)['currentStep'] as int?;
      if (savedStep != null && savedStep != _currentStep) {
        setState(() => _currentStep = savedStep);
      }
    });
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() => _currentStep++);
      ref.read(onboardingStateProvider.notifier).updateData({
        'currentStep': _currentStep,
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      ref.read(onboardingStateProvider.notifier).updateData({
        'currentStep': _currentStep,
      });
    }
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return WelcomeStepScreen(onNext: _nextStep);
      case 1:
        return AboutYouStepScreen(onNext: _nextStep, onBack: _previousStep);
      case 2:
        return BodyDetailsStepScreen(onNext: _nextStep, onBack: _previousStep);
      case 3:
        return FitnessGoalStepScreen(onNext: _nextStep, onBack: _previousStep);
      case 4:
        return ExperienceStepScreen(onNext: _nextStep, onBack: _previousStep);
      case 5:
        return LifestyleStepScreen(onNext: _nextStep, onBack: _previousStep);
      case 6:
        return TrainingPreferencesStepScreen(onNext: _nextStep, onBack: _previousStep);
      case 7:
        return FitnessBlueprintScreen(onNext: _nextStep, onBack: _previousStep);
      case 8:
        return ConfirmationStepScreen(onBack: _previousStep);
      default:
        return WelcomeStepScreen(onNext: _nextStep);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Onboarding'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: List.generate(_stepTitles.length, (index) {
                      final isActive = index == _currentStep;
                      final isCompleted = index < _currentStep;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < _stepTitles.length - 1 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: isCompleted || isActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step ${_currentStep + 1} of ${_stepTitles.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Step content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
