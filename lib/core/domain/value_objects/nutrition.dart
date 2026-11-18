import '../errors/domain_error.dart';

/// Calorie value (integer, no decimals).
final class Calories {
  final int value;

  const Calories._(this.value);

  /// Creates Calories from integer value.
  ///
  /// Throws [InvalidQuantityError] if negative.
  factory Calories(int value) {
    if (value < 0) {
      throw InvalidQuantityError('Calories cannot be negative: $value');
    }
    return Calories._(value);
  }

  /// Arithmetic operations.
  Calories operator +(Calories other) {
    return Calories(value + other.value);
  }

  Calories operator -(Calories other) {
    final result = value - other.value;
    if (result < 0) {
      throw InvalidQuantityError(
        'Subtraction would result in negative calories',
      );
    }
    return Calories(result);
  }

  bool operator >(Calories other) => value > other.value;
  bool operator >=(Calories other) => value >= other.value;
  bool operator <(Calories other) => value < other.value;
  bool operator <=(Calories other) => value <= other.value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Calories && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '$value kcal';
}

/// Macro nutrient grams (protein, carbs, fat) with 0.1g precision.
///
/// Stored as integer deci-grams (10.5g → 105 dg).
final class MacroGrams {
  final int deciGrams;

  const MacroGrams._(this.deciGrams);

  /// Creates MacroGrams from integer deci-grams.
  ///
  /// Throws [InvalidQuantityError] if negative.
  factory MacroGrams.fromDeciGrams(int deciGrams) {
    if (deciGrams < 0) {
      throw InvalidQuantityError(
        'Macro grams cannot be negative: $deciGrams dg',
      );
    }
    return MacroGrams._(deciGrams);
  }

  /// Creates MacroGrams from grams (converts to deci-grams).
  ///
  /// Input is rounded to 0.1g precision.
  factory MacroGrams.fromGrams(double grams) {
    if (grams < 0) {
      throw InvalidQuantityError('Macro grams cannot be negative: $grams g');
    }
    final deciGrams = (grams * 10).round();
    return MacroGrams._(deciGrams);
  }

  /// Returns display value in grams with 0.1g precision.
  double toGrams() => deciGrams / 10.0;

  /// Arithmetic operations.
  MacroGrams operator +(MacroGrams other) {
    return MacroGrams.fromDeciGrams(deciGrams + other.deciGrams);
  }

  MacroGrams operator -(MacroGrams other) {
    final result = deciGrams - other.deciGrams;
    if (result < 0) {
      throw InvalidQuantityError(
        'Subtraction would result in negative macro grams',
      );
    }
    return MacroGrams.fromDeciGrams(result);
  }

  bool operator >(MacroGrams other) => deciGrams > other.deciGrams;
  bool operator >=(MacroGrams other) => deciGrams >= other.deciGrams;
  bool operator <(MacroGrams other) => deciGrams < other.deciGrams;
  bool operator <=(MacroGrams other) => deciGrams <= other.deciGrams;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacroGrams && deciGrams == other.deciGrams;

  @override
  int get hashCode => deciGrams.hashCode;

  @override
  String toString() => '${toGrams()}g';
}

/// Food quantity representation.
///
/// Supports mass (grams), volume (ml), or count-based portions.
sealed class FoodQuantity {
  const FoodQuantity();
}

/// Mass-based quantity in grams.
final class MassQuantity extends FoodQuantity {
  final int grams;

  const MassQuantity(this.grams);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MassQuantity && grams == other.grams;

  @override
  int get hashCode => grams.hashCode;

  @override
  String toString() => '${grams}g';
}

/// Volume-based quantity in milliliters.
final class VolumeQuantity extends FoodQuantity {
  final int milliliters;

  const VolumeQuantity(this.milliliters);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolumeQuantity && milliliters == other.milliliters;

  @override
  int get hashCode => milliliters.hashCode;

  @override
  String toString() => '${milliliters}ml';
}

/// Count-based quantity (pieces, servings).
final class CountQuantity extends FoodQuantity {
  final double count;
  final String unit;

  const CountQuantity(this.count, this.unit);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountQuantity && count == other.count && unit == other.unit;

  @override
  int get hashCode => Object.hash(count, unit);

  @override
  String toString() => '$count $unit';
}
