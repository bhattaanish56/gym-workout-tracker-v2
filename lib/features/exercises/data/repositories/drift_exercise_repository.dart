import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../sessions/data/database/app_database.dart' as db;
import '../../domain/models/custom_exercise.dart' as domain;
import '../../domain/models/exercise.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/muscle_group.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../bundled_exercises.dart';

const _uuid = Uuid();

class DriftExerciseRepository implements ExerciseRepository {
  final db.AppDatabase _db;
  final String userId;

  DriftExerciseRepository(this._db, this.userId);

  @override
  Future<List<Exercise>> getBundledExercises() async {
    return bundledExercises;
  }

  @override
  Future<List<domain.CustomExercise>> getCustomExercises() async {
    final rows = await (_db.select(_db.customExercises)
          ..where((t) => t.userId.equals(userId)))
        .get();
    return rows.map((row) {
      return domain.CustomExercise(
        id: RecordId(row.id),
        name: row.name,
        equipment: Equipment.fromJson(row.equipment),
        primaryMuscle: MuscleGroup.fromJson(row.primaryMuscle),
        instructions: row.instructions,
        createdAt: row.createdAt,
      );
    }).toList();
  }

  @override
  Future<List<dynamic>> getAllExercises() async {
    final bundled = await getBundledExercises();
    final custom = await getCustomExercises();
    return [...bundled, ...custom];
  }

  @override
  Future<List<dynamic>> searchExercises({
    String? query,
    MuscleGroup? muscleFilter,
    Equipment? equipmentFilter,
  }) async {
    final all = await getAllExercises();

    return all.where((ex) {
      final name = ex is Exercise
          ? ex.canonicalName
          : (ex as domain.CustomExercise).name;
      final muscle = ex is Exercise
          ? ex.primaryMuscle
          : (ex as domain.CustomExercise).primaryMuscle;
      final equip = ex is Exercise
          ? ex.equipment
          : (ex as domain.CustomExercise).equipment;

      if (query != null && query.isNotEmpty) {
        if (!name.toLowerCase().contains(query.toLowerCase())) {
          return false;
        }
      }

      if (muscleFilter != null && muscle != muscleFilter) {
        return false;
      }

      if (equipmentFilter != null && equip != equipmentFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Future<domain.CustomExercise> createCustomExercise({
    required String name,
    required Equipment equipment,
    required MuscleGroup primaryMuscle,
    String? instructions,
  }) async {
    final id = RecordId(_uuid.v4());
    final now = DateTime.now().toUtc();

    await _db
        .into(_db.customExercises)
        .insert(
          db.CustomExercisesCompanion.insert(
            id: id.value,
            userId: Value(userId),
            name: name,
            equipment: equipment.toJson(),
            primaryMuscle: primaryMuscle.toJson(),
            instructions: Value(instructions),
            createdAt: now,
          ),
        );

    return domain.CustomExercise(
      id: id,
      name: name,
      equipment: equipment,
      primaryMuscle: primaryMuscle,
      instructions: instructions,
      createdAt: now,
    );
  }

  @override
  Future<void> deleteCustomExercise(String id) async {
    await (_db.delete(
      _db.customExercises,
    )..where((tbl) => tbl.id.equals(id) & tbl.userId.equals(userId))).go();
  }
}
