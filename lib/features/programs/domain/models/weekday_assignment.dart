import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Assignment type for weekday schedules.
enum AssignmentType {
  workout,
  rest;

  String toJson() => name;

  static AssignmentType fromJson(String value) {
    return AssignmentType.values.firstWhere(
      (e) => e.name == value,
      orElse: () =>
          throw InvalidQuantityError('Invalid AssignmentType: $value'),
    );
  }
}

/// Weekday assignment for fixed-weekly programs.
/// Maps a specific weekday to either a workout day or a rest day.
class WeekdayAssignment {
  final RecordId id;
  final RecordId programId;
  final int weekday;
  final AssignmentType assignmentType;
  final RecordId? programDayId;

  WeekdayAssignment({
    required this.id,
    required this.programId,
    required this.weekday,
    required this.assignmentType,
    this.programDayId,
  }) {
    if (weekday < 1 || weekday > 7) {
      throw const InvalidQuantityError('Weekday must be 1-7 (Mon-Sun)');
    }
    if (assignmentType == AssignmentType.workout && programDayId == null) {
      throw const InvalidQuantityError(
        'Workout assignment requires programDayId',
      );
    }
    if (assignmentType == AssignmentType.rest && programDayId != null) {
      throw const InvalidQuantityError(
        'Rest assignment cannot have programDayId',
      );
    }
  }

  WeekdayAssignment copyWith({
    int? weekday,
    AssignmentType? assignmentType,
    RecordId? programDayId,
    bool clearProgramDayId = false,
  }) {
    return WeekdayAssignment(
      id: id,
      programId: programId,
      weekday: weekday ?? this.weekday,
      assignmentType: assignmentType ?? this.assignmentType,
      programDayId: clearProgramDayId
          ? null
          : (programDayId ?? this.programDayId),
    );
  }
}
