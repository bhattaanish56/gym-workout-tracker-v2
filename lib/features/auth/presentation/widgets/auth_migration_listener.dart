import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../providers/migration_providers.dart';
import '../../domain/services/data_migration_service.dart';
import '../widgets/guest_data_import_dialog.dart';

/// Monitors auth state and triggers guest data import dialog when needed.
class AuthMigrationListener extends ConsumerStatefulWidget {
  final Widget child;

  const AuthMigrationListener({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AuthMigrationListener> createState() => _AuthMigrationListenerState();
}

class _AuthMigrationListenerState extends ConsumerState<AuthMigrationListener> {
  String? _lastCheckedUserId;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final migrationState = ref.watch(migrationStateProvider);

    // Check for guest data when user logs in (not anonymous)
    if (user != null && !user.isAnonymous && user.uid != _lastCheckedUserId) {
      _lastCheckedUserId = user.uid;
      // Trigger check on next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(migrationStateProvider.notifier).checkForGuestData(user.uid);
      });
    }

    // Show dialog when prompt needed
    if (migrationState.status == MigrationStatus.promptNeeded &&
        migrationState.guestData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showImportDialog(context, migrationState.guestData!);
      });
    }

    // Show import progress
    if (migrationState.status == MigrationStatus.importing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showProgressDialog(context);
      });
    }

    // Show result
    if (migrationState.status == MigrationStatus.completed &&
        migrationState.importResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(); // Close progress dialog
        _showResultDialog(context, migrationState.importResult!);
      });
    }

    return widget.child;
  }

  void _showImportDialog(BuildContext context, GuestDataStatus status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GuestDataImportDialog(
        status: status,
        onUseCloudData: () {
          Navigator.of(context).pop();
          ref.read(migrationStateProvider.notifier).useCloudData();
        },
        onImportGuestData: () {
          Navigator.of(context).pop();
          final user = ref.read(currentUserProvider);
          if (user != null) {
            ref.read(migrationStateProvider.notifier).importGuestData(user.uid);
          }
        },
        onDismiss: () {
          Navigator.of(context).pop();
          ref.read(migrationStateProvider.notifier).dismissPrompt();
        },
      ),
    );
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ImportProgressDialog(),
    );
  }

  void _showResultDialog(BuildContext context, ImportResult result) {
    showDialog(
      context: context,
      builder: (context) => ImportResultDialog(
        result: result,
        onClose: () {
          Navigator.of(context).pop();
          ref.read(migrationStateProvider.notifier).reset();
        },
      ),
    );
  }
}
