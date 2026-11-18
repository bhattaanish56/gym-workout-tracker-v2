import '../models/workout_session.dart';
import '../models/performed_exercise.dart';
import '../models/performed_set.dart';

/// Repository interface for workout session persistence.
abstract class WorkoutRepository {
  /// Creates a new workout session with exercises and sets.
  Future<void> createSession(
    WorkoutSession session,
    List<PerformedExercise> exercises,
    List<PerformedSet> sets,
  );

  /// Updates an existing workout session.
  Future<void> updateSession(WorkoutSession session);

  /// Retrieves a workout session by ID.
  Future<WorkoutSession?> getSession(String sessionId);

  /// Retrieves all workout sessions, ordered by start time descending.
  Future<List<WorkoutSession>> getAllSessions();

  /// Retrieves exercises for a session, ordered by orderIndex.
  Future<List<PerformedExercise>> getSessionExercises(String sessionId);

  /// Retrieves sets for an exercise, ordered by orderIndex.
  Future<List<PerformedSet>> getExerciseSets(String exerciseId);

  /// Adds a performed exercise to a session.
  Future<void> addExercise(PerformedExercise exercise);

  /// Updates a performed exercise.
  Future<void> updateExercise(PerformedExercise exercise);

  /// Deletes a performed exercise and its sets.
  Future<void> deleteExercise(String exerciseId);

  /// Adds a set to an exercise.
  Future<void> addSet(PerformedSet set);

  /// Updates a performed set.
  Future<void> updateSet(PerformedSet set);

  /// Deletes a performed set.
  Future<void> deleteSet(String setId);

  /// Completes a workout session (marks as completed with finish time).
  Future<void> completeSession(String sessionId, DateTime finishedAt);

  /// Retrieves the active (in-progress) session, if any.
  Future<WorkoutSession?> getActiveSession();

  /// Discards a workout session (marks as abandoned).
  Future<void> discardSession(String sessionId);
}
