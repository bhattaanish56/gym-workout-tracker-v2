import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WelcomeStepScreen extends ConsumerWidget {
  final VoidCallback onNext;

  const WelcomeStepScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Icon(
          Icons.fitness_center,
          size: 80,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome to Your Fitness Journey',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Let\'s create a personalized workout plan tailored to your goals, experience, and lifestyle.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _FeatureItem(
                  icon: Icons.track_changes,
                  title: 'Personalized Plans',
                  description: 'Workouts designed for your goals',
                ),
                const SizedBox(height: 12),
                _FeatureItem(
                  icon: Icons.trending_up,
                  title: 'Track Progress',
                  description: 'Monitor strength and body composition',
                ),
                const SizedBox(height: 12),
                _FeatureItem(
                  icon: Icons.restaurant,
                  title: 'Nutrition Targets',
                  description: 'Calorie and protein recommendations',
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        FilledButton(
          onPressed: onNext,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Get Started'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/home'),
          child: const Text('Skip for now'),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
