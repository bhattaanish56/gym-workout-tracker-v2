import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/firestore_sync_service.dart';
import '../../data/sync_coordinator.dart';
import '../../data/sync_queue_repository.dart';
import '../../data/data_restore_service.dart';
import '../../domain/models/sync_operation.dart';

final firestoreSyncServiceProvider = Provider<FirestoreSyncService?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.isGuest) return null;

  return FirestoreSyncService(FirebaseFirestore.instance, user.uid);
});

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return SyncQueueRepository(db, userId);
});

final syncCoordinatorProvider = Provider<SyncCoordinator?>((ref) {
  final syncService = ref.watch(firestoreSyncServiceProvider);
  if (syncService == null) return null;

  final queueRepo = ref.watch(syncQueueRepositoryProvider);
  final connectivity = Connectivity();
  final coordinator = SyncCoordinator(queueRepo, syncService, connectivity);

  ref.onDispose(() {
    coordinator.dispose();
  });

  return coordinator;
});

final dataRestoreServiceProvider = Provider<DataRestoreService?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null || user.isGuest) return null;

  final db = ref.watch(databaseProvider);
  return DataRestoreService(db, FirebaseFirestore.instance, user.uid);
});

final syncStatusProvider = StreamProvider<SyncStatusData>((ref) async* {
  final coordinator = ref.watch(syncCoordinatorProvider);

  while (true) {
    final pendingCount = coordinator != null
        ? await coordinator.getPendingCount()
        : 0;
    final isOnline = coordinator != null
        ? await coordinator.isOnline()
        : false;

    yield SyncStatusData(
      pendingCount: pendingCount,
      isOnline: isOnline,
      isSyncing: false, // Would need state tracking in coordinator
    );

    await Future.delayed(const Duration(seconds: 2));
  }
});

class SyncStatusData {
  final int pendingCount;
  final bool isOnline;
  final bool isSyncing;

  const SyncStatusData({
    required this.pendingCount,
    required this.isOnline,
    required this.isSyncing,
  });

  String get statusText {
    if (!isOnline) return 'Offline';
    if (isSyncing) return 'Syncing...';
    if (pendingCount > 0) return 'Pending ($pendingCount)';
    return 'Synced';
  }
}
