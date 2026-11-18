import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/workout_session.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/performed_exercise.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/performed_set.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/date_time.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/weight.dart';
import 'fake_workout_repository.dart';

void main() {
  group('Workout Completion', () {
    late FakeWorkoutRepository repository;

    setUp(() {
      repository = FakeWorkoutRepository();
    });

    test('completeSession marks workout as completed', () async {
      final sessionId = 'session-1';
      final now = DateTime.now().toUtc();
      final session = WorkoutSession(
        id: RecordId(sessionId),
        sourceType: WorkoutSourceType.freestyle,
        startedAt: now.subtract(const Duration(hours: 1)),
        workoutDate: LocalDate.fromDateTime(now),
        status: WorkoutStatus.inProgress,
        createdAt: now,
        updatedAt: now,
      );

      await repository.createSession(session, [], []);
      await repository.completeSession(sessionId, now);

      final completed = await repository.getSession(sessionId);
      expect(completed, isNotNull);
      expect(completed!.status, WorkoutStatus.completed);
      expect(completed.finishedAt, isNotNull);
    });

    test('completed sets contribute to volume calculation', () async {
      final sessionId = 'session-1';
      final exerciseId = 'exercise-1';
      final now = DateTime.now().toUtc();

      final session = WorkoutSession(
        id: RecordId(sessionId),
        sourceType: WorkoutSourceType.freestyle,
        startedAt: now.subtract(const Duration(hours: 1)),
        workoutDate: LocalDate.fromDateTime(now),
        status: WorkoutStatus.inProgress,
        createdAt: now,
        updatedAt: now,
      );

      final exercise = PerformedExercise(
        id: RecordId(exerciseId),
        sessionId: RecordId(sessionId),
        orderIndex: 0,
        snapshot: ExerciseSnapshot(
          name: 'Bench Press',
          equipment: 'barbell',
          primaryMuscle: 'chest',
        ),
      );

      final completedSet = PerformedSet(
        id: RecordId('set-1'),
        performedExerciseId: RecordId(exerciseId),
        orderIndex: 0,
        setType: SetType.working,
        loadGrams: WeightGrams.fromKg(80),
        reps: 10,
        completed: true,
      );

      final incompleteSet = PerformedSet(
        id: RecordId('set-2'),
        performedExerciseId: RecordId(exerciseId),
        orderIndex: 1,
        setType: SetType.working,
        loadGrams: WeightGrams.fromKg(80),
        reps: 8,
        completed: false,
      );

      await repository.createSession(session, [exercise], [completedSet, incompleteSet]);

      final sets = await repository.getExerciseSets(exerciseId);
      final completedSets = sets.where((s) => s.completed).toList();
      final incompleteSets = sets.where((s) => !s.completed).toList();

      expect(completedSets.length, 1);
      expect(incompleteSets.length, 1);

      // Volume calculation: only completed working sets
      int volumeGrams = 0;
      for (final set in completedSets) {
        if (set.setType == SetType.working && set.loadGrams != null && set.reps != null) {
          volumeGrams += (set.loadGrams!.grams * set.reps!).toInt();
        }
      }

      expect(volumeGrams, 800000); // 80kg * 10 reps * 1000g/kg
    });

    test('incomplete sets are saved but excluded from statistics', () async {
      final sessionId = 'session-1';
      final exerciseId = 'exercise-1';
      final now = DateTime.now().toUtc();

      final session = WorkoutSession(
        id: RecordId(sessionId),
        sourceType: WorkoutSourceType.freestyle,
        startedAt: now.subtract(const Duration(hours: 1)),
        workoutDate: LocalDate.fromDateTime(now),
        status: WorkoutStatus.inProgress,
        createdAt: now,
        updatedAt: now,
      );

      final exercise = PerformedExercise(
        id: RecordId(exerciseId),
        sessionId: RecordId(sessionId),
        orderIndex: 0,
        snapshot: ExerciseSnapshot(
          name: 'Squat',
          equipment: 'barbell',
          primaryMuscle: 'quads',
        ),
      );

      final incompleteSet = PerformedSet(
        id: RecordId('set-1'),
        performedExerciseId: RecordId(exerciseId),
        orderIndex: 0,
        setType: SetType.working,
        loadGrams: WeightGrams.fromKg(100),
        reps: null,
        completed: false,
      );

      await repository.createSession(session, [exercise], [incompleteSet]);
      await repository.completeSession(sessionId, now);

      final savedSets = await repository.getExerciseSets(exerciseId);
      expect(savedSets.length, 1);
      expect(savedSets.first.completed, false);

      // Incomplete set should not contribute to volume
      final set = savedSets.first;
      final shouldContribute = set.completed &&
                               set.setType == SetType.working &&
                               set.loadGrams != null &&
                               set.reps != null;
      expect(shouldContribute, false);
    });

    test('getAllSessions returns completed workouts only', () async {
      final now = DateTime.now().toUtc();

      final inProgress = WorkoutSession(
        id: RecordId('in-progress'),
        sourceType: WorkoutSourceType.freestyle,
        startedAt: now,
        workoutDate: LocalDate.fromDateTime(now),
        status: WorkoutStatus.inProgress,
        createdAt: now,
        updatedAt: now,
      );

      final completed = WorkoutSession(
        id: RecordId('completed'),
        sourceType: WorkoutSourceType.freestyle,
        startedAt: now.subtract(const Duration(hours: 2)),
        finishedAt: now.subtract(const Duration(hours: 1)),
        workoutDate: LocalDate.fromDateTime(now),
        status: WorkoutStatus.completed,
        createdAt: now,
        updatedAt: now,
      );

      await repository.createSession(inProgress, [], []);
      await repository.createSession(completed, [], []);

      final history = await repository.getAllSessions();
      expect(history.length, 1);
      expect(history.first.status, WorkoutStatus.completed);
      expect(history.first.id.value, 'completed');
    });
  });
}
