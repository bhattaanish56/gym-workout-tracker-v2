import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'program_builder_state.dart';

class Step2WorkoutDays extends ConsumerStatefulWidget {
  const Step2WorkoutDays({super.key});

  @override
  ConsumerState<Step2WorkoutDays> createState() => _Step2WorkoutDaysState();
}

class _Step2WorkoutDaysState extends ConsumerState<Step2WorkoutDays> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(programBuilderProvider);
    final notifier = ref.read(programBuilderProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Days',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Add and organize the workout days in your plan. You can name them by focus (e.g., Push, Pull, Legs) or by number.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Day Name',
                        hintText: 'e.g., Push Day',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => _addDay(notifier, value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _addDay(notifier, _nameController.text),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: state.dayNames.isEmpty
              ? Card(
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
                            'No workout days yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first workout day to get started',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ReorderableListView.builder(
                  itemCount: state.dayNames.length,
                  onReorder: notifier.reorderDays,
                  itemBuilder: (context, index) {
                    final dayName = state.dayNames[index];
                    return _DayListTile(
                      key: ValueKey(dayName),
                      dayName: dayName,
                      index: index,
                      onRename: (newName) => notifier.updateDayName(index, newName),
                      onDelete: () => notifier.removeDay(index),
                    );
                  },
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
                  onPressed: state.canProceedFromStep2 ? notifier.nextStep : null,
                  child: const Text('Next: Schedule'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addDay(ProgramBuilderNotifier notifier, String name) {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty) {
      notifier.addDay(trimmed);
      _nameController.clear();
    }
  }
}

class _DayListTile extends StatefulWidget {
  final String dayName;
  final int index;
  final Function(String) onRename;
  final VoidCallback onDelete;

  const _DayListTile({
    super.key,
    required this.dayName,
    required this.index,
    required this.onRename,
    required this.onDelete,
  });

  @override
  State<_DayListTile> createState() => _DayListTileState();
}

class _DayListTileState extends State<_DayListTile> {
  bool _editing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.dayName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: widget.index,
          child: const Icon(Icons.drag_handle),
        ),
        title: _editing
            ? TextField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: _saveName,
              )
            : Text(widget.dayName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_editing)
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _saveName,
              )
            else
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => setState(() => _editing = true),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }

  void _saveName([String? _]) {
    final newName = _controller.text.trim();
    if (newName.isNotEmpty && newName != widget.dayName) {
      widget.onRename(newName);
    }
    setState(() => _editing = false);
  }
}
