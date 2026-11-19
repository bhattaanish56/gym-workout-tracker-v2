import '../../../programs/domain/models/program.dart';
import '../../../programs/domain/models/program_day.dart';

/// Status of today's workout and what's up next
class TodayWorkoutStatus {
  final WorkoutCompletedToday? completedToday;
  final NextWorkout? nextWorkout;
  final bool hasActiveSession;

  const TodayWorkoutStatus({
    this.completedToday,
    this.nextWorkout,
    this.hasActiveSession = false,
  });

  const TodayWorkoutStatus.noProgram()
      : completedToday = null,
        nextWorkout = null,
        hasActiveSession = false;

  const TodayWorkoutStatus.loading()
      : completedToday = null,
        nextWorkout = null,
        hasActiveSession = false;
}

/// Details about a workout completed today
class WorkoutCompletedToday {
  final String programName;
  final String dayName;
  final DateTime completedAt;

  const WorkoutCompletedToday({
    required this.programName,
    required this.dayName,
    required this.completedAt,
  });
}

/// Details about the next scheduled workout
class NextWorkout {
  final Program program;
  final ProgramDay day;
  final DateTime? scheduledDate; // null = today or flexible rotation

  const NextWorkout({
    required this.program,
    required this.day,
    this.scheduledDate,
  });

  bool get isScheduledForFuture {
    if (scheduledDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduled = DateTime(
      scheduledDate!.year,
      scheduledDate!.month,
      scheduledDate!.day,
    );
    return scheduled.isAfter(today);
  }
}
