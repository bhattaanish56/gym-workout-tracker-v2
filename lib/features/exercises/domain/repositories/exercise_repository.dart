import '../models/custom_exercise.dart' as domain;
import '../models/exercise.dart';
import '../models/equipment.dart';
import '../models/muscle_group.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getBundledExercises();
  Future<List<domain.CustomExercise>> getCustomExercises();
  Future<List<dynamic>> getAllExercises();
  Future<List<dynamic>> searchExercises({
    String? query,
    MuscleGroup? muscleFilter,
    Equipment? equipmentFilter,
  });
  Future<domain.CustomExercise> createCustomExercise({
    required String name,
    required Equipment equipment,
    required MuscleGroup primaryMuscle,
    String? instructions,
  });
  Future<void> deleteCustomExercise(String id);
}
