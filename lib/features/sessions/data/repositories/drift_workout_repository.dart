import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/models/workout_session.dart' as domain;
import '../../domain/models/performed_exercise.dart' as domain;
import '../../domain/models/performed_set.dart' as domain;
import '../../domain/repositories/workout_repository.dart';
import '../database/app_database.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/value_objects/date_time.dart';
import '../../../../core/domain/value_objects/weight.dart';
import '../../../sync/domain/sync_hooks.dart';
import '../../../sync/data/firestore_serializer.dart';

/// Drift implementation of WorkoutRepository.
class DriftWorkoutRepository implements WorkoutRepository {
  final AppDatabase _db;
  final String userId;
  final SyncHooks? _syncHooks;

  DriftWorkoutRepository(this._db, this.userId, [this._syncHooks]);

  @override
  Future<void> createSession(
    domain.WorkoutSession session,
    List<domain.PerformedExercise> exercises,
    List<domain.PerformedSet> sets,
  ) async {
    await _db.transaction(() async {
      await _db
          .into(_db.workoutSessions)
          .insert(
            WorkoutSessionsCompanion.insert(
              id: session.id.value,
              userId: Value(userId),
              sourceType: session.sourceType.toJson(),
              startedAt: session.startedAt,
              finishedAt: Value(session.finishedAt),
              workoutDate: session.workoutDate.toIso8601(),
              status: session.status.toJson(),
              programId: Value(session.programId),
              programDayId: Value(session.programDayId),
              programSnapshot: Value(
                session.programSnapshot != null
                    ? jsonEncode(session.programSnapshot)
                    : null,
              ),
              fulfilledScheduledDate: Value(session.fulfilledScheduledDate?.toIso8601()),
              createdAt: session.createdAt,
              updatedAt: session.updatedAt,
            ),
          );

      for (final exercise in exercises) {
        await _db
            .into(_db.performedExercises)
            .insert(
              PerformedExercisesCompanion.insert(
                id: exercise.id.value,
                sessionId: exercise.sessionId.value,
                orderIndex: exercise.orderIndex,
                snapshotJson: jsonEncode(exercise.snapshot.toJson()),
                notes: Value(exercise.notes),
              ),
            );
      }

      for (final set in sets) {
        await _db
            .into(_db.performedSets)
            .insert(
              PerformedSetsCompanion.insert(
                id: set.id.value,
                performedExerciseId: set.performedExerciseId.value,
                orderIndex: set.orderIndex,
                setType: set.setType.toJson(),
                loadGrams: Value(set.loadGrams?.grams),
                reps: Value(set.reps),
                completed: set.completed,
                notes: Value(set.notes),
              ),
            );
      }
    });

    // Enqueue sync operation after successful local write
    if (_syncHooks != null) {
      final data = FirestoreSerializer.serializeWorkout(session, exercises, sets);
      await _syncHooks.onWorkoutCreated(session.id.value, data);
    }
  }

  @override
  Future<void> updateSession(domain.WorkoutSession session) async {
    await (_db.update(
      _db.workoutSessions,
    )..where((t) => t.id.equals(session.id.value) & t.userId.equals(userId))).write(
      WorkoutSessionsCompanion(
        sourceType: Value(session.sourceType.toJson()),
        startedAt: Value(session.startedAt),
        finishedAt: Value(session.finishedAt),
        workoutDate: Value(session.workoutDate.toIso8601()),
        status: Value(session.status.toJson()),
        programId: Value(session.programId),
        programDayId: Value(session.programDayId),
        programSnapshot: Value(
          session.programSnapshot != null
              ? jsonEncode(session.programSnapshot)
              : null,
        ),
        fulfilledScheduledDate: Value(session.fulfilledScheduledDate?.toIso8601()),
        updatedAt: Value(session.updatedAt),
      ),
    );

    // Enqueue sync operation after successful update
    if (_syncHooks != null) {
      // Fetch related data for full sync
      final exercises = await getSessionExercises(session.id.value);
      final allSets = <domain.PerformedSet>[];
      for (final exercise in exercises) {
        final sets = await getExerciseSets(exercise.id.value);
        allSets.addAll(sets);
      }
      final data = FirestoreSerializer.serializeWorkout(session, exercises, allSets);
      await _syncHooks.onWorkoutUpdated(session.id.value, data);
    }
  }

  @override
  Future<domain.WorkoutSession?> getSession(String sessionId) async {
    final row = await (_db.select(
      _db.workoutSessions,
    )..where((t) => t.id.equals(sessionId) & t.userId.equals(userId))).getSingleOrNull();

    if (row == null) return null;
    return _sessionFromRow(row);
  }

  @override
  Future<List<domain.WorkoutSession>> getAllSessions() async {
    final rows = await (_db.select(
      _db.workoutSessions,
    )..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).get();

    return rows.map(_sessionFromRow).toList();
  }

