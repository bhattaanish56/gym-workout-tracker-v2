import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../data/repositories/drift_exercise_repository.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/muscle_group.dart';
import '../../domain/repositories/exercise_repository.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftExerciseRepository(db);
});

final allExercisesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(exerciseRepositoryProvider);
  return repo.getAllExercises();
});

final customExercisesProvider = FutureProvider((ref) async {
  final repo = ref.watch(exerciseRepositoryProvider);
  return repo.getCustomExercises();
});

final exerciseSearchProvider =
    FutureProvider.family<List<dynamic>, ExerciseSearchParams>((
      ref,
      params,
    ) async {
      final repo = ref.watch(exerciseRepositoryProvider);
      return repo.searchExercises(
        query: params.query,
        muscleFilter: params.muscleFilter,
        equipmentFilter: params.equipmentFilter,
      );
    });

class ExerciseSearchParams {
  final String? query;
  final MuscleGroup? muscleFilter;
  final Equipment? equipmentFilter;

  ExerciseSearchParams({this.query, this.muscleFilter, this.equipmentFilter});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSearchParams &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          muscleFilter == other.muscleFilter &&
          equipmentFilter == other.equipmentFilter;

  @override
  int get hashCode => Object.hash(query, muscleFilter, equipmentFilter);
}
