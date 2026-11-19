import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_providers.dart';

class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncStatusProvider);

    return syncStatus.when(
      data: (status) {
        if (status.pendingCount == 0 && status.isOnline) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIcon(status),
                size: 16,
                color: _getColor(status, context),
              ),
              const SizedBox(width: 4),
              Text(
                status.statusText,
                style: TextStyle(
                  fontSize: 12,
                  color: _getColor(status, context),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  IconData _getIcon(SyncStatusData status) {
    if (!status.isOnline) return Icons.cloud_off;
    if (status.isSyncing) return Icons.sync;
    if (status.pendingCount > 0) return Icons.cloud_upload;
    return Icons.cloud_done;
  }

  Color _getColor(SyncStatusData status, BuildContext context) {
    if (!status.isOnline) return Colors.grey;
    if (status.isSyncing) return Colors.blue;
    if (status.pendingCount > 0) return Colors.orange;
    return Colors.green;
  }
}
