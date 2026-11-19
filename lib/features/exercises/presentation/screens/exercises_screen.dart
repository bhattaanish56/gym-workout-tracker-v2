import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/custom_exercise.dart';
import '../../domain/models/equipment.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/muscle_group.dart';
import '../providers/exercise_providers.dart';
import '../widgets/create_custom_exercise_dialog.dart';

class ExercisesScreen extends ConsumerStatefulWidget {
  const ExercisesScreen({super.key});

  @override
  ConsumerState<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends ConsumerState<ExercisesScreen> {
  String _searchQuery = '';
  MuscleGroup? _muscleFilter;
  Equipment? _equipmentFilter;

  @override
  Widget build(BuildContext context) {
    final searchParams = ExerciseSearchParams(
      query: _searchQuery.isEmpty ? null : _searchQuery,
      muscleFilter: _muscleFilter,
      equipmentFilter: _equipmentFilter,
    );
    final exercisesAsync = ref.watch(exerciseSearchProvider(searchParams));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exercises',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search exercises',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All Muscles'),
                    selected: _muscleFilter == null,
                    onSelected: (_) => setState(() => _muscleFilter = null),
                  ),
                  const SizedBox(width: 8),
                  ...MuscleGroup.values.map((muscle) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(muscle.label),
                        selected: _muscleFilter == muscle,
                        onSelected: (_) =>
                            setState(() => _muscleFilter = muscle),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All Equipment'),
                    selected: _equipmentFilter == null,
                    onSelected: (_) => setState(() => _equipmentFilter = null),
                  ),
                  const SizedBox(width: 8),
                  ...Equipment.values.map((equip) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(equip.label),
                        selected: _equipmentFilter == equip,
                        onSelected: (_) =>
                            setState(() => _equipmentFilter = equip),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: exercisesAsync.when(
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No exercises found',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Try adjusting your filters',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return _ExerciseCard(exercise: exercise);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    'Error: $err',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const CreateCustomExerciseDialog(),
          );
          ref.invalidate(exerciseSearchProvider);
        },
        icon: const Icon(Icons.add),
        label: const Text('Custom Exercise'),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final dynamic exercise;

  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final name = exercise is Exercise
        ? exercise.canonicalName
        : (exercise as CustomExercise).name;
    final equipment = exercise is Exercise
        ? exercise.equipment
        : (exercise as CustomExercise).equipment;
    final muscle = exercise is Exercise
        ? exercise.primaryMuscle
        : (exercise as CustomExercise).primaryMuscle;
    final id = exercise is Exercise
        ? exercise.id
        : (exercise as CustomExercise).id.value;

    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/exercises/$id', extra: exercise),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getEquipmentIcon(equipment),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${equipment.label} • ${muscle.label}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEquipmentIcon(Equipment equipment) {
    switch (equipment) {
      case Equipment.barbell:
        return Icons.fitness_center;
      case Equipment.dumbbell:
        return Icons.fitness_center;
      case Equipment.bodyweight:
        return Icons.accessibility_new;
      case Equipment.machine:
        return Icons.settings;
      case Equipment.cable:
        return Icons.linear_scale;
      case Equipment.kettlebell:
        return Icons.sports_gymnastics;
      case Equipment.band:
        return Icons.drag_handle;
      case Equipment.other:
        return Icons.more_horiz;
    }
  }
}
