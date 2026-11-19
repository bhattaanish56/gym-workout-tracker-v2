import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/models/bmi.dart';
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

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryCards(workoutStats, streakData),
            const SizedBox(height: 24),
            _buildBodyWeightSection(bodyWeightHistory, latestWeight),
            const SizedBox(height: 24),
            _buildBMISection(userHeight, latestWeight),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        icon: const Icon(Icons.add),
        label: const Text('Add Weight'),
      ),
    );
  }

  Widget _buildSummaryCards(
    AsyncValue<Map<String, int>> workoutStats,
    AsyncValue<Map<String, int>> streakData,
  ) {
    return workoutStats.when(
      data: (stats) => streakData.when(
        data: (streak) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Workouts',
                    value: stats['total'].toString(),
                    icon: Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'This Week',
                    value: stats['thisWeek'].toString(),
                    icon: Icons.calendar_today,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Current Streak',
                    value: '${streak['current']} days',
                    icon: Icons.local_fire_department,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Total Volume',
                    value:
                        '${(stats['totalVolume']! / 1000).toStringAsFixed(0)} kg',
                    icon: Icons.trending_up,
                  ),
                ),
              ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Body Weight',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            latestWeight.when(
              data: (weight) => weight == null
                  ? const Text('No weight entries yet')
                  : Text(
                      'Latest: ${weight.weightKg.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontSize: 16),
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
            ),
            const SizedBox(height: 16),
            history.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return const Text('No data to display');
                }
                return SizedBox(
                  height: 200,
                  child: _buildBodyWeightChart(entries),
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

  Widget _buildBodyWeightChart(List entries) {
    final spots = <FlSpot>[];
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[entries.length - 1 - i];
      spots.add(FlSpot(i.toDouble(), entry.weightKg));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(0),
                style: const TextStyle(fontSize: 10),
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
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBMISection(
    AsyncValue<int?> heightAsync,
    AsyncValue latestWeight,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI Calculator',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            heightAsync.when(
              data: (height) => Column(
                children: [
                  TextField(
                    controller: _heightController
                      ..text = height?.toString() ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final h = int.tryParse(value);
                      if (h != null && h > 0) {
                        ref.read(progressRepositoryProvider).setHeight(h);
                        ref.invalidate(userHeightProvider);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  latestWeight.when(
                    data: (weight) {
                      if (weight == null || height == null || height <= 0) {
                        return const Text(
                          'Enter height and weight to calculate BMI',
                        );
                      }
                      final bmi = BMI.calculate(
                        heightCm: height,
                        weightGrams: weight.weightGrams,
                      );
                      if (bmi == null) return const Text('Invalid data');
                      return Column(
                        children: [
                          Text(
                            'BMI: ${bmi.value.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Category: ${bmi.category}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (e, st) => Text('Error: $e'),
                  ),
                ],
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
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
