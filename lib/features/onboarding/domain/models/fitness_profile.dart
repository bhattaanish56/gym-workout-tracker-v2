import 'fitness_goal.dart';
import 'experience_level.dart';
import 'activity_level.dart';

class FitnessProfile {
  final String userId;
  final String? name;
  final DateTime? dateOfBirth;
  final String? gender;
  final int? heightCm;
  final int? currentWeightGrams;
  final int? goalWeightGrams;
  final FitnessGoal? fitnessGoal;
  final ExperienceLevel? experienceLevel;
  final ActivityLevel? activityLevel;
  final int? workoutDaysPerWeek;
  final String? trainingLocation;
  final List<String> equipment;
  final bool hasCompletedOnboarding;
  final int? maintenanceCalories;
  final int? targetCalories;
  final int? targetProteinGrams;
  final DateTime? onboardingCompletedAt;
  final DateTime updatedAt;

  FitnessProfile({
    required this.userId,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.currentWeightGrams,
    this.goalWeightGrams,
    this.fitnessGoal,
    this.experienceLevel,
    this.activityLevel,
    this.workoutDaysPerWeek,
    this.trainingLocation,
    List<String>? equipment,
    this.hasCompletedOnboarding = false,
    this.maintenanceCalories,
    this.targetCalories,
    this.targetProteinGrams,
    this.onboardingCompletedAt,
    DateTime? updatedAt,
  })  : equipment = equipment ?? [],
        updatedAt = updatedAt ?? DateTime.now();

  int? get ageYears {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  double? get currentWeightKg {
    if (currentWeightGrams == null) return null;
    return currentWeightGrams! / 1000.0;
  }

  double? get goalWeightKg {
    if (goalWeightGrams == null) return null;
    return goalWeightGrams! / 1000.0;
  }

  FitnessProfile copyWith({
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    int? heightCm,
    int? currentWeightGrams,
    int? goalWeightGrams,
    FitnessGoal? fitnessGoal,
    ExperienceLevel? experienceLevel,
    ActivityLevel? activityLevel,
    int? workoutDaysPerWeek,
    String? trainingLocation,
    List<String>? equipment,
    bool? hasCompletedOnboarding,
    int? maintenanceCalories,
    int? targetCalories,
    int? targetProteinGrams,
    DateTime? onboardingCompletedAt,
    DateTime? updatedAt,
  }) {
    return FitnessProfile(
      userId: userId,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      currentWeightGrams: currentWeightGrams ?? this.currentWeightGrams,
      goalWeightGrams: goalWeightGrams ?? this.goalWeightGrams,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      activityLevel: activityLevel ?? this.activityLevel,
      workoutDaysPerWeek: workoutDaysPerWeek ?? this.workoutDaysPerWeek,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      equipment: equipment ?? this.equipment,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      maintenanceCalories: maintenanceCalories ?? this.maintenanceCalories,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProteinGrams: targetProteinGrams ?? this.targetProteinGrams,
      onboardingCompletedAt: onboardingCompletedAt ?? this.onboardingCompletedAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
