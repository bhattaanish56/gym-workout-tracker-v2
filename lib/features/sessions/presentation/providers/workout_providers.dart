import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/database/app_database.dart' as db;
import '../../data/repositories/drift_workout_repository.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/models/workout_session.dart' as domain;
import '../../domain/models/performed_exercise.dart' as domain;
import '../../domain/models/performed_set.dart' as domain;
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/value_objects/date_time.dart';
import '../../../../core/domain/value_objects/weight.dart';
import '../../../programs/domain/repositories/program_repository.dart';
import '../../../programs/data/repositories/drift_program_repository.dart';
import '../../../programs/domain/models/program.dart' as domain;
import '../../../programs/domain/models/rotation_state.dart' as domain;
import '../../../exercises/domain/repositories/exercise_repository.dart';
import '../../../exercises/data/repositories/drift_exercise_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../sync/domain/sync_hooks.dart';
import '../../../sync/presentation/providers/sync_providers.dart';

// UUID generator
const _uuid = Uuid();

/// Database provider
final databaseProvider = Provider<db.AppDatabase>((ref) {
  return db.AppDatabase();
});

/// Current user ID provider (with fallback for offline/pre-auth usage)
final currentUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid ?? 'local_user';
});

/// Sync hooks provider
final syncHooksProvider = Provider<SyncHooks?>((ref) {
  final coordinator = ref.watch(syncCoordinatorProvider);
  return coordinator != null ? SyncHooks(coordinator) : null;
});

/// Workout repository provider
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  final syncHooks = ref.watch(syncHooksProvider);
  return DriftWorkoutRepository(database, userId, syncHooks);
});

/// Active workout state
class ActiveWorkoutState {
  final domain.WorkoutSession? session;
  final List<domain.PerformedExercise> exercises;
  final Map<String, List<domain.PerformedSet>> setsByExercise;
  final bool isLoading;
  final String? error;

  const ActiveWorkoutState({
    this.session,
    this.exercises = const [],
    this.setsByExercise = const {},
    this.isLoading = false,
    this.error,
  });

