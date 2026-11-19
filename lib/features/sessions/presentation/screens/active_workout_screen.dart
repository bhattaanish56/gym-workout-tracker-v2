import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/performed_exercise.dart' as domain;
import '../../domain/models/performed_set.dart' as domain;
import '../providers/workout_providers.dart';
import '../../../exercises/presentation/widgets/exercise_picker_dialog.dart';
import '../widgets/rest_timer_notifier.dart';
import '../widgets/workout_completion_dialog.dart';
import '../widgets/set_editor_modal.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../../../home/domain/providers/today_workout_status_provider.dart';
import '../../../../core/domain/value_objects/weight.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  String? _activeExerciseId;
  final Map<String, RestTimerNotifier> _restTimers = {};
  final Map<String, String> _exerciseStates = {}; // 'performing', 'resting', 'ready'
  bool _isFinishing = false;
  DateTime? _startTime;
  Timer? _clockTimer;
  bool _isPaused = false;
  Duration _pausedDuration = Duration.zero;
  DateTime? _pauseStartTime;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final session = ref.read(activeWorkoutProvider).session;
      if (session != null) {
        setState(() => _startTime = session.startedAt);
      }
    });
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_isPaused) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    for (final timer in _restTimers.values) {
      timer.dispose();
    }
    super.dispose();
  }

  RestTimerNotifier _getRestTimer(String exerciseId) {
    return _restTimers.putIfAbsent(exerciseId, () => RestTimerNotifier());
  }

  String _getExerciseState(String exerciseId) {
    return _exerciseStates[exerciseId] ?? 'performing';
  }

  void _setExerciseState(String exerciseId, String state) {
    setState(() {
      _exerciseStates[exerciseId] = state;
    });
  }

  void _togglePause() {
    setState(() {
      if (_isPaused) {
        // Resume
        if (_pauseStartTime != null) {
          _pausedDuration += DateTime.now().difference(_pauseStartTime!);
          _pauseStartTime = null;
        }
        _isPaused = false;
        for (final timer in _restTimers.values) {
          timer.resume();
        }
      } else {
        // Pause
        _pauseStartTime = DateTime.now();
        _isPaused = true;
        for (final timer in _restTimers.values) {
          timer.pause();
        }
      }
    });
  }

  String _getElapsedTime() {
    if (_startTime == null) return '0m';

    var elapsed = DateTime.now().difference(_startTime!);
    if (_isPaused && _pauseStartTime != null) {
      elapsed -= DateTime.now().difference(_pauseStartTime!);
    }
    elapsed -= _pausedDuration;

    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Future<void> _confirmDiscard() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Workout?'),
        content: const Text('This will permanently delete your workout in progress.'),
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

    var duration = DateTime.now().difference(session.startedAt);
    if (_isPaused && _pauseStartTime != null) {
      duration -= DateTime.now().difference(_pauseStartTime!);
    }
    duration -= _pausedDuration;

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
      ref.invalidate(workoutHistoryProvider);
      ref.invalidate(workoutStatsProvider);
      ref.invalidate(streakProvider);
      ref.invalidate(todayWorkoutStatusProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout saved')),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final notifier = ref.read(activeWorkoutProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getWorkoutTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
          tooltip: 'Save & Exit',
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: theme.colorScheme.primary,
            ),
            onPressed: _togglePause,
            tooltip: _isPaused ? 'Resume' : 'Pause',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'discard') {
                _confirmDiscard();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'discard',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: theme.colorScheme.error),
                    const SizedBox(width: 8),
                    Text('Discard Workout', style: TextStyle(color: theme.colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: _isFinishing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
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
                    color: theme.colorScheme.error.withValues(alpha: 0.1),
                    border: Border.all(color: theme.colorScheme.error),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    activeWorkout.error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),

              // Workout info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isPaused ? Icons.pause_circle : Icons.timer_outlined,
                            color: _isPaused ? Colors.orange : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getElapsedTime(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _isPaused ? Colors.orange : null,
                            ),
                          ),
                          if (_isPaused) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'PAUSED',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (!activeWorkout.isLoading) ...[
                            Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Saved',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ] else ...[
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Saving...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Circular progress indicator
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: activeWorkout.exercises.isEmpty
                                    ? 0
                                    : activeWorkout.exercises.where((e) {
                                        final sets = activeWorkout.setsByExercise[e.id.value] ?? [];
                                        return sets.isNotEmpty && sets.every((s) => s.completed);
                                      }).length / activeWorkout.exercises.length,
                                  strokeWidth: 6,
                                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                  color: Colors.orange,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${activeWorkout.exercises.where((e) {
                                      final sets = activeWorkout.setsByExercise[e.id.value] ?? [];
                                      return sets.isNotEmpty && sets.every((s) => s.completed);
                                    }).length}/${activeWorkout.exercises.length}',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Workout Progress',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${activeWorkout.exercises.where((e) {
                                    final sets = activeWorkout.setsByExercise[e.id.value] ?? [];
                                    return sets.isNotEmpty && sets.every((s) => s.completed);
                                  }).length} of ${activeWorkout.exercises.length} exercises completed',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: activeWorkout.exercises.isEmpty
                                      ? 0
                                      : activeWorkout.exercises.where((e) {
                                          final sets = activeWorkout.setsByExercise[e.id.value] ?? [];
                                          return sets.isNotEmpty && sets.every((s) => s.completed);
                                        }).length / activeWorkout.exercises.length,
                                    minHeight: 8,
                                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${activeWorkout.exercises.isEmpty ? 0 : ((activeWorkout.exercises.where((e) {
                              final sets = activeWorkout.setsByExercise[e.id.value] ?? [];
                              return sets.isNotEmpty && sets.every((s) => s.completed);
                            }).length / activeWorkout.exercises.length) * 100).round()}%',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Add Exercise button
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
                            onExerciseSelected: (name, equipment, muscle) async {
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

              // Exercise cards
              ...activeWorkout.exercises.map((exercise) {
                final sets = activeWorkout.setsByExercise[exercise.id.value] ?? [];
                final isActive = _activeExerciseId == exercise.id.value;
                final exerciseId = exercise.id.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ExerciseCard(
                    exercise: exercise,
                    sets: sets,
                    isActive: isActive,
                    isPaused: _isPaused,
                    exerciseState: _getExerciseState(exerciseId),
                    restTimer: _getRestTimer(exerciseId),
                    onPlayPressed: () {
                      setState(() {
                        _activeExerciseId = exerciseId;
                        if (!_exerciseStates.containsKey(exerciseId)) {
                          _exerciseStates[exerciseId] = 'performing';
                        }
                      });
                    },
                    onPausePressed: () {
                      setState(() {
                        _activeExerciseId = null;
                      });
                    },
                    onAddSet: () => notifier.addSet(exerciseId),
                    onRemoveExercise: () => notifier.removeExercise(exerciseId),
                    onUpdateSet: notifier.updateSet,
                    onRemoveSet: notifier.removeSet,
                    onSetCompleted: () {
                      if (!_isPaused) {
                        _getRestTimer(exerciseId).start(90);
                        _setExerciseState(exerciseId, 'resting');
                      }
                    },
                    onStartNextSet: () {
                      _setExerciseState(exerciseId, 'performing');
                    },
                    onRestComplete: () {
                      _setExerciseState(exerciseId, 'ready');
                    },
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

class _ExerciseCard extends StatelessWidget {
  final domain.PerformedExercise exercise;
  final List<domain.PerformedSet> sets;
  final bool isActive;
  final bool isPaused;
  final String exerciseState; // 'performing', 'resting', 'ready'
  final RestTimerNotifier restTimer;
  final VoidCallback onPlayPressed;
  final VoidCallback onPausePressed;
  final VoidCallback onAddSet;
  final VoidCallback onRemoveExercise;
  final Future<void> Function(domain.PerformedSet) onUpdateSet;
  final Future<void> Function(String) onRemoveSet;
  final VoidCallback onSetCompleted;
  final VoidCallback onStartNextSet;
  final VoidCallback onRestComplete;

  const _ExerciseCard({
    required this.exercise,
    required this.sets,
    required this.isActive,
    required this.isPaused,
    required this.exerciseState,
    required this.restTimer,
    required this.onPlayPressed,
    required this.onPausePressed,
    required this.onAddSet,
    required this.onRemoveExercise,
    required this.onUpdateSet,
    required this.onRemoveSet,
    required this.onSetCompleted,
    required this.onStartNextSet,
    required this.onRestComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedSets = sets.where((s) => s.completed).length;
    final totalSets = sets.length;

    // Find current set (first incomplete)
    final currentSetIndex = sets.indexWhere((s) => !s.completed);
    final hasCurrentSet = currentSetIndex != -1;

    if (!isActive) {
      // Collapsed view
      return Card(
        child: InkWell(
          onTap: onPlayPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.orange.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.snapshot.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedSets of $totalSets sets completed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Expanded view
    return ListenableBuilder(
      listenable: restTimer,
      builder: (context, _) {
        // Auto-transition from resting to ready when timer completes
        if (exerciseState == 'resting' && !restTimer.isActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onRestComplete();
          });
        }

        return Card(
          color: Colors.orange.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.orange.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.snapshot.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: onPausePressed,
                  tooltip: 'Pause Exercise',
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: theme.colorScheme.error),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Remove Exercise?'),
                        content: const Text('All sets will be deleted.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      onRemoveExercise();
                    }
                  },
                  tooltip: 'Remove exercise',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // State-based content
            if (hasCurrentSet && exerciseState == 'performing') ...[
              _CurrentSetCard(
                set: sets[currentSetIndex],
                setNumber: currentSetIndex + 1,
                isPaused: isPaused,
                onUpdateSet: onUpdateSet,
                onSetCompleted: onSetCompleted,
              ),
              const SizedBox(height: 16),
            ] else if (hasCurrentSet && exerciseState == 'resting') ...[
              _RestingCard(
                restTimer: restTimer,
                completedSet: sets[currentSetIndex - 1],
                setNumber: currentSetIndex, // Shows the number of the just-completed set
              ),
              const SizedBox(height: 16),
            ] else if (hasCurrentSet && exerciseState == 'ready') ...[
              _ReadyForNextSetCard(
                onStartNextSet: onStartNextSet,
                nextSetNumber: currentSetIndex + 1,
              ),
              const SizedBox(height: 16),
            ] else if (!hasCurrentSet) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'All sets completed',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Completed sets summary
            if (completedSets > 0) ...[
              Text(
                'Completed Sets',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              ...sets.asMap().entries.where((e) => e.value.completed).map((entry) {
                final index = entry.key;
                final set = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _CompletedSetRow(
                    set: set,
                    setNumber: index + 1,
                    onEditSet: onUpdateSet,
                    onRemoveSet: onRemoveSet,
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],

            // Upcoming sets preview
            if (hasCurrentSet) ...[
              () {
                final upcomingSets = sets.skip(currentSetIndex + 1).where((s) => !s.completed).toList();
                if (upcomingSets.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 24),
                    Text(
                      'Upcoming Sets',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...upcomingSets.take(2).map((set) {
                      final setIndex = sets.indexOf(set);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _NextSetPreview(
                          set: set,
                          setNumber: setIndex + 1,
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              }(),
            ],

            // Add set button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAddSet,
                icon: const Icon(Icons.add),
                label: const Text('Add Set'),
              ),
            ),
          ],
        ),
      ),
        );
      },
    );
  }
}

class _CurrentSetCard extends StatelessWidget {
  final domain.PerformedSet set;
  final int setNumber;
  final bool isPaused;
  final Future<void> Function(domain.PerformedSet) onUpdateSet;
  final VoidCallback onSetCompleted;

  const _CurrentSetCard({
    required this.set,
    required this.setNumber,
    required this.isPaused,
    required this.onUpdateSet,
    required this.onSetCompleted,
  });

  bool _isSetValid() {
    // Weighted sets need both KG and reps
    if (set.loadGrams != null && set.loadGrams!.grams > 0) {
      return set.reps != null && set.reps! > 0;
    }
    // Bodyweight (0 kg) OK with valid reps
    return set.reps != null && set.reps! > 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isValid = _isSetValid();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Set $setNumber',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(set.setType).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  set.setType.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(set.setType),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Wheel editor tap area
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SetEditorModal(
                  set: set,
                  setNumber: setNumber,
                  onSave: (updatedSet) => onUpdateSet(updatedSet),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ValueDisplay(
                    label: 'REPS',
                    value: set.reps?.toString() ?? '-',
                  ),
                  Container(
                    width: 2,
                    height: 40,
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  _ValueDisplay(
                    label: 'KG',
                    value: set.loadGrams != null
                        ? set.loadGrams!.displayValue(WeightUnit.kg).toStringAsFixed(1)
                        : '-',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Complete button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: isValid && !isPaused ? Colors.orange : null,
              ),
              onPressed: isValid && !isPaused
                  ? () async {
                      await onUpdateSet(set.copyWith(completed: true));
                      onSetCompleted();
                    }
                  : null,
              icon: const Icon(Icons.check_circle),
              label: Text(
                isPaused
                    ? 'Resume to Complete'
                    : isValid
                        ? 'Complete Set'
                        : 'Enter Values to Complete',
              ),
            ),
          ),

          if (!isValid)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Weighted sets need both reps and weight',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getTypeColor(domain.SetType type) {
    switch (type) {
      case domain.SetType.warmup:
        return Colors.blue;
      case domain.SetType.working:
        return Colors.green;
      case domain.SetType.drop:
        return Colors.orange;
    }
  }
}

class _RestingCard extends StatelessWidget {
  final RestTimerNotifier restTimer;
  final domain.PerformedSet completedSet;
  final int setNumber;

  const _RestingCard({
    required this.restTimer,
    required this.completedSet,
    required this.setNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: restTimer,
      builder: (context, _) {
        final minutes = restTimer.remainingSeconds ~/ 60;
        final seconds = restTimer.remainingSeconds % 60;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Rest timer display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rest Timer',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Completed set summary
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Set $setNumber completed:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${completedSet.reps} reps × ${completedSet.loadGrams?.displayValue(WeightUnit.kg).toStringAsFixed(1) ?? '0'} kg',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      if (restTimer.isRunning) {
                        restTimer.pause();
                      } else {
                        restTimer.resume();
                      }
                    },
                    icon: Icon(restTimer.isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(restTimer.isRunning ? 'Pause' : 'Resume'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => restTimer.addTime(15),
                    icon: const Icon(Icons.add),
                    label: const Text('+15s'),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () => restTimer.skip(),
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Skip'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReadyForNextSetCard extends StatelessWidget {
  final VoidCallback onStartNextSet;
  final int nextSetNumber;

  const _ReadyForNextSetCard({
    required this.onStartNextSet,
    required this.nextSetNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.timer_off, color: Colors.orange.shade700, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Rest complete. Ready for Set $nextSetNumber',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
              ),
              onPressed: onStartNextSet,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Next Set'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueDisplay extends StatelessWidget {
  final String label;
  final String value;

  const _ValueDisplay({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade700,
          ),
        ),
      ],
    );
  }
}

class _CompletedSetRow extends StatelessWidget {
  final domain.PerformedSet set;
  final int setNumber;
  final Future<void> Function(domain.PerformedSet) onEditSet;
  final Future<void> Function(String) onRemoveSet;

  const _CompletedSetRow({
    required this.set,
    required this.setNumber,
    required this.onEditSet,
    required this.onRemoveSet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Text(
            'Set $setNumber',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getTypeColor(set.setType).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              set.setType.displayName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getTypeColor(set.setType),
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${set.reps ?? '-'} reps × ${set.loadGrams?.displayValue(WeightUnit.kg).toStringAsFixed(1) ?? '0'} kg',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SetEditorModal(
                  set: set,
                  setNumber: setNumber,
                  onSave: (updatedSet) => onEditSet(updatedSet),
                ),
              );
            },
            tooltip: 'Edit',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: theme.colorScheme.error),
            onPressed: () => onRemoveSet(set.id.value),
            tooltip: 'Remove',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(domain.SetType type) {
    switch (type) {
      case domain.SetType.warmup:
        return Colors.blue;
      case domain.SetType.working:
        return Colors.green;
      case domain.SetType.drop:
        return Colors.orange;
    }
  }
}

class _NextSetPreview extends StatelessWidget {
  final domain.PerformedSet set;
  final int setNumber;

  const _NextSetPreview({
    required this.set,
    required this.setNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_forward,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            'Set $setNumber',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getTypeColor(set.setType).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              set.setType.displayName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getTypeColor(set.setType),
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${set.reps ?? '-'} reps × ${set.loadGrams?.displayValue(WeightUnit.kg).toStringAsFixed(1) ?? '0'} kg',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(domain.SetType type) {
    switch (type) {
      case domain.SetType.warmup:
        return Colors.blue;
      case domain.SetType.working:
        return Colors.green;
      case domain.SetType.drop:
        return Colors.orange;
    }
  }
}
