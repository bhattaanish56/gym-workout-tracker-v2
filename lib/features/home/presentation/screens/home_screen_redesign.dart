import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../../programs/presentation/providers/program_providers.dart';
import '../../../programs/domain/models/program.dart';
import '../../../programs/domain/models/program_day.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../../../../core/presentation/providers/theme_provider.dart';
import '../../domain/models/daily_science.dart';
import '../../domain/providers/today_workout_status_provider.dart';
import '../../domain/models/today_workout_status.dart';
import '../widgets/shimmer_workout_button.dart';
import '../../../sessions/presentation/widgets/early_workout_dialog.dart';
import '../../../../core/domain/value_objects/date_time.dart';

class HomeScreenRedesign extends ConsumerWidget {
  const HomeScreenRedesign({
    super.key,
    required this.onViewWorkouts,
    required this.onBrowseExercises,
    required this.onViewProgress,
    required this.onOpenNutrition,
  });

  final VoidCallback onViewWorkouts;
  final VoidCallback onBrowseExercises;
  final VoidCallback onViewProgress;
  final VoidCallback onOpenNutrition;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 👋';
    if (hour < 17) return 'Good Afternoon 👋';
    return 'Good Evening 👋';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);
    final nextWorkoutAsync = ref.watch(nextPlannedWorkoutProvider);
    final statsAsync = ref.watch(workoutStatsProvider);
    final streakAsync = ref.watch(streakProvider);
    final bodyweightAsync = ref.watch(latestBodyWeightProvider);

    final now = DateTime.now();
    final dateFormat = DateFormat('EEE, MMM d, y');

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(now),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {},
                          tooltip: 'Notifications',
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          onPressed: () {
                            ref.read(themeModeProvider.notifier).toggleTheme();
                          },
                          tooltip: 'Settings',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Today's Training card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildTodaysTrainingCard(
                  context,
                  theme,
                  ref,
                  activeWorkout,
                  activeProgramAsync,
                  nextWorkoutAsync,
                ),
              ),
            ),

            // Stats row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: statsAsync.when(
                  data: (stats) => streakAsync.when(
                    data: (streak) => bodyweightAsync.when(
                      data: (weight) => _buildStatsRow(
                        context,
                        theme,
                        stats,
                        streak,
                        weight,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Daily Science card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildDailyScienceCard(context, theme),
              ),
            ),

            // Training Insight card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildTrainingInsightCard(context, theme),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysTrainingCard(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    ActiveWorkoutState activeWorkout,
    AsyncValue<Program?> activeProgramAsync,
    AsyncValue<dynamic> nextWorkoutAsync,
  ) {
    // Active workout - show resume
    if (activeWorkout.session != null) {
      final dayName = activeWorkout.session!.programSnapshot?['dayName'] as String? ?? 'Workout';
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Today\'s Training',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dayName,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'In Progress',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ShimmerWorkoutButton(
                  onPressed: () => context.go('/workouts'),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_arrow, size: 24),
                      SizedBox(width: 8),
                      Text('Resume Workout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Use new status provider for completed/next separation
    final statusAsync = ref.watch(todayWorkoutStatusProvider);
    return statusAsync.when(
      data: (status) {
        return Column(
          children: [
            // Completed today card
            if (status.completedToday != null)
              _buildCompletedTodayCard(context, theme, status.completedToday!),

            // Spacing
            if (status.completedToday != null && status.nextWorkout != null)
              const SizedBox(height: 12),

            // Next workout card
            if (status.nextWorkout != null)
              _buildNextWorkoutCard(context, theme, ref, status.nextWorkout!),

            // No program fallback
            if (status.nextWorkout == null && status.completedToday == null)
              _buildNoActiveCard(context, theme),
          ],
        );
      },
      loading: () => _buildLoadingCard(context, theme),
      error: (_, __) => _buildNoActiveCard(context, theme),
    );
  }

  Widget _buildNoActiveCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Training',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'No active plan',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a workout plan to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/workouts/programs'),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Browse Plans'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Training',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    ThemeData theme,
    Map<String, int> stats,
    Map<String, int> streak,
    dynamic weight,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_today,
            value: '${stats['thisWeek'] ?? 0}',
            label: 'This Week',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            value: '${streak['current'] ?? 0} days',
            label: 'Streak',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.monitor_weight_outlined,
            value: weight != null ? '${weight.weightKg.toStringAsFixed(1)} kg' : '--',
            label: 'Bodyweight',
          ),
        ),
      ],
    );
  }

  Widget _buildDailyScienceCard(BuildContext context, ThemeData theme) {
    final science = DailyScience.sample;

    return Card(
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.science_outlined, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Science',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${science.category} • ${science.muscleGroup}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              science.insight,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Read more',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: theme.colorScheme.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingInsightCard(BuildContext context, ThemeData theme) {
    // TODO: Replace with actual progress tracking logic
    // For now, show a placeholder that indicates unavailable data
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.analytics_outlined, color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Your Training Insight',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.insights_outlined,
                    size: 32,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete more workouts to see insights',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTodayCard(BuildContext context, ThemeData theme, WorkoutCompletedToday completed) {
    final timeFormat = DateFormat('h:mm a');
    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${completed.dayName} Completed',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Finished at ${timeFormat.format(completed.completedAt.toLocal())}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextWorkoutCard(BuildContext context, ThemeData theme, WidgetRef ref, NextWorkout next) {
    final exercisesAsync = ref.watch(plannedExercisesProvider(next.day.id));

    String subtitle = 'Up Next';
    if (next.isScheduledForFuture) {
      final date = next.scheduledDate!;
      final dayName = DateFormat('EEEE').format(date);
      subtitle = 'Scheduled for $dayName';
    }

    exercisesAsync.whenData((exercises) {
      if (exercises.isNotEmpty) {
        final base = next.isScheduledForFuture ? 'Scheduled • ' : '';
        subtitle = '$base${exercises.length} ${exercises.length == 1 ? 'exercise' : 'exercises'}';
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fitness_center, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Up Next',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_run,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        next.day.name,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ShimmerWorkoutButton(
                onPressed: () async {
                  await _startPlannedWorkout(context, ref, next.program, next.day);
                },
                backgroundColor: next.isScheduledForFuture
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
                foregroundColor: next.isScheduledForFuture
                    ? theme.colorScheme.onSecondary
                    : theme.colorScheme.onPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      next.isScheduledForFuture ? 'Start Early Today' : 'Start Workout',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to start planned workout with early workout dialog if needed
  Future<void> _startPlannedWorkout(
    BuildContext context,
    WidgetRef ref,
    Program program,
    ProgramDay nextDay,
  ) async {
    // For fixed weekly: check if workout is scheduled for future
    LocalDate? scheduledDate;

    if (program.scheduleMode == ScheduleMode.fixedWeekly) {
      // For fixed weekly: check if workout is scheduled for future
      // Simplified check - full implementation would query weekday assignments
      scheduledDate = null; // Use today
    }

    // If scheduled for future, show dialog
    if (scheduledDate != null) {
      final todayLocal = LocalDate.fromDateTime(DateTime.now());
      final isFuture = scheduledDate.year > todayLocal.year ||
          (scheduledDate.year == todayLocal.year && scheduledDate.month > todayLocal.month) ||
          (scheduledDate.year == todayLocal.year &&
           scheduledDate.month == todayLocal.month &&
           scheduledDate.day > todayLocal.day);

      if (isFuture && context.mounted) {
        final choice = await showDialog<EarlyWorkoutChoice>(
          context: context,
          builder: (context) => EarlyWorkoutDialog(workoutName: nextDay.name),
        );

        if (choice == EarlyWorkoutChoice.cancel || choice == null) {
          return;
        }

        if (choice == EarlyWorkoutChoice.additionalWorkout) {
          scheduledDate = null; // Use today instead
        }
        // If completeScheduled, keep the scheduled date
      }
    }

    // Start workout
    await ref.read(activeWorkoutProvider.notifier).startPlannedWorkout(
      program.id.value,
      nextDay.id.value,
      scheduledDate: scheduledDate,
    );

    if (context.mounted) {
      final error = ref.read(activeWorkoutProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
