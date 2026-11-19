import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/date_time.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/database/app_database.dart';
import 'package:gym_workout_tracker_v2/features/progress/domain/services/progress_analytics_service.dart';
import 'package:drift/drift.dart';

void main() {
  late AppDatabase db;
  late ProgressAnalyticsService analytics;

  setUp(() {
    db = AppDatabase.withQueryExecutor(NativeDatabase.memory());
    analytics = ProgressAnalyticsService(db, 'test_user');
  });

  tearDown(() async {
    await db.close();
  });

  group('ProgressAnalyticsService', () {
    test('counts total completed workouts', () async {
      await _addWorkout(db, '1', 'completed', '2026-11-15');
      await _addWorkout(db, '2', 'completed', '2026-11-16');
      await _addWorkout(db, '3', 'active', '2026-11-17');

      final count = await analytics.getTotalCompletedWorkouts();
      expect(count, 2);
    });

    test('counts workouts this week', () async {
      final today = DateTime.now();
      final thisWeek = LocalDate.fromDateTime(today).toIso8601();
      final lastWeek = LocalDate.fromDateTime(
        today.subtract(const Duration(days: 8)),
      ).toIso8601();

      await _addWorkout(db, '1', 'completed', thisWeek);
      await _addWorkout(db, '2', 'completed', lastWeek);

      final count = await analytics.getWorkoutsThisWeek();
      expect(count, greaterThanOrEqualTo(1));
    });

    test('calculates current streak', () async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      await _addWorkout(
        db,
        '1',
        'completed',
        LocalDate.fromDateTime(today).toIso8601(),
      );
      await _addWorkout(
        db,
        '2',
        'completed',
        LocalDate.fromDateTime(yesterday).toIso8601(),
      );

      final streak = await analytics.getCurrentStreak();
      expect(streak, 2);
    });

    test('returns zero streak when no recent workouts', () async {
      final oldDate = DateTime.now().subtract(const Duration(days: 5));
      await _addWorkout(
        db,
        '1',
        'completed',
        LocalDate.fromDateTime(oldDate).toIso8601(),
      );

      final streak = await analytics.getCurrentStreak();
      expect(streak, 0);
    });

    test('counts total completed sets', () async {
      final sessionId = await _addWorkout(db, 's1', 'completed', '2026-11-15');
      final exerciseId = await _addExercise(db, 'e1', sessionId);
      await _addSet(db, '1', exerciseId, true);
      await _addSet(db, '2', exerciseId, true);
      await _addSet(db, '3', exerciseId, false);

      final count = await analytics.getTotalCompletedSets();
      expect(count, 2);
    });

    test('calculates total volume', () async {
      final sessionId = await _addWorkout(db, 's1', 'completed', '2026-11-15');
      final exerciseId = await _addExercise(db, 'e1', sessionId);
      await _addSet(db, '1', exerciseId, true, loadGrams: 10000, reps: 10);
      await _addSet(db, '2', exerciseId, true, loadGrams: 10000, reps: 8);

      final volume = await analytics.getTotalVolume();
      expect(volume, 180000); // (10*10000) + (8*10000)
    });
  });
}

Future<String> _addWorkout(
  AppDatabase db,
  String id,
  String status,
  String date,
) async {
  await db
      .into(db.workoutSessions)
      .insert(
        WorkoutSessionsCompanion.insert(
          id: id,
          userId: const Value('test_user'),
          sourceType: 'manual',
          startedAt: DateTime.now(),
          workoutDate: date,
          status: status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
  return id;
}

Future<String> _addExercise(AppDatabase db, String id, String sessionId) async {
  await db
      .into(db.performedExercises)
      .insert(
        PerformedExercisesCompanion.insert(
          id: id,
          sessionId: sessionId,
          orderIndex: 0,
          snapshotJson: '{"id":"ex1","name":"Test"}',
        ),
      );
  return id;
}

Future<void> _addSet(
  AppDatabase db,
  String id,
  String exerciseId,
  bool completed, {
  int? loadGrams,
  int? reps,
}) async {
  await db
      .into(db.performedSets)
      .insert(
        PerformedSetsCompanion.insert(
          id: id,
          performedExerciseId: exerciseId,
          orderIndex: 0,
          setType: 'working',
          completed: completed,
          loadGrams: Value(loadGrams),
          reps: Value(reps),
        ),
      );
}
