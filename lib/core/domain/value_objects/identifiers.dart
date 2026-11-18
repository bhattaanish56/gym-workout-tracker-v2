import '../errors/domain_error.dart';

/// Stable record identifier (UUID or equivalent).
///
/// Does not generate UUIDs; accepts validated strings.
/// Typically a UUID v4 string, but implementation is flexible.
final class RecordId {
  final String value;

  const RecordId._(this.value);

  /// Creates a RecordId from a validated string.
  ///
  /// Throws [InvalidIdentifierError] if:
  /// - value is empty
  /// - value contains only whitespace
  factory RecordId(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const InvalidIdentifierError('RecordId cannot be empty');
    }
    return RecordId._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// Firebase Auth UID reference.
///
/// Does not assume UIDs are UUIDs.
final class UserId {
  final String value;

  const UserId._(this.value);

  /// Creates a UserId from a validated Firebase Auth UID.
  ///
  /// Throws [InvalidIdentifierError] if:
  /// - value is empty
  /// - value contains only whitespace
  factory UserId(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const InvalidIdentifierError('UserId cannot be empty');
    }
    return UserId._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// Mutation/operation idempotency key.
final class OperationId {
  final String value;

  const OperationId._(this.value);

  /// Creates an OperationId from a validated string.
  ///
  /// Throws [InvalidIdentifierError] if:
  /// - value is empty
  /// - value contains only whitespace
  factory OperationId(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const InvalidIdentifierError('OperationId cannot be empty');
    }
    return OperationId._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
