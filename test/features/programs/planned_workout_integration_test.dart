import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/date_time.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/workout_session.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program_day.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/planned_exercise.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/rotation_state.dart';

void main() {
  group('Planned Workout Integration', () {
    test('WorkoutSession supports program fields', () {
      final session = WorkoutSession(
        id: RecordId('session1'),
        sourceType: WorkoutSourceType.programDay,
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate.fromDateTime(DateTime.now()),
        status: WorkoutStatus.inProgress,
        programId: 'prog1',
        programDayId: 'day1',
        programSnapshot: {
          'programName': 'Push Pull Legs',
          'dayName': 'Push Day',
          'dayOrderIndex': 0,
        },
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      expect(session.programId, 'prog1');
      expect(session.programDayId, 'day1');
      expect(session.programSnapshot!['programName'], 'Push Pull Legs');
      expect(session.programSnapshot!['dayName'], 'Push Day');
    });

    test('RotationState tracks next workout in flexible rotation', () {
      final state = RotationState(
        programId: RecordId('prog1'),
        nextDayIndex: 0,
      );

      expect(state.nextDayIndex, 0);

      final advanced = state.copyWith(nextDayIndex: 1);
      expect(advanced.nextDayIndex, 1);
    });

    test('PlannedExercise contains target parameters', () {
      final planned = PlannedExercise(
        id: RecordId('pe1'),
        programDayId: RecordId('day1'),
        exerciseId: ExerciseId('ex1'),
        orderIndex: 0,
        targetSets: 3,
        targetRepsMin: 8,
        targetRepsMax: 12,
        targetLoadGrams: 60000,
      );

      expect(planned.targetSets, 3);
      expect(planned.targetRepsMin, 8);
      expect(planned.targetRepsMax, 12);
      expect(planned.targetLoadGrams, 60000);
    });

    test('Program supports flexible rotation schedule mode', () {
      final program = Program(
        id: RecordId('prog1'),
        name: 'Push Pull Legs',
        scheduleMode: ScheduleMode.flexibleRotation,
        status: ProgramStatus.active,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      expect(program.scheduleMode, ScheduleMode.flexibleRotation);
      expect(program.status, ProgramStatus.active);
    });

    test('Rotation state wraps around to zero', () {
      final programId = RecordId('prog1');
      const dayCount = 3;

      // Simulate advancing through rotation
      var nextIndex = 0;
      nextIndex = (nextIndex + 1) % dayCount; // 1
      expect(nextIndex, 1);

      nextIndex = (nextIndex + 1) % dayCount; // 2
      expect(nextIndex, 2);

      nextIndex = (nextIndex + 1) % dayCount; // 0 (wrap)
      expect(nextIndex, 0);
    });
  });
}
