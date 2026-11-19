import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/experience_level.dart';
import '../providers/onboarding_providers.dart';

class ExperienceStepScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ExperienceStepScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<ExperienceStepScreen> createState() => _ExperienceStepScreenState();
}

class _ExperienceStepScreenState extends ConsumerState<ExperienceStepScreen> {
  ExperienceLevel? _selectedLevel;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingStateProvider);
    final levelValue = state['experienceLevel'] as String?;
    _selectedLevel = ExperienceLevel.fromValue(levelValue);
  }

  void _saveAndNext() {
    if (_selectedLevel != null) {
      ref.read(onboardingStateProvider.notifier).updateData({
        'experienceLevel': _selectedLevel!.value,
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
          'Training Experience',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'How long have you been training?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: [
              _ExperienceCard(
                level: ExperienceLevel.beginner,
                icon: Icons.start,
                isSelected: _selectedLevel == ExperienceLevel.beginner,
                onTap: () => setState(() => _selectedLevel = ExperienceLevel.beginner),
              ),
              const SizedBox(height: 12),
              _ExperienceCard(
                level: ExperienceLevel.intermediate,
                icon: Icons.trending_up,
                isSelected: _selectedLevel == ExperienceLevel.intermediate,
                onTap: () => setState(() => _selectedLevel = ExperienceLevel.intermediate),
              ),
              const SizedBox(height: 12),
              _ExperienceCard(
                level: ExperienceLevel.advanced,
                icon: Icons.star,
                isSelected: _selectedLevel == ExperienceLevel.advanced,
                onTap: () => setState(() => _selectedLevel = ExperienceLevel.advanced),
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
                onPressed: _selectedLevel != null ? _saveAndNext : null,
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

class _ExperienceCard extends StatelessWidget {
  final ExperienceLevel level;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExperienceCard({
    required this.level,
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
                      level.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? theme.colorScheme.primary : null,
                      ),
                    ),
                    const SizedBox(height: 4),
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
