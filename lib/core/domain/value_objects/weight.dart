import '../errors/domain_error.dart';

/// Weight unit for display.
enum WeightUnit {
  kg,
  lb;

  @override
  String toString() => name;
}

/// Canonical weight representation in integer grams.
///
/// Used for body weight and exercise resistance.
/// Display conversion handled separately via [displayValue].
final class WeightGrams {
  final int grams;

  const WeightGrams._(this.grams);

  /// Creates weight from integer grams.
  ///
  /// Throws [InvalidQuantityError] if negative.
  factory WeightGrams(int grams) {
    if (grams < 0) {
      throw InvalidQuantityError('Weight cannot be negative: $grams');
    }
    return WeightGrams._(grams);
  }

  /// Creates weight from kilograms (converts to grams).
  ///
  /// Input is rounded to nearest gram before storage.
  factory WeightGrams.fromKg(double kg) {
    if (kg < 0) {
      throw InvalidQuantityError('Weight cannot be negative: $kg kg');
    }
    final grams = (kg * 1000).round();
    return WeightGrams._(grams);
  }

  /// Creates weight from pounds (converts to grams).
  ///
  /// Input is rounded to nearest gram before storage.
  factory WeightGrams.fromLb(double lb) {
    if (lb < 0) {
      throw InvalidQuantityError('Weight cannot be negative: $lb lb');
    }
    // 1 lb = 453.59237 grams
    final grams = (lb * 453.59237).round();
    return WeightGrams._(grams);
  }

  /// Returns display value in specified unit, rounded appropriately.
  ///
  /// kg: rounded to 0.1 kg (100g precision for display)
  /// lb: rounded to 0.1 lb
  double displayValue(WeightUnit unit) {
    switch (unit) {
      case WeightUnit.kg:
        return (grams / 1000.0 * 10).round() / 10.0;
      case WeightUnit.lb:
        final lb = grams / 453.59237;
        return (lb * 10).round() / 10.0;
    }
  }

  /// Exact kg value without display rounding (for calculations).
  double toKg() => grams / 1000.0;

  /// Exact lb value without display rounding (for calculations).
  double toLb() => grams / 453.59237;

  /// Arithmetic operations.
  WeightGrams operator +(WeightGrams other) {
    return WeightGrams(grams + other.grams);
  }

  WeightGrams operator -(WeightGrams other) {
    final result = grams - other.grams;
    if (result < 0) {
      throw InvalidQuantityError('Subtraction would result in negative weight');
    }
    return WeightGrams(result);
  }

  bool operator >(WeightGrams other) => grams > other.grams;
  bool operator >=(WeightGrams other) => grams >= other.grams;
  bool operator <(WeightGrams other) => grams < other.grams;
  bool operator <=(WeightGrams other) => grams <= other.grams;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WeightGrams && grams == other.grams;

  @override
  int get hashCode => grams.hashCode;

  @override
  String toString() => '${displayValue(WeightUnit.kg)} kg';
}
