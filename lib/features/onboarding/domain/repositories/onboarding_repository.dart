import '../models/fitness_profile.dart';

/// Repository interface for onboarding data.
abstract class OnboardingRepository {
  Future<FitnessProfile?> getFitnessProfile(String userId);
  Future<void> saveFitnessProfile(FitnessProfile profile);
  Future<void> updatePartialProfile(String userId, Map<String, dynamic> updates);
  Future<bool> hasCompletedOnboarding(String userId);
}
