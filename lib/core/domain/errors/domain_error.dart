/// Base class for domain validation errors.
sealed class DomainError implements Exception {
  final String message;
  const DomainError(this.message);

  @override
  String toString() => 'DomainError: $message';
}

/// Invalid identifier format or value.
final class InvalidIdentifierError extends DomainError {
  const InvalidIdentifierError(super.message);

  @override
  String toString() => 'InvalidIdentifierError: $message';
}

/// Invalid date format or value.
final class InvalidDateError extends DomainError {
  const InvalidDateError(super.message);

  @override
  String toString() => 'InvalidDateError: $message';
}

/// Unsupported or invalid unit.
final class InvalidUnitError extends DomainError {
  const InvalidUnitError(super.message);

  @override
  String toString() => 'InvalidUnitError: $message';
}

/// Invalid quantity or value out of acceptable range.
final class InvalidQuantityError extends DomainError {
  const InvalidQuantityError(super.message);

  @override
  String toString() => 'InvalidQuantityError: $message';
}
