import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/sync_operation.dart';
import 'firestore_sync_service.dart';
import 'sync_queue_repository.dart';

const _uuid = Uuid();

class SyncCoordinator {
  final SyncQueueRepository _queueRepo;
  final FirestoreSyncService _firestoreService;
  final Connectivity _connectivity;

  bool _isSyncing = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicSyncTimer;

  SyncCoordinator(
    this._queueRepo,
    this._firestoreService,
    this._connectivity,
  );

  void startAutoSync() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        syncPending();
      }
    });

    // Periodic sync every 5 minutes
    _periodicSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      syncPending();
    });
  }

  void stopAutoSync() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
  }

  Future<void> enqueueOperation({
    required String collection,
    required String recordId,
    required SyncOperationType operationType,
    Map<String, dynamic>? data,
  }) async {
    final operation = SyncOperation(
      id: _uuid.v4(),
      collection: collection,
      recordId: recordId,
      operationType: operationType,
      data: data,
      status: SyncStatus.pending,
      createdAt: DateTime.now().toUtc(),
    );

    await _queueRepo.enqueueSyncOperation(operation);

    // Try immediate sync if online
    syncPending();
  }

  Future<void> syncPending() async {
    if (_isSyncing) {
      print('[SyncCoordinator] Already syncing, skipping');
      return;
    }

    final connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.every((result) => result == ConnectivityResult.none)) {
      print('[SyncCoordinator] Offline, skipping sync');
      return; // Offline
    }

    _isSyncing = true;
    try {
      final pending = await _queueRepo.getPendingOperations();
      print('[SyncCoordinator] Found ${pending.length} pending operations');

      int processed = 0, skipped = 0, succeeded = 0, failed = 0;

      for (final operation in pending) {
        // Skip if too many retries
        if (operation.retryCount >= 5) {
          print('[SyncCoordinator] Skipping ${operation.collection}/${operation.recordId} (retryCount=${operation.retryCount})');
          skipped++;
          continue;
        }

        try {
          print('[SyncCoordinator] Processing ${operation.collection}/${operation.recordId} (retry ${operation.retryCount})');
          processed++;

          // Mark as in progress
          await _queueRepo.updateSyncOperation(
            operation.copyWith(
              status: SyncStatus.inProgress,
              attemptedAt: DateTime.now().toUtc(),
            ),
          );

          // Execute sync
          await _firestoreService.executeSyncOperation(operation);

          // Mark as completed
          await _queueRepo.updateSyncOperation(
            operation.copyWith(
              status: SyncStatus.completed,
            ),
          );
          print('[SyncCoordinator] ✓ Success ${operation.collection}/${operation.recordId}');
          succeeded++;
        } catch (e) {
          print('[SyncCoordinator] ✗ Failed ${operation.collection}/${operation.recordId}: $e');
          // Mark as failed with retry
          await _queueRepo.updateSyncOperation(
            operation.copyWith(
              status: SyncStatus.failed,
              retryCount: operation.retryCount + 1,
              error: e.toString(),
            ),
          );
          failed++;
        }
      }

      print('[SyncCoordinator] Sync complete: processed=$processed, succeeded=$succeeded, failed=$failed, skipped=$skipped');

      // Clean up old completed operations (older than 7 days)
      await _queueRepo.clearCompletedOperations();
    } finally {
      _isSyncing = false;
    }
  }

  Future<int> getPendingCount() async {
    return await _queueRepo.getPendingCount();
  }

  Future<List<SyncOperation>> getAllOperations() async {
    return await _queueRepo.getAllOperations();
  }

  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  void dispose() {
    stopAutoSync();
  }
}
