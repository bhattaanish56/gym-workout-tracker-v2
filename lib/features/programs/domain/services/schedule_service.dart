import '../models/program.dart';
import '../models/program_day.dart';
import '../models/weekday_assignment.dart';

/// Schedule service for determining next workout.
class ScheduleService {
  /// Gets the scheduled workout day for a given date using weekday assignments.
  /// Returns null if it's a rest day or no day is assigned.
  ProgramDay? getScheduledDay(
    Program program,
    List<ProgramDay> days,
    List<WeekdayAssignment> assignments,
    DateTime date,
  ) {
    if (program.scheduleMode == ScheduleMode.fixedWeekly) {
      final weekday = date.weekday; // 1=Mon, 7=Sun

      // Find assignment for this weekday
      final assignment = assignments
          .where((a) => a.weekday == weekday)
          .firstOrNull;

      if (assignment == null) return null; // Unassigned
      if (assignment.assignmentType == AssignmentType.rest) return null; // Rest

      // Return the assigned ProgramDay
      return days
          .where((d) => d.id.value == assignment.programDayId!.value)
          .firstOrNull;
    }

    // Flexible rotation uses rotation state, handled by repository
    return null;
  }

  /// Validates weekday assignments for fixed-weekly programs.
  /// Returns error message if invalid, null if valid.
  String? validateWeekdayAssignments(List<WeekdayAssignment> assignments) {
    final assignedWeekdays = <int>{};

    for (final assignment in assignments) {
      if (assignedWeekdays.contains(assignment.weekday)) {
        return 'Weekday ${_weekdayName(assignment.weekday)} is assigned multiple times';
      }
      assignedWeekdays.add(assignment.weekday);
    }

    return null;
  }

  String _weekdayName(int weekday) {
    const names = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[weekday];
  }
}
