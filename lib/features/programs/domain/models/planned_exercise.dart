import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Planned exercise domain model.
class PlannedExercise {
  final RecordId id;
  final RecordId programDayId;
  final ExerciseId exerciseId;
  final int orderIndex;
  final int? targetSets;
  final int? targetRepsMin;
  final int? targetRepsMax;
  final int? targetLoadGrams;
  final int? restSeconds;
  final String? notes;

  PlannedExercise({
    required this.id,
    required this.programDayId,
    required this.exerciseId,
    required this.orderIndex,
    this.targetSets,
    this.targetRepsMin,
    this.targetRepsMax,
    this.targetLoadGrams,
    this.restSeconds,
    this.notes,
  }) {
    if (orderIndex < 0) {
      throw const InvalidQuantityError('Order index cannot be negative');
    }
    if (targetSets != null && targetSets! <= 0) {
      throw const InvalidQuantityError('Target sets must be positive');
    }
    if (targetRepsMin != null && targetRepsMin! <= 0) {
      throw const InvalidQuantityError('Target reps min must be positive');
    }
    if (targetRepsMax != null && targetRepsMax! <= 0) {
      throw const InvalidQuantityError('Target reps max must be positive');
    }
    if (targetRepsMin != null &&
        targetRepsMax != null &&
        targetRepsMin! > targetRepsMax!) {
      throw const InvalidQuantityError('Target reps min cannot exceed max');
    }
    if (targetLoadGrams != null && targetLoadGrams! < 0) {
      throw const InvalidQuantityError('Target load cannot be negative');
    }
    if (restSeconds != null && restSeconds! < 0) {
      throw const InvalidQuantityError('Rest seconds cannot be negative');
    }
  }

  PlannedExercise copyWith({
    int? orderIndex,
    int? targetSets,
    int? targetRepsMin,
    int? targetRepsMax,
    int? targetLoadGrams,
    int? restSeconds,
    String? notes,
  }) {
    return PlannedExercise(
      id: id,
      programDayId: programDayId,
      exerciseId: exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      targetSets: targetSets ?? this.targetSets,
      targetRepsMin: targetRepsMin ?? this.targetRepsMin,
      targetRepsMax: targetRepsMax ?? this.targetRepsMax,
      targetLoadGrams: targetLoadGrams ?? this.targetLoadGrams,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
    );
  }
}
