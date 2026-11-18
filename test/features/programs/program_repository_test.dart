import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/features/programs/data/repositories/drift_program_repository.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program_day.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/planned_exercise.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/database/app_database.dart'
    hide Program, ProgramDay, PlannedExercise, RotationState;
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late DriftProgramRepository repo;

  setUp(() {
    db = AppDatabase.withQueryExecutor(NativeDatabase.memory());
    repo = DriftProgramRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Program Repository', () {
    test('create and retrieve program', () async {
      final program = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Test Program',
        description: 'Test Description',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program);
      final retrieved = await repo.getProgramById(program.id);

      expect(retrieved, isNotNull);
      expect(retrieved!.name, program.name);
      expect(retrieved.description, program.description);
      expect(retrieved.scheduleMode, program.scheduleMode);
    });

    test('update program', () async {
      final program = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Original Name',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program);
      final updated = program.copyWith(name: 'Updated Name');
      await repo.updateProgram(updated);

      final retrieved = await repo.getProgramById(program.id);
      expect(retrieved!.name, 'Updated Name');
    });

    test('delete program', () async {
      final program = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Test Program',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program);
      await repo.deleteProgram(program.id);

      final retrieved = await repo.getProgramById(program.id);
      expect(retrieved, isNull);
    });

    test('activate program deactivates others', () async {
      final program1 = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Program 1',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.active,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      final program2 = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Program 2',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program1);
      await repo.createProgram(program2);
      await repo.activateProgram(program2.id);

      final retrieved1 = await repo.getProgramById(program1.id);
      final retrieved2 = await repo.getProgramById(program2.id);

      expect(retrieved1!.status, ProgramStatus.draft);
      expect(retrieved2!.status, ProgramStatus.active);
    });

    test('add and retrieve program days', () async {
      final program = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Test Program',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program);

      final day = ProgramDay(
        id: RecordId(const Uuid().v4()),
        programId: program.id,
        orderIndex: 0,
        name: 'Day 1',
      );

      await repo.addProgramDay(day);
      final days = await repo.getProgramDays(program.id);

      expect(days.length, 1);
      expect(days.first.name, 'Day 1');
    });

    test('reorder days', () async {
      final program = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Test Program',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program);

      final day1 = ProgramDay(
        id: RecordId(const Uuid().v4()),
        programId: program.id,
        orderIndex: 0,
        name: 'Day 1',
      );

      final day2 = ProgramDay(
        id: RecordId(const Uuid().v4()),
        programId: program.id,
        orderIndex: 1,
        name: 'Day 2',
      );

      await repo.addProgramDay(day1);
      await repo.addProgramDay(day2);

      await repo.reorderDays(program.id, [day2.id, day1.id]);

      final days = await repo.getProgramDays(program.id);
      expect(days[0].id, day2.id);
      expect(days[1].id, day1.id);
    });

    test('add and retrieve planned exercises', () async {
      final program = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Test Program',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program);

      final day = ProgramDay(
        id: RecordId(const Uuid().v4()),
        programId: program.id,
        orderIndex: 0,
        name: 'Day 1',
      );

      await repo.addProgramDay(day);

      final exercise = PlannedExercise(
        id: RecordId(const Uuid().v4()),
        programDayId: day.id,
        exerciseId: ExerciseId('ex_bench_press_barbell'),
        orderIndex: 0,
        targetSets: 3,
        targetRepsMin: 8,
        targetRepsMax: 12,
      );

      await repo.addPlannedExercise(exercise);
      final exercises = await repo.getPlannedExercises(day.id);

      expect(exercises.length, 1);
      expect(exercises.first.targetSets, 3);
      expect(exercises.first.targetRepsMin, 8);
      expect(exercises.first.targetRepsMax, 12);
    });

    test('get next planned workout', () async {
      final program = Program(
        id: RecordId(const Uuid().v4()),
        name: 'Test Program',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.active,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await repo.createProgram(program);

      final day1 = ProgramDay(
        id: RecordId(const Uuid().v4()),
        programId: program.id,
        orderIndex: 0,
        name: 'Day 1',
      );

      final day2 = ProgramDay(
        id: RecordId(const Uuid().v4()),
        programId: program.id,
        orderIndex: 1,
        name: 'Day 2',
      );

      await repo.addProgramDay(day1);
      await repo.addProgramDay(day2);

      final nextWorkout = await repo.getNextPlannedWorkout();
      expect(nextWorkout, isNotNull);
      expect(nextWorkout!.id, day1.id);
    });
  });
}
