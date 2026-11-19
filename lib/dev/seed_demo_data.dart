import 'dart:math';
import '../core/domain/value_objects/identifiers.dart';
import '../core/domain/value_objects/date_time.dart';
import '../core/domain/value_objects/weight.dart';
import '../features/sessions/data/database/app_database.dart';
import '../features/sessions/domain/models/workout_session.dart' as domain;
import '../features/sessions/domain/models/performed_exercise.dart' as domain;
import '../features/sessions/domain/models/performed_set.dart' as domain;
import '../features/progress/data/repositories/drift_progress_repository.dart';
import '../features/sessions/data/repositories/drift_workout_repository.dart';
import '../features/sync/domain/sync_hooks.dart';

/// One-time development seed for 90 days of demo workout and bodyweight data.
class DemoDataSeeder {
  final AppDatabase db;
  final String userId;
  final SyncHooks? syncHooks;
  final Random _random = Random(42); // Fixed seed for consistency

  DemoDataSeeder(this.db, this.userId, {this.syncHooks});

  /// Execute seeding with idempotent IDs to prevent duplicates
  Future<SeedingResult> seed() async {
    final result = SeedingResult();

    // Check if already seeded
    final existingCount = await _checkExistingDemoData();
    if (existingCount > 40) {
      result.alreadySeeded = true;
      result.existingWorkouts = existingCount;
      return result;
    }

    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 90));

    // Seed bodyweight entries (13 weekly measurements)
    await _seedBodyweightHistory(startDate, now, result);

    // Seed workout history (48 workouts over 90 days, ~4 per week)
    await _seedWorkoutHistory(startDate, now, result);

    return result;
  }

  Future<int> _checkExistingDemoData() async {
    final query = db.select(db.workoutSessions)
      ..where((t) => t.userId.equals(userId));
    final results = await query.get();
    return results.where((row) => row.id.startsWith('demo_')).length;
  }

  Future<void> _seedBodyweightHistory(DateTime start, DateTime end, SeedingResult result) async {
    final repo = DriftProgressRepository(db, userId, syncHooks);

    // Progress from 79kg to 84kg with natural fluctuations
    const startWeight = 79.0;
    const endWeight = 84.0;
    const measurements = 13;
    final weightGain = endWeight - startWeight;

    for (int i = 0; i < measurements; i++) {
      final daysOffset = (90 / (measurements - 1) * i).round();
      final measureDate = start.add(Duration(days: daysOffset));

      // Linear progression with random fluctuation
      final baseWeight = startWeight + (weightGain * i / (measurements - 1));
      final fluctuation = (_random.nextDouble() - 0.5) * 0.8; // ±0.4kg
      final weight = baseWeight + fluctuation;

      try {
        await repo.addBodyWeight(
          id: RecordId('demo_bw_$i'),
          weightGrams: (weight * 1000).round(),
          measuredAt: measureDate.toUtc(),
          measuredDate: LocalDate.fromDateTime(measureDate),
        );
        result.bodyweightCount++;
      } catch (e) {
        // Skip if already exists (UNIQUE constraint)
      }
    }
  }

  Future<void> _seedWorkoutHistory(DateTime start, DateTime end, SeedingResult result) async {
    final repo = DriftWorkoutRepository(db, userId, syncHooks);

    // PPL split: Push, Pull, Legs cycling
    final workoutTypes = ['push', 'pull', 'legs', 'upper', 'lower'];
    int workoutIndex = 0;
    int cycleIndex = 0;

    // Generate ~48 workouts over 90 days (average 4 per week)
    DateTime current = start;
    while (current.isBefore(end) && workoutIndex < 48) {
      // Skip occasional days (simulate rest/missed)
      if (_random.nextDouble() < 0.25) {
        current = current.add(const Duration(days: 1));
        continue;
      }

      final workoutType = workoutTypes[cycleIndex % workoutTypes.length];
      final exercises = _getExercisesForWorkout(workoutType);

      await _createWorkout(
        repo: repo,
        workoutIndex: workoutIndex,
        date: current,
        exercises: exercises,
        weekNumber: (workoutIndex / 4).floor(),
      );

      result.workoutCount++;
      workoutIndex++;
      cycleIndex++;
      current = current.add(const Duration(days: 1));
    }
  }

  List<Map<String, dynamic>> _getExercisesForWorkout(String type) {
    switch (type) {
      case 'push':
        return [
          {'id': 'ex_bench_press_barbell', 'name': 'Barbell Bench Press', 'baseWeight': 60},
          {'id': 'ex_press_overhead_dumbbell', 'name': 'Dumbbell Overhead Press', 'baseWeight': 20},
          {'id': 'ex_incline_bench_press_dumbbell', 'name': 'Incline Dumbbell Press', 'baseWeight': 25},
          {'id': 'ex_lateral_raise', 'name': 'Lateral Raise', 'baseWeight': 10},
          {'id': 'ex_tricep_pushdown', 'name': 'Tricep Pushdown', 'baseWeight': 25},
        ];
      case 'pull':
        return [
          {'id': 'ex_deadlift_barbell', 'name': 'Barbell Deadlift', 'baseWeight': 80},
          {'id': 'ex_pullup', 'name': 'Pull-up', 'baseWeight': 0},
          {'id': 'ex_row_barbell_bent', 'name': 'Bent Over Row', 'baseWeight': 50},
          {'id': 'ex_facepull', 'name': 'Face Pull', 'baseWeight': 20},
          {'id': 'ex_curl_barbell', 'name': 'Barbell Curl', 'baseWeight': 25},
        ];
      case 'legs':
        return [
          {'id': 'ex_squat_barbell', 'name': 'Barbell Squat', 'baseWeight': 70},
          {'id': 'ex_leg_press', 'name': 'Leg Press', 'baseWeight': 100},
          {'id': 'ex_rdl_barbell', 'name': 'Romanian Deadlift', 'baseWeight': 60},
          {'id': 'ex_leg_curl_lying', 'name': 'Lying Leg Curl', 'baseWeight': 30},
          {'id': 'ex_calf_raise_standing', 'name': 'Standing Calf Raise', 'baseWeight': 40},
        ];
      case 'upper':
        return [
          {'id': 'ex_bench_press_barbell', 'name': 'Barbell Bench Press', 'baseWeight': 60},
          {'id': 'ex_row_barbell_bent', 'name': 'Bent Over Row', 'baseWeight': 50},
          {'id': 'ex_press_overhead_dumbbell', 'name': 'Dumbbell Overhead Press', 'baseWeight': 20},
          {'id': 'ex_lat_pulldown', 'name': 'Lat Pulldown', 'baseWeight': 40},
        ];
      case 'lower':
        return [
          {'id': 'ex_squat_barbell', 'name': 'Barbell Squat', 'baseWeight': 70},
          {'id': 'ex_rdl_barbell', 'name': 'Romanian Deadlift', 'baseWeight': 60},
          {'id': 'ex_leg_press', 'name': 'Leg Press', 'baseWeight': 100},
          {'id': 'ex_leg_curl_lying', 'name': 'Lying Leg Curl', 'baseWeight': 30},
        ];
      default:
        return [];
    }
  }

  Future<void> _createWorkout({
    required DriftWorkoutRepository repo,
    required int workoutIndex,
    required DateTime date,
    required List<Map<String, dynamic>> exercises,
    required int weekNumber,
  }) async {
    final sessionId = RecordId('demo_session_$workoutIndex');
    final startTime = date.add(Duration(hours: 9 + _random.nextInt(8)));
    final duration = Duration(minutes: 45 + _random.nextInt(30));
    final finishTime = startTime.add(duration);

    final session = domain.WorkoutSession(
      id: sessionId,
      sourceType: domain.WorkoutSourceType.freestyle,
      startedAt: startTime.toUtc(),
      finishedAt: finishTime.toUtc(),
      workoutDate: LocalDate.fromDateTime(date),
      status: domain.WorkoutStatus.completed,
      createdAt: startTime.toUtc(),
      updatedAt: finishTime.toUtc(),
    );

    final performedExercises = <domain.PerformedExercise>[];
    final performedSets = <domain.PerformedSet>[];

    for (int i = 0; i < exercises.length; i++) {
      final exerciseData = exercises[i];
      final exerciseId = RecordId('demo_ex_${workoutIndex}_$i');

      performedExercises.add(domain.PerformedExercise(
        id: exerciseId,
        sessionId: sessionId,
        orderIndex: i,
        snapshot: domain.ExerciseSnapshot(
          id: exerciseData['id'],
          name: exerciseData['name'],
        ),
      ));

      // 3-4 sets per exercise with progressive overload
      final numSets = 3 + _random.nextInt(2);
      final baseWeight = exerciseData['baseWeight'] as int;
      final progressionWeight = (baseWeight * weekNumber * 0.05).round();

      for (int s = 0; s < numSets; s++) {
        final setWeight = baseWeight + progressionWeight + (_random.nextInt(10) - 5);
        final reps = exerciseData['id'] == 'ex_pullup'
            ? 6 + _random.nextInt(6)
            : 8 + _random.nextInt(5);

        performedSets.add(domain.PerformedSet(
          id: RecordId('demo_set_${workoutIndex}_${i}_$s'),
          performedExerciseId: exerciseId,
          orderIndex: s,
          setType: domain.SetType.working,
          loadGrams: exerciseData['id'] == 'ex_pullup' ? null : WeightGrams.fromKg(setWeight.toDouble()),
          reps: reps,
          completed: true,
        ));
      }
    }

    try {
      await repo.createSession(session, performedExercises, performedSets);
    } catch (e) {
      // Skip if already exists
    }
  }
}

class SeedingResult {
  bool alreadySeeded = false;
  int existingWorkouts = 0;
  int workoutCount = 0;
  int bodyweightCount = 0;
}
