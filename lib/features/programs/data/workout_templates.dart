import '../domain/models/program.dart';
import '../../exercises/domain/models/exercise.dart';

/// Template for a planned exercise.
class TemplatePlannedExercise {
  final String exerciseId;
  final int? targetSets;
  final int? targetRepsMin;
  final int? targetRepsMax;
  final int? targetLoadGrams;
  final int? restSeconds;
  final String? notes;

  const TemplatePlannedExercise({
    required this.exerciseId,
    this.targetSets,
    this.targetRepsMin,
    this.targetRepsMax,
    this.targetLoadGrams,
    this.restSeconds,
    this.notes,
  });
}

/// Template for a program day.
class TemplateProgramDay {
  final String name;
  final String? targetDescription;
  final List<TemplatePlannedExercise> exercises;

  const TemplateProgramDay({
    required this.name,
    this.targetDescription,
    required this.exercises,
  });
}

/// Workout program template.
class WorkoutTemplate {
  final String id;
  final String name;
  final String description;
  final ScheduleMode scheduleMode;
  final List<TemplateProgramDay> days;

  const WorkoutTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.scheduleMode,
    required this.days,
  });
}

/// All available workout templates.
const List<WorkoutTemplate> workoutTemplates = [
  // Push/Pull/Legs
  WorkoutTemplate(
    id: 'template_ppl',
    name: 'Push/Pull/Legs',
    description: '3-day split focusing on push, pull, and leg movements',
    scheduleMode: ScheduleMode.flexibleRotation,
    days: [
      TemplateProgramDay(
        name: 'Push Day',
        targetDescription: 'Chest, shoulders, and triceps',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_bench_press_barbell',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 180,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_press_overhead_dumbbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_incline_bench_press_dumbbell',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_lateral_raise',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_tricep_pushdown',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_tricep_extension_overhead',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 60,
          ),
        ],
      ),
      TemplateProgramDay(
        name: 'Pull Day',
        targetDescription: 'Back and biceps',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_deadlift_barbell',
            targetSets: 3,
            targetRepsMin: 5,
            targetRepsMax: 8,
            restSeconds: 180,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_pullup',
            targetSets: 3,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_row_barbell_bent',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_facepull',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_curl_barbell',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_hammer_curl',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 60,
          ),
        ],
      ),
      TemplateProgramDay(
        name: 'Leg Day',
        targetDescription: 'Quads, hamstrings, glutes, and calves',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_squat_barbell',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 180,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_press',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_rdl_barbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_curl_lying',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_extension',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_calf_raise_standing',
            targetSets: 4,
            targetRepsMin: 12,
            targetRepsMax: 20,
            restSeconds: 45,
          ),
        ],
      ),
    ],
  ),

  // Upper/Lower Split
  WorkoutTemplate(
    id: 'template_upper_lower',
    name: 'Upper/Lower Split',
    description: '2-day split alternating upper and lower body',
    scheduleMode: ScheduleMode.flexibleRotation,
    days: [
      TemplateProgramDay(
        name: 'Upper Body',
        targetDescription: 'Chest, back, shoulders, and arms',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_bench_press_barbell',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_row_barbell_bent',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_press_overhead_dumbbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_lat_pulldown',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_curl_dumbbell',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_tricep_pushdown',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
        ],
      ),
      TemplateProgramDay(
        name: 'Lower Body',
        targetDescription: 'Quads, hamstrings, glutes, and calves',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_squat_barbell',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 180,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_rdl_barbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_press',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_curl_lying',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_lunge_dumbbell',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_calf_raise_standing',
            targetSets: 4,
            targetRepsMin: 12,
            targetRepsMax: 20,
            restSeconds: 45,
          ),
        ],
      ),
    ],
  ),

  // Full Body
  WorkoutTemplate(
    id: 'template_full_body',
    name: 'Full Body',
    description: 'Single full-body workout targeting all major muscle groups',
    scheduleMode: ScheduleMode.flexibleRotation,
    days: [
      TemplateProgramDay(
        name: 'Full Body Workout',
        targetDescription: 'All major muscle groups',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_squat_barbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_bench_press_barbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_deadlift_barbell',
            targetSets: 3,
            targetRepsMin: 5,
            targetRepsMax: 8,
            restSeconds: 180,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_press_overhead_dumbbell',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_row_barbell_bent',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_curl_barbell',
            targetSets: 2,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_tricep_pushdown',
            targetSets: 2,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
        ],
      ),
    ],
  ),

  // Bro Split (5-day)
  WorkoutTemplate(
    id: 'template_bro_split',
    name: 'Bro Split',
    description: '5-day split with dedicated days for each muscle group',
    scheduleMode: ScheduleMode.flexibleRotation,
    days: [
      TemplateProgramDay(
        name: 'Chest Day',
        targetDescription: 'Chest focus',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_bench_press_barbell',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_incline_bench_press_barbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_chest_fly_dumbbell',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_dip_chest',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_cable_fly',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
        ],
      ),
      TemplateProgramDay(
        name: 'Back Day',
        targetDescription: 'Back focus',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_deadlift_barbell',
            targetSets: 4,
            targetRepsMin: 5,
            targetRepsMax: 8,
            restSeconds: 180,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_pullup',
            targetSets: 3,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_row_barbell_bent',
            targetSets: 4,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_cable_row_seated',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_shrug_barbell',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
        ],
      ),
      TemplateProgramDay(
        name: 'Shoulder Day',
        targetDescription: 'Shoulder focus',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_press_overhead_barbell',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_lateral_raise',
            targetSets: 4,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_rear_delt_fly',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_front_raise',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_facepull',
            targetSets: 3,
            targetRepsMin: 15,
            targetRepsMax: 20,
            restSeconds: 45,
          ),
        ],
      ),
      TemplateProgramDay(
        name: 'Arm Day',
        targetDescription: 'Biceps and triceps',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_curl_barbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_tricep_pushdown',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_hammer_curl',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_skullcrusher',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_preacher_curl',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 12,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_tricep_extension_overhead',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
        ],
      ),
      TemplateProgramDay(
        name: 'Leg Day',
        targetDescription: 'Legs and calves',
        exercises: [
          TemplatePlannedExercise(
            exerciseId: 'ex_squat_barbell',
            targetSets: 4,
            targetRepsMin: 6,
            targetRepsMax: 10,
            restSeconds: 180,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_press',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 120,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_curl_lying',
            targetSets: 3,
            targetRepsMin: 10,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_leg_extension',
            targetSets: 3,
            targetRepsMin: 12,
            targetRepsMax: 15,
            restSeconds: 60,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_rdl_barbell',
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
            restSeconds: 90,
          ),
          TemplatePlannedExercise(
            exerciseId: 'ex_calf_raise_standing',
            targetSets: 4,
            targetRepsMin: 12,
            targetRepsMax: 20,
            restSeconds: 45,
          ),
        ],
      ),
    ],
  ),
];
