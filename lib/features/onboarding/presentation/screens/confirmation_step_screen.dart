import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../programs/presentation/providers/program_providers.dart';

class ConfirmationStepScreen extends ConsumerWidget {
  final VoidCallback onBack;

  const ConfirmationStepScreen({super.key, required this.onBack});

  Future<void> _acceptAndFinish(BuildContext context, WidgetRef ref) async {
    try {
      final userId = ref.read(authRepositoryProvider).currentUser?.uid;
      if (userId == null) return;

      // Save profile with completion flag
      await ref.read(onboardingStateProvider.notifier).completeOnboarding(userId);

      // Check if active program exists
      final programRepo = ref.read(programRepositoryProvider);
      final activeProgram = await programRepo.getActiveProgram();

      if (context.mounted) {
        if (activeProgram != null) {
          // Show message that current plan is preserved
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Profile saved! Your current plan is preserved. View saved recommendation in Programs.',
              ),
              backgroundColor: Colors.green.shade700,
            ),
          );
        }
        context.go('/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Ready to Start?',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your personalized fitness plan is ready',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'All Set!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Your workout plan and nutrition targets are ready. You can adjust these anytime in settings.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        FilledButton(
          onPressed: () => _acceptAndFinish(context, ref),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Start Training'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onBack,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Go Back'),
        ),
      ],
    );
  }
}
