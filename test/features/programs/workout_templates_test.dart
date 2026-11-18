import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/features/programs/data/workout_templates.dart';
import 'package:gym_workout_tracker_v2/features/programs/domain/models/program.dart';
import 'package:gym_workout_tracker_v2/features/exercises/data/bundled_exercises.dart';

void main() {
  group('Workout Templates', () {
    test('should have 4 templates', () {
      expect(workoutTemplates.length, 4);
    });

    test('Push/Pull/Legs template should exist', () {
      final ppl = workoutTemplates.firstWhere((t) => t.id == 'template_ppl');
      expect(ppl.name, 'Push/Pull/Legs');
      expect(ppl.scheduleMode, ScheduleMode.flexibleRotation);
      expect(ppl.days.length, 3);
    });

    test('Upper/Lower template should exist', () {
      final ul = workoutTemplates.firstWhere(
        (t) => t.id == 'template_upper_lower',
      );
      expect(ul.name, 'Upper/Lower Split');
      expect(ul.days.length, 2);
    });

    test('Full Body template should exist', () {
      final fb = workoutTemplates.firstWhere(
        (t) => t.id == 'template_full_body',
      );
      expect(fb.name, 'Full Body');
      expect(fb.days.length, 1);
    });

    test('Bro Split template should exist', () {
      final bro = workoutTemplates.firstWhere(
        (t) => t.id == 'template_bro_split',
      );
      expect(bro.name, 'Bro Split');
      expect(bro.days.length, 5);
    });

    test('all template exercise IDs should be valid', () {
      final validExerciseIds = bundledExercises.map((e) => e.id).toSet();

      for (final template in workoutTemplates) {
        for (final day in template.days) {
          for (final exercise in day.exercises) {
            expect(
              validExerciseIds.contains(exercise.exerciseId),
              true,
              reason:
                  'Exercise ID ${exercise.exerciseId} in ${template.name} - ${day.name} is not valid',
            );
          }
        }
      }
    });

    test('template exercises should have valid targets', () {
      for (final template in workoutTemplates) {
        for (final day in template.days) {
          for (final exercise in day.exercises) {
            if (exercise.targetSets != null) {
              expect(exercise.targetSets! > 0, true);
            }
            if (exercise.targetRepsMin != null) {
              expect(exercise.targetRepsMin! > 0, true);
            }
            if (exercise.targetRepsMax != null) {
              expect(exercise.targetRepsMax! > 0, true);
            }
            if (exercise.targetRepsMin != null &&
                exercise.targetRepsMax != null) {
              expect(exercise.targetRepsMin! <= exercise.targetRepsMax!, true);
            }
          }
        }
      }
    });
  });
}
