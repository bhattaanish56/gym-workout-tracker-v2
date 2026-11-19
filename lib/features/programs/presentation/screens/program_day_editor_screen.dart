import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../shared/widgets/section_page.dart';
import '../../../exercises/presentation/providers/exercise_providers.dart';
import '../../../exercises/presentation/widgets/exercise_picker_dialog.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../domain/models/program_day.dart';
import '../../domain/models/planned_exercise.dart';
import '../providers/program_providers.dart';

class ProgramDayEditorScreen extends ConsumerStatefulWidget {
  final String programId;
  final String dayId;

  const ProgramDayEditorScreen({
    super.key,
    required this.programId,
    required this.dayId,
  });

  @override
  ConsumerState<ProgramDayEditorScreen> createState() =>
      _ProgramDayEditorScreenState();
}

class _ProgramDayEditorScreenState
    extends ConsumerState<ProgramDayEditorScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayId = RecordId(widget.dayId);
    final exercisesAsync = ref.watch(plannedExercisesProvider(dayId));

    return FutureBuilder<ProgramDay?>(
      future: _loadDay(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final day = snapshot.data;
        if (day == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Day Not Found')),
            body: const Center(child: Text('Workout day not found')),
          );
        }

        if (_nameController.text.isEmpty) {
          _nameController.text = day.name;
          _descriptionController.text = day.targetDescription ?? '';
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Edit Workout Day')),
          body: PageFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day name
                TextField(
                  controller: _nameController,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Day name',
                  ),
                  onChanged: (_) => _saveDay(day),
                ),
                const SizedBox(height: 8),

                // Description
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Target description (e.g., chest and triceps)...',
                  ),
                  maxLines: 2,
                  onChanged: (_) => _saveDay(day),
                ),
                const SizedBox(height: 16),

                // Start workout button
                FilledButton.icon(
                  onPressed: () => _startWorkout(day),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Workout'),
                ),
                const SizedBox(height: 24),

                // Exercises section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercises',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton.icon(
                      onPressed: () => _addExercise(day),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Exercises list
                Expanded(
                  child: exercisesAsync.when(
                    data: (exercises) => exercises.isEmpty
                        ? const Card(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'No exercises yet. Add some to build your workout.',
                              ),
                            ),
                          )
                        : ReorderableListView.builder(
                            itemCount: exercises.length,
                            onReorder: (oldIndex, newIndex) {
                              _reorderExercises(
                                day,
                                exercises,
                                oldIndex,
                                newIndex,
                              );
                            },
                            itemBuilder: (context, index) {
                              final exercise = exercises[index];
                              return _ExerciseCard(
                                key: ValueKey(exercise.id.value),
                                exercise: exercise,
                                index: index,
                                onEdit: () => _editExercise(exercise),
                                onDelete: () => _deleteExercise(exercise),
                              );
                            },
                          ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text('Error: $e'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<ProgramDay?> _loadDay() async {
    final repo = ref.read(programRepositoryProvider);
    final programId = RecordId(widget.programId);
    final days = await repo.getProgramDays(programId);
    return days.where((d) => d.id.value == widget.dayId).firstOrNull;
  }

  void _saveDay(ProgramDay day) {
    final repo = ref.read(programRepositoryProvider);
    final updated = day.copyWith(
      name: _nameController.text.trim(),
      targetDescription: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );
    repo.updateProgramDay(updated);
  }

  void _addExercise(ProgramDay day) {
    showDialog(
      context: context,
      builder: (context) => ExercisePickerDialog(
        onExerciseSelected: (id, name, equipment, primaryMuscle) async {
          final repo = ref.read(programRepositoryProvider);
          final allExercises = ref.read(allExercisesProvider).value ?? [];
          final selectedExercise = allExercises
              .where((e) => e.id == id)
              .firstOrNull;

          if (selectedExercise == null) return;

          final exercises = await repo.getPlannedExercises(day.id);
          final planned = PlannedExercise(
            id: RecordId(const Uuid().v4()),
            programDayId: day.id,
            exerciseId: selectedExercise.id,
            orderIndex: exercises.length,
            targetSets: 3,
            targetRepsMin: 8,
            targetRepsMax: 12,
          );
          await repo.addPlannedExercise(planned);
          setState(() {});
        },
      ),
    );
  }

  void _editExercise(PlannedExercise exercise) {
    showDialog(
      context: context,
      builder: (context) => _EditExerciseDialog(
        exercise: exercise,
        onSaved: (updated) async {
          final repo = ref.read(programRepositoryProvider);
          await repo.updatePlannedExercise(updated);
          setState(() {});
        },
      ),
    );
  }

  Future<void> _deleteExercise(PlannedExercise exercise) async {
    final repo = ref.read(programRepositoryProvider);
    await repo.deletePlannedExercise(exercise.id);
    setState(() {});
  }

  Future<void> _reorderExercises(
    ProgramDay day,
    List<PlannedExercise> exercises,
    int oldIndex,
    int newIndex,
  ) async {
    if (newIndex > oldIndex) newIndex--;
    final reordered = List<PlannedExercise>.from(exercises);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    final repo = ref.read(programRepositoryProvider);
    await repo.reorderExercises(day.id, reordered.map((e) => e.id).toList());
    setState(() {});
  }

  void _startWorkout(ProgramDay day) async {
    final plannedExercises = await ref
        .read(programRepositoryProvider)
        .getPlannedExercises(day.id);

    if (plannedExercises.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add exercises before starting workout'),
          ),
        );
      }
      return;
    }

    if (mounted) {
      await ref
          .read(activeWorkoutProvider.notifier)
          .startPlannedWorkout(widget.programId, widget.dayId);

      if (mounted) {
        final error = ref.read(activeWorkoutProvider).error;
        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        } else {
          context.go('/workouts');
        }
      }
    }
  }
}

