import 'dart:convert';
import 'package:drift/drift.dart';
import '../../sessions/data/database/app_database.dart';
import '../domain/models/sync_operation.dart' as domain;

class SyncQueueRepository {
  final AppDatabase _db;
  final String userId;

  SyncQueueRepository(this._db, this.userId);

  Future<void> enqueueSyncOperation(domain.SyncOperation operation) async {
    await _db.into(_db.syncOperations).insert(
          SyncOperationsCompanion.insert(
            id: operation.id,
            userId: userId,
            collection: operation.collection,
            recordId: operation.recordId,
            operationType: operation.operationType.toJson(),
            data: Value(operation.data != null ? jsonEncode(operation.data) : null),
            status: operation.status.toJson(),
            createdAt: operation.createdAt,
            attemptedAt: Value(operation.attemptedAt),
            retryCount: operation.retryCount,
            error: Value(operation.error),
          ),
        );
  }

  Future<void> updateSyncOperation(domain.SyncOperation operation) async {
    await (_db.update(_db.syncOperations)
          ..where((t) => t.id.equals(operation.id) & t.userId.equals(userId)))
        .write(
      SyncOperationsCompanion(
        status: Value(operation.status.toJson()),
        attemptedAt: Value(operation.attemptedAt),
        retryCount: Value(operation.retryCount),
        error: Value(operation.error),
      ),
    );
  }

  Future<void> deleteSyncOperation(String operationId) async {
    await (_db.delete(_db.syncOperations)
          ..where((t) => t.id.equals(operationId) & t.userId.equals(userId)))
        .go();
  }

  Future<List<domain.SyncOperation>> getPendingOperations() async {
    final rows = await (_db.select(_db.syncOperations)
          ..where((t) =>
              t.userId.equals(userId) &
              (t.status.equals(domain.SyncStatus.pending.toJson()) |
               t.status.equals(domain.SyncStatus.failed.toJson())))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    return rows.map(_mapToSyncOperation).toList();
  }

  Future<List<domain.SyncOperation>> getAllOperations() async {
    final rows = await (_db.select(_db.syncOperations)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    return rows.map(_mapToSyncOperation).toList();
  }

  Future<int> getPendingCount() async {
    return await (_db.syncOperations.count(
      where: (t) =>
          t.userId.equals(userId) &
          (t.status.equals(domain.SyncStatus.pending.toJson()) |
           t.status.equals(domain.SyncStatus.failed.toJson())),
    )).getSingle();
  }

  Future<void> clearCompletedOperations() async {
    await (_db.delete(_db.syncOperations)
          ..where((t) =>
              t.userId.equals(userId) &
              t.status.equals(domain.SyncStatus.completed.toJson())))
        .go();
  }

  domain.SyncOperation _mapToSyncOperation(SyncOperation row) {
    return domain.SyncOperation(
      id: row.id,
      collection: row.collection,
      recordId: row.recordId,
      operationType: domain.SyncOperationType.fromJson(row.operationType),
      data: row.data != null ? jsonDecode(row.data!) as Map<String, dynamic> : null,
      status: domain.SyncStatus.fromJson(row.status),
      createdAt: row.createdAt,
      attemptedAt: row.attemptedAt,
      retryCount: row.retryCount,
      error: row.error,
    );
  }
}
