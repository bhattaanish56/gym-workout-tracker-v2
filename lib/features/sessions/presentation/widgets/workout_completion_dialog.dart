import 'package:flutter/material.dart';
import '../../domain/models/workout_session.dart';
import '../../domain/models/performed_exercise.dart';
import '../../domain/models/performed_set.dart';

class WorkoutCompletionDialog extends StatelessWidget {
  final WorkoutSession session;
  final List<PerformedExercise> exercises;
  final Map<String, List<PerformedSet>> setsByExercise;
  final Duration duration;

  const WorkoutCompletionDialog({
    super.key,
    required this.session,
    required this.exercises,
    required this.setsByExercise,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _calculateStats();

    return AlertDialog(
      title: const Text('Complete Workout?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow(
              context,
              Icons.timer_outlined,
              'Duration',
              _formatDuration(duration),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.fitness_center,
              'Exercises',
              '${exercises.length}',
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.check_circle,
              'Completed Sets',
              '${stats['completed']}',
            ),
            if (stats['incomplete']! > 0) ...[
              const SizedBox(height: 8),
              _buildStatRow(
                context,
                Icons.circle_outlined,
                'Incomplete Sets',
                '${stats['incomplete']}',
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.scale,
              'Training Volume',
              '${(stats['volume']! / 1000).toStringAsFixed(1)} kg',
            ),
            const SizedBox(height: 16),
            Text(
              'Incomplete sets will be saved but excluded from performance statistics.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Finish & Save'),
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    final statColor = color ?? theme.colorScheme.primary;

    return Row(
      children: [
        Icon(icon, size: 20, color: statColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: statColor,
          ),
        ),
      ],
    );
  }

  Map<String, int> _calculateStats() {
    int completed = 0;
    int incomplete = 0;
    int volumeGrams = 0;

    for (final sets in setsByExercise.values) {
      for (final set in sets) {
        if (set.completed) {
          completed++;
          if (set.setType == SetType.working && set.loadGrams != null && set.reps != null) {
            volumeGrams += set.loadGrams!.grams * set.reps!;
          }
        } else {
          incomplete++;
        }
      }
    }

    return {
      'completed': completed,
      'incomplete': incomplete,
      'volume': volumeGrams,
    };
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
