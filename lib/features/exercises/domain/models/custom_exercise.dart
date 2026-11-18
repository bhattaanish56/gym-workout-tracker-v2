import '../../../../core/domain/value_objects/identifiers.dart';
import 'equipment.dart';
import 'muscle_group.dart';

/// User-created custom exercise.
class CustomExercise {
  final RecordId id;
  final String name;
  final Equipment equipment;
  final MuscleGroup primaryMuscle;
  final String? instructions;
  final DateTime createdAt;

  CustomExercise({
    required this.id,
    required this.name,
    required this.equipment,
    required this.primaryMuscle,
    this.instructions,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id.value,
    'name': name,
    'equipment': equipment.toJson(),
    'primaryMuscle': primaryMuscle.toJson(),
    if (instructions != null) 'instructions': instructions,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CustomExercise.fromJson(Map<String, dynamic> json) {
    return CustomExercise(
      id: RecordId(json['id'] as String),
      name: json['name'] as String,
      equipment: Equipment.fromJson(json['equipment'] as String),
      primaryMuscle: MuscleGroup.fromJson(json['primaryMuscle'] as String),
      instructions: json['instructions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
