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
  final List<String>? imageUrls;

  // Detailed exercise content
  final String? description;
  final List<String>? howToPerform;
  final List<String>? proTips;
  final List<String>? commonMistakes;

  const Exercise({
    required this.id,
    required this.sourceProvider,
    required this.canonicalName,
    required this.equipment,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.instructions,
    this.imageUrls,
    this.description,
    this.howToPerform,
    this.proTips,
    this.commonMistakes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceProvider': sourceProvider,
    'canonicalName': canonicalName,
    'equipment': equipment.toJson(),
    'primaryMuscle': primaryMuscle.toJson(),
    'secondaryMuscles': secondaryMuscles.map((m) => m.toJson()).toList(),
    'instructions': instructions,
    if (imageUrls != null) 'imageUrls': imageUrls,
    if (description != null) 'description': description,
    if (howToPerform != null) 'howToPerform': howToPerform,
    if (proTips != null) 'proTips': proTips,
    if (commonMistakes != null) 'commonMistakes': commonMistakes,
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
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'] as List)
          : null,
      description: json['description'] as String?,
      howToPerform: json['howToPerform'] != null
          ? List<String>.from(json['howToPerform'] as List)
          : null,
      proTips: json['proTips'] != null
          ? List<String>.from(json['proTips'] as List)
          : null,
      commonMistakes: json['commonMistakes'] != null
          ? List<String>.from(json['commonMistakes'] as List)
          : null,
    );
  }
}
