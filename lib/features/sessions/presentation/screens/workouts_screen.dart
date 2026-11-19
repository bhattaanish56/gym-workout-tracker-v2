import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/workout_session.dart' as domain;
import '../../domain/models/performed_exercise.dart' as domain;
import '../../domain/models/performed_set.dart' as domain;
import '../providers/workout_providers.dart';
import '../../../programs/presentation/providers/program_providers.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import 'active_workout_screen.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final historyAsync = ref.watch(workoutHistoryProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);
    final nextWorkoutAsync = ref.watch(nextPlannedWorkoutProvider);
    final allProgramsAsync = ref.watch(allProgramsProvider);

    if (activeWorkout.session != null) {
      return const ActiveWorkoutScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Workouts',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Active program card
                    activeProgramAsync.when(
                      data: (activeProgram) {
                        if (activeProgram != null) {
                          return nextWorkoutAsync.when(
                            data: (nextDay) => Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.fitness_center,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                activeProgram.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'Active',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (nextDay != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Next: ${nextDay.name}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FilledButton.icon(
                                              style: FilledButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                              ),
                                              onPressed: () async {
                                                await ref
                                                    .read(activeWorkoutProvider.notifier)
                                                    .startPlannedWorkout(
                                                      activeProgram.id.value,
                                                      nextDay.id.value,
                                                    );
                                                if (context.mounted) {
                                                  final error = ref
                                                      .read(activeWorkoutProvider)
                                                      .error;
                                                  if (error != null) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(content: Text(error)),
                                                    );
                                                  }
                                                }
                                              },
                                              icon: const Icon(Icons.play_arrow, size: 18),
                                              label: Text('Start ${nextDay.name}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                            ),
                                            onPressed: () => _showSwitchPlanDialog(
                                              context,
                                              ref,
                                              allProgramsAsync,
                                              activeProgram.id.value,
                                            ),
                                            icon: const Icon(Icons.swap_horiz, size: 16),
                                            label: const Text('Switch Plan'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                            ),
                                            onPressed: () => context.push(
                                              '/workouts/programs/${activeProgram.id.value}',
                                            ),
                                            icon: const Icon(Icons.settings, size: 16),
                                            label: const Text('Manage'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 12),

                    // Quick actions grid
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.calendar_month,
                            label: 'My Plans',
                            onTap: () => context.push('/workouts/programs'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.play_circle_outline,
                            label: 'Start Freestyle',
                            onTap: () async {
                              await ref
                                  .read(activeWorkoutProvider.notifier)
                                  .startWorkout();
                              if (context.mounted) {
                                final error = ref
                                    .read(activeWorkoutProvider)
                                    .error;
                                if (error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Resume Active Workout card
            if (activeWorkout.session != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _ResumeActiveWorkoutCard(
                    session: activeWorkout.session!,
                    exercises: activeWorkout.exercises,
                    setsByExercise: activeWorkout.setsByExercise,
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Workouts',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/workouts/history'),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('View All'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            historyAsync.when(
              data: (sessions) {
                final completed = sessions
                    .where(
                      (s) => s.status == domain.WorkoutStatus.completed,
                    )
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
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No workouts yet',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Start your first workout above',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final session = completed[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: WorkoutHistoryCard(session: session),
                      );
                    },
                    childCount: completed.length,
                  ),
                );
              },
              loading: () => SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Error: $err',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ),

            // Info banner about incomplete sets
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.amber.shade800,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Incomplete sets are saved but excluded from stats.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  void _showSwitchPlanDialog(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<dynamic>> allProgramsAsync,
    String currentProgramId,
  ) {
    allProgramsAsync.whenData((programs) {
      final availablePrograms = programs.where((p) => p.id.value != currentProgramId).toList();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Switch Plan'),
          content: availablePrograms.isEmpty
              ? const Text('No other plans available')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: availablePrograms.map((program) {
                    return ListTile(
                      title: Text(program.name),
                      onTap: () async {
                        Navigator.of(context).pop();
                        final repo = ref.read(programRepositoryProvider);
                        await repo.activateProgram(RecordId(program.id.value));
                        ref.invalidate(activeProgramProvider);
                        ref.invalidate(nextPlannedWorkoutProvider);
                        ref.invalidate(allProgramsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Switched to ${program.name}')),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    });
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumeActiveWorkoutCard extends ConsumerWidget {
  final domain.WorkoutSession session;
  final List<domain.PerformedExercise> exercises;
  final Map<String, List<domain.PerformedSet>> setsByExercise;

  const _ResumeActiveWorkoutCard({
    required this.session,
    required this.exercises,
    required this.setsByExercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dayName = session.programSnapshot?['dayName'] as String? ?? 'Workout';

    int completedExercises = 0;
    for (final exercise in exercises) {
      final sets = setsByExercise[exercise.id.value] ?? [];
      if (sets.isNotEmpty && sets.every((s) => s.completed)) {
        completedExercises++;
      }
    }
    final totalExercises = exercises.length;
    final progressPercent = totalExercises > 0
        ? ((completedExercises / totalExercises) * 100).round()
        : 0;

    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => context.go('/workouts'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        value: progressPercent / 100,
                        strokeWidth: 3,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.play_arrow,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resume Active Workout',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dayName • $completedExercises of $totalExercises exercises ($progressPercent%)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutHistoryCard extends ConsumerWidget {
  final domain.WorkoutSession session;

  const WorkoutHistoryCard({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(
      sessionExercisesProvider(session.id.value),
    );

    final titleText = session.programSnapshot != null
        ? '${session.programSnapshot!['programName']} - ${session.programSnapshot!['dayName']}'
        : 'Freestyle Workout';

    final statusBadge = session.status == domain.WorkoutStatus.completed
        ? _StatusBadge(label: 'Completed', color: Colors.green)
        : session.status == domain.WorkoutStatus.inProgress
        ? _StatusBadge(label: 'Draft', color: Colors.blue)
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.fitness_center,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            titleText,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (statusBadge != null) statusBadge,
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${session.workoutDate.year}-${session.workoutDate.month.toString().padLeft(2, '0')}-${session.workoutDate.day.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (session.finishedAt != null) ...[
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(
                              session.finishedAt!.difference(session.startedAt),
                            ),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        exercisesAsync.when(
                          data: (exercises) => Row(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${exercises.length} ${exercises.length == 1 ? 'exercise' : 'exercises'}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (error, _) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
    return '${minutes}m';
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            label == 'Completed' ? Icons.check_circle : Icons.edit,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
