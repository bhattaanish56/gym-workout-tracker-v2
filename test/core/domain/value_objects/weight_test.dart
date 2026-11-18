import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/errors/domain_error.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/weight.dart';

void main() {
  group('WeightGrams', () {
    test('creates weight from grams', () {
      final weight = WeightGrams(5000);
      expect(weight.grams, 5000);
    });

    test('rejects negative grams', () {
      expect(() => WeightGrams(-100), throwsA(isA<InvalidQuantityError>()));
    });

    test('creates from kg with rounding', () {
      final w1 = WeightGrams.fromKg(10.5);
      expect(w1.grams, 10500);

      final w2 = WeightGrams.fromKg(10.5555);
      expect(w2.grams, 10556); // rounds to nearest gram
    });

    test('creates from lb with rounding', () {
      final w1 = WeightGrams.fromLb(100.0);
      expect(w1.grams, 45359); // 100 * 453.59237 rounded

      final w2 = WeightGrams.fromLb(45.0);
      expect(w2.grams, 20412);
    });

    test('rejects negative kg', () {
      expect(
        () => WeightGrams.fromKg(-5.0),
        throwsA(isA<InvalidQuantityError>()),
      );
    });

    test('rejects negative lb', () {
      expect(
        () => WeightGrams.fromLb(-10.0),
        throwsA(isA<InvalidQuantityError>()),
      );
    });

    test('displayValue rounds to 0.1 kg', () {
      final w1 = WeightGrams(10555); // 10.555 kg
      expect(w1.displayValue(WeightUnit.kg), 10.6);

      final w2 = WeightGrams(10544); // 10.544 kg
      expect(w2.displayValue(WeightUnit.kg), 10.5);
    });

    test('displayValue rounds to 0.1 lb', () {
      final w1 = WeightGrams(45359); // ~100 lb
      final display = w1.displayValue(WeightUnit.lb);
      expect(display, closeTo(100.0, 0.1));
    });

    test('toKg exact conversion', () {
      final weight = WeightGrams(5000);
      expect(weight.toKg(), 5.0);
    });

    test('toLb exact conversion', () {
      final weight = WeightGrams(45359);
      expect(weight.toLb(), closeTo(100.0, 0.01));
    });

    test('addition works', () {
      final w1 = WeightGrams(1000);
      final w2 = WeightGrams(2000);
      final sum = w1 + w2;
      expect(sum.grams, 3000);
    });

    test('subtraction works', () {
      final w1 = WeightGrams(5000);
      final w2 = WeightGrams(2000);
      final diff = w1 - w2;
      expect(diff.grams, 3000);
    });

    test('subtraction throws on negative result', () {
      final w1 = WeightGrams(1000);
      final w2 = WeightGrams(2000);
      expect(() => w1 - w2, throwsA(isA<InvalidQuantityError>()));
    });

    test('comparison operators work', () {
      final w1 = WeightGrams(1000);
      final w2 = WeightGrams(2000);
      final w3 = WeightGrams(1000);

      expect(w2 > w1, isTrue);
      expect(w1 < w2, isTrue);
      expect(w1 >= w3, isTrue);
      expect(w1 <= w3, isTrue);
    });

    test('equality works', () {
      final w1 = WeightGrams(5000);
      final w2 = WeightGrams(5000);
      final w3 = WeightGrams(6000);

      expect(w1, equals(w2));
      expect(w1, isNot(equals(w3)));
    });

    test('handles zero weight', () {
      final weight = WeightGrams(0);
      expect(weight.grams, 0);
      expect(weight.displayValue(WeightUnit.kg), 0.0);
    });

    test('handles large weights', () {
      final weight = WeightGrams(500000); // 500 kg
      expect(weight.displayValue(WeightUnit.kg), 500.0);
    });

    test('kg to lb round-trip approximately preserves value', () {
      final originalKg = 80.5;
      final weight = WeightGrams.fromKg(originalKg);
      final roundTrip = weight.displayValue(WeightUnit.kg);
      expect(roundTrip, closeTo(originalKg, 0.1));
    });
  });
}
