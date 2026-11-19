import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/activity_level.dart';
import '../providers/onboarding_providers.dart';

class LifestyleStepScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LifestyleStepScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<LifestyleStepScreen> createState() => _LifestyleStepScreenState();
}

class _LifestyleStepScreenState extends ConsumerState<LifestyleStepScreen> {
  ActivityLevel? _activityLevel;
  int? _workoutDays;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingStateProvider);
    final activityValue = state['activityLevel'] as String?;
    _activityLevel = ActivityLevel.fromValue(activityValue);
    _workoutDays = state['workoutDaysPerWeek'] as int?;
  }

  void _saveAndNext() {
    if (_activityLevel != null && _workoutDays != null) {
      ref.read(onboardingStateProvider.notifier).updateData({
        'activityLevel': _activityLevel!.value,
        'workoutDaysPerWeek': _workoutDays,
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
          'Your Lifestyle',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about your daily activity',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: [
              Text(
                'Activity Level',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...ActivityLevel.values.map((level) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _ActivityCard(
                  level: level,
                  isSelected: _activityLevel == level,
                  onTap: () => setState(() => _activityLevel = level),
                ),
              )),
              const SizedBox(height: 24),
              Text(
                'Workout Frequency',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(7, (index) {
                  final days = index + 1;
                  return ChoiceChip(
                    label: Text('$days day${days > 1 ? 's' : ''}'),
                    selected: _workoutDays == days,
                    onSelected: (selected) {
                      setState(() => _workoutDays = selected ? days : null);
                    },
                  );
                }),
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
                onPressed: _activityLevel != null && _workoutDays != null ? _saveAndNext : null,
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

class _ActivityCard extends StatelessWidget {
  final ActivityLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.level,
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
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? theme.colorScheme.primary : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      level.description,
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
