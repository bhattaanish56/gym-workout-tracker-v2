import 'package:flutter/material.dart';
import '../../domain/services/data_migration_service.dart';

class GuestDataImportDialog extends StatelessWidget {
  final GuestDataStatus status;
  final VoidCallback onUseCloudData;
  final VoidCallback onImportGuestData;
  final VoidCallback onDismiss;

  const GuestDataImportDialog({
    super.key,
    required this.status,
    required this.onUseCloudData,
    required this.onImportGuestData,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Workout Data Found'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You have local workout data from guest mode:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          if (status.sessionCount > 0)
            Text('• ${status.sessionCount} workout sessions'),
          if (status.programCount > 0)
            Text('• ${status.programCount} programs'),
          if (status.exerciseCount > 0)
            Text('• ${status.exerciseCount} custom exercises'),
          if (status.bodyWeightCount > 0)
            Text('• ${status.bodyWeightCount} body weight entries'),
          const SizedBox(height: 16),
          const Text(
            'What would you like to do?',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('Not Now'),
        ),
        TextButton(
          onPressed: onImportGuestData,
          child: const Text('Import Guest Data'),
        ),
        FilledButton(
          onPressed: onUseCloudData,
          child: const Text('Use Cloud Data'),
        ),
      ],
    );
  }
}

class ImportProgressDialog extends StatelessWidget {
  const ImportProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Importing your data...'),
        ],
      ),
    );
  }
}

class ImportResultDialog extends StatelessWidget {
  final ImportResult result;
  final VoidCallback onClose;

  const ImportResultDialog({
    super.key,
    required this.result,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(result.success ? 'Import Complete' : 'Import Partial'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.success)
            const Text('Your guest data has been imported successfully.')
          else
            const Text('Some data could not be imported.'),
          const SizedBox(height: 12),
          Text('Imported: ${result.imported}'),
          if (result.skipped > 0) Text('Skipped (duplicates): ${result.skipped}'),
          if (result.errors.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Errors:',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
            ),
            ...result.errors.take(3).map((e) => Text('• $e', style: const TextStyle(fontSize: 12))),
            if (result.errors.length > 3)
              Text('... and ${result.errors.length - 3} more'),
          ],
        ],
      ),
      actions: [
        FilledButton(
          onPressed: onClose,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
