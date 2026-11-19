import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/features/onboarding/domain/models/fitness_profile.dart';
import 'package:gym_workout_tracker_v2/features/onboarding/domain/models/fitness_goal.dart';
import 'package:gym_workout_tracker_v2/features/onboarding/domain/models/experience_level.dart';
import 'package:gym_workout_tracker_v2/features/onboarding/domain/models/activity_level.dart';
import 'package:gym_workout_tracker_v2/features/onboarding/domain/services/fitness_recommendation_service.dart';

void main() {
  group('FitnessRecommendationService', () {
    late FitnessRecommendationService service;

    setUp(() {
      service = FitnessRecommendationService();
    });

    test('calculates BMR and maintenance calories correctly', () {
      // 25 year old, 175cm, 75kg, moderately active
      final profile = FitnessProfile(
        userId: 'test-user',
        dateOfBirth: DateTime(1999, 1, 1),
        heightCm: 175,
        currentWeightGrams: 75000, // 75kg
        activityLevel: ActivityLevel.moderatelyActive,
      );

      final recommendation = service.calculateRecommendations(profile);

      // BMR = 10 * 75 + 6.25 * 175 - 5 * 25 = 1718.75
      // Maintenance = 1718.75 * 1.55 = 2664
      expect(recommendation.maintenanceCalories, isNotNull);
      expect(recommendation.maintenanceCalories, closeTo(2664, 20));
    });

    test('applies calorie adjustment for muscle gain goal', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        dateOfBirth: DateTime(1999, 1, 1),
        heightCm: 175,
        currentWeightGrams: 75000,
        activityLevel: ActivityLevel.moderatelyActive,
        fitnessGoal: FitnessGoal.gainMuscle,
      );

      final recommendation = service.calculateRecommendations(profile);

      expect(recommendation.targetCalories, isNotNull);
      expect(
        recommendation.targetCalories! - recommendation.maintenanceCalories!,
        equals(400),
      );
    });

    test('applies calorie adjustment for fat loss goal', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        dateOfBirth: DateTime(1999, 1, 1),
        heightCm: 175,
        currentWeightGrams: 75000,
        activityLevel: ActivityLevel.moderatelyActive,
        fitnessGoal: FitnessGoal.loseFat,
      );

      final recommendation = service.calculateRecommendations(profile);

      expect(recommendation.targetCalories, isNotNull);
      expect(
        recommendation.maintenanceCalories! - recommendation.targetCalories!,
        equals(400),
      );
    });

    test('calculates protein target correctly for muscle gain', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        currentWeightGrams: 75000, // 75kg
        fitnessGoal: FitnessGoal.gainMuscle,
      );

      final recommendation = service.calculateRecommendations(profile);

      // 75kg * 2.0g/kg = 150g
      expect(recommendation.targetProteinGrams, equals(150));
    });

    test('calculates protein target correctly for fat loss', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        currentWeightGrams: 75000, // 75kg
        fitnessGoal: FitnessGoal.loseFat,
      );

      final recommendation = service.calculateRecommendations(profile);

      // 75kg * 2.2g/kg = 165g
      expect(recommendation.targetProteinGrams, equals(165));
    });

    test('recommends Full Body 3x/Week for 3 workout days', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        workoutDaysPerWeek: 3,
        experienceLevel: ExperienceLevel.beginner,
        trainingLocation: 'gym',
      );

      final recommendation = service.calculateRecommendations(profile);

      expect(recommendation.recommendedTemplateName, equals('Full Body 3x/Week'));
      expect(recommendation.templateReasoning, isNotNull);
    });

    test('recommends Upper/Lower 4x/Week for 4 workout days', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        workoutDaysPerWeek: 4,
        experienceLevel: ExperienceLevel.intermediate,
        trainingLocation: 'gym',
      );

      final recommendation = service.calculateRecommendations(profile);

      expect(recommendation.recommendedTemplateName, equals('Upper/Lower 4x/Week'));
    });

    test('recommends PPL for 5 workout days', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        workoutDaysPerWeek: 5,
        experienceLevel: ExperienceLevel.advanced,
        trainingLocation: 'gym',
      );

      final recommendation = service.calculateRecommendations(profile);

      expect(recommendation.recommendedTemplateName, equals('Push/Pull/Legs 5x/Week'));
    });

    test('adjusts template name for home training', () {
      final profile = FitnessProfile(
        userId: 'test-user',
        workoutDaysPerWeek: 3,
        experienceLevel: ExperienceLevel.beginner,
        trainingLocation: 'home',
      );

      final recommendation = service.calculateRecommendations(profile);

      expect(recommendation.recommendedTemplateName, contains('(Home)'));
      expect(recommendation.templateReasoning, contains('home equipment'));
    });

    test('handles missing data gracefully', () {
      final profile = FitnessProfile(
        userId: 'test-user',
      );

      final recommendation = service.calculateRecommendations(profile);

      // Should not crash, but values should be null when data is missing
      expect(recommendation.maintenanceCalories, isNull);
      expect(recommendation.targetCalories, isNull);
      expect(recommendation.targetProteinGrams, isNull);
    });

    test('applies different activity multipliers', () {
      final sedentaryProfile = FitnessProfile(
        userId: 'test-user',
        dateOfBirth: DateTime(1999, 1, 1),
        heightCm: 175,
        currentWeightGrams: 75000,
        activityLevel: ActivityLevel.sedentary,
      );

      final veryActiveProfile = FitnessProfile(
        userId: 'test-user',
        dateOfBirth: DateTime(1999, 1, 1),
        heightCm: 175,
        currentWeightGrams: 75000,
        activityLevel: ActivityLevel.veryActive,
      );

      final sedentaryRec = service.calculateRecommendations(sedentaryProfile);
      final veryActiveRec = service.calculateRecommendations(veryActiveProfile);

      expect(sedentaryRec.maintenanceCalories, isNotNull);
      expect(veryActiveRec.maintenanceCalories, isNotNull);
      expect(
        veryActiveRec.maintenanceCalories! > sedentaryRec.maintenanceCalories!,
        isTrue,
      );
    });
  });
}
