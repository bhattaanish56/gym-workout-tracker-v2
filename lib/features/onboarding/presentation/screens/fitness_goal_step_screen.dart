import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/fitness_goal.dart';
import '../providers/onboarding_providers.dart';

class FitnessGoalStepScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const FitnessGoalStepScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<FitnessGoalStepScreen> createState() => _FitnessGoalStepScreenState();
}

class _FitnessGoalStepScreenState extends ConsumerState<FitnessGoalStepScreen> {
  FitnessGoal? _selectedGoal;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingStateProvider);
    final goalValue = state['fitnessGoal'] as String?;
    _selectedGoal = FitnessGoal.fromValue(goalValue);
  }

  void _saveAndNext() {
    if (_selectedGoal != null) {
      ref.read(onboardingStateProvider.notifier).updateData({
        'fitnessGoal': _selectedGoal!.value,
      });
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Your Fitness Goal',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What would you like to achieve?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: [
              _GoalCard(
                goal: FitnessGoal.gainMuscle,
                icon: Icons.fitness_center,
                isSelected: _selectedGoal == FitnessGoal.gainMuscle,
                onTap: () => setState(() => _selectedGoal = FitnessGoal.gainMuscle),
              ),
              const SizedBox(height: 12),
              _GoalCard(
                goal: FitnessGoal.loseFat,
                icon: Icons.show_chart,
                isSelected: _selectedGoal == FitnessGoal.loseFat,
                onTap: () => setState(() => _selectedGoal = FitnessGoal.loseFat),
              ),
              const SizedBox(height: 12),
              _GoalCard(
                goal: FitnessGoal.improveStrength,
                icon: Icons.bolt,
                isSelected: _selectedGoal == FitnessGoal.improveStrength,
                onTap: () => setState(() => _selectedGoal = FitnessGoal.improveStrength),
              ),
              const SizedBox(height: 12),
              _GoalCard(
                goal: FitnessGoal.maintain,
                icon: Icons.balance,
                isSelected: _selectedGoal == FitnessGoal.maintain,
                onTap: () => setState(() => _selectedGoal = FitnessGoal.maintain),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _selectedGoal != null ? _saveAndNext : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final FitnessGoal goal;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? theme.colorScheme.primary : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
