import 'package:drift/drift.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/value_objects/date_time.dart';
import '../../../sessions/data/database/app_database.dart';

class ProgressAnalyticsService {
  final AppDatabase _db;

  ProgressAnalyticsService(this._db);

  Future<int> getTotalCompletedWorkouts() async {
    return await (_db.workoutSessions.count(
      where: (t) => t.status.equals('completed'),
    )).getSingle();
  }

  Future<int> getWorkoutsThisWeek() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = LocalDate.fromDateTime(startOfWeek).toIso8601();

    return await (_db.workoutSessions.count(
      where: (t) =>
          t.status.equals('completed') &
          t.workoutDate.isBiggerOrEqualValue(startDate),
    )).getSingle();
  }

  Future<int> getTotalCompletedSets() async {
    return await (_db.performedSets.count(
      where: (t) => t.completed.equals(true),
    )).getSingle();
  }

  Future<int> getTotalVolume() async {
    final sets =
        await (_db.select(_db.performedSets)..where(
              (t) =>
                  t.completed.equals(true) &
                  t.loadGrams.isNotNull() &
                  t.reps.isNotNull(),
            ))
            .get();

    return sets.fold<int>(0, (sum, set) {
      return sum + (set.loadGrams! * set.reps!);
    });
  }

  Future<int> getCurrentStreak() async {
    final sessions =
        await (_db.select(_db.workoutSessions)
              ..where((t) => t.status.equals('completed'))
              ..orderBy([(t) => OrderingTerm.desc(t.workoutDate)]))
            .get();

    if (sessions.isEmpty) return 0;

    int streak = 0;
    DateTime? lastDate;

    for (final session in sessions) {
      final sessionDate = LocalDate.parse(session.workoutDate);
      final sessionDateTime = DateTime(
        sessionDate.year,
        sessionDate.month,
        sessionDate.day,
      );

      if (lastDate == null) {
        final today = DateTime.now();
        final todayStart = DateTime(today.year, today.month, today.day);
        final diff = todayStart.difference(sessionDateTime).inDays;
        if (diff > 1) break;
        streak = 1;
        lastDate = sessionDateTime;
      } else {
        final diff = lastDate.difference(sessionDateTime).inDays;
        if (diff <= 1) {
          if (diff == 1) streak++;
          lastDate = sessionDateTime;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  Future<int> getLongestStreak() async {
    final sessions =
        await (_db.select(_db.workoutSessions)
              ..where((t) => t.status.equals('completed'))
              ..orderBy([(t) => OrderingTerm.asc(t.workoutDate)]))
            .get();

    if (sessions.isEmpty) return 0;

    int longestStreak = 0;
    int currentStreak = 1;
    DateTime? lastDate;

    for (final session in sessions) {
      final sessionDate = LocalDate.parse(session.workoutDate);
      final sessionDateTime = DateTime(
        sessionDate.year,
        sessionDate.month,
        sessionDate.day,
      );

      if (lastDate == null) {
        lastDate = sessionDateTime;
      } else {
        final diff = sessionDateTime.difference(lastDate).inDays;
        if (diff <= 1) {
          if (diff == 1) currentStreak++;
        } else {
          if (currentStreak > longestStreak) longestStreak = currentStreak;
          currentStreak = 1;
        }
        lastDate = sessionDateTime;
      }
    }

    return currentStreak > longestStreak ? currentStreak : longestStreak;
  }

  Future<List<Map<String, dynamic>>> getExerciseHistory(
    ExerciseId exerciseId,
  ) async {
    final query =
        _db.select(_db.performedSets).join([
            innerJoin(
              _db.performedExercises,
              _db.performedExercises.id.equalsExp(
                _db.performedSets.performedExerciseId,
              ),
            ),
            innerJoin(
              _db.workoutSessions,
              _db.workoutSessions.id.equalsExp(
                _db.performedExercises.sessionId,
              ),
            ),
          ])
          ..where(_db.workoutSessions.status.equals('completed'))
          ..orderBy([OrderingTerm.desc(_db.workoutSessions.workoutDate)]);

    final results = await query.get();

    final filtered = <Map<String, dynamic>>[];
    for (final row in results) {
      final exercise = row.readTable(_db.performedExercises);
      final snapshotJson = exercise.snapshotJson;

      if (snapshotJson.contains('"id":"${exerciseId.value}"')) {
        final set = row.readTable(_db.performedSets);
        final session = row.readTable(_db.workoutSessions);
        filtered.add({'set': set, 'session': session});
      }
    }

    return filtered;
  }

  Future<int?> getHeaviestLift(ExerciseId exerciseId) async {
    final history = await getExerciseHistory(exerciseId);

    int? maxLoad;
    for (final item in history) {
      final set = item['set'] as PerformedSet;
      if (set.completed && set.setType == 'working' && set.loadGrams != null) {
        if (maxLoad == null || set.loadGrams! > maxLoad) {
          maxLoad = set.loadGrams;
        }
      }
    }

    return maxLoad;
  }

  Future<double?> estimateOneRepMax(ExerciseId exerciseId) async {
    final history = await getExerciseHistory(exerciseId);

    double? bestEstimate;
    for (final item in history) {
      final set = item['set'] as PerformedSet;
      if (set.completed &&
          set.setType == 'working' &&
          set.loadGrams != null &&
          set.reps != null &&
          set.reps! >= 1 &&
          set.reps! <= 10) {
        final weightKg = set.loadGrams! / 1000;
        final estimate = weightKg * (1 + set.reps! / 30);
        if (bestEstimate == null || estimate > bestEstimate) {
          bestEstimate = estimate;
        }
      }
    }

    return bestEstimate;
  }
}