  @override
  Future<List<domain.PerformedExercise>> getSessionExercises(
    String sessionId,
  ) async {
    final rows =
        await (_db.select(_db.performedExercises)
              ..where((t) => t.sessionId.equals(sessionId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();

    return rows.map(_exerciseFromRow).toList();
  }

  @override
  Future<List<domain.PerformedSet>> getExerciseSets(String exerciseId) async {
    final rows =
        await (_db.select(_db.performedSets)
              ..where((t) => t.performedExerciseId.equals(exerciseId))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();

    return rows.map(_setFromRow).toList();
  }

  @override
  Future<void> addExercise(domain.PerformedExercise exercise) async {
    await _db
        .into(_db.performedExercises)
        .insert(
          PerformedExercisesCompanion.insert(
            id: exercise.id.value,
            sessionId: exercise.sessionId.value,
            orderIndex: exercise.orderIndex,
            snapshotJson: jsonEncode(exercise.snapshot.toJson()),
            notes: Value(exercise.notes),
          ),
        );
  }

  @override
  Future<void> updateExercise(domain.PerformedExercise exercise) async {
    await (_db.update(
      _db.performedExercises,
    )..where((t) => t.id.equals(exercise.id.value))).write(
      PerformedExercisesCompanion(
        orderIndex: Value(exercise.orderIndex),
        snapshotJson: Value(jsonEncode(exercise.snapshot.toJson())),
        notes: Value(exercise.notes),
      ),
    );
  }

  @override
  Future<void> deleteExercise(String exerciseId) async {
    await (_db.delete(
      _db.performedExercises,
    )..where((t) => t.id.equals(exerciseId))).go();
  }

  @override
  Future<void> addSet(domain.PerformedSet set) async {
    await _db
        .into(_db.performedSets)
        .insert(
          PerformedSetsCompanion.insert(
            id: set.id.value,
            performedExerciseId: set.performedExerciseId.value,
            orderIndex: set.orderIndex,
            setType: set.setType.toJson(),
            loadGrams: Value(set.loadGrams?.grams),
            reps: Value(set.reps),
            completed: set.completed,
            notes: Value(set.notes),
          ),
        );
  }

  @override
  Future<void> updateSet(domain.PerformedSet set) async {
    await (_db.update(
      _db.performedSets,
    )..where((t) => t.id.equals(set.id.value))).write(
      PerformedSetsCompanion(
        orderIndex: Value(set.orderIndex),
        setType: Value(set.setType.toJson()),
        loadGrams: Value(set.loadGrams?.grams),
        reps: Value(set.reps),
        completed: Value(set.completed),
        notes: Value(set.notes),
      ),
    );
  }

  @override
  Future<void> deleteSet(String setId) async {
    await (_db.delete(
      _db.performedSets,
    )..where((t) => t.id.equals(setId))).go();
  }

  @override
  Future<void> completeSession(String sessionId, DateTime finishedAt) async {
    await (_db.update(
      _db.workoutSessions,
    )..where((t) => t.id.equals(sessionId) & t.userId.equals(userId))).write(
      WorkoutSessionsCompanion(
        finishedAt: Value(finishedAt.toUtc()),
        status: Value(domain.WorkoutStatus.completed.toJson()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<domain.WorkoutSession?> getActiveSession() async {
    final row =
        await (_db.select(_db.workoutSessions)
              ..where(
                (t) =>
                    t.status.equals(domain.WorkoutStatus.inProgress.toJson()) &
                    t.userId.equals(userId),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
              ..limit(1))
            .getSingleOrNull();

    if (row == null) return null;
    return _sessionFromRow(row);
  }

  @override
  Future<void> discardSession(String sessionId) async {
    await (_db.update(
      _db.workoutSessions,
    )..where((t) => t.id.equals(sessionId) & t.userId.equals(userId))).write(
      WorkoutSessionsCompanion(
        status: Value(domain.WorkoutStatus.abandoned.toJson()),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  domain.WorkoutSession _sessionFromRow(WorkoutSession row) {
    return domain.WorkoutSession(
      id: RecordId(row.id),
      sourceType: domain.WorkoutSourceType.fromJson(row.sourceType),
      startedAt: row.startedAt.toUtc(),
      finishedAt: row.finishedAt?.toUtc(),
      workoutDate: LocalDate.parse(row.workoutDate),
      status: domain.WorkoutStatus.fromJson(row.status),
      programId: row.programId,
      programDayId: row.programDayId,
      programSnapshot: row.programSnapshot != null
          ? jsonDecode(row.programSnapshot!) as Map<String, dynamic>
          : null,
      fulfilledScheduledDate: row.fulfilledScheduledDate != null
          ? LocalDate.parse(row.fulfilledScheduledDate!)
          : null,
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
    );
  }

  domain.PerformedExercise _exerciseFromRow(PerformedExercise row) {
    return domain.PerformedExercise(
      id: RecordId(row.id),
      sessionId: RecordId(row.sessionId),
      orderIndex: row.orderIndex,
      snapshot: domain.ExerciseSnapshot.fromJson(
        jsonDecode(row.snapshotJson) as Map<String, dynamic>,
      ),
      notes: row.notes,
    );
  }

  domain.PerformedSet _setFromRow(PerformedSet row) {
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
