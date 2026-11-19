import '../../sync/data/sync_coordinator.dart';
import '../../sync/domain/models/sync_operation.dart';

/// Helper to enqueue sync operations after successful local writes
class SyncHooks {
  final SyncCoordinator? _coordinator;

  SyncHooks(this._coordinator);

  Future<void> onWorkoutCreated(String workoutId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'workouts',
      recordId: workoutId,
      operationType: SyncOperationType.create,
      data: data,
    );
  }

  Future<void> onWorkoutUpdated(String workoutId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'workouts',
      recordId: workoutId,
      operationType: SyncOperationType.update,
      data: data,
    );
  }

  Future<void> onProgramCreated(String programId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'programs',
      recordId: programId,
      operationType: SyncOperationType.create,
      data: data,
    );
  }

  Future<void> onProgramUpdated(String programId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'programs',
      recordId: programId,
      operationType: SyncOperationType.update,
      data: data,
    );
  }

  Future<void> onCustomExerciseCreated(String exerciseId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'custom_exercises',
      recordId: exerciseId,
      operationType: SyncOperationType.create,
      data: data,
    );
  }

  Future<void> onBodyWeightCreated(String entryId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'bodyweight',
      recordId: entryId,
      operationType: SyncOperationType.create,
      data: data,
    );
  }

  Future<void> onBodyWeightUpdated(String entryId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'bodyweight',
      recordId: entryId,
      operationType: SyncOperationType.update,
      data: data,
    );
  }

  // Nutrition sync hooks
  Future<void> onMealEntryCreated(String mealId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'meal_entries',
      recordId: mealId,
      operationType: SyncOperationType.create,
      data: data,
    );
  }

  Future<void> onMealEntryDeleted(String mealId) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'meal_entries',
      recordId: mealId,
      operationType: SyncOperationType.delete,
      data: null,
    );
  }

  Future<void> onCustomFoodCreated(String foodId, Map<String, dynamic> data) async {
    if (_coordinator == null) return;

    await _coordinator.enqueueOperation(
      collection: 'custom_foods',
      recordId: foodId,
      operationType: SyncOperationType.create,
      data: data,
    );
  }
}
