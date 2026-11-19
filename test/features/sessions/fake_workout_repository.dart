import 'package:gym_workout_tracker_v2/features/sessions/domain/repositories/workout_repository.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/workout_session.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/performed_exercise.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/performed_set.dart';

/// In-memory fake repository for widget tests
class FakeWorkoutRepository implements WorkoutRepository {
  final Map<String, WorkoutSession> _sessions = {};
  final Map<String, List<PerformedExercise>> _exercises = {};
  final Map<String, List<PerformedSet>> _sets = {};

  @override
  Future<void> createSession(
    WorkoutSession session,
    List<PerformedExercise> exercises,
    List<PerformedSet> sets,
  ) async {
    _sessions[session.id.value] = session;
    _exercises[session.id.value] = List.from(exercises);
    for (final exercise in exercises) {
      final exerciseSets = sets
          .where((s) => s.performedExerciseId.value == exercise.id.value)
          .toList();
      _sets[exercise.id.value] = exerciseSets;
    }
  }

  @override
  Future<WorkoutSession?> getSession(String sessionId) async {
    return _sessions[sessionId];
  }

  @override
  Future<void> updateSession(WorkoutSession session) async {
    _sessions[session.id.value] = session;
  }

  @override
  Future<List<WorkoutSession>> getAllSessions() async {
    final sessions = _sessions.values.toList();
    sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sessions;
  }

  @override
  Future<WorkoutSession?> getActiveSession() async {
    final inProgress = _sessions.values
        .where((s) => s.status == WorkoutStatus.inProgress)
        .toList();

    if (inProgress.isEmpty) return null;

    inProgress.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return inProgress.first;
  }

  @override
  Future<void> completeSession(String sessionId, DateTime finishedAt) async {
    final session = _sessions[sessionId];
    if (session == null) throw Exception('Session not found');

    final completed = WorkoutSession(
      id: session.id,
      sourceType: session.sourceType,
      programId: session.programId,
      programDayId: session.programDayId,
      programSnapshot: session.programSnapshot,
      startedAt: session.startedAt,
      finishedAt: finishedAt,
      workoutDate: session.workoutDate,
      fulfilledScheduledDate: session.fulfilledScheduledDate,
      status: WorkoutStatus.completed,
      createdAt: session.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );

    _sessions[sessionId] = completed;
  }

  @override
  Future<void> discardSession(String sessionId) async {
    final session = _sessions[sessionId];
    if (session == null) throw Exception('Session not found');

    final abandoned = WorkoutSession(
      id: session.id,
      sourceType: session.sourceType,
      programId: session.programId,
      programDayId: session.programDayId,
      programSnapshot: session.programSnapshot,
      startedAt: session.startedAt,
      finishedAt: session.finishedAt,
      workoutDate: session.workoutDate,
      fulfilledScheduledDate: session.fulfilledScheduledDate,
      status: WorkoutStatus.abandoned,
      createdAt: session.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );

    _sessions[sessionId] = abandoned;
  }

  @override
  Future<void> addExercise(PerformedExercise exercise) async {
    final sessionExercises = _exercises[exercise.sessionId.value] ?? [];
    sessionExercises.add(exercise);
    _exercises[exercise.sessionId.value] = sessionExercises;
    _sets[exercise.id.value] = [];
  }

  @override
  Future<List<PerformedExercise>> getSessionExercises(String sessionId) async {
    final exercises = _exercises[sessionId] ?? [];
    exercises.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return exercises;
  }

  @override
  Future<void> updateExercise(PerformedExercise exercise) async {
    final sessionExercises = _exercises[exercise.sessionId.value] ?? [];
    final index = sessionExercises.indexWhere(
      (e) => e.id.value == exercise.id.value,
    );
    if (index != -1) {
      sessionExercises[index] = exercise;
      _exercises[exercise.sessionId.value] = sessionExercises;
    }
  }

  @override
  Future<void> deleteExercise(String exerciseId) async {
    for (final sessionId in _exercises.keys) {
      _exercises[sessionId] = _exercises[sessionId]!
          .where((e) => e.id.value != exerciseId)
          .toList();
    }
    _sets.remove(exerciseId);
  }

  @override
  Future<void> addSet(PerformedSet set) async {
    final exerciseSets = _sets[set.performedExerciseId.value] ?? [];
    exerciseSets.add(set);
    _sets[set.performedExerciseId.value] = exerciseSets;
  }

  @override
  Future<void> updateSet(PerformedSet set) async {
    final exerciseSets = _sets[set.performedExerciseId.value] ?? [];
    final index = exerciseSets.indexWhere((s) => s.id.value == set.id.value);
    if (index != -1) {
      exerciseSets[index] = set;
      _sets[set.performedExerciseId.value] = exerciseSets;
    }
  }

  @override
  Future<void> deleteSet(String setId) async {
    for (final exerciseId in _sets.keys) {
      _sets[exerciseId] = _sets[exerciseId]!
          .where((s) => s.id.value != setId)
          .toList();
    }
  }

  @override
  Future<List<PerformedSet>> getExerciseSets(String exerciseId) async {
    final sets = _sets[exerciseId] ?? [];
    sets.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return sets;
  }

  void clear() {
    _sessions.clear();
    _exercises.clear();
    _sets.clear();
  }
}
