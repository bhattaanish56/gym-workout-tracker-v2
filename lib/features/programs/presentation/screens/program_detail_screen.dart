import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../domain/models/program.dart';
import '../../domain/models/program_day.dart';
import '../providers/program_providers.dart';

class ProgramDetailScreen extends ConsumerStatefulWidget {
  final String programId;

  const ProgramDetailScreen({super.key, required this.programId});

  @override
  ConsumerState<ProgramDetailScreen> createState() =>
      _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
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
    final repo = ref.watch(programRepositoryProvider);
    final programId = RecordId(widget.programId);

    return FutureBuilder<Program?>(
      future: repo.getProgramById(programId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final program = snapshot.data;
        if (program == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Program Not Found')),
            body: const Center(child: Text('Program not found')),
          );
        }

        if (_nameController.text.isEmpty) {
          _nameController.text = program.name;
          _descriptionController.text = program.description ?? '';
        }

        final daysAsync = ref.watch(programDaysProvider(programId));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Workout Plan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/workouts/programs/${widget.programId}/edit'),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmDelete(context, program),
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth >= 600 ? 40 : 24,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          TextField(
                            controller: _nameController,
                            style: Theme.of(context).textTheme.headlineSmall,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Plan name',
                            ),
                            onChanged: (_) => _saveProgram(program),
                          ),
                          const SizedBox(height: 8),

                          // Description
                          TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add description...',
                            ),
                            maxLines: 2,
                            onChanged: (_) => _saveProgram(program),
                          ),
                          const SizedBox(height: 16),

                          // Status and Schedule Mode
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(
                                label: Text(_statusLabel(program.status)),
                                backgroundColor: program.status == ProgramStatus.active
                                    ? Theme.of(context).colorScheme.primaryContainer
                                    : null,
                              ),
                              Chip(label: Text(_scheduleModeLabel(program.scheduleMode))),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Activate/Deactivate button
                          if (program.status != ProgramStatus.active)
                            FilledButton.icon(
                              onPressed: () => _activateProgram(program),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Activate Plan'),
                            )
                          else
                            OutlinedButton.icon(
                              onPressed: () => _deactivateProgram(program),
                              icon: const Icon(Icons.pause),
                              label: const Text('Deactivate Plan'),
                            ),
                          const SizedBox(height: 24),

                          // Days section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Workout Days',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextButton.icon(
                                onPressed: () => _addDay(program),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Day'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Days list
                          Expanded(
                            child: daysAsync.when(
                              data: (days) => days.isEmpty
                                  ? const Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'No workout days yet. Add one to get started.',
                                        ),
                                      ),
                                    )
                                  : ReorderableListView.builder(
                                      itemCount: days.length,
                                      onReorder: (oldIndex, newIndex) {
                                        _reorderDays(program, days, oldIndex, newIndex);
                                      },
                                      itemBuilder: (context, index) {
                                        final day = days[index];
                                        return _DayCard(
                                          key: ValueKey(day.id.value),
                                          day: day,
                                          index: index,
                                          onTap: () => context.push(
                                            '/workouts/programs/${widget.programId}/days/${day.id.value}',
                                          ),
                                          onDelete: () => _deleteDay(day),
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
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _saveProgram(Program program) {
    final repo = ref.read(programRepositoryProvider);
    final updated = program.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );
    repo.updateProgram(updated);
  }

  Future<void> _activateProgram(Program program) async {
    final repo = ref.read(programRepositoryProvider);
    await repo.activateProgram(program.id);
    ref.invalidate(activeProgramProvider);
    ref.invalidate(nextPlannedWorkoutProvider);
    ref.invalidate(allProgramsProvider);
    setState(() {});
  }

  Future<void> _deactivateProgram(Program program) async {
    final repo = ref.read(programRepositoryProvider);
    final updated = program.copyWith(status: ProgramStatus.draft);
    await repo.updateProgram(updated);
    ref.invalidate(activeProgramProvider);
    ref.invalidate(nextPlannedWorkoutProvider);
    ref.invalidate(allProgramsProvider);
    setState(() {});
  }

  Future<void> _addDay(Program program) async {
    final repo = ref.read(programRepositoryProvider);
    final days = await repo.getProgramDays(program.id);
    final day = ProgramDay(
      id: RecordId(const Uuid().v4()),
      programId: program.id,
      orderIndex: days.length,
      name: 'Day ${days.length + 1}',
    );
    await repo.addProgramDay(day);
    setState(() {});
  }

  Future<void> _deleteDay(ProgramDay day) async {
    final repo = ref.read(programRepositoryProvider);
    await repo.deleteProgramDay(day.id);
    setState(() {});
  }

  Future<void> _reorderDays(
    Program program,
    List<ProgramDay> days,
    int oldIndex,
    int newIndex,
  ) async {
    if (newIndex > oldIndex) newIndex--;
    final reordered = List<ProgramDay>.from(days);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    final repo = ref.read(programRepositoryProvider);
    await repo.reorderDays(program.id, reordered.map((d) => d.id).toList());
    setState(() {});
  }

  void _confirmDelete(BuildContext context, Program program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan'),
        content: const Text(
          'Are you sure you want to delete this plan? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(programRepositoryProvider);
              await repo.deleteProgram(program.id);
              if (context.mounted) {
                Navigator.of(context).pop();
                context.pop();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _statusLabel(ProgramStatus status) {
    switch (status) {
      case ProgramStatus.draft:
        return 'Draft';
      case ProgramStatus.active:
        return 'Active';
      case ProgramStatus.archived:
        return 'Archived';
    }
  }

  String _scheduleModeLabel(ScheduleMode mode) {
    return mode == ScheduleMode.fixedWeekly
        ? 'Fixed Weekly'
        : 'Flexible Rotation';
  }
}

class _DayCard extends StatelessWidget {
  final ProgramDay day;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DayCard({
    super.key,
    required this.day,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
        title: Text(day.name),
        subtitle: day.targetDescription != null
            ? Text(day.targetDescription!)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
