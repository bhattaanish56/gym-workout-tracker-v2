import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../domain/models/program.dart';
import '../../domain/models/program_day.dart';
import '../../domain/models/planned_exercise.dart';
import '../../domain/models/weekday_assignment.dart';
import '../../domain/repositories/program_repository.dart';
import '../providers/program_providers.dart';

/// State for program builder wizard.
class ProgramBuilderState {
  final int currentStep;
  final String? editingProgramId;

  // Step 1: Plan info
  final String name;
  final String description;
  final ScheduleMode scheduleMode;

  // Step 2: Workout days (names in rotation order)
  final List<String> dayNames;

  // Step 3: Schedule assignments (fixed-weekly only)
  final Map<int, String?> weekdayToDayName; // weekday (1-7) -> day name or 'rest'

  // Step 4: Exercises per day
  final Map<String, List<TempExercise>> dayExercises; // day name -> exercises

  const ProgramBuilderState({
    this.currentStep = 0,
    this.editingProgramId,
    this.name = '',
    this.description = '',
    this.scheduleMode = ScheduleMode.fixedWeekly,
    this.dayNames = const [],
    this.weekdayToDayName = const {},
    this.dayExercises = const {},
  });

  ProgramBuilderState copyWith({
    int? currentStep,
    String? name,
    String? description,
    ScheduleMode? scheduleMode,
    List<String>? dayNames,
    Map<int, String?>? weekdayToDayName,
    Map<String, List<TempExercise>>? dayExercises,
  }) {
    return ProgramBuilderState(
      currentStep: currentStep ?? this.currentStep,
      editingProgramId: editingProgramId,
      name: name ?? this.name,
      description: description ?? this.description,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      dayNames: dayNames ?? this.dayNames,
      weekdayToDayName: weekdayToDayName ?? this.weekdayToDayName,
      dayExercises: dayExercises ?? this.dayExercises,
    );
  }

  bool get canProceedFromStep1 => name.trim().isNotEmpty;
  bool get canProceedFromStep2 => dayNames.isNotEmpty;
  bool get canProceedFromStep3 => true; // Schedule is optional
  bool get canProceedFromStep4 => true; // Exercises are optional
}

/// Temporary exercise holder (no IDs yet).
class TempExercise {
  final String exerciseId;
  final int? targetSets;
  final int? targetRepsMin;
  final int? targetRepsMax;
  final int? targetLoadGrams;
  final int? restSeconds;
  final String? notes;

  const TempExercise({
    required this.exerciseId,
    this.targetSets,
    this.targetRepsMin,
    this.targetRepsMax,
    this.targetLoadGrams,
    this.restSeconds,
    this.notes,
  });

  TempExercise copyWith({
    int? targetSets,
    int? targetRepsMin,
    int? targetRepsMax,
    int? targetLoadGrams,
    int? restSeconds,
    String? notes,
  }) {
    return TempExercise(
      exerciseId: exerciseId,
      targetSets: targetSets ?? this.targetSets,
      targetRepsMin: targetRepsMin ?? this.targetRepsMin,
      targetRepsMax: targetRepsMax ?? this.targetRepsMax,
      targetLoadGrams: targetLoadGrams ?? this.targetLoadGrams,
      restSeconds: restSeconds ?? this.restSeconds,
      notes: notes ?? this.notes,
    );
  }
}

/// Notifier for program builder.
class ProgramBuilderNotifier extends Notifier<ProgramBuilderState> {
  late final ProgramRepository _repo;

  @override
  ProgramBuilderState build() {
    _repo = ref.watch(programRepositoryProvider);
    return const ProgramBuilderState();
  }

