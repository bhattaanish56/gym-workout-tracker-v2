import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/features/programs/data/repositories/drift_program_repository.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program_day.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/weekday_assignment.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/database/app_database.dart'
    hide Program, ProgramDay, WeekdayAssignment;

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

  group('Fixed-weekly scheduling', () {
    test('getNextPlannedWorkout returns day for current weekday', () async {
      final now = DateTime.now();
      final currentWeekday = now.weekday;

      final program = Program(
        id: RecordId('prog-1'),
        name: 'Fixed Weekly Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);
      await repo.activateProgram(program.id);

      // Create day
      final day = ProgramDay(
        id: RecordId('day-1'),
        programId: program.id,
        orderIndex: 0,
        name: 'Current Day',
      );
      await repo.addProgramDay(day);

      // Assign to current weekday
      final assignment = WeekdayAssignment(
        id: RecordId('assign-1'),
        programId: program.id,
        weekday: currentWeekday,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );
      await repo.addWeekdayAssignment(assignment);

      final nextDay = await repo.getNextPlannedWorkout();
      expect(nextDay, isNotNull);
      expect(nextDay!.id, day.id);
    });

    test('getNextPlannedWorkout returns null on explicit rest day', () async {
      final now = DateTime.now();
      final currentWeekday = now.weekday;

      final program = Program(
        id: RecordId('prog-2'),
        name: 'Rest Day Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);
      await repo.activateProgram(program.id);

      // Create explicit rest assignment for current weekday
      final assignment = WeekdayAssignment(
        id: RecordId('assign-2'),
        programId: program.id,
        weekday: currentWeekday,
        assignmentType: AssignmentType.rest,
      );
      await repo.addWeekdayAssignment(assignment);

      final nextDay = await repo.getNextPlannedWorkout();
      expect(nextDay, isNull); // Explicit rest day
    });

    test('getNextPlannedWorkout returns null on unassigned day', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-3'),
        name: 'Unassigned Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);
      await repo.activateProgram(program.id);

      // No assignment for current weekday
      final nextDay = await repo.getNextPlannedWorkout();
      expect(nextDay, isNull); // Unassigned day
    });

    test('flexible rotation still uses rotation state', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-4'),
        name: 'Flexible Test',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);
      await repo.activateProgram(program.id);

      final day1 = ProgramDay(
        id: RecordId('day-4a'),
        programId: program.id,
        orderIndex: 0,
        name: 'Day 1',
      );
      final day2 = ProgramDay(
        id: RecordId('day-4b'),
        programId: program.id,
        orderIndex: 1,
        name: 'Day 2',
      );
      await repo.addProgramDay(day1);
      await repo.addProgramDay(day2);

      // Should return first day (rotation state default)
      final nextDay = await repo.getNextPlannedWorkout();
      expect(nextDay, isNotNull);
      expect(nextDay!.id, day1.id);
    });

    test('weekday assignment persists through add and retrieve', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-5'),
        name: 'Persistence Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);

      final day = ProgramDay(
        id: RecordId('day-5'),
        programId: program.id,
        orderIndex: 0,
        name: 'Monday',
      );
      await repo.addProgramDay(day);

      final assignment = WeekdayAssignment(
        id: RecordId('assign-5'),
        programId: program.id,
        weekday: 1,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );
      await repo.addWeekdayAssignment(assignment);

      final retrieved = await repo.getWeekdayAssignments(program.id);
      expect(retrieved.length, 1);
      expect(retrieved.first.weekday, 1);
      expect(retrieved.first.programDayId, day.id);
    });

    test('weekday assignment updates correctly', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-6'),
        name: 'Update Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);

      final day = ProgramDay(
        id: RecordId('day-6'),
        programId: program.id,
        orderIndex: 0,
        name: 'Movable Day',
      );
      await repo.addProgramDay(day);

      final assignment = WeekdayAssignment(
        id: RecordId('assign-6'),
        programId: program.id,
        weekday: 1,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );
      await repo.addWeekdayAssignment(assignment);

      // Update to different weekday
      final updated = assignment.copyWith(weekday: 3);
      await repo.updateWeekdayAssignment(updated);

      final retrieved = await repo.getWeekdayAssignment(program.id, 3);
      expect(retrieved, isNotNull);
      expect(retrieved!.weekday, 3);
      expect(retrieved.programDayId, day.id);
    });

    test('can delete weekday assignment', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-7'),
        name: 'Delete Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);

      final day = ProgramDay(
        id: RecordId('day-7'),
        programId: program.id,
        orderIndex: 0,
        name: 'Deletable Day',
      );
      await repo.addProgramDay(day);

      final assignment = WeekdayAssignment(
        id: RecordId('assign-7'),
        programId: program.id,
        weekday: 2,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );
      await repo.addWeekdayAssignment(assignment);

      // Delete assignment
      await repo.deleteWeekdayAssignment(assignment.id);

      final retrieved = await repo.getWeekdayAssignment(program.id, 2);
      expect(retrieved, isNull);
    });

    test('one ProgramDay can be assigned to multiple weekdays', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-8'),
        name: 'Reuse Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);

      final day = ProgramDay(
        id: RecordId('day-8'),
        programId: program.id,
        orderIndex: 0,
        name: 'Full Body',
      );
      await repo.addProgramDay(day);

      // Assign same day to Mon, Wed, Fri
      final assign1 = WeekdayAssignment(
        id: RecordId('assign-8a'),
        programId: program.id,
        weekday: 1,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );
      final assign2 = WeekdayAssignment(
        id: RecordId('assign-8b'),
        programId: program.id,
        weekday: 3,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );
      final assign3 = WeekdayAssignment(
        id: RecordId('assign-8c'),
        programId: program.id,
        weekday: 5,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );

      await repo.addWeekdayAssignment(assign1);
      await repo.addWeekdayAssignment(assign2);
      await repo.addWeekdayAssignment(assign3);

      final assignments = await repo.getWeekdayAssignments(program.id);
      expect(assignments.length, 3);
      expect(assignments.every((a) => a.programDayId == day.id), isTrue);
    });
  });

  group('Database constraints', () {
    test('unique constraint prevents duplicate weekday assignment', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-9'),
        name: 'Constraint Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);

      final day1 = ProgramDay(
        id: RecordId('day-9a'),
        programId: program.id,
        orderIndex: 0,
        name: 'Day A',
      );
      final day2 = ProgramDay(
        id: RecordId('day-9b'),
        programId: program.id,
        orderIndex: 1,
        name: 'Day B',
      );
      await repo.addProgramDay(day1);
      await repo.addProgramDay(day2);

      final assign1 = WeekdayAssignment(
        id: RecordId('assign-9a'),
        programId: program.id,
        weekday: 1,
        assignmentType: AssignmentType.workout,
        programDayId: day1.id,
      );
      await repo.addWeekdayAssignment(assign1);

      // Attempt duplicate assignment for same weekday
      final assign2 = WeekdayAssignment(
        id: RecordId('assign-9b'),
        programId: program.id,
        weekday: 1,
        assignmentType: AssignmentType.workout,
        programDayId: day2.id,
      );

      expect(
        () => repo.addWeekdayAssignment(assign2),
        throwsA(anything), // Unique constraint violation
      );
    });

    test('cascade delete removes assignments when program deleted', () async {
      final now = DateTime.now();

      final program = Program(
        id: RecordId('prog-10'),
        name: 'Cascade Test',
        scheduleMode: ScheduleMode.fixedWeekly,
        status: ProgramStatus.draft,
        createdAt: now.toUtc(),
        updatedAt: now.toUtc(),
      );
      await repo.createProgram(program);

      final day = ProgramDay(
        id: RecordId('day-10'),
        programId: program.id,
        orderIndex: 0,
        name: 'Day',
      );
      await repo.addProgramDay(day);

      final assignment = WeekdayAssignment(
        id: RecordId('assign-10'),
        programId: program.id,
        weekday: 1,
        assignmentType: AssignmentType.workout,
        programDayId: day.id,
      );
      await repo.addWeekdayAssignment(assignment);

      // Delete program
      await repo.deleteProgram(program.id);

      // Assignment should be deleted
      final assignments = await repo.getWeekdayAssignments(program.id);
      expect(assignments, isEmpty);
    });

    test(
      'cascade delete removes assignments when program day deleted',
      () async {
        final now = DateTime.now();

        final program = Program(
          id: RecordId('prog-11'),
          name: 'Day Cascade Test',
          scheduleMode: ScheduleMode.fixedWeekly,
          status: ProgramStatus.draft,
          createdAt: now.toUtc(),
          updatedAt: now.toUtc(),
        );
        await repo.createProgram(program);

        final day = ProgramDay(
          id: RecordId('day-11'),
          programId: program.id,
          orderIndex: 0,
          name: 'Day',
        );
        await repo.addProgramDay(day);

        final assignment = WeekdayAssignment(
          id: RecordId('assign-11'),
          programId: program.id,
          weekday: 1,
          assignmentType: AssignmentType.workout,
          programDayId: day.id,
        );
        await repo.addWeekdayAssignment(assignment);

        // Delete program day
        await repo.deleteProgramDay(day.id);

        // Assignment should be deleted
        final retrieved = await repo.getWeekdayAssignment(program.id, 1);
        expect(retrieved, isNull);
      },
    );
  });
}
