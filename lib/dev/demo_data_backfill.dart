import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../features/sessions/data/database/app_database.dart';
import '../features/sync/domain/sync_hooks.dart';
import '../features/sync/data/firestore_serializer.dart';
import '../features/sessions/domain/models/workout_session.dart' as domain;
import '../features/sessions/domain/models/performed_exercise.dart' as domain;
import '../features/sessions/domain/models/performed_set.dart' as domain;
import '../features/progress/domain/models/bodyweight_entry.dart' as domain;
import '../core/domain/value_objects/identifiers.dart';
import '../core/domain/value_objects/date_time.dart';
import '../core/domain/value_objects/weight.dart';

/// Backfill existing demo data to Firestore sync queue
class DemoDataBackfill {
  final AppDatabase db;
  final String userId;
  final SyncHooks? syncHooks;

  DemoDataBackfill(this.db, this.userId, this.syncHooks);

  /// Enqueue all existing demo workout sessions and bodyweight entries for sync
  Future<BackfillResult> backfillToSyncQueue() async {
    final result = BackfillResult();

    if (syncHooks == null) {
      result.error = 'Sync not available (offline or guest mode)';
      return result;
    }

    try {
      // Backfill workout sessions
      await _backfillWorkouts(result);

      // Backfill bodyweight entries
      await _backfillBodyweight(result);

      return result;
    } catch (e) {
      result.error = e.toString();
      return result;
    }
  }

  Future<void> _backfillWorkouts(BackfillResult result) async {
    // Query all demo workout sessions
    final sessions = await (db.select(db.workoutSessions)
          ..where((t) => t.userId.equals(userId)))
        .get();

    final demoSessions = sessions.where((s) => s.id.startsWith('demo_')).toList();

    for (final sessionRow in demoSessions) {
      try {
        // Get exercises for this session
        final exerciseRows = await (db.select(db.performedExercises)
              ..where((t) => t.sessionId.equals(sessionRow.id)))
            .get();

        // Get sets for this session
        final setRows = await (db.select(db.performedSets)
              ..where((t) => t.performedExerciseId.isIn(
                    exerciseRows.map((e) => e.id).toList(),
                  )))
            .get();

        // Convert to domain models
        final session = _convertSession(sessionRow);
        final exercises = exerciseRows.map(_convertExercise).toList();
        final sets = setRows.map(_convertSet).toList();

        // Serialize to Firestore format
        final data = FirestoreSerializer.serializeWorkout(session, exercises, sets);

        // Enqueue for sync
        await syncHooks!.onWorkoutCreated(sessionRow.id, data);
        result.workoutsQueued++;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Failed to backfill workout ${sessionRow.id}: $e');
        }
        result.workoutsFailed++;
      }
    }
  }

  Future<void> _backfillBodyweight(BackfillResult result) async {
    // Query all demo bodyweight entries
    final entries = await (db.select(db.bodyWeightEntries)
          ..where((t) => t.userId.equals(userId)))
        .get();

    final demoEntries = entries.where((e) => e.id.startsWith('demo_')).toList();

    for (final entryRow in demoEntries) {
      try {
        final entry = domain.BodyWeightEntry(
          id: RecordId(entryRow.id),
          weightGrams: entryRow.weightGrams,
          measuredAt: entryRow.measuredAt,
          measuredDate: LocalDate.parse(entryRow.measuredDate),
          notes: entryRow.notes,
          createdAt: entryRow.createdAt,
        );

        final data = FirestoreSerializer.serializeBodyWeight(entry);

        await syncHooks!.onBodyWeightCreated(entryRow.id, data);
        result.bodyweightQueued++;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Failed to backfill bodyweight ${entryRow.id}: $e');
        }
        result.bodyweightFailed++;
      }
    }
  }

  domain.WorkoutSession _convertSession(WorkoutSession row) {
    return domain.WorkoutSession(
      id: RecordId(row.id),
      sourceType: domain.WorkoutSourceType.fromJson(row.sourceType),
      startedAt: row.startedAt,
      finishedAt: row.finishedAt,
      workoutDate: LocalDate.parse(row.workoutDate),
      status: domain.WorkoutStatus.fromJson(row.status),
      programId: row.programId,
      programDayId: row.programDayId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  domain.PerformedExercise _convertExercise(PerformedExercise row) {
    final snapshotMap = row.snapshotJson is Map<String, dynamic>
        ? row.snapshotJson as Map<String, dynamic>
        : Map<String, dynamic>.from(jsonDecode(row.snapshotJson as String));

    return domain.PerformedExercise(
      id: RecordId(row.id),
      sessionId: RecordId(row.sessionId),
      orderIndex: row.orderIndex,
      snapshot: domain.ExerciseSnapshot.fromJson(snapshotMap),
      notes: row.notes,
    );
  }

  domain.PerformedSet _convertSet(PerformedSet row) {
    return domain.PerformedSet(
      id: RecordId(row.id),
      performedExerciseId: RecordId(row.performedExerciseId),
      orderIndex: row.orderIndex,
      setType: domain.SetType.fromJson(row.setType),
      loadGrams: row.loadGrams != null ? WeightGrams(row.loadGrams!) : null,
      reps: row.reps,
      completed: row.completed,
      notes: row.notes,
    );
  }
}

class BackfillResult {
  int workoutsQueued = 0;
  int workoutsFailed = 0;
  int bodyweightQueued = 0;
  int bodyweightFailed = 0;
  String? error;

  bool get hasError => error != null;
  int get totalQueued => workoutsQueued + bodyweightQueued;
  int get totalFailed => workoutsFailed + bodyweightFailed;
}