  ActiveWorkoutState copyWith({
    domain.WorkoutSession? session,
    List<domain.PerformedExercise>? exercises,
    Map<String, List<domain.PerformedSet>>? setsByExercise,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ActiveWorkoutState(
      session: session ?? this.session,
      exercises: exercises ?? this.exercises,
      setsByExercise: setsByExercise ?? this.setsByExercise,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Active workout notifier (Riverpod 3 pattern)
class ActiveWorkoutNotifier extends Notifier<ActiveWorkoutState> {
  late final WorkoutRepository _repository;
  late final ProgramRepository _programRepository;
  late final ExerciseRepository _exerciseRepository;
  Future<void>? _pendingWrite;

  @override
  ActiveWorkoutState build() {
    _repository = ref.watch(workoutRepositoryProvider);
    final db = ref.watch(databaseProvider);
    final userId = ref.watch(currentUserIdProvider);
    _programRepository = DriftProgramRepository(db, userId);
    _exerciseRepository = DriftExerciseRepository(db, userId);
    _loadActiveSession();
    return const ActiveWorkoutState();
  }

  Future<void> _loadActiveSession() async {
    try {
      final session = await _repository.getActiveSession();
      if (session == null) return;

      final exercises = await _repository.getSessionExercises(session.id.value);
      final setsByExercise = <String, List<domain.PerformedSet>>{};

      for (final exercise in exercises) {
        final sets = await _repository.getExerciseSets(exercise.id.value);
        setsByExercise[exercise.id.value] = sets;
      }

      state = ActiveWorkoutState(
        session: session,
        exercises: exercises,
        setsByExercise: setsByExercise,
      );
    } catch (e) {
      state = ActiveWorkoutState(error: 'Failed to load active session: $e');
    }
  }

  Future<void> _serializeWrite(Future<void> Function() operation) async {
    await _pendingWrite;
    _pendingWrite = operation().catchError((error) {
      // Reset pending write so subsequent operations can proceed
      _pendingWrite = null;
      throw error;
    });
    await _pendingWrite;
  }

  /// Clears any error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Starts a new freestyle workout
  Future<void> startWorkout() async {
    try {
      final existing = await _repository.getActiveSession();
      if (existing != null) {
        state = state.copyWith(error: 'Active workout already exists');
        return;
      }

      final now = DateTime.now().toUtc();
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId(_uuid.v4()),
        startedAt: now,
        workoutDate: LocalDate.fromDateTime(now),
      );

      await _serializeWrite(() => _repository.createSession(session, [], []));

      state = state.copyWith(
        session: session,
        exercises: [],
        setsByExercise: {},
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to start workout: $e');
    }
  }

  /// Starts a planned workout from program day
  /// [scheduledDate] - optional scheduled date being fulfilled (for early completion)
  /// workoutDate will always be today (actual training date)
  /// scheduledDate is stored separately to track which assignment was fulfilled
  Future<void> startPlannedWorkout(
    String programId,
    String programDayId, {
    LocalDate? scheduledDate,
  }) async {
    try {
      final existing = await _repository.getActiveSession();
      if (existing != null) {
        state = state.copyWith(error: 'Active workout already exists');
        return;
      }

      final program = await _programRepository.getProgramById(
        RecordId(programId),
      );
      final days = await _programRepository.getProgramDays(RecordId(programId));
      final day = days.where((d) => d.id.value == programDayId).firstOrNull;
      final plannedExercises = await _programRepository.getPlannedExercises(
        RecordId(programDayId),
      );

      if (program == null || day == null) {
        state = state.copyWith(error: 'Program or day not found');
        return;
      }

      if (plannedExercises.isEmpty) {
        state = state.copyWith(error: 'No exercises in this workout day');
        return;
      }

      final allExercises = await _exerciseRepository.getAllExercises();

      final sessionId = _uuid.v4();
      final now = DateTime.now().toUtc();
      final today = LocalDate.fromDateTime(now.toLocal());

      final session = domain.WorkoutSession(
        id: RecordId(sessionId),
        sourceType: domain.WorkoutSourceType.programDay,
        programId: programId,
        programDayId: programDayId,
        programSnapshot: {
          'programName': program.name,
          'dayName': day.name,
          'dayOrderIndex': day.orderIndex,
        },
        startedAt: now,
        workoutDate: today, // Always today (actual training date)
        fulfilledScheduledDate: scheduledDate, // Which scheduled date was fulfilled (if early)
        status: domain.WorkoutStatus.inProgress,
        createdAt: now,
        updatedAt: now,
      );

      await _serializeWrite(() async {
        await _repository.createSession(session, [], []);

        final exercises = <domain.PerformedExercise>[];
        final setsByExercise = <String, List<domain.PerformedSet>>{};

        for (final planned in plannedExercises) {
          final exerciseData = allExercises
              .where((e) => e.id == planned.exerciseId.value)
              .firstOrNull;
          if (exerciseData == null) continue;

          final exerciseId = _uuid.v4();
          final exercise = domain.PerformedExercise(
            id: RecordId(exerciseId),
            sessionId: session.id,
            orderIndex: planned.orderIndex,
            snapshot: domain.ExerciseSnapshot(
              name: exerciseData.canonicalName,
              equipment: exerciseData.equipment.toJson(),
              primaryMuscle: exerciseData.primaryMuscle.toJson(),
            ),
          );
          await _repository.addExercise(exercise);
          exercises.add(exercise);

          final sets = <domain.PerformedSet>[];
          final targetSets = planned.targetSets ?? 3;
          for (int i = 0; i < targetSets; i++) {
            final setId = _uuid.v4();
            final set = domain.PerformedSet(
              id: RecordId(setId),
              performedExerciseId: exercise.id,
              orderIndex: i,
              setType: domain.SetType.working,
              loadGrams: planned.targetLoadGrams != null
                  ? WeightGrams(planned.targetLoadGrams!)
                  : null,
              reps: planned.targetRepsMin,
              completed: false,
            );
            await _repository.addSet(set);
            sets.add(set);
          }
          setsByExercise[exerciseId] = sets;
        }

        state = ActiveWorkoutState(
          session: session,
          exercises: exercises,
          setsByExercise: setsByExercise,
        );
      });
    } catch (e) {
      state = state.copyWith(error: 'Failed to start planned workout: $e');
    }
  }

  /// Adds an exercise to the active workout
  Future<void> addExercise(
    String exerciseName, {
    String? equipment,
    String? primaryMuscle,
  }) async {
    if (state.session == null) return;

    final exercise = domain.PerformedExercise(
      id: RecordId(_uuid.v4()),
      sessionId: state.session!.id,
      orderIndex: state.exercises.length,
      snapshot: domain.ExerciseSnapshot(
        name: exerciseName,
        equipment: equipment,
        primaryMuscle: primaryMuscle,
      ),
    );

    try {
      await _serializeWrite(() => _repository.addExercise(exercise));

      state = state.copyWith(
        exercises: [...state.exercises, exercise],
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to add exercise: $e');
    }
  }

  /// Adds a set to an exercise
  Future<void> addSet(String exerciseId) async {
    final sets = state.setsByExercise[exerciseId] ?? [];
    final newSet = domain.PerformedSet(
      id: RecordId(_uuid.v4()),
      performedExerciseId: RecordId(exerciseId),
      orderIndex: sets.length,
      setType: domain.SetType.working,
      completed: false,
    );

    try {
      await _serializeWrite(() => _repository.addSet(newSet));

      final updatedSets = [...sets, newSet];
      final updatedSetsByExercise = Map<String, List<domain.PerformedSet>>.from(
        state.setsByExercise,
      );
      updatedSetsByExercise[exerciseId] = updatedSets;

      state = state.copyWith(
        setsByExercise: updatedSetsByExercise,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to add set: $e');
    }
  }

  /// Updates a set
  Future<void> updateSet(domain.PerformedSet updatedSet) async {
    final exerciseId = updatedSet.performedExerciseId.value;
    final sets = state.setsByExercise[exerciseId] ?? [];

    try {
      await _serializeWrite(() => _repository.updateSet(updatedSet));

      final updatedSets = sets
          .map((s) => s.id.value == updatedSet.id.value ? updatedSet : s)
          .toList();
      final updatedSetsByExercise = Map<String, List<domain.PerformedSet>>.from(
        state.setsByExercise,
      );
      updatedSetsByExercise[exerciseId] = updatedSets;

      state = state.copyWith(
        setsByExercise: updatedSetsByExercise,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to update set: $e');
    }
  }

  /// Removes a set
  Future<void> removeSet(String setId) async {
    try {
      await _serializeWrite(() => _repository.deleteSet(setId));

      final updatedSetsByExercise = Map<String, List<domain.PerformedSet>>.from(
        state.setsByExercise,
      );

      for (final exerciseId in updatedSetsByExercise.keys) {
        final sets = updatedSetsByExercise[exerciseId]!;
        final filtered = sets.where((s) => s.id.value != setId).toList();
        updatedSetsByExercise[exerciseId] = filtered;
      }

      state = state.copyWith(
        setsByExercise: updatedSetsByExercise,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to remove set: $e');
    }
  }

  /// Removes an exercise
  Future<void> removeExercise(String exerciseId) async {
    try {
      await _serializeWrite(() => _repository.deleteExercise(exerciseId));

      final filtered = state.exercises
          .where((e) => e.id.value != exerciseId)
          .toList();
      final updatedSetsByExercise = Map<String, List<domain.PerformedSet>>.from(
        state.setsByExercise,
      );
      updatedSetsByExercise.remove(exerciseId);

      state = state.copyWith(
        exercises: filtered,
        setsByExercise: updatedSetsByExercise,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to remove exercise: $e');
    }
  }

  /// Saves and completes the workout
  Future<void> finishWorkout() async {
    final session = state.session;
    if (session == null) return;

    state = state.copyWith(isLoading: true);

    try {
      await _serializeWrite(() async {
        await _repository.completeSession(
          session.id.value,
          DateTime.now().toUtc(),
        );

        // Advance rotation state if flexible_rotation program
        if (session.programId != null &&
            session.sourceType == domain.WorkoutSourceType.programDay) {
          final program = await _programRepository.getProgramById(
            RecordId(session.programId!),
          );
          if (program != null &&
              program.scheduleMode == domain.ScheduleMode.flexibleRotation) {
            final days = await _programRepository.getProgramDays(
              RecordId(session.programId!),
            );
            if (days.isNotEmpty) {
              final rotationState = await _programRepository.getRotationState(
                RecordId(session.programId!),
              );
              final currentIndex = rotationState?.nextDayIndex ?? 0;
              final nextIndex = (currentIndex + 1) % days.length;

              await _programRepository.updateRotationState(
                domain.RotationState(
                  programId: RecordId(session.programId!),
                  nextDayIndex: nextIndex,
                  lastCompletionEventId: session.id,
                ),
              );
            }
          }
        }
      });

      state = const ActiveWorkoutState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to finish workout: $e',
      );
    }
  }

  /// Discards the active workout
  Future<void> discardWorkout() async {
    final session = state.session;
    if (session == null) return;

    try {
      await _serializeWrite(() => _repository.discardSession(session.id.value));
      state = const ActiveWorkoutState();
    } catch (e) {
      state = state.copyWith(error: 'Failed to discard workout: $e');
    }
  }
}

/// Active workout provider (Riverpod 3 NotifierProvider)
final activeWorkoutProvider =
    NotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>(() {
      return ActiveWorkoutNotifier();
    });

/// Workout history provider
final workoutHistoryProvider = FutureProvider<List<domain.WorkoutSession>>((
  ref,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getAllSessions();
});

/// Individual workout session provider
final workoutSessionProvider =
    FutureProvider.family<domain.WorkoutSession?, String>((
      ref,
      sessionId,
    ) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getSession(sessionId);
    });

/// Session exercises provider
final sessionExercisesProvider =
    FutureProvider.family<List<domain.PerformedExercise>, String>((
      ref,
      sessionId,
    ) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getSessionExercises(sessionId);
    });

/// Exercise sets provider
final exerciseSetsProvider =
    FutureProvider.family<List<domain.PerformedSet>, String>((
      ref,
      exerciseId,
    ) async {
      final repository = ref.watch(workoutRepositoryProvider);
      return repository.getExerciseSets(exerciseId);
    });
