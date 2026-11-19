import 'package:drift/drift.dart';
import '../../../sessions/data/database/app_database.dart';
import '../../domain/models/fitness_profile.dart';
import '../../domain/models/fitness_goal.dart';
import '../../domain/models/experience_level.dart';
import '../../domain/models/activity_level.dart';
import '../../domain/repositories/onboarding_repository.dart';

class DriftOnboardingRepository implements OnboardingRepository {
  final AppDatabase _db;

  DriftOnboardingRepository(this._db);

  @override
  Future<FitnessProfile?> getFitnessProfile(String userId) async {
    final row = await (_db.select(_db.userProfile)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();

    if (row == null) return null;

    return _rowToProfile(row);
  }

  @override
  Future<void> saveFitnessProfile(FitnessProfile profile) async {
    await _db.into(_db.userProfile).insertOnConflictUpdate(
          UserProfileCompanion.insert(
            userId: profile.userId,
            heightCm: Value(profile.heightCm),
            dateOfBirth: Value(profile.dateOfBirth),
            gender: Value(profile.gender),
            currentWeightGrams: Value(profile.currentWeightGrams),
            goalWeightGrams: Value(profile.goalWeightGrams),
            fitnessGoal: Value(profile.fitnessGoal?.value),
            experienceLevel: Value(profile.experienceLevel?.value),
            activityLevel: Value(profile.activityLevel?.value),
            workoutDaysPerWeek: Value(profile.workoutDaysPerWeek),
            trainingLocation: Value(profile.trainingLocation),
            equipment: Value(profile.equipment.isEmpty ? null : profile.equipment.join(',')),
            hasCompletedOnboarding: Value(profile.hasCompletedOnboarding),
            maintenanceCalories: Value(profile.maintenanceCalories),
            targetCalories: Value(profile.targetCalories),
            targetProteinGrams: Value(profile.targetProteinGrams),
            onboardingCompletedAt: Value(profile.onboardingCompletedAt),
            updatedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<void> updatePartialProfile(String userId, Map<String, dynamic> updates) async {
    final companion = UserProfileCompanion(
      userId: Value(userId),
      heightCm: updates.containsKey('heightCm') ? Value(updates['heightCm'] as int?) : const Value.absent(),
      dateOfBirth: updates.containsKey('dateOfBirth') ? Value(updates['dateOfBirth'] as DateTime?) : const Value.absent(),
      gender: updates.containsKey('gender') ? Value(updates['gender'] as String?) : const Value.absent(),
      currentWeightGrams: updates.containsKey('currentWeightGrams') ? Value(updates['currentWeightGrams'] as int?) : const Value.absent(),
      goalWeightGrams: updates.containsKey('goalWeightGrams') ? Value(updates['goalWeightGrams'] as int?) : const Value.absent(),
      fitnessGoal: updates.containsKey('fitnessGoal') ? Value(updates['fitnessGoal'] as String?) : const Value.absent(),
      experienceLevel: updates.containsKey('experienceLevel') ? Value(updates['experienceLevel'] as String?) : const Value.absent(),
      activityLevel: updates.containsKey('activityLevel') ? Value(updates['activityLevel'] as String?) : const Value.absent(),
      workoutDaysPerWeek: updates.containsKey('workoutDaysPerWeek') ? Value(updates['workoutDaysPerWeek'] as int?) : const Value.absent(),
      trainingLocation: updates.containsKey('trainingLocation') ? Value(updates['trainingLocation'] as String?) : const Value.absent(),
      equipment: updates.containsKey('equipment') ? Value(updates['equipment'] as String?) : const Value.absent(),
      hasCompletedOnboarding: updates.containsKey('hasCompletedOnboarding') ? Value(updates['hasCompletedOnboarding'] as bool) : const Value.absent(),
      maintenanceCalories: updates.containsKey('maintenanceCalories') ? Value(updates['maintenanceCalories'] as int?) : const Value.absent(),
      targetCalories: updates.containsKey('targetCalories') ? Value(updates['targetCalories'] as int?) : const Value.absent(),
      targetProteinGrams: updates.containsKey('targetProteinGrams') ? Value(updates['targetProteinGrams'] as int?) : const Value.absent(),
      onboardingCompletedAt: updates.containsKey('onboardingCompletedAt') ? Value(updates['onboardingCompletedAt'] as DateTime?) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await _db.into(_db.userProfile).insertOnConflictUpdate(companion);
  }

  @override
  Future<bool> hasCompletedOnboarding(String userId) async {
    final row = await (_db.select(_db.userProfile)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();

    return row?.hasCompletedOnboarding ?? false;
  }

  FitnessProfile _rowToProfile(UserProfileData row) {
    return FitnessProfile(
      userId: row.userId,
      heightCm: row.heightCm,
      dateOfBirth: row.dateOfBirth,
      gender: row.gender,
      currentWeightGrams: row.currentWeightGrams,
      goalWeightGrams: row.goalWeightGrams,
      fitnessGoal: FitnessGoal.fromValue(row.fitnessGoal),
      experienceLevel: ExperienceLevel.fromValue(row.experienceLevel),
      activityLevel: ActivityLevel.fromValue(row.activityLevel),
      workoutDaysPerWeek: row.workoutDaysPerWeek,
      trainingLocation: row.trainingLocation,
      equipment: row.equipment?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      hasCompletedOnboarding: row.hasCompletedOnboarding,
      maintenanceCalories: row.maintenanceCalories,
      targetCalories: row.targetCalories,
      targetProteinGrams: row.targetProteinGrams,
      onboardingCompletedAt: row.onboardingCompletedAt,
      updatedAt: row.updatedAt,
    );
  }
}
