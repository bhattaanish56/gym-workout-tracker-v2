import 'package:gym_workout_tracker_v2/features/exercises/domain/models/exercise.dart';
import 'package:gym_workout_tracker_v2/features/exercises/domain/models/custom_exercise.dart'
    as domain;
import 'package:gym_workout_tracker_v2/features/exercises/domain/models/equipment.dart';
import 'package:gym_workout_tracker_v2/features/exercises/domain/models/muscle_group.dart';
import 'package:gym_workout_tracker_v2/features/exercises/domain/repositories/exercise_repository.dart';

class FakeExerciseRepository implements ExerciseRepository {
  final List<Exercise> _bundled = [
    const Exercise(
      id: 'ex_bench_press',
      sourceProvider: 'curated',
      canonicalName: 'Bench Press',
      equipment: Equipment.barbell,
      primaryMuscle: MuscleGroup.chest,
      secondaryMuscles: [],
      instructions: 'Press bar from chest.',
    ),
    const Exercise(
      id: 'ex_squat',
      sourceProvider: 'curated',
      canonicalName: 'Squat',
      equipment: Equipment.barbell,
      primaryMuscle: MuscleGroup.legs,
      secondaryMuscles: [],
      instructions: 'Squat down and up.',
    ),
  ];

  final List<domain.CustomExercise> _custom = [];

  @override
  Future<List<Exercise>> getBundledExercises() async => _bundled;

  @override
  Future<List<domain.CustomExercise>> getCustomExercises() async => _custom;

  @override
  Future<List<dynamic>> getAllExercises() async => [..._bundled, ..._custom];

  @override
  Future<List<dynamic>> searchExercises({
    String? query,
    MuscleGroup? muscleFilter,
    Equipment? equipmentFilter,
  }) async {
    final all = await getAllExercises();
    if (query == null || query.isEmpty) return all;
    return all.where((ex) {
      final name = ex is Exercise
          ? ex.canonicalName
          : (ex as domain.CustomExercise).name;
      return name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Future<domain.CustomExercise> createCustomExercise({
    required String name,
    required Equipment equipment,
    required MuscleGroup primaryMuscle,
    String? instructions,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCustomExercise(String id) async {
    throw UnimplementedError();
  }
}
