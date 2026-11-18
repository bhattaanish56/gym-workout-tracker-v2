import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/database/app_database.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/repositories/drift_workout_repository.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/workout_session.dart'
    as domain;
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/performed_exercise.dart'
    as domain;
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/performed_set.dart'
    as domain;
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/date_time.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/weight.dart';

void main() {
  late AppDatabase db;
  late DriftWorkoutRepository repo;

  setUp(() {
    db = AppDatabase.withQueryExecutor(NativeDatabase.memory());
    repo = DriftWorkoutRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Database CRUD', () {
    test('creates and retrieves session', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-1'),
        startedAt: DateTime(2024, 1, 15, 10, 0).toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);

      final retrieved = await repo.getSession('session-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.id.value, 'session-1');
      expect(retrieved.status, domain.WorkoutStatus.inProgress);
      expect(retrieved.workoutDate, LocalDate(2024, 1, 15));
    });

    test('creates session with exercises and sets', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-2'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-1'),
        sessionId: RecordId('session-2'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Bench Press'),
      );

      final set1 = domain.PerformedSet(
        id: RecordId('set-1'),
        performedExerciseId: RecordId('ex-1'),
        orderIndex: 0,
        setType: domain.SetType.working,
        loadGrams: WeightGrams.fromKg(80),
        reps: 10,
        completed: true,
      );

      await repo.createSession(session, [exercise], [set1]);

      final exercises = await repo.getSessionExercises('session-2');
      expect(exercises.length, 1);
      expect(exercises[0].snapshot.name, 'Bench Press');

      final sets = await repo.getExerciseSets('ex-1');
      expect(sets.length, 1);
      expect(sets[0].loadGrams!.grams, 80000);
      expect(sets[0].reps, 10);
    });

    test('updates session', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-3'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);

      final completed = session.complete(DateTime.now().toUtc());
      await repo.updateSession(completed);

      final retrieved = await repo.getSession('session-3');
      expect(retrieved!.status, domain.WorkoutStatus.completed);
      expect(retrieved.finishedAt, isNotNull);
    });

    test('deletes exercise with cascade', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-4'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-2'),
        sessionId: RecordId('session-4'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Squat'),
      );

      final set1 = domain.PerformedSet(
        id: RecordId('set-2'),
        performedExerciseId: RecordId('ex-2'),
        orderIndex: 0,
        setType: domain.SetType.working,
        completed: false,
      );

      await repo.createSession(session, [exercise], [set1]);
      await repo.deleteExercise('ex-2');

      final exercises = await repo.getSessionExercises('session-4');
      expect(exercises, isEmpty);

      final sets = await repo.getExerciseSets('ex-2');
      expect(sets, isEmpty);
    });
  });

  group('Exercise and Set Ordering', () {
    test('retrieves exercises in order', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-5'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final ex1 = domain.PerformedExercise(
        id: RecordId('ex-3'),
        sessionId: RecordId('session-5'),
        orderIndex: 2,
        snapshot: const domain.ExerciseSnapshot(name: 'Third'),
      );

      final ex2 = domain.PerformedExercise(
        id: RecordId('ex-4'),
        sessionId: RecordId('session-5'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'First'),
      );

      final ex3 = domain.PerformedExercise(
        id: RecordId('ex-5'),
        sessionId: RecordId('session-5'),
        orderIndex: 1,
        snapshot: const domain.ExerciseSnapshot(name: 'Second'),
      );

      await repo.createSession(session, [ex1, ex2, ex3], []);

      final exercises = await repo.getSessionExercises('session-5');
      expect(exercises[0].snapshot.name, 'First');
      expect(exercises[1].snapshot.name, 'Second');
      expect(exercises[2].snapshot.name, 'Third');
    });

    test('retrieves sets in order', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-6'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-6'),
        sessionId: RecordId('session-6'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Press'),
      );

      final set1 = domain.PerformedSet(
        id: RecordId('set-3'),
        performedExerciseId: RecordId('ex-6'),
        orderIndex: 2,
        setType: domain.SetType.working,
        reps: 8,
        completed: true,
      );

      final set2 = domain.PerformedSet(
        id: RecordId('set-4'),
        performedExerciseId: RecordId('ex-6'),
        orderIndex: 0,
        setType: domain.SetType.warmup,
        reps: 10,
        completed: true,
      );

      final set3 = domain.PerformedSet(
        id: RecordId('set-5'),
        performedExerciseId: RecordId('ex-6'),
        orderIndex: 1,
        setType: domain.SetType.working,
        reps: 10,
        completed: true,
      );

      await repo.createSession(session, [exercise], [set1, set2, set3]);

      final sets = await repo.getExerciseSets('ex-6');
      expect(sets[0].setType, domain.SetType.warmup);
      expect(sets[0].reps, 10);
      expect(sets[1].reps, 10);
      expect(sets[2].reps, 8);
    });
  });

  group('Close and Reopen Persistence', () {
    test('data survives database close and reopen', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-7'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);

      await db.close();

      final db2 = AppDatabase.withQueryExecutor(NativeDatabase.memory());
      final repo2 = DriftWorkoutRepository(db2);

      final retrieved = await repo2.getSession('session-7');
      expect(retrieved, isNull);

      await db2.close();
    });
  });

  group('Transaction Rollback', () {
    test('transaction rolls back on error', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-8'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-7'),
        sessionId: RecordId('session-8'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Deadlift'),
      );

      await repo.createSession(session, [exercise], []);

      final duplicateExercise = domain.PerformedExercise(
        id: RecordId('ex-7'),
        sessionId: RecordId('session-8'),
        orderIndex: 1,
        snapshot: const domain.ExerciseSnapshot(name: 'Squat'),
      );

      try {
        await repo.addExercise(duplicateExercise);
        fail('Should have thrown constraint violation');
      } catch (e) {
        // Expected
      }

      final exercises = await repo.getSessionExercises('session-8');
      expect(exercises.length, 1);
      expect(exercises[0].snapshot.name, 'Deadlift');
    });
  });

  group('Duplicate Completion Prevention', () {
    test('completes session idempotently', () async {
      final startTime = DateTime.utc(2024, 1, 15, 10, 0);
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-9'),
        startedAt: startTime,
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);

      final finishTime = DateTime.utc(2024, 1, 15, 11, 30);
      await repo.completeSession('session-9', finishTime);

      final retrieved1 = await repo.getSession('session-9');
      expect(retrieved1!.status, domain.WorkoutStatus.completed);
      expect(retrieved1.finishedAt, finishTime);

      final finishTime2 = DateTime.utc(2024, 1, 15, 11, 45);
      await repo.completeSession('session-9', finishTime2);

      final retrieved2 = await repo.getSession('session-9');
      expect(retrieved2!.status, domain.WorkoutStatus.completed);
      expect(retrieved2.finishedAt, finishTime2);
    });
  });

  group('Domain to Drift Mapping', () {
    test('maps weight correctly', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-10'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-8'),
        sessionId: RecordId('session-10'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Press'),
      );

      final set1 = domain.PerformedSet(
        id: RecordId('set-6'),
        performedExerciseId: RecordId('ex-8'),
        orderIndex: 0,
        setType: domain.SetType.working,
        loadGrams: WeightGrams.fromKg(100.5),
        reps: 5,
        completed: true,
      );

      await repo.createSession(session, [exercise], [set1]);

      final sets = await repo.getExerciseSets('ex-8');
      expect(sets[0].loadGrams!.grams, 100500);
      expect(sets[0].loadGrams!.toKg(), closeTo(100.5, 0.001));
    });

    test('maps exercise snapshot to JSON', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-11'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-9'),
        sessionId: RecordId('session-11'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(
          name: 'Barbell Row',
          equipment: 'Barbell',
          primaryMuscle: 'Back',
        ),
      );

      await repo.createSession(session, [exercise], []);

      final exercises = await repo.getSessionExercises('session-11');
      expect(exercises[0].snapshot.name, 'Barbell Row');
      expect(exercises[0].snapshot.equipment, 'Barbell');
      expect(exercises[0].snapshot.primaryMuscle, 'Back');
    });

    test('maps LocalDate to ISO8601 string', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-12'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 3, 5),
      );

      await repo.createSession(session, [], []);

      final retrieved = await repo.getSession('session-12');
      expect(retrieved!.workoutDate.toIso8601(), '2024-03-05');
      expect(retrieved.workoutDate.year, 2024);
      expect(retrieved.workoutDate.month, 3);
      expect(retrieved.workoutDate.day, 5);
    });
  });

  group('History Queries', () {
    test('getAllSessions returns in descending order', () async {
      final session1 = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-13'),
        startedAt: DateTime(2024, 1, 10).toUtc(),
        workoutDate: LocalDate(2024, 1, 10),
      );

      final session2 = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-14'),
        startedAt: DateTime(2024, 1, 15).toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final session3 = domain.WorkoutSession.createFreestyle(
        id: RecordId('session-15'),
        startedAt: DateTime(2024, 1, 12).toUtc(),
        workoutDate: LocalDate(2024, 1, 12),
      );

      await repo.createSession(session1, [], []);
      await repo.createSession(session2, [], []);
      await repo.createSession(session3, [], []);

      final sessions = await repo.getAllSessions();
      expect(sessions.length, 3);
      expect(sessions[0].id.value, 'session-14');
      expect(sessions[1].id.value, 'session-15');
      expect(sessions[2].id.value, 'session-13');
    });
  });

  group('Autosave and Recovery', () {
    test('getActiveSession returns in-progress session', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('active-1'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);

      final active = await repo.getActiveSession();
      expect(active, isNotNull);
      expect(active!.id.value, 'active-1');
      expect(active.status, domain.WorkoutStatus.inProgress);
    });

    test('getActiveSession returns null when no active session', () async {
      final active = await repo.getActiveSession();
      expect(active, isNull);
    });

    test('getActiveSession ignores completed sessions', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('completed-1'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);
      await repo.completeSession('completed-1', DateTime.now().toUtc());

      final active = await repo.getActiveSession();
      expect(active, isNull);
    });

    test(
      'getActiveSession returns most recent when multiple in-progress',
      () async {
        final session1 = domain.WorkoutSession.createFreestyle(
          id: RecordId('active-2'),
          startedAt: DateTime(2024, 1, 10).toUtc(),
          workoutDate: LocalDate(2024, 1, 10),
        );

        final session2 = domain.WorkoutSession.createFreestyle(
          id: RecordId('active-3'),
          startedAt: DateTime(2024, 1, 15).toUtc(),
          workoutDate: LocalDate(2024, 1, 15),
        );

        await repo.createSession(session1, [], []);
        await repo.createSession(session2, [], []);

        final active = await repo.getActiveSession();
        expect(active!.id.value, 'active-3');
      },
    );

    test('discardSession marks session as abandoned', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('discard-1'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);
      await repo.discardSession('discard-1');

      final retrieved = await repo.getSession('discard-1');
      expect(retrieved!.status, domain.WorkoutStatus.abandoned);

      final active = await repo.getActiveSession();
      expect(active, isNull);
    });

    test('exercise autosave persists immediately', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('autosave-1'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      await repo.createSession(session, [], []);

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-auto-1'),
        sessionId: RecordId('autosave-1'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Squat'),
      );

      await repo.addExercise(exercise);

      final exercises = await repo.getSessionExercises('autosave-1');
      expect(exercises.length, 1);
      expect(exercises[0].snapshot.name, 'Squat');
    });

    test('set autosave persists immediately', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('autosave-2'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-auto-2'),
        sessionId: RecordId('autosave-2'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Press'),
      );

      await repo.createSession(session, [exercise], []);

      final set1 = domain.PerformedSet(
        id: RecordId('set-auto-1'),
        performedExerciseId: RecordId('ex-auto-2'),
        orderIndex: 0,
        setType: domain.SetType.working,
        reps: 10,
        completed: true,
      );

      await repo.addSet(set1);

      final sets = await repo.getExerciseSets('ex-auto-2');
      expect(sets.length, 1);
      expect(sets[0].reps, 10);
    });

    test('rapid consecutive updates maintain consistency', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('rapid-1'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final exercise = domain.PerformedExercise(
        id: RecordId('ex-rapid-1'),
        sessionId: RecordId('rapid-1'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Curl'),
      );

      await repo.createSession(session, [exercise], []);

      final set1 = domain.PerformedSet(
        id: RecordId('set-rapid-1'),
        performedExerciseId: RecordId('ex-rapid-1'),
        orderIndex: 0,
        setType: domain.SetType.working,
        reps: 10,
        completed: false,
      );

      await repo.addSet(set1);

      // Rapid updates
      await repo.updateSet(set1.copyWith(reps: 12));
      await repo.updateSet(set1.copyWith(reps: 15));
      await repo.updateSet(set1.copyWith(reps: 20, completed: true));

      final sets = await repo.getExerciseSets('ex-rapid-1');
      expect(sets.length, 1);
      expect(sets[0].reps, 20);
      expect(sets[0].completed, true);
    });

    test('edit and removal persistence', () async {
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('edit-1'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate(2024, 1, 15),
      );

      final ex1 = domain.PerformedExercise(
        id: RecordId('ex-edit-1'),
        sessionId: RecordId('edit-1'),
        orderIndex: 0,
        snapshot: const domain.ExerciseSnapshot(name: 'Original'),
      );

      final ex2 = domain.PerformedExercise(
        id: RecordId('ex-edit-2'),
        sessionId: RecordId('edit-1'),
        orderIndex: 1,
        snapshot: const domain.ExerciseSnapshot(name: 'ToDelete'),
      );

      await repo.createSession(session, [ex1, ex2], []);

      await repo.updateExercise(ex1.copyWith(notes: 'Updated notes'));
      await repo.deleteExercise('ex-edit-2');

      final exercises = await repo.getSessionExercises('edit-1');
      expect(exercises.length, 1);
      expect(exercises[0].notes, 'Updated notes');
    });
  });
}
