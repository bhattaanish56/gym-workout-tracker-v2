import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../exercises/data/bundled_exercises.dart';
import '../../domain/models/program.dart';
import 'program_builder_state.dart';

class Step5Review extends ConsumerStatefulWidget {
  const Step5Review({super.key});

  @override
  ConsumerState<Step5Review> createState() => _Step5ReviewState();
}

class _Step5ReviewState extends ConsumerState<Step5Review> {
  bool _saving = false;

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
                'Review & Save',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Review your workout plan before saving. You can go back to edit any section.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _SummarySection(
                title: 'Plan Information',
                icon: Icons.info_outline,
                onEdit: () => notifier.goToStep(0),
                children: [
                  _SummaryRow('Name', state.name),
                  if (state.description.isNotEmpty)
                    _SummaryRow('Description', state.description),
                  _SummaryRow(
                    'Schedule',
                    state.scheduleMode == ScheduleMode.fixedWeekly
                        ? 'Fixed Weekly'
                        : 'Flexible Rotation',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SummarySection(
                title: 'Workout Days',
                icon: Icons.calendar_today,
                onEdit: () => notifier.goToStep(1),
                children: [
                  _SummaryRow('Total Days', state.dayNames.length.toString()),
                  const SizedBox(height: 8),
                  ...state.dayNames.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${entry.key + 1}. ${entry.value}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              _SummarySection(
                title: 'Schedule',
                icon: Icons.event,
                onEdit: () => notifier.goToStep(2),
                children: [
                  if (state.scheduleMode == ScheduleMode.fixedWeekly) ...[
                    for (int weekday = 1; weekday <= 7; weekday++)
                      if (state.weekdayToDayName.containsKey(weekday))
                        _SummaryRow(
                          _weekdayName(weekday),
                          state.weekdayToDayName[weekday] == 'rest'
                              ? 'Rest Day'
                              : state.weekdayToDayName[weekday]!,
                        ),
                    if (state.weekdayToDayName.isEmpty)
                      Text(
                        'No weekly schedule assigned',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                  ] else ...[
                    Text(
                      'Workouts will rotate in order: ${state.dayNames.join(', ')}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              _SummarySection(
                title: 'Exercises',
                icon: Icons.fitness_center,
                onEdit: () => notifier.goToStep(3),
                children: [
                  for (final dayName in state.dayNames) ...[
                    Text(
                      dayName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    ...() {
                      final exercises = state.dayExercises[dayName] ?? [];
                      if (exercises.isEmpty) {
                        return [
                          Text(
                            'No exercises',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ];
                      }
                      return exercises.map((ex) {
                        final catalogEx = bundledExercises.firstWhere(
                          (e) => e.id == ex.exerciseId,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Text(
                            '• ${catalogEx.canonicalName}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }).toList();
                    }(),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : notifier.previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Plan'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final notifier = ref.read(programBuilderProvider.notifier);
      final programId = await notifier.save();
      if (mounted) {
        notifier.reset();
        context.go('/workouts/programs/$programId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving plan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

class _SummarySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onEdit;
  final List<Widget> children;

  const _SummarySection({
    required this.title,
    required this.icon,
    required this.onEdit,
    required this.children,
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
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: onEdit,
                  child: const Text('Edit'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
