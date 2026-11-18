import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/custom_exercise.dart';
import '../../domain/models/exercise.dart';
import '../providers/exercise_providers.dart';

class ExercisePickerDialog extends ConsumerStatefulWidget {
  final Function(String name, String? equipment, String? primaryMuscle)
  onExerciseSelected;

  const ExercisePickerDialog({super.key, required this.onExerciseSelected});

  @override
  ConsumerState<ExercisePickerDialog> createState() =>
      _ExercisePickerDialogState();
}

class _ExercisePickerDialogState extends ConsumerState<ExercisePickerDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final searchParams = ExerciseSearchParams(
      query: _searchQuery.isEmpty ? null : _searchQuery,
    );
    final exercisesAsync = ref.watch(exerciseSearchProvider(searchParams));

    return Dialog(
      backgroundColor: const Color(0xFF1C1E23),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Select Exercise',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Search exercises',
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
                autofocus: true,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: exercisesAsync.when(
                data: (exercises) {
                  if (exercises.isEmpty) {
                    return const Center(
                      child: Text(
                        'No exercises found',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      final name = exercise is Exercise
                          ? exercise.canonicalName
                          : (exercise as CustomExercise).name;
                      final equipment = exercise is Exercise
                          ? exercise.equipment.label
                          : (exercise as CustomExercise).equipment.label;
                      final muscle = exercise is Exercise
                          ? exercise.primaryMuscle.label
                          : (exercise as CustomExercise).primaryMuscle.label;

                      return Card(
                        color: const Color(0xFF101114),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            widget.onExerciseSelected(name, equipment, muscle);
                            Navigator.of(context).pop();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$equipment • $muscle',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    'Error: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
