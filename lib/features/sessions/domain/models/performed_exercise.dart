import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Exercise snapshot for historical preservation.
///
/// Preserves exercise name and metadata at logging time
/// so catalog changes don't alter workout history.
class ExerciseSnapshot {
  final String id;
  final String name;
  final String? equipment;
  final String? primaryMuscle;

  const ExerciseSnapshot({
    required this.id,
    required this.name,
    this.equipment,
    this.primaryMuscle,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (equipment != null) 'equipment': equipment,
    if (primaryMuscle != null) 'primaryMuscle': primaryMuscle,
  };

  factory ExerciseSnapshot.fromJson(Map<String, dynamic> json) {
    return ExerciseSnapshot(
      id: json['id'] as String? ?? 'unknown_${json['name']}',
      name: json['name'] as String,
      equipment: json['equipment'] as String?,
      primaryMuscle: json['primaryMuscle'] as String?,
    );
  }
}

/// Performed exercise in a workout session.
///
/// Contains ordered sets and historical exercise snapshot.
class PerformedExercise {
  final RecordId id;
  final RecordId sessionId;
  final int orderIndex;
  final ExerciseSnapshot snapshot;
  final String? notes;

  PerformedExercise({
    required this.id,
    required this.sessionId,
    required this.orderIndex,
    required this.snapshot,
    this.notes,
  }) {
    if (orderIndex < 0) {
      throw InvalidQuantityError('orderIndex cannot be negative: $orderIndex');
    }
    if (snapshot.name.trim().isEmpty) {
      throw const InvalidIdentifierError('Exercise name cannot be empty');
    }
  }

  PerformedExercise copyWith({
    int? orderIndex,
    ExerciseSnapshot? snapshot,
    String? notes,
  }) {
    return PerformedExercise(
      id: id,
      sessionId: sessionId,
      orderIndex: orderIndex ?? this.orderIndex,
      snapshot: snapshot ?? this.snapshot,
      notes: notes ?? this.notes,
    );
  }
}
