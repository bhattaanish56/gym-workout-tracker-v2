import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../sessions/data/database/app_database.dart' hide CustomExercise;
import '../../../exercises/domain/models/exercise.dart';
import '../../../exercises/domain/models/custom_exercise.dart';
import '../../../exercises/presentation/providers/exercise_providers.dart';
import '../../domain/models/bmi.dart';
import '../../domain/models/time_range.dart';
import '../providers/progress_providers.dart';
import '../widgets/add_bodyweight_dialog.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutStats = ref.watch(workoutStatsProvider);
    final streakData = ref.watch(streakProvider);
    final bodyWeightHistory = ref.watch(bodyWeightHistoryProvider);
    final latestWeight = ref.watch(latestBodyWeightProvider);
    final userHeight = ref.watch(userHeightProvider);
    final globalTimeRange = ref.watch(globalTimeRangeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Progress',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        final timeRange = TimeRange.values.firstWhere(
                          (e) => e.name == value,
                        );
                        ref.read(globalTimeRangeProvider.notifier).setRange(timeRange);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'week', child: Text('This Week')),
                        const PopupMenuItem(value: 'month', child: Text('This Month')),
                        const PopupMenuItem(value: 'threeMonths', child: Text('3 Months')),
                        const PopupMenuItem(value: 'allTime', child: Text('All Time')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              globalTimeRange.label,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Overview Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildStatsGrid(workoutStats, streakData),
              ),
              const SizedBox(height: 16),

              // Body Weight Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildBodyWeightSection(bodyWeightHistory, latestWeight),
              ),
              const SizedBox(height: 16),

              // Strength Progress placeholder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildStrengthProgressSection(),
              ),
              const SizedBox(height: 16),

              // BMI and Achievements row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildBMISection(userHeight, latestWeight),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRecentAchievements(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => const AddBodyWeightDialog(),
            );
            if (!mounted) return;
            if (result == true) {
              messenger.showSnackBar(const SnackBar(content: Text('Weight added')));
            }
          },
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    AsyncValue<Map<String, int>> workoutStats,
    AsyncValue<Map<String, int>> streakData,
  ) {
    return workoutStats.when(
      data: (stats) => streakData.when(
        data: (streak) => Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.fitness_center,
                value: stats['total'].toString(),
                label: 'Total\nWorkouts',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                icon: Icons.calendar_today,
                value: stats['thisWeek'].toString(),
                label: 'This Week',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department,
                value: '${streak['current']} days',
                label: 'Current\nStreak',
                color: Colors.orange,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Text('Error: $e'),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text('Error: $e'),
    );
  }

  Widget _buildBodyWeightSection(
    AsyncValue<List> history,
    AsyncValue latestWeight,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.monitor_weight_outlined, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Body Weight',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    final timeRange = TimeRange.values.firstWhere(
                      (e) => e.name == value,
                    );
                    ref.read(bodyWeightTimeRangeProvider.notifier).setRange(timeRange);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'week', child: Text('This Week')),
                    const PopupMenuItem(value: 'month', child: Text('This Month')),
                    const PopupMenuItem(value: 'threeMonths', child: Text('3 Months')),
                    const PopupMenuItem(value: 'allTime', child: Text('All Time')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(ref.watch(bodyWeightTimeRangeProvider).label, style: theme.textTheme.bodySmall),
                        const SizedBox(width: 2),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Track your body weight trend over time.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            history.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text('No weight data yet'),
                    ),
                  );
                }

                final first = entries.first.weightKg;
                final last = entries.last.weightKg;
                final change = last - first;
                final changePercent = ((change / first) * 100);

                return Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: _buildBodyWeightChart(entries),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${first.toStringAsFixed(1)} kg',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${last.toStringAsFixed(1)} kg',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Change',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      change < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                                      color: change < 0 ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${change.abs().toStringAsFixed(1)} kg (${changePercent.abs().toStringAsFixed(1)}%)',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: change < 0 ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    latestWeight.when(
                      data: (weight) => weight != null
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${weight.weightKg.toStringAsFixed(1)} kg',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthProgressSection() {
    final theme = Theme.of(context);
    final selectedExerciseId = ref.watch(selectedExerciseIdProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Strength Progress',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                _buildExerciseSelector(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Track your key lifts over time.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (selectedExerciseId == null)
              _buildExerciseSelectorPrompt()
            else
              _buildStrengthCharts(selectedExerciseId),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSelector() {
    final theme = Theme.of(context);
    final selectedExerciseId = ref.watch(selectedExerciseIdProvider);
    final exercisesAsync = ref.watch(exerciseSearchProvider(ExerciseSearchParams()));
    final exercisesWithHistoryAsync = ref.watch(exercisesWithHistoryProvider);

    return exercisesAsync.when(
      data: (allExercises) {
        return exercisesWithHistoryAsync.when(
          data: (exerciseIdsWithHistory) {
            if (exerciseIdsWithHistory.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'No exercises with data yet',
                  style: theme.textTheme.bodySmall,
                ),
              );
            }

            // Filter exercises to only those with history
            final exercisesWithData = allExercises.where((exercise) {
              final id = exercise is Exercise ? exercise.id : (exercise as CustomExercise).id.value;
              return exerciseIdsWithHistory.contains(id);
            }).toList();

            // Set default to bench press if it has history, otherwise first exercise
            if (selectedExerciseId == null || !exerciseIdsWithHistory.contains(selectedExerciseId)) {
              final defaultId = exerciseIdsWithHistory.contains('ex_bench_press_barbell')
                  ? 'ex_bench_press_barbell'
                  : exerciseIdsWithHistory.first;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(selectedExerciseIdProvider.notifier).setExercise(defaultId);
              });
            }

            String? selectedName;
            if (selectedExerciseId != null) {
              final match = exercisesWithData
                  .where((e) {
                    final id = e is Exercise ? e.id : (e as CustomExercise).id.value;
                    return id == selectedExerciseId;
                  })
                  .firstOrNull;
              if (match != null) {
                selectedName = match is Exercise ? match.canonicalName : (match as CustomExercise).name;
              }
            }

            return PopupMenuButton<String>(
              onSelected: (exerciseId) {
                ref.read(selectedExerciseIdProvider.notifier).setExercise(exerciseId);
              },
              itemBuilder: (context) => exercisesWithData.map((exercise) {
                final id = exercise is Exercise ? exercise.id : (exercise as CustomExercise).id.value;
                final name = exercise is Exercise ? exercise.canonicalName : (exercise as CustomExercise).name;
                return PopupMenuItem(value: id, child: Text(name));
              }).toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedName ?? 'Select Exercise',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_drop_down, size: 16),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox(width: 100, height: 24, child: LinearProgressIndicator()),
          error: (e, st) => const Text('Error'),
        );
      },
      loading: () => const SizedBox(width: 100, height: 24, child: LinearProgressIndicator()),
      error: (e, st) => const Text('Error'),
    );
  }

  Widget _buildExerciseSelectorPrompt() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(
              Icons.insights_outlined,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Select an exercise to see progress',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthCharts(String exerciseId) {
    final progressAsync = ref.watch(exerciseProgressProvider(ExerciseId(exerciseId)));

    return progressAsync.when(
      data: (data) {
        final history = data['history'] as List<Map<String, dynamic>>;
        if (history.isEmpty) {
          return _buildEmptyStrengthState();
        }

        final heaviest = data['heaviest'] as int?;
        final oneRepMax = data['oneRepMax'] as double?;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStrengthStat(
                    'Heaviest Lift',
                    heaviest != null ? '${(heaviest / 1000).toStringAsFixed(1)} kg' : '--',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStrengthStat(
                    'Est. 1RM',
                    oneRepMax != null ? '${oneRepMax.toStringAsFixed(1)} kg' : '--',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: _buildStrengthChart(history),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text('Error: $e'),
    );
  }

  Widget _buildEmptyStrengthState() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'No data for this exercise yet',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthStat(String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthChart(List<Map<String, dynamic>> history) {
    final theme = Theme.of(context);
    final spots = <FlSpot>[];

    // Get last 10 workouts with this exercise
    final recentHistory = history.take(10).toList().reversed.toList();

    for (int i = 0; i < recentHistory.length; i++) {
      final set = recentHistory[i]['set'] as PerformedSet;
      if (set.completed && set.loadGrams != null && set.reps != null && set.reps! > 0) {
        final weightKg = set.loadGrams! / 1000;
        spots.add(FlSpot(i.toDouble(), weightKg));
      }
    }

    if (spots.isEmpty) {
      return const Center(child: Text('No completed sets with weight'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${value.toInt()}kg',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAchievements() {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recent Achievements',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your latest milestones and highlights.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),
            _buildAchievementItem(
              icon: Icons.calendar_today,
              title: '4 workouts this week',
              subtitle: 'Great consistency! Keep it up!',
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            _buildAchievementItem(
              icon: Icons.emoji_events,
              title: 'New PR: Incline DB Press',
              subtitle: '30 kg × 10 (previous: 27.5 kg × 10)',
              color: Colors.amber.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBodyWeightChart(List entries) {
    final theme = Theme.of(context);
    final spots = <FlSpot>[];
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      spots.add(FlSpot(i.toDouble(), entry.weightKg));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  value.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMISection(
    AsyncValue<int?> heightAsync,
    AsyncValue latestWeight,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'BMI',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Assess your body weight status.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),
            heightAsync.when(
              data: (height) => latestWeight.when(
                data: (weight) {
                  if (weight == null || height == null || height <= 0) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Height', style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      height != null ? '$height cm' : '-- cm',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Weight', style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('-- kg', style: theme.textTheme.bodyLarge),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  final bmi = BMI.calculate(
                    heightCm: height,
                    weightGrams: weight.weightGrams,
                  );
                  if (bmi == null) {
                    return const Text('Invalid data');
                  }

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Height', style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                )),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('$height cm', style: theme.textTheme.bodyLarge),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weight', style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                )),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${weight.weightKg.toStringAsFixed(1)} kg',
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('BMI', style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                )),
                                const SizedBox(height: 4),
                                Text(
                                  bmi.value.toStringAsFixed(1),
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Healthy range',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '(18.5 – 24.9)',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, st) => Text('Error: $e'),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
