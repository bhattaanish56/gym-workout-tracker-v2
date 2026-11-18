import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Rotation state domain model.
class RotationState {
  final RecordId programId;
  final int nextDayIndex;
  final RecordId? lastCompletionEventId;

  RotationState({
    required this.programId,
    required this.nextDayIndex,
    this.lastCompletionEventId,
  }) {
    if (nextDayIndex < 0) {
      throw const InvalidQuantityError('Next day index cannot be negative');
    }
  }

  RotationState copyWith({int? nextDayIndex, RecordId? lastCompletionEventId}) {
    return RotationState(
      programId: programId,
      nextDayIndex: nextDayIndex ?? this.nextDayIndex,
      lastCompletionEventId:
          lastCompletionEventId ?? this.lastCompletionEventId,
    );
  }
}
