import '../models/fitness_profile.dart';
import '../models/fitness_goal.dart';
import '../models/experience_level.dart';

/// Fitness recommendation including nutrition and workout template.
class FitnessRecommendation {
  final int? maintenanceCalories;
  final int? targetCalories;
  final int? targetProteinGrams;
  final String? recommendedTemplateName;
  final String? templateReasoning;

  FitnessRecommendation({
    this.maintenanceCalories,
    this.targetCalories,
    this.targetProteinGrams,
    this.recommendedTemplateName,
    this.templateReasoning,
  });
}

/// Deterministic fitness recommendation service.
/// Uses Mifflin-St Jeor equation for BMR calculation.
class FitnessRecommendationService {
  /// Calculate recommendations based on fitness profile.
  FitnessRecommendation calculateRecommendations(FitnessProfile profile) {
    final maintenanceCals = _calculateMaintenanceCalories(profile);
    final targetCals = _calculateTargetCalories(profile, maintenanceCals);
    final proteinGrams = _calculateProteinTarget(profile);
    final template = _recommendWorkoutTemplate(profile);

    return FitnessRecommendation(
      maintenanceCalories: maintenanceCals,
      targetCalories: targetCals,
      targetProteinGrams: proteinGrams,
      recommendedTemplateName: template.$1,
      templateReasoning: template.$2,
    );
  }

  /// Calculate BMR using Mifflin-St Jeor equation.
  /// BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age + s
  /// where s = +5 for males, -161 for females, 0 for unspecified
  int? _calculateBMR(FitnessProfile profile) {
    final weightKg = profile.currentWeightKg;
    final heightCm = profile.heightCm;
    final age = profile.ageYears;

    if (weightKg == null || heightCm == null || age == null) return null;

    // Base calculation without gender adjustment
    final bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);

    return bmr.round();
  }

  /// Calculate maintenance calories: BMR * activity multiplier.
  int? _calculateMaintenanceCalories(FitnessProfile profile) {
    final bmr = _calculateBMR(profile);
    if (bmr == null) return null;

    final activityMultiplier = profile.activityLevel?.multiplier ?? 1.55;
    return (bmr * activityMultiplier).round();
  }

  /// Adjust maintenance calories based on fitness goal.
  /// Muscle gain: +300-500 cal (conservative)
  /// Fat loss: -300-500 cal (conservative)
  /// Maintain: same as maintenance
  int? _calculateTargetCalories(FitnessProfile profile, int? maintenanceCals) {
    if (maintenanceCals == null) return null;

    final goal = profile.fitnessGoal;
    if (goal == null) return maintenanceCals;

    switch (goal) {
      case FitnessGoal.gainMuscle:
        return maintenanceCals + 400; // Conservative surplus
      case FitnessGoal.loseFat:
        return maintenanceCals - 400; // Conservative deficit
      case FitnessGoal.improveStrength:
        return maintenanceCals + 200; // Slight surplus
      case FitnessGoal.maintain:
        return maintenanceCals;
    }
  }

  /// Calculate protein target: 1.6-2.2g per kg bodyweight based on goal.
  /// Higher protein for muscle gain and fat loss, moderate for maintenance.
  int? _calculateProteinTarget(FitnessProfile profile) {
    final weightKg = profile.currentWeightKg;
    if (weightKg == null) return null;

    final goal = profile.fitnessGoal;
    double proteinPerKg;

    switch (goal) {
      case FitnessGoal.gainMuscle:
        proteinPerKg = 2.0; // Higher for muscle building
      case FitnessGoal.loseFat:
        proteinPerKg = 2.2; // Highest for fat loss (preserve muscle)
      case FitnessGoal.improveStrength:
        proteinPerKg = 1.8;
      case FitnessGoal.maintain:
      case null:
        proteinPerKg = 1.6; // Baseline for general fitness
    }

    return (weightKg * proteinPerKg).round();
  }

  /// Recommend workout template based on days/week, experience, and equipment.
  /// Returns (templateName, reasoning).
  (String?, String?) _recommendWorkoutTemplate(FitnessProfile profile) {
    final daysPerWeek = profile.workoutDaysPerWeek;
    final experience = profile.experienceLevel;
    final location = profile.trainingLocation;

    if (daysPerWeek == null) {
      return (null, null);
    }

    // Template selection based on frequency
    String templateName;
    String reasoning;

    if (daysPerWeek <= 2) {
      templateName = 'Full Body 2x/Week';
      reasoning = 'With 2 days per week, full body workouts ensure each muscle group is trained.';
    } else if (daysPerWeek == 3) {
      templateName = 'Full Body 3x/Week';
      reasoning = '3-day full body split is optimal for building strength and muscle with adequate recovery.';
    } else if (daysPerWeek == 4) {
      if (experience == ExperienceLevel.beginner) {
        templateName = 'Upper/Lower 4x/Week';
        reasoning = 'Upper/lower split provides great balance and recovery for intermediate training.';
      } else {
        templateName = 'Upper/Lower 4x/Week';
        reasoning = 'Classic upper/lower split maximizes frequency and recovery.';
      }
    } else if (daysPerWeek == 5) {
      templateName = 'Push/Pull/Legs 5x/Week';
      reasoning = 'PPL split allows high volume and frequency for experienced lifters.';
    } else {
      templateName = 'Push/Pull/Legs 6x/Week';
      reasoning = 'High-frequency PPL for advanced training with optimal recovery between muscle groups.';
    }

    // Adjust for home training
    if (location == 'home') {
      templateName += ' (Home)';
      reasoning += ' Adapted for home equipment.';
    }

    return (templateName, reasoning);
  }
}