class _ExerciseCard extends ConsumerWidget {
  final PlannedExercise exercise;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allExercises = ref.watch(allExercisesProvider).value ?? [];
    final exerciseData = allExercises
        .where((e) => e.id.value == exercise.exerciseId.value)
        .firstOrNull;

    return Card(
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
        title: Text(exerciseData?.canonicalName ?? 'Unknown Exercise'),
        subtitle: Text(_buildTargetText()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _buildTargetText() {
    final parts = <String>[];
    if (exercise.targetSets != null) {
      parts.add('${exercise.targetSets} sets');
    }
    if (exercise.targetRepsMin != null && exercise.targetRepsMax != null) {
      parts.add('${exercise.targetRepsMin}-${exercise.targetRepsMax} reps');
    } else if (exercise.targetRepsMin != null) {
      parts.add('${exercise.targetRepsMin}+ reps');
    }
    return parts.isEmpty ? 'No targets set' : parts.join(' × ');
  }
}

class _EditExerciseDialog extends StatefulWidget {
  final PlannedExercise exercise;
  final Function(PlannedExercise) onSaved;

  const _EditExerciseDialog({required this.exercise, required this.onSaved});

  @override
  State<_EditExerciseDialog> createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<_EditExerciseDialog> {
  late TextEditingController _setsController;
  late TextEditingController _repsMinController;
  late TextEditingController _repsMaxController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(
      text: widget.exercise.targetSets?.toString(),
    );
    _repsMinController = TextEditingController(
      text: widget.exercise.targetRepsMin?.toString(),
    );
    _repsMaxController = TextEditingController(
      text: widget.exercise.targetRepsMax?.toString(),
    );
    _notesController = TextEditingController(text: widget.exercise.notes);
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsMinController.dispose();
    _repsMaxController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Exercise Targets'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _setsController,
              decoration: const InputDecoration(labelText: 'Target Sets'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _repsMinController,
              decoration: const InputDecoration(labelText: 'Min Reps'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _repsMaxController,
              decoration: const InputDecoration(labelText: 'Max Reps'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final updated = widget.exercise.copyWith(
              targetSets: int.tryParse(_setsController.text),
              targetRepsMin: int.tryParse(_repsMinController.text),
              targetRepsMax: int.tryParse(_repsMaxController.text),
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            );
            widget.onSaved(updated);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
