import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/drift_onboarding_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/services/fitness_recommendation_service.dart';
import '../../domain/models/fitness_profile.dart';
import '../../domain/models/fitness_goal.dart';
import '../../domain/models/experience_level.dart';
import '../../domain/models/activity_level.dart';

// Repository provider
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftOnboardingRepository(db);
});

// Recommendation service provider
final fitnessRecommendationServiceProvider = Provider((ref) {
  return FitnessRecommendationService();
});

// Onboarding state provider (holds current step and form data)
class OnboardingStateNotifier extends Notifier<Map<String, dynamic>> {
  OnboardingRepository get _repository => ref.read(onboardingRepositoryProvider);
  String? get _userId => ref.read(authRepositoryProvider).currentUser?.uid;

  @override
  Map<String, dynamic> build() {
    _loadSavedState();
    return {};
  }

  Future<void> _loadSavedState() async {
    if (_userId != null) {
      final profile = await _repository.getFitnessProfile(_userId!);
      if (profile != null) {
        state = {
          'name': profile.name,
          'dateOfBirth': profile.dateOfBirth,
          'gender': profile.gender,
          'heightCm': profile.heightCm,
          'currentWeightGrams': profile.currentWeightGrams,
          'goalWeightGrams': profile.goalWeightGrams,
          'fitnessGoal': profile.fitnessGoal?.value,
          'experienceLevel': profile.experienceLevel?.value,
          'activityLevel': profile.activityLevel?.value,
          'workoutDaysPerWeek': profile.workoutDaysPerWeek,
          'trainingLocation': profile.trainingLocation,
          'equipment': profile.equipment.join(','),
          'currentStep': 0,
        };
      }
    }
  }

  void updateData(Map<String, dynamic> data) {
    state = {...state, ...data};

    // Save partial progress to database
    if (_userId != null) {
      _repository.updatePartialProfile(_userId!, data);
    }
  }

  Future<void> completeOnboarding(String userId) async {
    final profile = FitnessProfile(
      userId: userId,
      name: state['name'] as String?,
      dateOfBirth: state['dateOfBirth'] as DateTime?,
      gender: state['gender'] as String?,
      heightCm: state['heightCm'] as int?,
      currentWeightGrams: state['currentWeightGrams'] as int?,
      goalWeightGrams: state['goalWeightGrams'] as int?,
      fitnessGoal: FitnessGoal.fromValue(state['fitnessGoal'] as String?),
      experienceLevel: ExperienceLevel.fromValue(state['experienceLevel'] as String?),
      activityLevel: ActivityLevel.fromValue(state['activityLevel'] as String?),
      workoutDaysPerWeek: state['workoutDaysPerWeek'] as int?,
      trainingLocation: state['trainingLocation'] as String?,
      equipment: (state['equipment'] as String?)?.split(',').where((e) => e.isNotEmpty).toList(),
      hasCompletedOnboarding: true,
      maintenanceCalories: state['maintenanceCalories'] as int?,
      targetCalories: state['targetCalories'] as int?,
      targetProteinGrams: state['targetProteinGrams'] as int?,
      onboardingCompletedAt: DateTime.now(),
    );

    await _repository.saveFitnessProfile(profile);
  }
}

final onboardingStateProvider =
    NotifierProvider<OnboardingStateNotifier, Map<String, dynamic>>(() {
  return OnboardingStateNotifier();
});

// Fitness profile provider
final fitnessProfileProvider = FutureProvider<FitnessProfile?>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  final userId = ref.watch(authRepositoryProvider).currentUser?.uid;

  if (userId == null) return null;

  return repository.getFitnessProfile(userId);
});

// Recommended plan provider
final recommendedPlanProvider = FutureProvider((ref) async {
  final service = ref.watch(fitnessRecommendationServiceProvider);
  final state = ref.watch(onboardingStateProvider);
  final userId = ref.watch(authRepositoryProvider).currentUser?.uid;

  if (userId == null) {
    throw Exception('User not authenticated');
  }

  // Build profile from current state
  final profile = FitnessProfile(
    userId: userId,
    name: state['name'] as String?,
    dateOfBirth: state['dateOfBirth'] as DateTime?,
    gender: state['gender'] as String?,
    heightCm: state['heightCm'] as int?,
    currentWeightGrams: state['currentWeightGrams'] as int?,
    goalWeightGrams: state['goalWeightGrams'] as int?,
    fitnessGoal: FitnessGoal.fromValue(state['fitnessGoal'] as String?),
    experienceLevel: ExperienceLevel.fromValue(state['experienceLevel'] as String?),
    activityLevel: ActivityLevel.fromValue(state['activityLevel'] as String?),
    workoutDaysPerWeek: state['workoutDaysPerWeek'] as int?,
    trainingLocation: state['trainingLocation'] as String?,
    equipment: (state['equipment'] as String?)?.split(',').where((e) => e.isNotEmpty).toList(),
  );

  final recommendation = service.calculateRecommendations(profile);

  // Update state with calculated values
  ref.read(onboardingStateProvider.notifier).updateData({
    'maintenanceCalories': recommendation.maintenanceCalories,
    'targetCalories': recommendation.targetCalories,
    'targetProteinGrams': recommendation.targetProteinGrams,
  });

  return recommendation;
});

// Has completed onboarding check (auto-disposes and invalidates on user change)
final hasCompletedOnboardingProvider = FutureProvider.autoDispose<bool>((ref) async {
  final repository = ref.watch(onboardingRepositoryProvider);
  final userId = ref.watch(authRepositoryProvider).currentUser?.uid;

  if (userId == null) return false;

  return repository.hasCompletedOnboarding(userId);
});
