import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../../programs/presentation/providers/program_providers.dart';
import '../../../programs/domain/models/program.dart';
import '../../../progress/presentation/providers/progress_providers.dart';
import '../../../../core/presentation/providers/theme_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
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
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);
    final nextWorkoutAsync = ref.watch(nextPlannedWorkoutProvider);
    final historyAsync = ref.watch(workoutHistoryProvider);
    final statsAsync = ref.watch(workoutStatsProvider);
    final streakAsync = ref.watch(streakProvider);
    final bodyweightAsync = ref.watch(latestBodyWeightProvider);

    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d, y');

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                    Consumer(
                      builder: (context, ref, _) => IconButton(
                        icon: const Icon(Icons.brightness_6),
                        onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                        tooltip: 'Toggle theme',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main action card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildMainActionCard(
                  context,
                  theme,
                  activeWorkout,
                  activeProgramAsync,
                  nextWorkoutAsync,
                ),
              ),
            ),

            // Stats grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: statsAsync.when(
                  data: (stats) => streakAsync.when(
                    data: (streak) => _buildStatsGrid(context, theme, stats, streak),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),

            // Recent workout
            SliverToBoxAdapter(
              child: historyAsync.when(
                data: (sessions) {
                  if (sessions.isEmpty) return const SizedBox.shrink();
                  final recent = sessions.first;
                  final workoutTitle = recent.programSnapshot?['dayName'] as String? ?? 'Workout';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.fitness_center,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(
                          workoutTitle,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${recent.workoutDate.year}-${recent.workoutDate.month.toString().padLeft(2, '0')}-${recent.workoutDate.day.toString().padLeft(2, '0')}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/workouts/history/${recent.id.value}'),
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Latest bodyweight
            SliverToBoxAdapter(
              child: bodyweightAsync.when(
                data: (entry) {
                  if (entry == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.monitor_weight_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        title: const Text(
                          'Latest Weight',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${entry.measuredDate.year}-${entry.measuredDate.month.toString().padLeft(2, '0')}-${entry.measuredDate.day.toString().padLeft(2, '0')}',
                        ),
                        trailing: Text(
                          '${entry.weightKg.toStringAsFixed(1)} kg',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Quick links
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Quick Links',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('My Plans'),
                      onTap: () => context.push('/workouts/programs'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.list),
                      title: const Text('Exercises'),
                      onTap: onBrowseExercises,
                    ),
                    ListTile(
                      leading: const Icon(Icons.trending_up),
                      title: const Text('Progress'),
                      onTap: onViewProgress,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActionCard(
    BuildContext context,
    ThemeData theme,
    ActiveWorkoutState activeWorkout,
    AsyncValue<Program?> activeProgramAsync,
    AsyncValue<dynamic> nextWorkoutAsync,
  ) {
    // Active workout - highest priority
    if (activeWorkout.session != null) {
      return Card(
        child: InkWell(
          onTap: () => context.go('/workouts'),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.play_circle_filled, color: theme.colorScheme.primary, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resume Workout',
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            activeWorkout.session!.programSnapshot?['dayName'] as String? ?? 'In Progress',
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
              ],
            ),
          ),
        ),
      );
    }

    // Active program - show today's workout or next planned
    return activeProgramAsync.when(
      data: (program) {
        if (program != null) {
          return nextWorkoutAsync.when(
            data: (nextDay) {
              final isRestDay = nextDay == null;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isRestDay ? Icons.hotel : Icons.fitness_center,
                            color: theme.colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isRestDay ? 'Rest Day' : 'Today\'s Workout',
                                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  isRestDay ? 'Recovery day' : nextDay.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (!isRestDay) ...[
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => context.go('/workouts'),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start Workout'),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
            loading: () => const Card(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
            error: (_, __) => _buildNoActiveCard(context, theme),
          );
        }
        return _buildNoActiveCard(context, theme);
      },
      loading: () => const Card(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
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
            Text(
              'Ready to Train?',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a workout plan or start a freestyle session',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => context.push('/workouts/programs'),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Choose Plan'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.go('/workouts'),
                  icon: const Icon(Icons.add),
                  label: const Text('Start Freestyle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    ThemeData theme,
    Map<String, int> stats,
    Map<String, int> streak,
  ) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    '${stats['thisWeek'] ?? 0}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This Week',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_fire_department, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${streak['current'] ?? 0}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Day Streak',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
