import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_providers.dart';

class TrainingPreferencesStepScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const TrainingPreferencesStepScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<TrainingPreferencesStepScreen> createState() =>
      _TrainingPreferencesStepScreenState();
}

class _TrainingPreferencesStepScreenState
    extends ConsumerState<TrainingPreferencesStepScreen> {
  String? _trainingLocation;
  final Set<String> _equipment = {};

  final List<String> _equipmentOptions = [
    'Barbell',
    'Dumbbells',
    'Resistance Bands',
    'Pull-up Bar',
    'Bench',
    'Squat Rack',
    'Cable Machine',
    'Leg Press',
    'Bodyweight Only',
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingStateProvider);
    _trainingLocation = state['trainingLocation'] as String?;
    final equipmentString = state['equipment'] as String?;
    if (equipmentString != null && equipmentString.isNotEmpty) {
      _equipment.addAll(equipmentString.split(','));
    }
  }

  void _saveAndNext() {
    if (_trainingLocation != null) {
      ref.read(onboardingStateProvider.notifier).updateData({
        'trainingLocation': _trainingLocation,
        'equipment': _equipment.join(','),
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
          'Training Preferences',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Where will you train?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: [
              Text(
                'Training Location',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Gym'),
                    selected: _trainingLocation == 'gym',
                    onSelected: (selected) {
                      setState(() => _trainingLocation = selected ? 'gym' : null);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Home'),
                    selected: _trainingLocation == 'home',
                    onSelected: (selected) {
                      setState(() => _trainingLocation = selected ? 'home' : null);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Both'),
                    selected: _trainingLocation == 'both',
                    onSelected: (selected) {
                      setState(() => _trainingLocation = selected ? 'both' : null);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Available Equipment (Optional)',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _equipmentOptions.map((equipment) {
                  return FilterChip(
                    label: Text(equipment),
                    selected: _equipment.contains(equipment),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _equipment.add(equipment);
                        } else {
                          _equipment.remove(equipment);
                        }
                      });
                    },
                  );
                }).toList(),
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
                onPressed: _trainingLocation != null ? _saveAndNext : null,
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
