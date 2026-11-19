import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/workout_session.dart' as domain;
import '../../domain/models/performed_exercise.dart' as domain;
import '../../domain/models/performed_set.dart' as domain;
import '../providers/workout_providers.dart';
import '../../../exercises/presentation/widgets/exercise_picker_dialog.dart';
import '../widgets/rest_timer_widget.dart';
import '../widgets/rest_timer_notifier.dart';
import '../widgets/workout_completion_dialog.dart';
import '../../../programs/presentation/providers/program_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../../../../core/domain/value_objects/weight.dart';
import '../../../../core/domain/value_objects/identifiers.dart';

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
      return const ActiveWorkoutEditor();
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Recent Workouts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

    return Card(
      child: InkWell(
        onTap: () => context.push('/workouts/${session.id.value}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                session.workoutDate.toIso8601(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              exercisesAsync.when(
                data: (exercises) => Text(
                  '${exercises.length} ${exercises.length == 1 ? 'exercise' : 'exercises'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                loading: () => Text(
                  '...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                error: (error, _) => Text(
                  'Error',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              if (session.finishedAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatDuration(
                    session.finishedAt!.difference(session.startedAt),
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
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

class ActiveWorkoutEditor extends ConsumerStatefulWidget {
  const ActiveWorkoutEditor({super.key});

  @override
  ConsumerState<ActiveWorkoutEditor> createState() =>
      _ActiveWorkoutEditorState();
}

class _ActiveWorkoutEditorState extends ConsumerState<ActiveWorkoutEditor> {
  final _repsControllers = <String, TextEditingController>{};
  final _weightControllers = <String, TextEditingController>{};
  final _restTimer = RestTimerNotifier();
  bool _isFinishing = false;
  DateTime? _startTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final session = ref.read(activeWorkoutProvider).session;
      if (session != null) {
        setState(() => _startTime = session.startedAt);
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer.dispose();
    for (final c in _repsControllers.values) {
      c.dispose();
    }
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getRepsController(domain.PerformedSet set) {
    final key = set.id.value;
    final currentValue = set.reps?.toString() ?? '';

    if (!_repsControllers.containsKey(key)) {
      _repsControllers[key] = TextEditingController(text: currentValue);
    } else {
      final controller = _repsControllers[key]!;
      if (controller.text != currentValue && !controller.selection.isValid) {
        controller.text = currentValue;
      }
    }
    return _repsControllers[key]!;
  }

  TextEditingController _getWeightController(domain.PerformedSet set) {
    final key = set.id.value;
    final currentValue = set.loadGrams != null
        ? set.loadGrams!.displayValue(WeightUnit.kg).toString()
        : '';

    if (!_weightControllers.containsKey(key)) {
      _weightControllers[key] = TextEditingController(text: currentValue);
    } else {
      final controller = _weightControllers[key]!;
      if (controller.text != currentValue && !controller.selection.isValid) {
        controller.text = currentValue;
      }
    }
    return _weightControllers[key]!;
  }

  Future<void> _confirmDiscard() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Workout?'),
        content: const Text(
          'This will permanently delete your workout in progress.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(activeWorkoutProvider.notifier).discardWorkout();
    }
  }

  Future<void> _finishWorkout() async {
    if (_isFinishing) return;

    final activeWorkout = ref.read(activeWorkoutProvider);
    final session = activeWorkout.session;
    if (session == null) return;

    final duration = DateTime.now().difference(session.startedAt);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => WorkoutCompletionDialog(
        session: session,
        exercises: activeWorkout.exercises,
        setsByExercise: activeWorkout.setsByExercise,
        duration: duration,
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isFinishing = true);

    await ref.read(activeWorkoutProvider.notifier).finishWorkout();

    if (mounted && ref.read(activeWorkoutProvider).session == null) {
      // Refresh providers to update history and stats
      ref.invalidate(workoutHistoryProvider);
      ref.invalidate(workoutStatsProvider);
      ref.invalidate(streakProvider);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Workout saved')));
    } else {
      setState(() => _isFinishing = false);
    }
  }

  String _getWorkoutTitle() {
    final session = ref.read(activeWorkoutProvider).session;
    if (session?.programSnapshot != null) {
      return '${session!.programSnapshot!['programName']} - ${session.programSnapshot!['dayName']}';
    }
    return 'Freestyle Workout';
  }

  String _getElapsedTime() {
    if (_startTime == null) return '0m';
    final elapsed = DateTime.now().difference(_startTime!);
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final notifier = ref.read(activeWorkoutProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Workout'),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Theme.of(context).colorScheme.error),
            onPressed: _confirmDiscard,
            tooltip: 'Discard',
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: _isFinishing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.check, size: 20),
            label: const Text('Finish'),
            onPressed: _isFinishing ? null : _finishWorkout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (activeWorkout.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                    border: Border.all(color: Theme.of(context).colorScheme.error),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    activeWorkout.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getWorkoutTitle(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getElapsedTime(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (!activeWorkout.isLoading) ...[
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'All changes saved',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ] else ...[
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Saving...',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              RestTimerWidget(notifier: _restTimer),
              if (_restTimer.isActive) const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => ExercisePickerDialog(
                            onExerciseSelected:
                                (name, equipment, muscle) async {
                                  await notifier.addExercise(
                                    name,
                                    equipment: equipment,
                                    primaryMuscle: muscle,
                                  );
                                },
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...activeWorkout.exercises.map((exercise) {
                final sets =
                    activeWorkout.setsByExercise[exercise.id.value] ?? [];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExerciseCard(
                    exercise: exercise,
                    sets: sets,
                    onAddSet: () => notifier.addSet(exercise.id.value),
                    onRemoveExercise: () =>
                        notifier.removeExercise(exercise.id.value),
                    onUpdateSet: notifier.updateSet,
                    onRemoveSet: notifier.removeSet,
                    onSetCompleted: () => _restTimer.start(90),
                    getRepsController: _getRepsController,
                    getWeightController: _getWeightController,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final domain.PerformedExercise exercise;
  final List<domain.PerformedSet> sets;
  final VoidCallback onAddSet;
  final VoidCallback onRemoveExercise;
  final Future<void> Function(domain.PerformedSet) onUpdateSet;
  final Future<void> Function(String) onRemoveSet;
  final VoidCallback? onSetCompleted;
  final TextEditingController Function(domain.PerformedSet) getRepsController;
  final TextEditingController Function(domain.PerformedSet) getWeightController;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.sets,
    required this.onAddSet,
    required this.onRemoveExercise,
    required this.onUpdateSet,
    required this.onRemoveSet,
    this.onSetCompleted,
    required this.getRepsController,
    required this.getWeightController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exercise.snapshot.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                  onPressed: onRemoveExercise,
                  tooltip: 'Remove exercise',
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (sets.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No sets yet',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else ...[
              Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(
                      'SET',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      'REPS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'KG',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 88,
                    child: Text(
                      '✓',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...sets.asMap().entries.map((entry) {
                final index = entry.key;
                final set = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SetRow(
                    set: set,
                    index: index,
                    onUpdateSet: onUpdateSet,
                    onRemoveSet: onRemoveSet,
                    onSetCompleted: onSetCompleted,
                    repsController: getRepsController(set),
                    weightController: getWeightController(set),
                  ),
                );
              }),
            ],
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onAddSet,
                child: const Text('+ Add Set'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  final domain.PerformedSet set;
  final int index;
  final Future<void> Function(domain.PerformedSet) onUpdateSet;
  final Future<void> Function(String) onRemoveSet;
  final VoidCallback? onSetCompleted;
  final TextEditingController repsController;
  final TextEditingController weightController;

  const _SetRow({
    required this.set,
    required this.index,
    required this.onUpdateSet,
    required this.onRemoveSet,
    this.onSetCompleted,
    required this.repsController,
    required this.weightController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            '${index + 1}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        PopupMenuButton<domain.SetType>(
          initialValue: set.setType,
          onSelected: (type) {
            onUpdateSet(set.copyWith(setType: type));
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: domain.SetType.working,
              child: Text('Working'),
            ),
            const PopupMenuItem(
              value: domain.SetType.warmup,
              child: Text('Warmup'),
            ),
          ],
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: set.setType == domain.SetType.warmup
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              set.setType == domain.SetType.warmup ? 'W' : 'S',
              style: TextStyle(
                color: set.setType == domain.SetType.warmup
                    ? Colors.blue
                    : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: repsController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              labelText: 'Reps',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
            onChanged: (value) {
              final reps = int.tryParse(value);
              if (reps != null && reps >= 0) {
                onUpdateSet(set.copyWith(reps: reps));
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              labelText: 'kg',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            ),
            onChanged: (value) {
              final kg = double.tryParse(value);
              if (kg != null && kg >= 0) {
                try {
                  onUpdateSet(set.copyWith(loadGrams: WeightGrams.fromKg(kg)));
                } catch (e) {
                  // Invalid weight, keep existing
                }
              }
            },
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 44,
          height: 44,
          child: Checkbox(
            value: set.completed,
            onChanged: (value) async {
              final wasCompleted = set.completed;
              await onUpdateSet(set.copyWith(completed: value ?? false));

              if (!wasCompleted && (value ?? false) && onSetCompleted != null) {
                onSetCompleted!();
              }
            },
          ),
        ),
        SizedBox(
          width: 44,
          height: 44,
          child: IconButton(
            icon: Icon(Icons.close, color: Theme.of(context).colorScheme.error, size: 20),
            onPressed: () => onRemoveSet(set.id.value),
            tooltip: 'Remove set',
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
