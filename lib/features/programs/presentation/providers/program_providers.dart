import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../data/repositories/drift_program_repository.dart';
import '../../data/workout_templates.dart';
import '../../domain/models/program.dart';
import '../../domain/models/program_day.dart';
import '../../domain/models/planned_exercise.dart';
import '../../domain/repositories/program_repository.dart';

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  final syncHooks = ref.watch(syncHooksProvider);
  return DriftProgramRepository(db, userId, syncHooks);
});

final allProgramsProvider = StreamProvider<List<Program>>((ref) {
  final repo = ref.watch(programRepositoryProvider);
  return Stream.periodic(
    const Duration(milliseconds: 500),
  ).asyncMap((_) => repo.getPrograms());
});

final activeProgramProvider = StreamProvider<Program?>((ref) {
  final repo = ref.watch(programRepositoryProvider);
  return Stream.periodic(
    const Duration(milliseconds: 500),
  ).asyncMap((_) => repo.getActiveProgram());
});

final programDaysProvider = StreamProvider.family<List<ProgramDay>, RecordId>((
  ref,
  programId,
) {
  final repo = ref.watch(programRepositoryProvider);
  return Stream.periodic(
    const Duration(milliseconds: 500),
  ).asyncMap((_) => repo.getProgramDays(programId));
});

final plannedExercisesProvider =
    StreamProvider.family<List<PlannedExercise>, RecordId>((ref, programDayId) {
      final repo = ref.watch(programRepositoryProvider);
      return Stream.periodic(
        const Duration(milliseconds: 500),
      ).asyncMap((_) => repo.getPlannedExercises(programDayId));
    });

final nextPlannedWorkoutProvider = StreamProvider<ProgramDay?>((ref) {
  final repo = ref.watch(programRepositoryProvider);
  return Stream.periodic(
    const Duration(milliseconds: 500),
  ).asyncMap((_) => repo.getNextPlannedWorkout());
});

final workoutTemplatesProvider = Provider<List<WorkoutTemplate>>((ref) {
  return workoutTemplates;
});
