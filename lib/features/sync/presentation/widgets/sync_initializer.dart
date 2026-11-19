import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/sync_providers.dart';

class SyncInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const SyncInitializer({super.key, required this.child});

  @override
  ConsumerState<SyncInitializer> createState() => _SyncInitializerState();
}

class _SyncInitializerState extends ConsumerState<SyncInitializer> {
  @override
  void initState() {
    super.initState();

    // Delay initialization to after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSync();
    });
  }

  void _initializeSync() {
    ref.listenManual(currentUserProvider, (previous, next) {
      final coordinator = ref.read(syncCoordinatorProvider);

      if (next != null && !next.isGuest && coordinator != null) {
        // Start auto-sync for authenticated non-guest users
        coordinator.startAutoSync();

        // Trigger initial sync
        coordinator.syncPending();
      } else if (coordinator != null) {
        // Stop sync for guest or signed-out users
        coordinator.stopAutoSync();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
