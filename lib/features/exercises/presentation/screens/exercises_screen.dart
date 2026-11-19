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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with logo
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gym Workout Tracker V2',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Track • Train • Progress',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Exercises',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search exercises',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),

            // Muscle filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Muscles'),
                    selected: _muscleFilter == null,
                    onSelected: (_) => setState(() => _muscleFilter = null),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: _muscleFilter == null
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: _muscleFilter == null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Chest'),
                    selected: _muscleFilter == MuscleGroup.chest,
                    onSelected: (_) => setState(() => _muscleFilter = MuscleGroup.chest),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: _muscleFilter == MuscleGroup.chest
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: _muscleFilter == MuscleGroup.chest ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Back'),
                    selected: _muscleFilter == MuscleGroup.back,
                    onSelected: (_) => setState(() => _muscleFilter = MuscleGroup.back),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: _muscleFilter == MuscleGroup.back
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: _muscleFilter == MuscleGroup.back ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Legs'),
                    selected: _muscleFilter == MuscleGroup.legs,
                    onSelected: (_) => setState(() => _muscleFilter = MuscleGroup.legs),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: _muscleFilter == MuscleGroup.legs
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: _muscleFilter == MuscleGroup.legs ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Equipment filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All Equipment'),
                    selected: _equipmentFilter == null,
                    onSelected: (_) => setState(() => _equipmentFilter = null),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: const Color(0xFFFF6B00),
                    labelStyle: TextStyle(
                      color: _equipmentFilter == null
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: _equipmentFilter == null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Barbell'),
                    selected: _equipmentFilter == Equipment.barbell,
                    onSelected: (_) => setState(() => _equipmentFilter = Equipment.barbell),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: const Color(0xFFFF6B00),
                    labelStyle: TextStyle(
                      color: _equipmentFilter == Equipment.barbell
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: _equipmentFilter == Equipment.barbell ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Dumbbell'),
                    selected: _equipmentFilter == Equipment.dumbbell,
                    onSelected: (_) => setState(() => _equipmentFilter = Equipment.dumbbell),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: const Color(0xFFFF6B00),
                    labelStyle: TextStyle(
                      color: _equipmentFilter == Equipment.dumbbell
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: _equipmentFilter == Equipment.dumbbell ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Bodyweight'),
                    selected: _equipmentFilter == Equipment.bodyweight,
                    onSelected: (_) => setState(() => _equipmentFilter = Equipment.bodyweight),
                    backgroundColor: theme.colorScheme.surface,
                    selectedColor: const Color(0xFFFF6B00),
                    labelStyle: TextStyle(
                      color: _equipmentFilter == Equipment.bodyweight
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: _equipmentFilter == Equipment.bodyweight ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
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
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) => const CreateCustomExerciseDialog(),
            );
            ref.invalidate(exerciseSearchProvider);
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.add, size: 24),
          label: const Text(
            'Custom Exercise',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
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
