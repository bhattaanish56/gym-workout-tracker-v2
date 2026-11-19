import 'package:drift/drift.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../sessions/data/database/app_database.dart';
import '../../domain/models/program.dart' as domain;
import '../../domain/models/program_day.dart' as domain;
import '../../domain/models/planned_exercise.dart' as domain;
import '../../domain/models/rotation_state.dart' as domain;
import '../../domain/models/weekday_assignment.dart' as domain;
import '../../domain/repositories/program_repository.dart';
import '../../../sync/domain/sync_hooks.dart';
import '../../../sync/data/firestore_serializer.dart';

/// Drift implementation of program repository.
class DriftProgramRepository implements ProgramRepository {
  final AppDatabase _db;
  final String userId;
  final SyncHooks? _syncHooks;

  DriftProgramRepository(this._db, this.userId, [this._syncHooks]);

  @override
  Future<domain.Program> createProgram(domain.Program program) async {
    await _db
        .into(_db.programs)
        .insert(
          ProgramsCompanion(
            id: Value(program.id.value),
            userId: Value(userId),
            name: Value(program.name),
            description: Value(program.description),
            scheduleMode: Value(program.scheduleMode.toJson()),
            status: Value(program.status.toJson()),
            createdAt: Value(program.createdAt),
            updatedAt: Value(program.updatedAt),
          ),
        );

    // Enqueue sync operation after successful create
    if (_syncHooks != null) {
      final days = await getProgramDays(program.id);
      final exercisesByDay = <String, List<domain.PlannedExercise>>{};
      for (final day in days) {
        exercisesByDay[day.id.value] = await getPlannedExercises(day.id);
      }
      final data = FirestoreSerializer.serializeProgram(program, days, exercisesByDay);
      await _syncHooks.onProgramCreated(program.id.value, data);
    }

    return program;
  }

  @override
  Future<domain.Program> updateProgram(domain.Program program) async {
    await (_db.update(
      _db.programs,
    )..where((t) => t.id.equals(program.id.value) & t.userId.equals(userId))).write(
      ProgramsCompanion(
        name: Value(program.name),
        description: Value(program.description),
        scheduleMode: Value(program.scheduleMode.toJson()),
        status: Value(program.status.toJson()),
        updatedAt: Value(program.updatedAt),
      ),
    );

    // Enqueue sync operation after successful update
    if (_syncHooks != null) {
      final days = await getProgramDays(program.id);
      final exercisesByDay = <String, List<domain.PlannedExercise>>{};
      for (final day in days) {
        exercisesByDay[day.id.value] = await getPlannedExercises(day.id);
      }
      final data = FirestoreSerializer.serializeProgram(program, days, exercisesByDay);
      await _syncHooks.onProgramUpdated(program.id.value, data);
    }

    return program;
  }

  @override
  Future<void> deleteProgram(RecordId programId) async {
    await (_db.delete(
      _db.programs,
    )..where((t) => t.id.equals(programId.value) & t.userId.equals(userId))).go();
  }

  @override
  Future<List<domain.Program>> getPrograms() async {
    final rows = await (_db.select(_db.programs)
          ..where((t) => t.userId.equals(userId)))
        .get();
    return rows.map(_programFromRow).toList();
  }

  @override
  Future<domain.Program?> getProgramById(RecordId programId) async {
    final row = await (_db.select(
      _db.programs,
    )..where((t) => t.id.equals(programId.value) & t.userId.equals(userId))).getSingleOrNull();
    return row != null ? _programFromRow(row) : null;
  }

  @override
  Future<domain.Program?> getActiveProgram() async {
    final row =
        await (_db.select(_db.programs)..where(
              (t) => t.status.equals(domain.ProgramStatus.active.toJson()) &
                     t.userId.equals(userId),
            ))
            .getSingleOrNull();
    return row != null ? _programFromRow(row) : null;
  }

