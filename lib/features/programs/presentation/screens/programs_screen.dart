import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../shared/widgets/section_page.dart';
import '../../domain/models/program.dart';
import '../../domain/models/program_day.dart';
import '../../domain/models/planned_exercise.dart';
import '../providers/program_providers.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(allProgramsProvider);
    final activeProgramAsync = ref.watch(activeProgramProvider);

    return Scaffold(
      body: PageFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Workout Plans',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 24),
            programsAsync.when(
              data: (programs) => _buildContent(
                context,
                ref,
                programs,
                activeProgramAsync.value,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/workouts/programs/create'),
        icon: const Icon(Icons.add),
        label: const Text('Create Plan'),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Program> programs,
    Program? activeProgram,
  ) {
    final templates = ref.watch(workoutTemplatesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Active program section
        if (activeProgram != null) ...[
          Text('Active Plan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _ProgramCard(
            program: activeProgram,
            isActive: true,
            onTap: () =>
                context.push('/workouts/programs/${activeProgram.id.value}'),
          ),
          const SizedBox(height: 24),
        ],

        // All programs section
        Text('My Plans', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (programs.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No workout plans yet. Create one or pick a template.',
              ),
            ),
          )
        else
          ...programs.map(
            (program) => _ProgramCard(
              program: program,
              isActive: program.status == ProgramStatus.active,
              onTap: () =>
                  context.push('/workouts/programs/${program.id.value}'),
            ),
          ),
        const SizedBox(height: 24),

        // Templates section
        Text('Templates', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...templates.map(
          (template) => Card(
            child: ListTile(
              leading: const Icon(Icons.content_copy),
              title: Text(template.name),
              subtitle: Text(template.description),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => _createFromTemplate(context, ref, template),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createFromTemplate(
    BuildContext context,
    WidgetRef ref,
    template,
  ) async {
    final repo = ref.read(programRepositoryProvider);
    final now = DateTime.now().toUtc();
    final programId = RecordId(const Uuid().v4());

    // Create program
    final program = Program(
      id: programId,
      name: template.name,
      description: template.description,
      scheduleMode: template.scheduleMode,
      status: ProgramStatus.draft,
      createdAt: now,
      updatedAt: now,
    );
    await repo.createProgram(program);

    // Create days and exercises
    for (var i = 0; i < template.days.length; i++) {
      final templateDay = template.days[i];
      final dayId = RecordId(const Uuid().v4());

      final day = ProgramDay(
        id: dayId,
        programId: programId,
        orderIndex: i,
        name: templateDay.name,
        targetDescription: templateDay.targetDescription,
      );
      await repo.addProgramDay(day);

      for (var j = 0; j < templateDay.exercises.length; j++) {
        final templateExercise = templateDay.exercises[j];
        final exercise = PlannedExercise(
          id: RecordId(const Uuid().v4()),
          programDayId: dayId,
          exerciseId: ExerciseId(templateExercise.exerciseId),
          orderIndex: j,
          targetSets: templateExercise.targetSets,
          targetRepsMin: templateExercise.targetRepsMin,
          targetRepsMax: templateExercise.targetRepsMax,
          targetLoadGrams: templateExercise.targetLoadGrams,
          restSeconds: templateExercise.restSeconds,
          notes: templateExercise.notes,
        );
        await repo.addPlannedExercise(exercise);
      }
    }

    if (context.mounted) {
      context.push('/workouts/programs/${programId.value}');
    }
  }
}

class _ProgramCard extends StatelessWidget {
  final Program program;
  final bool isActive;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.program,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isActive ? Icons.play_circle : Icons.fitness_center,
          color: isActive ? Theme.of(context).colorScheme.primary : null,
        ),
        title: Text(program.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (program.description != null) Text(program.description!),
            Text(
              _scheduleLabel(program.scheduleMode),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: isActive
            ? Chip(
                label: const Text('Active'),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              )
            : const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }

  String _scheduleLabel(ScheduleMode mode) {
    return mode == ScheduleMode.fixedWeekly
        ? 'Fixed Weekly'
        : 'Flexible Rotation';
  }
}
