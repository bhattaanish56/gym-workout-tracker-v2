import 'equipment.dart';
import 'muscle_group.dart';

/// Bundled catalog exercise.
class Exercise {
  final String id;
  final String sourceProvider;
  final String canonicalName;
  final Equipment equipment;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final String instructions;

  const Exercise({
    required this.id,
    required this.sourceProvider,
    required this.canonicalName,
    required this.equipment,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.instructions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceProvider': sourceProvider,
    'canonicalName': canonicalName,
    'equipment': equipment.toJson(),
    'primaryMuscle': primaryMuscle.toJson(),
    'secondaryMuscles': secondaryMuscles.map((m) => m.toJson()).toList(),
    'instructions': instructions,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      sourceProvider: json['sourceProvider'] as String,
      canonicalName: json['canonicalName'] as String,
      equipment: Equipment.fromJson(json['equipment'] as String),
      primaryMuscle: MuscleGroup.fromJson(json['primaryMuscle'] as String),
      secondaryMuscles: (json['secondaryMuscles'] as List)
          .map((m) => MuscleGroup.fromJson(m as String))
          .toList(),
      instructions: json['instructions'] as String,
    );
  }
}
