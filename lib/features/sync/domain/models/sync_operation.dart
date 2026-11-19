enum SyncOperationType {
  create,
  update,
  delete;

  String toJson() => name;
  static SyncOperationType fromJson(String json) => values.byName(json);
}

enum SyncStatus {
  pending,
  inProgress,
  completed,
  failed;

  String toJson() => name;
  static SyncStatus fromJson(String json) => values.byName(json);
}

class SyncOperation {
  final String id;
  final String collection;
  final String recordId;
  final SyncOperationType operationType;
  final Map<String, dynamic>? data;
  final SyncStatus status;
  final DateTime createdAt;
  final DateTime? attemptedAt;
  final int retryCount;
  final String? error;

  const SyncOperation({
    required this.id,
    required this.collection,
    required this.recordId,
    required this.operationType,
    this.data,
    required this.status,
    required this.createdAt,
    this.attemptedAt,
    this.retryCount = 0,
    this.error,
  });

  SyncOperation copyWith({
    SyncStatus? status,
    DateTime? attemptedAt,
    int? retryCount,
    String? error,
  }) {
    return SyncOperation(
      id: id,
      collection: collection,
      recordId: recordId,
      operationType: operationType,
      data: data,
      status: status ?? this.status,
      createdAt: createdAt,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      retryCount: retryCount ?? this.retryCount,
      error: error ?? this.error,
    );
  }
}
