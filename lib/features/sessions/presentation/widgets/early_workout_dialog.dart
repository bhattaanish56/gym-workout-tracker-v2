import 'package:flutter/material.dart';

enum EarlyWorkoutChoice {
  completeScheduled, // Complete the scheduled workout early
  additionalWorkout, // Start as additional workout today
  cancel,
}

/// Dialog shown when user starts a future scheduled workout early
class EarlyWorkoutDialog extends StatelessWidget {
  final String workoutName;

  const EarlyWorkoutDialog({
    super.key,
    required this.workoutName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text('You\'re starting $workoutName early.'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How would you like to record this workout?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(EarlyWorkoutChoice.cancel),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(EarlyWorkoutChoice.additionalWorkout),
          child: const Text('Start as additional workout'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(EarlyWorkoutChoice.completeScheduled),
          child: const Text('Complete scheduled workout early'),
        ),
      ],
    );
  }
}
