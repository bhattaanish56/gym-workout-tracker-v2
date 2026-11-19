import 'package:drift/drift.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/value_objects/date_time.dart';
import '../../../sessions/data/database/app_database.dart';

class ProgressAnalyticsService {
  final AppDatabase _db;
  final String userId;

  ProgressAnalyticsService(this._db, this.userId);

  Future<int> getTotalCompletedWorkouts({DateTime? startDate}) async {
    if (startDate == null) {
      return await (_db.workoutSessions.count(
        where: (t) => t.status.equals('completed') & t.userId.equals(userId),
      )).getSingle();
    }

    final startDateStr = LocalDate.fromDateTime(startDate).toIso8601();
    return await (_db.workoutSessions.count(
      where: (t) =>
        t.status.equals('completed') &
        t.userId.equals(userId) &
        t.workoutDate.isBiggerOrEqualValue(startDateStr),
    )).getSingle();
  }

  Future<int> getWorkoutsThisWeek() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = LocalDate.fromDateTime(startOfWeek).toIso8601();

    return await (_db.workoutSessions.count(
      where: (t) =>
          t.status.equals('completed') &
          t.workoutDate.isBiggerOrEqualValue(startDate) &
          t.userId.equals(userId),
    )).getSingle();
  }

  Future<int> getTotalCompletedSets({DateTime? startDate}) async {
    final query = _db.selectOnly(_db.performedSets)
      ..addColumns([_db.performedSets.id.count()])
      ..join([
        innerJoin(
          _db.performedExercises,
          _db.performedExercises.id.equalsExp(_db.performedSets.performedExerciseId),
        ),
        innerJoin(
          _db.workoutSessions,
          _db.workoutSessions.id.equalsExp(_db.performedExercises.sessionId),
        ),
      ]);

    if (startDate == null) {
      query.where(_db.performedSets.completed.equals(true) & _db.workoutSessions.userId.equals(userId));
    } else {
      final startDateStr = LocalDate.fromDateTime(startDate).toIso8601();
      query.where(
        _db.performedSets.completed.equals(true) &
        _db.workoutSessions.userId.equals(userId) &
        _db.workoutSessions.workoutDate.isBiggerOrEqualValue(startDateStr)
      );
    }

    final result = await query.getSingle();
    return result.read(_db.performedSets.id.count()) ?? 0;
  }

  Future<int> getTotalVolume({DateTime? startDate}) async {
    final query = _db.select(_db.performedSets).join([
      innerJoin(
        _db.performedExercises,
        _db.performedExercises.id.equalsExp(_db.performedSets.performedExerciseId),
      ),
      innerJoin(
        _db.workoutSessions,
        _db.workoutSessions.id.equalsExp(_db.performedExercises.sessionId),
      ),
    ]);

    if (startDate == null) {
      query.where(
        _db.performedSets.completed.equals(true) &
            _db.performedSets.loadGrams.isNotNull() &
            _db.performedSets.reps.isNotNull() &
            _db.workoutSessions.userId.equals(userId),
      );
    } else {
      final startDateStr = LocalDate.fromDateTime(startDate).toIso8601();
      query.where(
        _db.performedSets.completed.equals(true) &
            _db.performedSets.loadGrams.isNotNull() &
            _db.performedSets.reps.isNotNull() &
            _db.workoutSessions.userId.equals(userId) &
            _db.workoutSessions.workoutDate.isBiggerOrEqualValue(startDateStr),
      );
    }

    final results = await query.get();

    int totalVolume = 0;
    for (final row in results) {
      final set = row.readTable(_db.performedSets);
      totalVolume += (set.loadGrams! * set.reps!);
    }
    return totalVolume;
  }

  Future<int> getCurrentStreak() async {
    final sessions =
        await (_db.select(_db.workoutSessions)
              ..where((t) => t.status.equals('completed') & t.userId.equals(userId))
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
              ..where((t) => t.status.equals('completed') & t.userId.equals(userId))
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
          ..where(_db.workoutSessions.status.equals('completed') &
                  _db.workoutSessions.userId.equals(userId))
          ..orderBy([OrderingTerm.desc(_db.workoutSessions.workoutDate)]);

    final results = await query.get();

    final filtered = <Map<String, dynamic>>[];
    for (final row in results) {
      final exercise = row.readTable(_db.performedExercises);
      final snapshotJson = exercise.snapshotJson;

      // Match by exercise ID in snapshot
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
