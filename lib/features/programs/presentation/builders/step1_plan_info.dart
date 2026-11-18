import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/program.dart';
import 'program_builder_state.dart';

class Step1PlanInfo extends ConsumerWidget {
  const Step1PlanInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(programBuilderProvider);
    final notifier = ref.read(programBuilderProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan Information',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Give your workout plan a name and choose how you want to schedule it.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Plan Name',
                    hintText: 'e.g., Push Pull Legs',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: state.name)
                    ..selection = TextSelection.collapsed(offset: state.name.length),
                  onChanged: notifier.setName,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Add notes about this plan...',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: state.description)
                    ..selection =
                        TextSelection.collapsed(offset: state.description.length),
                  onChanged: notifier.setDescription,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Text(
                  'Schedule Type',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _ScheduleModeCard(
                  title: 'Fixed Weekly',
                  description:
                      'Assign specific workouts to days of the week (Mon-Sun)',
                  icon: Icons.calendar_today,
                  selected: state.scheduleMode == ScheduleMode.fixedWeekly,
                  onTap: () => notifier.setScheduleMode(ScheduleMode.fixedWeekly),
                ),
                const SizedBox(height: 12),
                _ScheduleModeCard(
                  title: 'Flexible Rotation',
                  description:
                      'Cycle through workouts in order, regardless of the day',
                  icon: Icons.repeat,
                  selected: state.scheduleMode == ScheduleMode.flexibleRotation,
                  onTap: () =>
                      notifier.setScheduleMode(ScheduleMode.flexibleRotation),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: state.canProceedFromStep1 ? notifier.nextStep : null,
              child: const Text('Next: Workout Days'),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScheduleModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ScheduleModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: selected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
