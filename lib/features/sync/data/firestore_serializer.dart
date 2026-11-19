import 'dart:convert';
import '../../sessions/domain/models/workout_session.dart';
import '../../sessions/domain/models/performed_exercise.dart';
import '../../sessions/domain/models/performed_set.dart';
import '../../programs/domain/models/program.dart';
import '../../programs/domain/models/program_day.dart';
import '../../programs/domain/models/planned_exercise.dart';
import '../../exercises/domain/models/custom_exercise.dart';
import '../../progress/domain/models/bodyweight_entry.dart';

class FirestoreSerializer {
  static Map<String, dynamic> serializeWorkout(
    WorkoutSession session,
    List<PerformedExercise> exercises,
    List<PerformedSet> sets,
  ) {
    return {
      'id': session.id.value,
      'sourceType': session.sourceType.toJson(),
      'startedAt': session.startedAt.toIso8601String(),
      'finishedAt': session.finishedAt?.toIso8601String(),
      'workoutDate': session.workoutDate.toIso8601(),
      'status': session.status.toJson(),
      'programId': session.programId,
      'programDayId': session.programDayId,
      'programSnapshot': session.programSnapshot,
      'fulfilledScheduledDate': session.fulfilledScheduledDate?.toIso8601(),
      'exercises': exercises.map((e) => {
        'id': e.id.value,
        'orderIndex': e.orderIndex,
        'snapshot': e.snapshot.toJson(),
        'notes': e.notes,
        'sets': sets
            .where((s) => s.performedExerciseId.value == e.id.value)
            .map((s) => {
              'id': s.id.value,
              'orderIndex': s.orderIndex,
              'setType': s.setType.toJson(),
              'loadGrams': s.loadGrams?.grams,
              'reps': s.reps,
              'completed': s.completed,
              'notes': s.notes,
            })
            .toList(),
      }).toList(),
      'createdAt': session.createdAt.toIso8601String(),
      'updatedAt': session.updatedAt.toIso8601String(),
    };
  }

  static Map<String, dynamic> serializeProgram(
    Program program,
    List<ProgramDay> days,
    Map<String, List<PlannedExercise>> exercisesByDay,
  ) {
    return {
      'id': program.id.value,
      'name': program.name,
      'description': program.description,
      'scheduleMode': program.scheduleMode.toJson(),
      'status': program.status.toJson(),
      'days': days.map((day) => {
        'id': day.id.value,
        'orderIndex': day.orderIndex,
        'name': day.name,
        'targetDescription': day.targetDescription,
        'exercises': (exercisesByDay[day.id.value] ?? []).map((ex) => {
          'id': ex.id.value,
          'exerciseId': ex.exerciseId.value,
          'orderIndex': ex.orderIndex,
          'targetSets': ex.targetSets,
          'targetRepsMin': ex.targetRepsMin,
          'targetRepsMax': ex.targetRepsMax,
          'targetLoadGrams': ex.targetLoadGrams,
          'restSeconds': ex.restSeconds,
          'notes': ex.notes,
        }).toList(),
      }).toList(),
      'createdAt': program.createdAt.toIso8601String(),
      'updatedAt': program.updatedAt.toIso8601String(),
    };
  }

  static Map<String, dynamic> serializeCustomExercise(CustomExercise exercise) {
    return {
      'id': exercise.id.value,
      'name': exercise.name,
      'equipment': exercise.equipment.toJson(),
      'primaryMuscle': exercise.primaryMuscle.toJson(),
      'instructions': exercise.instructions,
      'createdAt': exercise.createdAt.toIso8601String(),
    };
  }

  static Map<String, dynamic> serializeBodyWeight(BodyWeightEntry entry) {
    return {
      'id': entry.id.value,
      'weightGrams': entry.weightGrams,
      'measuredAt': entry.measuredAt.toIso8601String(),
      'measuredDate': entry.measuredDate.toIso8601(),
      'notes': entry.notes,
      'createdAt': entry.createdAt.toIso8601String(),
    };
  }
}
