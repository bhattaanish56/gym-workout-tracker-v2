import 'package:flutter/material.dart';
import 'package:gym_workout_tracker_v2/shared/widgets/section_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onViewWorkouts,
    required this.onBrowseExercises,
    required this.onViewProgress,
    required this.onOpenNutrition,
  });

  final VoidCallback onViewWorkouts;
  final VoidCallback onBrowseExercises;
  final VoidCallback onViewProgress;
  final VoidCallback onOpenNutrition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Gym Workout Tracker',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Keep workouts, exercises and meals together.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onViewWorkouts,
            icon: const ExcludeSemantics(child: Icon(Icons.fitness_center)),
            label: const Text('View workouts'),
          ),
          const SizedBox(height: 32),
          Semantics(
            header: true,
            child: Text('Your training', style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const ExcludeSemantics(child: Icon(Icons.list_outlined)),
            title: const Text('Exercises'),
            subtitle: const Text('Exercise library'),
            onTap: onBrowseExercises,
          ),
          ListTile(
            leading: const ExcludeSemantics(child: Icon(Icons.trending_up)),
            title: const Text('Progress'),
            subtitle: const Text('Training history'),
            onTap: onViewProgress,
          ),
          ListTile(
            leading: const ExcludeSemantics(
              child: Icon(Icons.restaurant_outlined),
            ),
            title: const Text('Nutrition'),
            subtitle: const Text('Meal history'),
            onTap: onOpenNutrition,
          ),
        ],
      ),
    );
  }
}
