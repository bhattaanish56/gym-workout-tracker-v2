import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/weight.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/nutrition.dart';

void main() {
  group('Web integer safety', () {
    test('weight grams within safe integer range', () {
      // JavaScript safe integer: 2^53-1 = 9007199254740991
      // Max weight in test: 500000 grams (500 kg)
      // DATA-CONTRACT.md: 1,000,000g max (1000 kg)
      final maxRealistic = WeightGrams(1000000);
      expect(maxRealistic.grams, 1000000);
      expect(maxRealistic.grams < 9007199254740991, isTrue);
    });

    test('macro deci-grams within safe integer range', () {
      // Max realistic: 300g protein = 3000 dg
      final large = MacroGrams.fromGrams(300.0);
      expect(large.deciGrams, 3000);
      expect(large.deciGrams < 9007199254740991, isTrue);
    });

    test('calories within safe integer range', () {
      // Max from DATA-CONTRACT: 100,000 per entry
      final maxCalories = Calories(100000);
      expect(maxCalories.value, 100000);
      expect(maxCalories.value < 9007199254740991, isTrue);
    });

    test('arithmetic does not overflow JavaScript integers', () {
      // Sum of large weights
      final w1 = WeightGrams(500000);
      final w2 = WeightGrams(500000);
      final sum = w1 + w2;
      expect(sum.grams, 1000000);
      expect(sum.grams < 9007199254740991, isTrue);
    });
  });
}
