import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/models/workout_session.dart' as domain;
import '../providers/workout_providers.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: historyAsync.when(
        data: (sessions) {
          final completed = sessions
              .where((s) => s.status == domain.WorkoutStatus.completed)
              .toList()
            ..sort((a, b) {
              final dateA = a.workoutDate;
              final dateB = b.workoutDate;
              if (dateA.year != dateB.year) {
                return dateB.year.compareTo(dateA.year);
              }
              if (dateA.month != dateB.month) {
                return dateB.month.compareTo(dateA.month);
              }
              return dateB.day.compareTo(dateA.day);
            });

          if (completed.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No workouts yet',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete your first workout to see it here',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completed.length,
            itemBuilder: (context, index) {
              final session = completed[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _WorkoutHistoryCard(session: session),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading workouts',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutHistoryCard extends ConsumerWidget {
  final domain.WorkoutSession session;

  const _WorkoutHistoryCard({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final exercisesAsync = ref.watch(sessionExercisesProvider(session.id.value));

    final titleText = session.programSnapshot != null
        ? '${session.programSnapshot!['programName']} - ${session.programSnapshot!['dayName']}'
        : 'Freestyle Workout';

    final dateFormat = DateFormat('EEE, MMM d, y');
    final dateText = dateFormat.format(
      DateTime(session.workoutDate.year, session.workoutDate.month, session.workoutDate.day),
    );

    final duration = session.finishedAt != null
        ? session.finishedAt!.difference(session.startedAt)
        : null;

    return Card(
      child: InkWell(
        onTap: () => context.push('/workouts/${session.id.value}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fitness_center,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (duration != null) ...[
                          Icon(Icons.timer, size: 14, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(duration),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        exercisesAsync.when(
                          data: (exercises) => Row(
                            children: [
                              Icon(Icons.fitness_center, size: 14, color: theme.colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(
                                '${exercises.length} ${exercises.length == 1 ? 'exercise' : 'exercises'}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes} min';
  }
}
