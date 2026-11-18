import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Program schedule mode.
enum ScheduleMode {
  fixedWeekly,
  flexibleRotation;

  String toJson() => name;

  static ScheduleMode fromJson(String value) {
    return ScheduleMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw InvalidQuantityError('Invalid ScheduleMode: $value'),
    );
  }
}

/// Program status.
enum ProgramStatus {
  draft,
  active,
  archived;

  String toJson() => name;

  static ProgramStatus fromJson(String value) {
    return ProgramStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw InvalidQuantityError('Invalid ProgramStatus: $value'),
    );
  }
}

/// Workout program domain model.
class Program {
  final RecordId id;
  final String name;
  final String? description;
  final ScheduleMode scheduleMode;
  final ProgramStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Program({
    required this.id,
    required this.name,
    this.description,
    required this.scheduleMode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) {
    if (name.trim().isEmpty) {
      throw const InvalidQuantityError('Program name cannot be empty');
    }
  }

  Program copyWith({
    String? name,
    String? description,
    ScheduleMode? scheduleMode,
    ProgramStatus? status,
    DateTime? updatedAt,
  }) {
    return Program(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }
}
