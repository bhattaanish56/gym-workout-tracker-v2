import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/program.dart';
import 'program_builder_state.dart';

class Step3Schedule extends ConsumerWidget {
  const Step3Schedule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                'Schedule',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.scheduleMode == ScheduleMode.fixedWeekly
                    ? 'Assign workout days to specific days of the week. You can assign rest days or leave days unassigned.'
                    : 'Your workouts will cycle through in the order you defined. No weekly schedule needed.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: state.scheduleMode == ScheduleMode.fixedWeekly
              ? ListView(
                  children: [
                    for (int weekday = 1; weekday <= 7; weekday++)
                      _WeekdayRow(
                        weekday: weekday,
                        dayNames: state.dayNames,
                        assignment: state.weekdayToDayName[weekday],
                        onChanged: (value) => notifier.assignWeekday(weekday, value),
                      ),
                  ],
                )
              : SingleChildScrollView(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rotation Order',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ...state.dayNames.asMap().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    child: Text('${entry.key + 1}'),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    entry.value,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
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
                  child: const Text('Next: Exercises'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  final int weekday;
  final List<String> dayNames;
  final String? assignment;
  final Function(String?) onChanged;

  const _WeekdayRow({
    required this.weekday,
    required this.dayNames,
    required this.assignment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                _weekdayName(weekday),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String?>(
                value: assignment,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                hint: const Text('Unassigned'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Unassigned'),
                  ),
                  const DropdownMenuItem(
                    value: 'rest',
                    child: Text('Rest Day'),
                  ),
                  for (final dayName in dayNames)
                    DropdownMenuItem(
                      value: dayName,
                      child: Text(dayName),
                    ),
                ],
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
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
