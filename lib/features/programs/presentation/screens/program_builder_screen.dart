import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../builders/program_builder_state.dart';
import '../builders/step1_plan_info.dart';
import '../builders/step2_workout_days.dart';
import '../builders/step3_schedule.dart';
import '../builders/step4_exercises.dart';
import '../builders/step5_review.dart';

class ProgramBuilderScreen extends ConsumerStatefulWidget {
  final String? programId;

  const ProgramBuilderScreen({super.key, this.programId});

  @override
  ConsumerState<ProgramBuilderScreen> createState() => _ProgramBuilderScreenState();
}

class _ProgramBuilderScreenState extends ConsumerState<ProgramBuilderScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgram();
  }

  Future<void> _loadProgram() async {
    if (widget.programId != null) {
      await ref.read(programBuilderProvider.notifier).loadProgram(widget.programId!);
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final state = ref.watch(programBuilderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programId != null ? 'Edit Workout Plan' : 'Create Workout Plan'),
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
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _Stepper(currentStep: state.currentStep),
                      const SizedBox(height: 24),
                      Expanded(
                        child: IndexedStack(
                          index: state.currentStep,
                          children: const [
                            Step1PlanInfo(),
                            Step2WorkoutDays(),
                            Step3Schedule(),
                            Step4Exercises(),
                            Step5Review(),
                          ],
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
  }
}

class _Stepper extends StatelessWidget {
  final int currentStep;

  const _Stepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Info',
      'Days',
      'Schedule',
      'Exercises',
      'Review',
    ];

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _StepIndicator(
            label: steps[i],
            number: i + 1,
            active: i == currentStep,
            completed: i < currentStep,
          ),
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: 2,
                color: i < currentStep
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final int number;
  final bool active;
  final bool completed;

  const _StepIndicator({
    required this.label,
    required this.number,
    required this.active,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active
              ? Theme.of(context).colorScheme.primary
              : completed
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceVariant,
          child: completed
              ? Icon(
                  Icons.check,
                  size: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                )
              : Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 12,
                    color: active
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
