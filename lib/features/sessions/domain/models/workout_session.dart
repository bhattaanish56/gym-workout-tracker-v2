import '../../../../core/domain/value_objects/date_time.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Workout session status.
enum WorkoutStatus {
  inProgress,
  completed,
  abandoned;

  String toJson() => name;

  static WorkoutStatus fromJson(String value) {
    return WorkoutStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw InvalidQuantityError('Invalid WorkoutStatus: $value'),
    );
  }
}

/// Workout source type.
enum WorkoutSourceType {
  freestyle,
  programDay,
  scheduled;

  String toJson() => name;

  static WorkoutSourceType fromJson(String value) {
    return WorkoutSourceType.values.firstWhere(
      (e) => e.name == value,
      orElse: () =>
          throw InvalidQuantityError('Invalid WorkoutSourceType: $value'),
    );
  }
}

/// Workout session domain model.
///
/// Represents a single workout session with start/end times and local workout date.
/// For WORKOUT-001: local-only, no UID/cloud fields yet.
class WorkoutSession {
  final RecordId id;
  final WorkoutSourceType sourceType;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final LocalDate workoutDate; // Actual training date
  final WorkoutStatus status;
  final String? programId;
  final String? programDayId;
  final Map<String, dynamic>? programSnapshot;
  final LocalDate? fulfilledScheduledDate; // For early completion: which scheduled date was fulfilled
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutSession({
    required this.id,
    required this.sourceType,
    required this.startedAt,
    this.finishedAt,
    required this.workoutDate,
    required this.status,
    this.programId,
    this.programDayId,
    this.programSnapshot,
    this.fulfilledScheduledDate,
    required this.createdAt,
    required this.updatedAt,
  }) {
    if (status == WorkoutStatus.completed && finishedAt == null) {
      throw const InvalidQuantityError(
        'Completed workout must have finishedAt timestamp',
      );
    }
    if (finishedAt != null && finishedAt!.isBefore(startedAt)) {
      throw const InvalidQuantityError('finishedAt cannot be before startedAt');
    }
  }

  /// Creates a new freestyle workout session.
  factory WorkoutSession.createFreestyle({
    required RecordId id,
    required DateTime startedAt,
    required LocalDate workoutDate,
  }) {
    final now = DateTime.now().toUtc();
    return WorkoutSession(
      id: id,
      sourceType: WorkoutSourceType.freestyle,
      startedAt: startedAt.toUtc(),
      workoutDate: workoutDate,
      status: WorkoutStatus.inProgress,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Marks session as completed.
  WorkoutSession complete(DateTime finishedAt) {
    return WorkoutSession(
      id: id,
      sourceType: sourceType,
      startedAt: startedAt,
      finishedAt: finishedAt.toUtc(),
      workoutDate: workoutDate,
      status: WorkoutStatus.completed,
      programId: programId,
      programDayId: programDayId,
      programSnapshot: programSnapshot,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Updates session.
  WorkoutSession copyWith({
    WorkoutSourceType? sourceType,
    DateTime? startedAt,
    DateTime? finishedAt,
    LocalDate? workoutDate,
    WorkoutStatus? status,
    String? programId,
    String? programDayId,
    Map<String, dynamic>? programSnapshot,
    DateTime? updatedAt,
  }) {
    return WorkoutSession(
      id: id,
      sourceType: sourceType ?? this.sourceType,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      workoutDate: workoutDate ?? this.workoutDate,
      status: status ?? this.status,
      programId: programId ?? this.programId,
      programDayId: programDayId ?? this.programDayId,
      programSnapshot: programSnapshot ?? this.programSnapshot,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }
}
