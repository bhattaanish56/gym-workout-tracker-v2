import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../exercises/data/bundled_exercises.dart';
import '../../../exercises/domain/models/exercise.dart';
import 'program_builder_state.dart';

class Step4Exercises extends ConsumerStatefulWidget {
  const Step4Exercises({super.key});

  @override
  ConsumerState<Step4Exercises> createState() => _Step4ExercisesState();
}

class _Step4ExercisesState extends ConsumerState<Step4Exercises> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(programBuilderProvider);
    _tabController = TabController(length: state.dayNames.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programBuilderProvider);
    final notifier = ref.read(programBuilderProvider.notifier);

    if (state.dayNames.isEmpty) {
      return Column(
        children: [
          const Expanded(
            child: Center(child: Text('No workout days defined')),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 24),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: notifier.previousStep,
                child: const Text('Back'),
              ),
            ),
          ),
        ],
      );
    }

    if (_tabController.length != state.dayNames.length) {
      _tabController.dispose();
      _tabController = TabController(length: state.dayNames.length, vsync: this);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exercises',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Add exercises to each workout day. You can set target sets, reps, and weight.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: state.dayNames.map((name) => Tab(text: name)).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: state.dayNames.map((dayName) {
              final exercises = state.dayExercises[dayName] ?? [];
              return _DayExercisesList(
                dayName: dayName,
                exercises: exercises,
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: notifier.previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: notifier.nextStep,
                  child: const Text('Next: Review'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayExercisesList extends ConsumerWidget {
  final String dayName;
  final List<TempExercise> exercises;

  const _DayExercisesList({
    required this.dayName,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(programBuilderProvider.notifier);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: () => _showExercisePicker(context, ref, dayName),
            icon: const Icon(Icons.add),
            label: const Text('Add Exercise'),
          ),
        ),
        const SizedBox(height: 16),
        if (exercises.isEmpty)
          Expanded(
            child: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No exercises yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add exercises to this workout day',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ReorderableListView.builder(
              itemCount: exercises.length,
              onReorder: (oldIndex, newIndex) {
                notifier.reorderExercises(dayName, oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final catalogExercise = bundledExercises.firstWhere(
                  (e) => e.id == exercise.exerciseId,
                  orElse: () => throw Exception('Exercise not found'),
                );
                return _ExerciseCard(
                  key: ValueKey('${dayName}_${exercise.exerciseId}_$index'),
                  dayName: dayName,
                  index: index,
                  exercise: exercise,
                  catalogExercise: catalogExercise,
                );
              },
            ),
          ),
      ],
    );
  }

  void _showExercisePicker(BuildContext context, WidgetRef ref, String dayName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (context, scrollController) => _ExercisePicker(
          dayName: dayName,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _ExercisePicker extends ConsumerStatefulWidget {
  final String dayName;
  final ScrollController scrollController;

  const _ExercisePicker({
    required this.dayName,
    required this.scrollController,
  });

  @override
  ConsumerState<_ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends ConsumerState<_ExercisePicker> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(programBuilderProvider.notifier);
    final filtered = bundledExercises.where((e) {
      return e.canonicalName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search exercises',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final exercise = filtered[index];
              return ListTile(
                title: Text(exercise.canonicalName),
                subtitle: Text(exercise.primaryMuscle.name),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () {
                  notifier.addExercise(widget.dayName, exercise.id);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ExerciseCard extends ConsumerStatefulWidget {
  final String dayName;
  final int index;
  final TempExercise exercise;
  final Exercise catalogExercise;

  const _ExerciseCard({
    super.key,
    required this.dayName,
    required this.index,
    required this.exercise,
    required this.catalogExercise,
  });

  @override
  ConsumerState<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends ConsumerState<_ExerciseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(programBuilderProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: ReorderableDragStartListener(
              index: widget.index,
              child: const Icon(Icons.drag_handle),
            ),
            title: Text(widget.catalogExercise.canonicalName),
            subtitle: Text(_subtitle()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => notifier.removeExercise(widget.dayName, widget.index),
                ),
              ],
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Sets',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: widget.exercise.targetSets?.toString() ?? '',
                          ),
                          onChanged: (value) {
                            final sets = int.tryParse(value);
                            notifier.updateExercise(
                              widget.dayName,
                              widget.index,
                              widget.exercise.copyWith(targetSets: sets),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Reps Min',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: widget.exercise.targetRepsMin?.toString() ?? '',
                          ),
                          onChanged: (value) {
                            final reps = int.tryParse(value);
                            notifier.updateExercise(
                              widget.dayName,
                              widget.index,
                              widget.exercise.copyWith(targetRepsMin: reps),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Reps Max',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: widget.exercise.targetRepsMax?.toString() ?? '',
                          ),
                          onChanged: (value) {
                            final reps = int.tryParse(value);
                            notifier.updateExercise(
                              widget.dayName,
                              widget.index,
                              widget.exercise.copyWith(targetRepsMax: reps),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: widget.exercise.targetLoadGrams != null
                                ? (widget.exercise.targetLoadGrams! / 1000).toStringAsFixed(1)
                                : '',
                          ),
                          onChanged: (value) {
                            final kg = double.tryParse(value);
                            notifier.updateExercise(
                              widget.dayName,
                              widget.index,
                              widget.exercise.copyWith(
                                targetLoadGrams: kg != null ? (kg * 1000).round() : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Rest (sec)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: widget.exercise.restSeconds?.toString() ?? '',
                          ),
                          onChanged: (value) {
                            final rest = int.tryParse(value);
                            notifier.updateExercise(
                              widget.dayName,
                              widget.index,
                              widget.exercise.copyWith(restSeconds: rest),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[];
    if (widget.exercise.targetSets != null) {
      parts.add('${widget.exercise.targetSets} sets');
    }
    if (widget.exercise.targetRepsMin != null && widget.exercise.targetRepsMax != null) {
      parts.add('${widget.exercise.targetRepsMin}-${widget.exercise.targetRepsMax} reps');
    } else if (widget.exercise.targetRepsMin != null) {
      parts.add('${widget.exercise.targetRepsMin}+ reps');
    }
    if (widget.exercise.targetLoadGrams != null) {
      parts.add('${(widget.exercise.targetLoadGrams! / 1000).toStringAsFixed(1)} kg');
    }
    return parts.isEmpty ? 'Tap to configure' : parts.join(' • ');
  }
}
