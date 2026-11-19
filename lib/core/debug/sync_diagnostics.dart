import '../../../features/sync/data/sync_coordinator.dart';

/// Diagnostic utility for analyzing sync queue state.
class SyncDiagnostics {
  final SyncCoordinator coordinator;

  SyncDiagnostics(this.coordinator);

  Future<Map<String, dynamic>> analyzeSyncQueue() async {
    final operations = await coordinator.getAllOperations();

    final byStatus = <String, int>{};
    final byRetryCount = <int, int>{};
    final errorSamples = <String, int>{};
    final maxRetryOps = <Map<String, dynamic>>[];

    for (final op in operations) {
      // Count by status
      byStatus[op.status.name] = (byStatus[op.status.name] ?? 0) + 1;

      // Count by retry
      byRetryCount[op.retryCount] = (byRetryCount[op.retryCount] ?? 0) + 1;

      // Sample errors
      if (op.error != null) {
        final errorKey = op.error!.split('\n').first.substring(0, op.error!.length > 100 ? 100 : op.error!.length);
        errorSamples[errorKey] = (errorSamples[errorKey] ?? 0) + 1;
      }

      // Track max-retry operations
      if (op.retryCount >= 5) {
        maxRetryOps.add({
          'id': op.id,
          'collection': op.collection,
          'recordId': op.recordId,
          'retryCount': op.retryCount,
          'status': op.status.name,
          'error': op.error?.substring(0, op.error!.length > 200 ? 200 : op.error!.length),
          'createdAt': op.createdAt.toIso8601String(),
          'attemptedAt': op.attemptedAt?.toIso8601String(),
        });
      }
    }

    return {
      'total': operations.length,
      'byStatus': byStatus,
      'byRetryCount': byRetryCount,
      'errorSamples': errorSamples,
      'maxRetryOperations': maxRetryOps,
      'pendingCount': await coordinator.getPendingCount(),
      'online': await coordinator.isOnline(),
    };
  }

  String formatReport(Map<String, dynamic> analysis) {
    final buffer = StringBuffer();
    buffer.writeln('=== Sync Queue Diagnostic Report ===');
    buffer.writeln('Total operations: ${analysis['total']}');
    buffer.writeln('Pending count (pending + failed): ${analysis['pendingCount']}');
    buffer.writeln('Online: ${analysis['online']}');
    buffer.writeln('');

    buffer.writeln('Status breakdown:');
    for (final entry in (analysis['byStatus'] as Map).entries) {
      buffer.writeln('  ${entry.key}: ${entry.value}');
    }
    buffer.writeln('');

    buffer.writeln('Retry count distribution:');
    for (final entry in (analysis['byRetryCount'] as Map).entries) {
      buffer.writeln('  ${entry.key} retries: ${entry.value}');
    }
    buffer.writeln('');

    buffer.writeln('Error samples:');
    for (final entry in (analysis['errorSamples'] as Map).entries) {
      buffer.writeln('  "${entry.key}": ${entry.value} ops');
    }
    buffer.writeln('');

    final maxRetry = analysis['maxRetryOperations'] as List;
    buffer.writeln('Operations at max retry (≥5):');
    if (maxRetry.isEmpty) {
      buffer.writeln('  None');
    } else {
      for (final op in maxRetry.take(5)) {
        buffer.writeln('  ${op['collection']}/${op['recordId']}');
        buffer.writeln('    Status: ${op['status']}, Retries: ${op['retryCount']}');
        buffer.writeln('    Error: ${op['error'] ?? 'none'}');
      }
      if (maxRetry.length > 5) {
        buffer.writeln('  ... and ${maxRetry.length - 5} more');
      }
    }

    return buffer.toString();
  }
}
