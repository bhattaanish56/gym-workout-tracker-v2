import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../providers/migration_providers.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../../sync/presentation/providers/sync_providers.dart' as sync;
import '../../../onboarding/presentation/providers/onboarding_providers.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../../../dev/seed_demo_data.dart';
import '../../../../dev/demo_data_backfill.dart';
import '../../../../core/debug/sync_diagnostics.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final fitnessProfileAsync = ref.watch(fitnessProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage:
                      user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                  child: user?.photoUrl == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: theme.colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? 'User',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (user?.email != null) ...[
                const SizedBox(height: 4),
                Text(
                  user!.email!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (user?.isGuest ?? false) ...[
                const SizedBox(height: 4),
                Text(
                  'Guest Account',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Account Type'),
                      trailing: Text(
                        user?.isGuest ?? false ? 'Guest' : 'Registered',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.fingerprint),
                      title: const Text('User ID'),
                      subtitle: Text(
                        user?.uid ?? 'Not available',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Fitness Goals & Nutrition Card
              fitnessProfileAsync.when(
                data: (profile) {
                  if (profile != null && profile.hasCompletedOnboarding) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.fitness_center),
                            title: const Text('Fitness Goals & Nutrition'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/fitness-settings'),
                          ),
                          if (profile.fitnessGoal != null ||
                              profile.activityLevel != null ||
                              profile.targetCalories != null) ...[
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (profile.fitnessGoal != null)
                                    _InfoRow(
                                      label: 'Goal',
                                      value: profile.fitnessGoal!.label,
                                    ),
                                  if (profile.activityLevel != null)
                                    _InfoRow(
                                      label: 'Activity',
                                      value: profile.activityLevel!.label,
                                    ),
                                  if (profile.targetCalories != null)
                                    _InfoRow(
                                      label: 'Target Calories',
                                      value: '${profile.targetCalories} kcal/day',
                                    ),
                                  if (profile.targetProteinGrams != null)
                                    _InfoRow(
                                      label: 'Target Protein',
                                      value: '${profile.targetProteinGrams}g/day',
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),
              if (kDebugMode)
                OutlinedButton.icon(
                  onPressed: () => _handleSeedDemoData(context, ref),
                  icon: const Icon(Icons.dataset),
                  label: const Text('Seed Demo Data'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              if (kDebugMode && !(user?.isGuest ?? true))
                const SizedBox(height: 12),
              if (kDebugMode && !(user?.isGuest ?? true))
                OutlinedButton.icon(
                  onPressed: () => _handleBackfillDemoData(context, ref),
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Backfill Demo Data to Cloud'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              if (kDebugMode && !(user?.isGuest ?? true))
                const SizedBox(height: 12),
              if (kDebugMode && !(user?.isGuest ?? true))
                OutlinedButton.icon(
                  onPressed: () => _handleDiagnoseSyncQueue(context, ref),
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Diagnose Sync Queue'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              if (kDebugMode && !(user?.isGuest ?? true))
                const SizedBox(height: 12),
              if (kDebugMode && !(user?.isGuest ?? true))
                OutlinedButton.icon(
                  onPressed: () => _handleManualSync(context, ref),
                  icon: const Icon(Icons.sync),
                  label: const Text('Trigger Manual Sync'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              if (kDebugMode)
                const SizedBox(height: 12),
              if (!(user?.isGuest ?? true))
                OutlinedButton.icon(
                  onPressed: () => _handleRestoreCloudData(context, ref),
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Restore Cloud Data'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              if (!(user?.isGuest ?? true))
                const SizedBox(height: 12),
              if (user?.isGuest ?? false)
                FilledButton.icon(
                  onPressed: () {
                    context.go('/welcome');
                  },
                  icon: const Icon(Icons.upgrade),
                  label: const Text('Upgrade to Full Account'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _handleSignOut(context, ref),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSeedDemoData(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Seeding demo data...'),
          ],
        ),
      ),
    );

    try {
      final db = ref.read(appDatabaseProvider);
      final syncHooks = ref.read(sync.syncHooksProvider);
      final seeder = DemoDataSeeder(db, user.uid, syncHooks: syncHooks);
      final result = await seeder.seed();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog

        if (result.alreadySeeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Already seeded (${result.existingWorkouts} workouts exist)'),
              backgroundColor: Colors.orange.shade700,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Seeded ${result.workoutCount} workouts, ${result.bodyweightCount} bodyweight entries'),
              backgroundColor: Colors.green.shade700,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seeding failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  Future<void> _handleManualSync(BuildContext context, WidgetRef ref) async {
    final coordinator = ref.read(sync.syncCoordinatorProvider);
    if (coordinator == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync coordinator not available'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Syncing... check logs for details'),
          ],
        ),
      ),
    );

    try {
      await coordinator.syncPending();
      final pendingCount = await coordinator.getPendingCount();

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync complete. Pending: $pendingCount'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  Future<void> _handleDiagnoseSyncQueue(BuildContext context, WidgetRef ref) async {
    final coordinator = ref.read(sync.syncCoordinatorProvider);
    if (coordinator == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync coordinator not available'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing sync queue...'),
          ],
        ),
      ),
    );

    try {
      final diagnostics = SyncDiagnostics(coordinator);
      final analysis = await diagnostics.analyzeSyncQueue();
      final report = diagnostics.formatReport(analysis);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sync Queue Diagnostics'),
            content: SingleChildScrollView(
              child: SelectableText(
                report,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Diagnostics failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  Future<void> _handleBackfillDemoData(BuildContext context, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Backfilling demo data to sync queue...'),
          ],
        ),
      ),
    );

    try {
      final db = ref.read(appDatabaseProvider);
      final userId = ref.read(currentUserIdProvider);
      final syncHooks = ref.read(sync.syncHooksProvider);

      final backfill = DemoDataBackfill(db, userId, syncHooks);
      final result = await backfill.backfillToSyncQueue();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog

        if (result.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error!),
              backgroundColor: Colors.red.shade700,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Queued ${result.workoutsQueued} workouts, ${result.bodyweightQueued} bodyweight entries for sync'),
              backgroundColor: Colors.green.shade700,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backfill failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final authRepo = ref.read(authRepositoryProvider);
        await authRepo.signOut();
        if (context.mounted) {
          context.go('/welcome');
        }
      } on AuthException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleRestoreCloudData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Cloud Data'),
        content: const Text(
          'This will download your workout data from the cloud and merge it with local data. This operation is safe and non-destructive.\n\nContinue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Restoring cloud data...'),
          ],
        ),
      ),
    );

    try {
      final restoreService = ref.read(sync.dataRestoreServiceProvider);
      if (restoreService == null) {
        throw Exception('Restore service not available');
      }

      await restoreService.restoreAllData();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cloud data restored successfully'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
