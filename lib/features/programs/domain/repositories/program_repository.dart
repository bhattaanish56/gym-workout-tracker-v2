import '../../../../core/domain/value_objects/identifiers.dart';
import '../models/program.dart';
import '../models/program_day.dart';
import '../models/planned_exercise.dart';
import '../models/rotation_state.dart';
import '../models/weekday_assignment.dart';

/// Program repository interface.
abstract class ProgramRepository {
  // Program CRUD
  Future<Program> createProgram(Program program);
  Future<Program> updateProgram(Program program);
  Future<void> deleteProgram(RecordId programId);
  Future<List<Program>> getPrograms();
  Future<Program?> getProgramById(RecordId programId);
  Future<Program?> getActiveProgram();
  Future<void> activateProgram(RecordId programId);

  // Program Day CRUD
  Future<ProgramDay> addProgramDay(ProgramDay day);
  Future<ProgramDay> updateProgramDay(ProgramDay day);
  Future<void> deleteProgramDay(RecordId dayId);
  Future<List<ProgramDay>> getProgramDays(RecordId programId);
  Future<void> reorderDays(RecordId programId, List<RecordId> dayIds);

  // Planned Exercise CRUD
  Future<PlannedExercise> addPlannedExercise(PlannedExercise exercise);
  Future<PlannedExercise> updatePlannedExercise(PlannedExercise exercise);
  Future<void> deletePlannedExercise(RecordId exerciseId);
  Future<List<PlannedExercise>> getPlannedExercises(RecordId programDayId);
  Future<void> reorderExercises(
    RecordId programDayId,
    List<RecordId> exerciseIds,
  );

  // Weekday Assignments (fixed-weekly schedules)
  Future<WeekdayAssignment> addWeekdayAssignment(WeekdayAssignment assignment);
  Future<WeekdayAssignment> updateWeekdayAssignment(
    WeekdayAssignment assignment,
  );
  Future<void> deleteWeekdayAssignment(RecordId assignmentId);
  Future<List<WeekdayAssignment>> getWeekdayAssignments(RecordId programId);
  Future<WeekdayAssignment?> getWeekdayAssignment(
    RecordId programId,
    int weekday,
  );

  // Rotation State
  Future<RotationState?> getRotationState(RecordId programId);
  Future<void> updateRotationState(RotationState state);

  // Next workout
  Future<ProgramDay?> getNextPlannedWorkout();
}
