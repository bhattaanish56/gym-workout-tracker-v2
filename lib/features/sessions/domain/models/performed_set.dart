import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/value_objects/weight.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Set type classification.
enum SetType {
  warmup,
  working;

  String toJson() => name;

  static SetType fromJson(String value) {
    return SetType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw InvalidQuantityError('Invalid SetType: $value'),
    );
  }
}

/// Performed set in an exercise.
///
/// Records weight, reps, and completion status.
class PerformedSet {
  final RecordId id;
  final RecordId performedExerciseId;
  final int orderIndex;
  final SetType setType;
  final WeightGrams? loadGrams;
  final int? reps;
  final bool completed;
  final String? notes;

  PerformedSet({
    required this.id,
    required this.performedExerciseId,
    required this.orderIndex,
    required this.setType,
    this.loadGrams,
    this.reps,
    required this.completed,
    this.notes,
  }) {
    if (orderIndex < 0) {
      throw InvalidQuantityError('orderIndex cannot be negative: $orderIndex');
    }
    if (reps != null && reps! < 0) {
      throw InvalidQuantityError('reps cannot be negative: $reps');
    }
  }

  PerformedSet copyWith({
    int? orderIndex,
    SetType? setType,
    WeightGrams? loadGrams,
    int? reps,
    bool? completed,
    String? notes,
  }) {
    return PerformedSet(
      id: id,
      performedExerciseId: performedExerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      setType: setType ?? this.setType,
      loadGrams: loadGrams ?? this.loadGrams,
      reps: reps ?? this.reps,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
    );
  }

  /// Marks set as completed.
  PerformedSet markCompleted() {
    return copyWith(completed: true);
  }

  /// Marks set as not completed.
  PerformedSet markIncomplete() {
    return copyWith(completed: false);
  }
}
