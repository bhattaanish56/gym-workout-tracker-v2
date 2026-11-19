import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/drift_progress_repository.dart';
import '../../domain/services/progress_analytics_service.dart';
import '../../domain/models/bodyweight_entry.dart';
import '../../domain/models/time_range.dart';

// Time range state - using NotifierProvider pattern for Riverpod 3
class GlobalTimeRangeNotifier extends Notifier<TimeRange> {
  @override
  TimeRange build() => TimeRange.month;

  void setRange(TimeRange range) {
    state = range;
  }
}

class BodyWeightTimeRangeNotifier extends Notifier<TimeRange> {
  @override
  TimeRange build() => TimeRange.month;

  void setRange(TimeRange range) {
    state = range;
  }
}

class SelectedExerciseIdNotifier extends Notifier<String?> {
  @override
  String? build() => 'ex_bench_press_barbell';

  void setExercise(String? id) {
    state = id;
  }
}

final globalTimeRangeProvider = NotifierProvider<GlobalTimeRangeNotifier, TimeRange>(() {
  return GlobalTimeRangeNotifier();
});

final bodyWeightTimeRangeProvider = NotifierProvider<BodyWeightTimeRangeNotifier, TimeRange>(() {
  return BodyWeightTimeRangeNotifier();
});

final selectedExerciseIdProvider = NotifierProvider<SelectedExerciseIdNotifier, String?>(() {
  return SelectedExerciseIdNotifier();
});

final progressRepositoryProvider = Provider<DriftProgressRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return DriftProgressRepository(db, userId);
});

final progressAnalyticsProvider = Provider<ProgressAnalyticsService>((ref) {
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return ProgressAnalyticsService(db, userId);
});

final bodyWeightHistoryProvider = FutureProvider<List<BodyWeightEntry>>((
  ref,
) async {
  final repo = ref.watch(progressRepositoryProvider);
  final timeRange = ref.watch(bodyWeightTimeRangeProvider);
  final startDate = timeRange.getStartDate();
  return repo.getBodyWeightHistory(limit: 100, startDate: startDate);
});

final latestBodyWeightProvider = FutureProvider<BodyWeightEntry?>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.getLatestBodyWeight();
});

final userHeightProvider = FutureProvider<int?>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return repo.getHeight(user.uid);
});

final workoutStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final analytics = ref.watch(progressAnalyticsProvider);
  final timeRange = ref.watch(globalTimeRangeProvider);
  final startDate = timeRange.getStartDate();

  final total = await analytics.getTotalCompletedWorkouts(startDate: startDate);
  final thisWeek = await analytics.getWorkoutsThisWeek();
  final totalSets = await analytics.getTotalCompletedSets(startDate: startDate);
  final totalVolume = await analytics.getTotalVolume(startDate: startDate);

  return {
    'total': total,
    'thisWeek': thisWeek,
    'totalSets': totalSets,
    'totalVolume': totalVolume,
  };
});

final streakProvider = FutureProvider<Map<String, int>>((ref) async {
  final analytics = ref.watch(progressAnalyticsProvider);
  final current = await analytics.getCurrentStreak();
  final longest = await analytics.getLongestStreak();

  return {'current': current, 'longest': longest};
});

final exerciseProgressProvider =
    FutureProvider.family<Map<String, dynamic>, ExerciseId>((
      ref,
      exerciseId,
    ) async {
      final analytics = ref.watch(progressAnalyticsProvider);
      final heaviest = await analytics.getHeaviestLift(exerciseId);
      final oneRepMax = await analytics.estimateOneRepMax(exerciseId);
      final history = await analytics.getExerciseHistory(exerciseId);

      return {'heaviest': heaviest, 'oneRepMax': oneRepMax, 'history': history};
    });

final exercisesWithHistoryProvider = FutureProvider<List<String>>((ref) async {
  final analytics = ref.watch(progressAnalyticsProvider);
  return analytics.getExerciseIdsWithHistory();
});
