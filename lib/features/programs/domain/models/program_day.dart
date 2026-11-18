import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/errors/domain_error.dart';

/// Program day domain model.
class ProgramDay {
  final RecordId id;
  final RecordId programId;
  final int orderIndex;
  final String name;
  final String? targetDescription;

  ProgramDay({
    required this.id,
    required this.programId,
    required this.orderIndex,
    required this.name,
    this.targetDescription,
  }) {
    if (name.trim().isEmpty) {
      throw const InvalidQuantityError('Program day name cannot be empty');
    }
    if (orderIndex < 0) {
      throw const InvalidQuantityError('Order index cannot be negative');
    }
  }

  ProgramDay copyWith({
    int? orderIndex,
    String? name,
    String? targetDescription,
  }) {
    return ProgramDay(
      id: id,
      programId: programId,
      orderIndex: orderIndex ?? this.orderIndex,
      name: name ?? this.name,
      targetDescription: targetDescription ?? this.targetDescription,
    );
  }
}
