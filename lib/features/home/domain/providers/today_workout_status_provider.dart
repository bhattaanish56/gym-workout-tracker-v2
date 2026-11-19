import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/today_workout_status.dart';
import '../../../sessions/presentation/providers/workout_providers.dart';
import '../../../programs/data/repositories/drift_program_repository.dart';
import '../../../../core/domain/value_objects/date_time.dart';
import '../../../sessions/domain/models/workout_session.dart';
import '../../../programs/domain/models/program.dart';
import '../../../programs/domain/models/program_day.dart';

final todayWorkoutStatusProvider = FutureProvider<TodayWorkoutStatus>((ref) async {
  final workoutRepo = ref.watch(workoutRepositoryProvider);
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  final programRepo = DriftProgramRepository(db, userId);

  // Check for active session
  final activeSession = await workoutRepo.getActiveSession();
  if (activeSession != null) {
    return const TodayWorkoutStatus(hasActiveSession: true);
  }

  // Get all sessions and primary program
  final allSessions = await workoutRepo.getAllSessions();
  final programs = await programRepo.getPrograms();
  final primaryProgram = programs.where((p) => p.status == ProgramStatus.active).firstOrNull;

  if (primaryProgram == null) {
    return const TodayWorkoutStatus.noProgram();
  }

  final today = LocalDate.fromDateTime(DateTime.now());

  // Find completed workout today (by workoutDate)
  WorkoutCompletedToday? completedToday;
  final todaySession = allSessions.where((s) {
    return s.status == WorkoutStatus.completed &&
           s.workoutDate == today &&
           s.programId == primaryProgram.id.value;
  }).firstOrNull;

  if (todaySession != null && todaySession.programSnapshot != null) {
    completedToday = WorkoutCompletedToday(
      programName: todaySession.programSnapshot!['programName'] as String,
      dayName: todaySession.programSnapshot!['dayName'] as String,
      completedAt: todaySession.finishedAt ?? todaySession.updatedAt,
    );
  }

  // Determine next workout
  final days = await programRepo.getProgramDays(primaryProgram.id);
  if (days.isEmpty) {
    return TodayWorkoutStatus(
      completedToday: completedToday,
      nextWorkout: null,
    );
  }

  NextWorkout? nextWorkout;

  if (primaryProgram.scheduleMode == ScheduleMode.flexibleRotation) {
    // Flexible: next in rotation, no scheduled date
    final rotationState = await programRepo.getRotationState(primaryProgram.id);
    final nextIndex = rotationState?.nextDayIndex ?? 0;
    final nextDay = days[nextIndex % days.length];

    nextWorkout = NextWorkout(
      program: primaryProgram,
      day: nextDay,
      scheduledDate: null,
    );
  } else if (primaryProgram.scheduleMode == ScheduleMode.fixedWeekly) {
    // Fixed weekly: find next unfulfilled scheduled workout
    final weekdayAssignments = await programRepo.getWeekdayAssignments(primaryProgram.id);

    if (weekdayAssignments.isNotEmpty) {
      // Build list of scheduled dates for next 7 days
      final now = DateTime.now();
      final scheduledDates = <({DateTime date, ProgramDay day})>[];

      for (int i = 0; i < 7; i++) {
        final checkDate = now.add(Duration(days: i));
        final weekday = checkDate.weekday;

        final assignment = weekdayAssignments.where((a) => a.weekday == weekday).firstOrNull;
        if (assignment != null && assignment.programDayId != null) {
          final day = days.where((d) => d.id == assignment.programDayId!).firstOrNull;
          if (day != null) {
            scheduledDates.add((date: checkDate, day: day));
          }
        }
      }

      // Filter out dates already fulfilled
      final fulfilledDates = allSessions
          .where((s) => s.status == WorkoutStatus.completed && s.fulfilledScheduledDate != null)
          .map((s) => s.fulfilledScheduledDate!)
          .toSet();

      final unfulfilledScheduled = scheduledDates.where((entry) {
        final entryDate = LocalDate.fromDateTime(entry.date);
        return !fulfilledDates.contains(entryDate);
      }).toList();

      if (unfulfilledScheduled.isNotEmpty) {
        final next = unfulfilledScheduled.first;
        nextWorkout = NextWorkout(
          program: primaryProgram,
          day: next.day,
          scheduledDate: next.date,
        );
      }
    }
  }

  return TodayWorkoutStatus(
    completedToday: completedToday,
    nextWorkout: nextWorkout,
  );
});