  @override
  Future<void> activateProgram(RecordId programId) async {
    await _db.transaction(() async {
      // Deactivate all programs for this user
      await (_db.update(_db.programs)..where(
            (t) => t.status.equals(domain.ProgramStatus.active.toJson()) &
                   t.userId.equals(userId),
          ))
          .write(
            ProgramsCompanion(
              status: Value(domain.ProgramStatus.draft.toJson()),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          );

      // Activate target program (verify ownership)
      await (_db.update(
        _db.programs,
      )..where((t) => t.id.equals(programId.value) & t.userId.equals(userId))).write(
        ProgramsCompanion(
          status: Value(domain.ProgramStatus.active.toJson()),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    });
  }

  @override
  Future<domain.ProgramDay> addProgramDay(domain.ProgramDay day) async {
    await _db
        .into(_db.programDays)
        .insert(
          ProgramDaysCompanion(
            id: Value(day.id.value),
            programId: Value(day.programId.value),
            orderIndex: Value(day.orderIndex),
            name: Value(day.name),
            targetDescription: Value(day.targetDescription),
          ),
        );
    return day;
  }

  @override
  Future<domain.ProgramDay> updateProgramDay(domain.ProgramDay day) async {
    await (_db.update(
      _db.programDays,
    )..where((t) => t.id.equals(day.id.value))).write(
      ProgramDaysCompanion(
        orderIndex: Value(day.orderIndex),
        name: Value(day.name),
        targetDescription: Value(day.targetDescription),
      ),
    );
    return day;
  }

  @override
  Future<void> deleteProgramDay(RecordId dayId) async {
    await (_db.delete(
      _db.programDays,
    )..where((t) => t.id.equals(dayId.value))).go();
  }

  @override
  Future<List<domain.ProgramDay>> getProgramDays(RecordId programId) async {
    final rows =
        await (_db.select(_db.programDays)
              ..where((t) => t.programId.equals(programId.value))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
    return rows.map(_programDayFromRow).toList();
  }

  @override
  Future<void> reorderDays(RecordId programId, List<RecordId> dayIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < dayIds.length; i++) {
        await (_db.update(_db.programDays)
              ..where((t) => t.id.equals(dayIds[i].value)))
            .write(ProgramDaysCompanion(orderIndex: Value(i)));
      }
    });
  }

  @override
  Future<domain.PlannedExercise> addPlannedExercise(
    domain.PlannedExercise exercise,
  ) async {
    await _db
        .into(_db.plannedExercises)
        .insert(
          PlannedExercisesCompanion(
            id: Value(exercise.id.value),
            programDayId: Value(exercise.programDayId.value),
            exerciseId: Value(exercise.exerciseId.value),
            orderIndex: Value(exercise.orderIndex),
            targetSets: Value(exercise.targetSets),
            targetRepsMin: Value(exercise.targetRepsMin),
            targetRepsMax: Value(exercise.targetRepsMax),
            targetLoadGrams: Value(exercise.targetLoadGrams),
            restSeconds: Value(exercise.restSeconds),
            notes: Value(exercise.notes),
          ),
        );
    return exercise;
  }

  @override
  Future<domain.PlannedExercise> updatePlannedExercise(
    domain.PlannedExercise exercise,
  ) async {
    await (_db.update(
      _db.plannedExercises,
    )..where((t) => t.id.equals(exercise.id.value))).write(
      PlannedExercisesCompanion(
        orderIndex: Value(exercise.orderIndex),
        targetSets: Value(exercise.targetSets),
        targetRepsMin: Value(exercise.targetRepsMin),
        targetRepsMax: Value(exercise.targetRepsMax),
        targetLoadGrams: Value(exercise.targetLoadGrams),
        restSeconds: Value(exercise.restSeconds),
        notes: Value(exercise.notes),
      ),
    );
    return exercise;
  }

  @override
  Future<void> deletePlannedExercise(RecordId exerciseId) async {
    await (_db.delete(
      _db.plannedExercises,
    )..where((t) => t.id.equals(exerciseId.value))).go();
  }

  @override
  Future<List<domain.PlannedExercise>> getPlannedExercises(
    RecordId programDayId,
  ) async {
    final rows =
        await (_db.select(_db.plannedExercises)
              ..where((t) => t.programDayId.equals(programDayId.value))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();
    return rows.map(_plannedExerciseFromRow).toList();
  }

  @override
  Future<void> reorderExercises(
    RecordId programDayId,
    List<RecordId> exerciseIds,
  ) async {
    await _db.transaction(() async {
      for (var i = 0; i < exerciseIds.length; i++) {
        await (_db.update(_db.plannedExercises)
              ..where((t) => t.id.equals(exerciseIds[i].value)))
            .write(PlannedExercisesCompanion(orderIndex: Value(i)));
      }
    });
  }

  @override
  Future<domain.RotationState?> getRotationState(RecordId programId) async {
    final row = await (_db.select(
      _db.rotationStates,
    )..where((t) => t.programId.equals(programId.value))).getSingleOrNull();
    return row != null ? _rotationStateFromRow(row) : null;
  }

  @override
  Future<void> updateRotationState(domain.RotationState state) async {
    await _db
        .into(_db.rotationStates)
        .insertOnConflictUpdate(
          RotationStatesCompanion(
            programId: Value(state.programId.value),
            nextDayIndex: Value(state.nextDayIndex),
            lastCompletionEventId: Value(state.lastCompletionEventId?.value),
          ),
        );
  }

  @override
  Future<domain.WeekdayAssignment> addWeekdayAssignment(
    domain.WeekdayAssignment assignment,
  ) async {
    await _db
        .into(_db.weekdayAssignments)
        .insert(
          WeekdayAssignmentsCompanion(
            id: Value(assignment.id.value),
            programId: Value(assignment.programId.value),
            weekday: Value(assignment.weekday),
            assignmentType: Value(assignment.assignmentType.toJson()),
            programDayId: Value(assignment.programDayId?.value),
          ),
        );
    return assignment;
  }

  @override
  Future<domain.WeekdayAssignment> updateWeekdayAssignment(
    domain.WeekdayAssignment assignment,
  ) async {
    await (_db.update(
      _db.weekdayAssignments,
    )..where((t) => t.id.equals(assignment.id.value))).write(
      WeekdayAssignmentsCompanion(
        weekday: Value(assignment.weekday),
        assignmentType: Value(assignment.assignmentType.toJson()),
        programDayId: Value(assignment.programDayId?.value),
      ),
    );
    return assignment;
  }

  @override
  Future<void> deleteWeekdayAssignment(RecordId assignmentId) async {
    await (_db.delete(
      _db.weekdayAssignments,
    )..where((t) => t.id.equals(assignmentId.value))).go();
  }

  @override
  Future<List<domain.WeekdayAssignment>> getWeekdayAssignments(
    RecordId programId,
  ) async {
    final rows =
        await (_db.select(_db.weekdayAssignments)
              ..where((t) => t.programId.equals(programId.value))
              ..orderBy([(t) => OrderingTerm.asc(t.weekday)]))
            .get();
    return rows.map(_weekdayAssignmentFromRow).toList();
  }

  @override
  Future<domain.WeekdayAssignment?> getWeekdayAssignment(
    RecordId programId,
    int weekday,
  ) async {
    final row =
        await (_db.select(_db.weekdayAssignments)..where(
              (t) =>
                  t.programId.equals(programId.value) &
                  t.weekday.equals(weekday),
            ))
            .getSingleOrNull();
    return row != null ? _weekdayAssignmentFromRow(row) : null;
  }

  @override
  Future<domain.ProgramDay?> getNextPlannedWorkout() async {
    // Get active program
    final activeProgram = await getActiveProgram();
    if (activeProgram == null) return null;

    // Get program days
    final days = await getProgramDays(activeProgram.id);
    if (days.isEmpty) return null;

    // For fixed weekly, use weekday assignments
    if (activeProgram.scheduleMode == domain.ScheduleMode.fixedWeekly) {
      final now = DateTime.now();
      final weekday = now.weekday; // 1=Mon, 7=Sun

      // Get assignment for this weekday
      final assignment = await getWeekdayAssignment(activeProgram.id, weekday);
      if (assignment == null) return null; // Unassigned day
      if (assignment.assignmentType == domain.AssignmentType.rest) {
        return null; // Explicit rest day
      }

      // Return the assigned ProgramDay
      return days
          .where((d) => d.id.value == assignment.programDayId!.value)
          .firstOrNull;
    }

    // For flexible rotation, use rotation state
    final rotationState = await getRotationState(activeProgram.id);
    final nextIndex = rotationState?.nextDayIndex ?? 0;
    if (nextIndex >= days.length) {
      return days.first; // Wrap around
    }
    return days[nextIndex];
  }

  domain.Program _programFromRow(Program row) {
    return domain.Program(
      id: RecordId(row.id),
      name: row.name,
      description: row.description,
      scheduleMode: domain.ScheduleMode.fromJson(row.scheduleMode),
      status: domain.ProgramStatus.fromJson(row.status),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  domain.ProgramDay _programDayFromRow(ProgramDay row) {
    return domain.ProgramDay(
      id: RecordId(row.id),
      programId: RecordId(row.programId),
      orderIndex: row.orderIndex,
      name: row.name,
      targetDescription: row.targetDescription,
    );
  }

  domain.PlannedExercise _plannedExerciseFromRow(PlannedExercise row) {
    return domain.PlannedExercise(
      id: RecordId(row.id),
      programDayId: RecordId(row.programDayId),
      exerciseId: ExerciseId(row.exerciseId),
      orderIndex: row.orderIndex,
      targetSets: row.targetSets,
      targetRepsMin: row.targetRepsMin,
      targetRepsMax: row.targetRepsMax,
      targetLoadGrams: row.targetLoadGrams,
      restSeconds: row.restSeconds,
      notes: row.notes,
    );
  }

  domain.RotationState _rotationStateFromRow(RotationState row) {
    return domain.RotationState(
      programId: RecordId(row.programId),
      nextDayIndex: row.nextDayIndex,
      lastCompletionEventId: row.lastCompletionEventId != null
          ? RecordId(row.lastCompletionEventId!)
          : null,
    );
  }

  domain.WeekdayAssignment _weekdayAssignmentFromRow(WeekdayAssignment row) {
    return domain.WeekdayAssignment(
      id: RecordId(row.id),
      programId: RecordId(row.programId),
      weekday: row.weekday,
      assignmentType: domain.AssignmentType.fromJson(row.assignmentType),
      programDayId: row.programDayId != null
          ? RecordId(row.programDayId!)
          : null,
    );
  }
}
