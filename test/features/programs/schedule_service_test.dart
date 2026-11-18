import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program_day.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/weekday_assignment.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/services/schedule_service.dart';

void main() {
  late ScheduleService service;
  late Program fixedProgram;
  late List<ProgramDay> days;
  late List<WeekdayAssignment> assignments;

  setUp(() {
    service = ScheduleService();
    final now = DateTime.now().toUtc();
    final programId = RecordId('prog-1');

    fixedProgram = Program(
      id: programId,
      name: 'Test Program',
      scheduleMode: ScheduleMode.fixedWeekly,
      status: ProgramStatus.active,
      createdAt: now,
      updatedAt: now,
    );

    days = [
      ProgramDay(
        id: RecordId('day-1'),
        programId: programId,
        orderIndex: 0,
        name: 'Monday Workout',
      ),
      ProgramDay(
        id: RecordId('day-2'),
        programId: programId,
        orderIndex: 1,
        name: 'Wednesday Workout',
      ),
      ProgramDay(
        id: RecordId('day-3'),
        programId: programId,
        orderIndex: 2,
        name: 'Friday Workout',
      ),
    ];

    assignments = [
      WeekdayAssignment(
        id: RecordId('assign-1'),
        programId: programId,
        weekday: 1, // Monday
        assignmentType: AssignmentType.workout,
        programDayId: days[0].id,
      ),
      WeekdayAssignment(
        id: RecordId('assign-2'),
        programId: programId,
        weekday: 3, // Wednesday
        assignmentType: AssignmentType.workout,
        programDayId: days[1].id,
      ),
      WeekdayAssignment(
        id: RecordId('assign-3'),
        programId: programId,
        weekday: 5, // Friday
        assignmentType: AssignmentType.workout,
        programDayId: days[2].id,
      ),
    ];
  });

  group('getScheduledDay', () {
    test('returns matching day for assigned weekday', () {
      final monday = DateTime(2026, 11, 16); // Monday
      final day = service.getScheduledDay(
        fixedProgram,
        days,
        assignments,
        monday,
      );

      expect(day, isNotNull);
      expect(day!.name, 'Monday Workout');
    });

    test('returns null for explicit rest day', () {
      final restAssignments = [
        ...assignments,
        WeekdayAssignment(
          id: RecordId('assign-rest'),
          programId: fixedProgram.id,
          weekday: 2, // Tuesday
          assignmentType: AssignmentType.rest,
        ),
      ];
      final tuesday = DateTime(2026, 11, 17); // Tuesday
      final day = service.getScheduledDay(
        fixedProgram,
        days,
        restAssignments,
        tuesday,
      );

      expect(day, isNull);
    });

    test('returns null for unassigned weekday', () {
      final saturday = DateTime(2026, 11, 22); // Saturday
      final day = service.getScheduledDay(
        fixedProgram,
        days,
        assignments,
        saturday,
      );

      expect(day, isNull);
    });

    test('returns correct day across week boundary', () {
      final friday = DateTime(2026, 11, 20); // Friday
      final day = service.getScheduledDay(
        fixedProgram,
        days,
        assignments,
        friday,
      );

      expect(day, isNotNull);
      expect(day!.name, 'Friday Workout');
    });

    test('returns null for flexible rotation programs', () {
      final flexProgram = fixedProgram.copyWith(
        scheduleMode: ScheduleMode.flexibleRotation,
      );
      final monday = DateTime(2026, 11, 16);

      final day = service.getScheduledDay(
        flexProgram,
        days,
        assignments,
        monday,
      );
      expect(day, isNull);
    });
  });

  group('validateWeekdayAssignments', () {
    test('returns null for valid assignments', () {
      final error = service.validateWeekdayAssignments(assignments);
      expect(error, isNull);
    });

    test('detects duplicate weekday assignments', () {
      final duplicateAssignments = [
        assignments[0],
        WeekdayAssignment(
          id: RecordId('assign-dup'),
          programId: fixedProgram.id,
          weekday: 1, // Duplicate Monday
          assignmentType: AssignmentType.workout,
          programDayId: days[1].id,
        ),
      ];

      final error = service.validateWeekdayAssignments(duplicateAssignments);
      expect(error, isNotNull);
      expect(error, contains('Monday'));
      expect(error, contains('multiple'));
    });

    test('allows rest and workout on different days', () {
      final mixedAssignments = [
        assignments[0],
        WeekdayAssignment(
          id: RecordId('assign-rest'),
          programId: fixedProgram.id,
          weekday: 2,
          assignmentType: AssignmentType.rest,
        ),
      ];

      final error = service.validateWeekdayAssignments(mixedAssignments);
      expect(error, isNull);
    });

    test('validates all weekdays 1-7', () {
      final allAssignments = List.generate(
        7,
        (i) => WeekdayAssignment(
          id: RecordId('assign-${i + 1}'),
          programId: fixedProgram.id,
          weekday: i + 1,
          assignmentType: i.isEven
              ? AssignmentType.workout
              : AssignmentType.rest,
          programDayId: i.isEven ? days[0].id : null,
        ),
      );

      final error = service.validateWeekdayAssignments(allAssignments);
      expect(error, isNull);
    });
  });

  group('WeekdayAssignment validation', () {
    test('accepts weekday 1-7', () {
      for (var weekday = 1; weekday <= 7; weekday++) {
        expect(
          () => WeekdayAssignment(
            id: RecordId('assign-test'),
            programId: RecordId('prog-1'),
            weekday: weekday,
            assignmentType: AssignmentType.workout,
            programDayId: RecordId('day-1'),
          ),
          returnsNormally,
        );
      }
    });

    test('rejects weekday < 1', () {
      expect(
        () => WeekdayAssignment(
          id: RecordId('assign-test'),
          programId: RecordId('prog-1'),
          weekday: 0,
          assignmentType: AssignmentType.workout,
          programDayId: RecordId('day-1'),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('rejects weekday > 7', () {
      expect(
        () => WeekdayAssignment(
          id: RecordId('assign-test'),
          programId: RecordId('prog-1'),
          weekday: 8,
          assignmentType: AssignmentType.workout,
          programDayId: RecordId('day-1'),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('workout assignment requires programDayId', () {
      expect(
        () => WeekdayAssignment(
          id: RecordId('assign-test'),
          programId: RecordId('prog-1'),
          weekday: 1,
          assignmentType: AssignmentType.workout,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('rest assignment must not have programDayId', () {
      expect(
        () => WeekdayAssignment(
          id: RecordId('assign-test'),
          programId: RecordId('prog-1'),
          weekday: 1,
          assignmentType: AssignmentType.rest,
          programDayId: RecordId('day-1'),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