  // Navigation
  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 4) {
      state = state.copyWith(currentStep: step);
    }
  }

  // Step 1: Plan info
  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void setScheduleMode(ScheduleMode mode) {
    state = state.copyWith(
      scheduleMode: mode,
      weekdayToDayName: {}, // Reset schedule when mode changes
    );
  }

  // Step 2: Workout days
  void addDay(String dayName) {
    state = state.copyWith(
      dayNames: [...state.dayNames, dayName],
      dayExercises: {...state.dayExercises, dayName: []},
    );
  }

  void updateDayName(int index, String newName) {
    if (index < 0 || index >= state.dayNames.length) return;
    final oldName = state.dayNames[index];
    final newNames = [...state.dayNames];
    newNames[index] = newName;

    // Update exercises map and weekday assignments
    final newExercises = Map<String, List<TempExercise>>.from(state.dayExercises);
    newExercises[newName] = newExercises.remove(oldName) ?? [];

    final newWeekdays = Map<int, String?>.from(state.weekdayToDayName);
    for (var entry in newWeekdays.entries) {
      if (entry.value == oldName) {
        newWeekdays[entry.key] = newName;
      }
    }

    state = state.copyWith(
      dayNames: newNames,
      dayExercises: newExercises,
      weekdayToDayName: newWeekdays,
    );
  }

  void removeDay(int index) {
    if (index < 0 || index >= state.dayNames.length) return;
    final dayName = state.dayNames[index];
    final newNames = [...state.dayNames];
    newNames.removeAt(index);

    final newExercises = Map<String, List<TempExercise>>.from(state.dayExercises);
    newExercises.remove(dayName);

    final newWeekdays = Map<int, String?>.from(state.weekdayToDayName);
    newWeekdays.removeWhere((_, name) => name == dayName);

    state = state.copyWith(
      dayNames: newNames,
      dayExercises: newExercises,
      weekdayToDayName: newWeekdays,
    );
  }

  void reorderDays(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final newNames = [...state.dayNames];
    final item = newNames.removeAt(oldIndex);
    newNames.insert(newIndex, item);
    state = state.copyWith(dayNames: newNames);
  }

  // Step 3: Schedule
  void assignWeekday(int weekday, String? dayNameOrRest) {
    final newWeekdays = Map<int, String?>.from(state.weekdayToDayName);
    if (dayNameOrRest == null) {
      newWeekdays.remove(weekday);
    } else {
      newWeekdays[weekday] = dayNameOrRest;
    }
    state = state.copyWith(weekdayToDayName: newWeekdays);
  }

  // Step 4: Exercises
  void addExercise(String dayName, String exerciseId) {
    final exercises = List<TempExercise>.from(state.dayExercises[dayName] ?? []);
    exercises.add(TempExercise(exerciseId: exerciseId, targetSets: 3, targetRepsMin: 8, targetRepsMax: 12));
    final newExercises = Map<String, List<TempExercise>>.from(state.dayExercises);
    newExercises[dayName] = exercises;
    state = state.copyWith(dayExercises: newExercises);
  }

  void updateExercise(String dayName, int index, TempExercise exercise) {
    final exercises = List<TempExercise>.from(state.dayExercises[dayName] ?? []);
    if (index >= 0 && index < exercises.length) {
      exercises[index] = exercise;
      final newExercises = Map<String, List<TempExercise>>.from(state.dayExercises);
      newExercises[dayName] = exercises;
      state = state.copyWith(dayExercises: newExercises);
    }
  }

  void removeExercise(String dayName, int index) {
    final exercises = List<TempExercise>.from(state.dayExercises[dayName] ?? []);
    if (index >= 0 && index < exercises.length) {
      exercises.removeAt(index);
      final newExercises = Map<String, List<TempExercise>>.from(state.dayExercises);
      newExercises[dayName] = exercises;
      state = state.copyWith(dayExercises: newExercises);
    }
  }

  void reorderExercises(String dayName, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final exercises = List<TempExercise>.from(state.dayExercises[dayName] ?? []);
    final item = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, item);
    final newExercises = Map<String, List<TempExercise>>.from(state.dayExercises);
    newExercises[dayName] = exercises;
    state = state.copyWith(dayExercises: newExercises);
  }

  // Load existing program for editing
  Future<void> loadProgram(String programId) async {
    final program = await _repo.getProgramById(RecordId(programId));
    if (program == null) return;

    final days = await _repo.getProgramDays(program.id);
    final dayNames = days.map((d) => d.name).toList();

    final dayExercises = <String, List<TempExercise>>{};
    for (final day in days) {
      final exercises = await _repo.getPlannedExercises(day.id);
      dayExercises[day.name] = exercises.map((e) => TempExercise(
        exerciseId: e.exerciseId.value,
        targetSets: e.targetSets,
        targetRepsMin: e.targetRepsMin,
        targetRepsMax: e.targetRepsMax,
        targetLoadGrams: e.targetLoadGrams,
        restSeconds: e.restSeconds,
        notes: e.notes,
      )).toList();
    }

    final weekdayToDayName = <int, String?>{};
    if (program.scheduleMode == ScheduleMode.fixedWeekly) {
      final assignments = await _repo.getWeekdayAssignments(program.id);
      for (final assignment in assignments) {
        if (assignment.assignmentType == AssignmentType.workout) {
          final day = days.firstWhere((d) => d.id == assignment.programDayId);
          weekdayToDayName[assignment.weekday] = day.name;
        } else {
          weekdayToDayName[assignment.weekday] = 'rest';
        }
      }
    }

    state = ProgramBuilderState(
      currentStep: 0,
      editingProgramId: programId,
      name: program.name,
      description: program.description ?? '',
      scheduleMode: program.scheduleMode,
      dayNames: dayNames,
      weekdayToDayName: weekdayToDayName,
      dayExercises: dayExercises,
    );
  }

  // Save program atomically
  Future<String> save() async {
    final uuid = const Uuid();
    final now = DateTime.now().toUtc();
    final programId = RecordId(state.editingProgramId ?? uuid.v4());

    // Create or update program
    final program = Program(
      id: programId,
      name: state.name.trim(),
      description: state.description.trim().isEmpty ? null : state.description.trim(),
      scheduleMode: state.scheduleMode,
      status: ProgramStatus.draft,
      createdAt: now,
      updatedAt: now,
    );

    if (state.editingProgramId != null) {
      await _repo.updateProgram(program);
      // Delete existing days and rebuild
      final existingDays = await _repo.getProgramDays(programId);
      for (final day in existingDays) {
        await _repo.deleteProgramDay(day.id);
      }
      // Delete existing weekday assignments
      final existingAssignments = await _repo.getWeekdayAssignments(programId);
      for (final assignment in existingAssignments) {
        await _repo.deleteWeekdayAssignment(assignment.id);
      }
    } else {
      await _repo.createProgram(program);
    }

    // Create days
    final dayIdMap = <String, RecordId>{};
    for (var i = 0; i < state.dayNames.length; i++) {
      final dayName = state.dayNames[i];
      final dayId = RecordId(uuid.v4());
      dayIdMap[dayName] = dayId;

      final day = ProgramDay(
        id: dayId,
        programId: programId,
        orderIndex: i,
        name: dayName,
      );
      await _repo.addProgramDay(day);

      // Add exercises
      final exercises = state.dayExercises[dayName] ?? [];
      for (var j = 0; j < exercises.length; j++) {
        final ex = exercises[j];
        final plannedExercise = PlannedExercise(
          id: RecordId(uuid.v4()),
          programDayId: dayId,
          exerciseId: ExerciseId(ex.exerciseId),
          orderIndex: j,
          targetSets: ex.targetSets,
          targetRepsMin: ex.targetRepsMin,
          targetRepsMax: ex.targetRepsMax,
          targetLoadGrams: ex.targetLoadGrams,
          restSeconds: ex.restSeconds,
          notes: ex.notes,
        );
        await _repo.addPlannedExercise(plannedExercise);
      }
    }

    // Create weekday assignments (fixed-weekly only)
    if (state.scheduleMode == ScheduleMode.fixedWeekly) {
      for (final entry in state.weekdayToDayName.entries) {
        final weekday = entry.key;
        final dayNameOrRest = entry.value;

        if (dayNameOrRest == 'rest') {
          final assignment = WeekdayAssignment(
            id: RecordId(uuid.v4()),
            programId: programId,
            weekday: weekday,
            assignmentType: AssignmentType.rest,
          );
          await _repo.addWeekdayAssignment(assignment);
        } else if (dayNameOrRest != null && dayIdMap.containsKey(dayNameOrRest)) {
          final assignment = WeekdayAssignment(
            id: RecordId(uuid.v4()),
            programId: programId,
            weekday: weekday,
            assignmentType: AssignmentType.workout,
            programDayId: dayIdMap[dayNameOrRest],
          );
          await _repo.addWeekdayAssignment(assignment);
        }
      }
    }

    return programId.value;
  }

  void reset() {
    state = const ProgramBuilderState();
  }
}

final programBuilderProvider = NotifierProvider<ProgramBuilderNotifier, ProgramBuilderState>(() {
  return ProgramBuilderNotifier();
});
