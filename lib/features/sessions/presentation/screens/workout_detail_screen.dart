import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/performed_exercise.dart' as domain;
import '../../domain/models/performed_set.dart' as domain;
import '../../domain/models/workout_session.dart' as domain;
import '../providers/workout_providers.dart';
import '../../../../core/domain/value_objects/weight.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  final String sessionId;

  const WorkoutDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(workoutSessionProvider(sessionId));
    final exercisesAsync = ref.watch(sessionExercisesProvider(sessionId));

    return Scaffold(
      backgroundColor: const Color(0xFF101114),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1E23),
        title: const Text('Workout Details'),
      ),
      body: sessionAsync.when(
        data: (session) {
          if (session == null) {
            return const Center(
              child: Text(
                'Workout not found',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return exercisesAsync.when(
            data: (exercises) =>
                _buildContent(context, ref, session, exercises),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Error loading exercises: $err',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    domain.WorkoutSession session,
    List<domain.PerformedExercise> exercises,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFF1C1E23),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.workoutDate.toIso8601(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (session.finishedAt != null) ...[
                    _InfoRow(
                      icon: Icons.schedule,
                      label: 'Duration',
                      value: _formatDuration(
                        session.finishedAt!.difference(session.startedAt),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  _InfoRow(
                    icon: Icons.fitness_center,
                    label: 'Exercises',
                    value: exercises.length.toString(),
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    icon: Icons.check_circle,
                    label: 'Status',
                    value: session.status.toJson(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (exercises.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No exercises recorded',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          else
            ...exercises.map((exercise) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ExerciseDetailCard(
                  exercise: exercise,
                  sessionId: sessionId,
                ),
              );
            }),
        ],
      ),
    );
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFFF6B00)),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ExerciseDetailCard extends ConsumerWidget {
  final domain.PerformedExercise exercise;
  final String sessionId;

  const _ExerciseDetailCard({required this.exercise, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(exerciseSetsProvider(exercise.id.value));

    return Card(
      color: const Color(0xFF1C1E23),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.snapshot.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            setsAsync.when(
              data: (sets) {
                if (sets.isEmpty) {
                  return const Text(
                    'No sets recorded',
                    style: TextStyle(color: Colors.white54),
                  );
                }

                return Column(
                  children: [
                    // Header row
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                          child: Text(
                            'Set',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 40,
                          child: Text(
                            'Type',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Reps',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Weight',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 16),
                    ...sets.asMap().entries.map((entry) {
                      final index = entry.key;
                      final set = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _SetDetailRow(set: set, index: index),
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text(
                'Error loading sets: $err',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetDetailRow extends StatelessWidget {
  final domain.PerformedSet set;
  final int index;

  const _SetDetailRow({required this.set, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: set.setType == domain.SetType.warmup
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              set.setType == domain.SetType.warmup ? 'W' : 'S',
              style: TextStyle(
                color: set.setType == domain.SetType.warmup
                    ? Colors.blue
                    : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            set.reps?.toString() ?? '-',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            set.loadGrams != null
                ? '${set.loadGrams!.displayValue(WeightUnit.kg)} kg'
                : '-',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
