import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/errors/domain_error.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/nutrition.dart';

void main() {
  group('Calories', () {
    test('creates valid calories', () {
      final cal = Calories(250);
      expect(cal.value, 250);
    });

    test('rejects negative calories', () {
      expect(() => Calories(-100), throwsA(isA<InvalidQuantityError>()));
    });

    test('addition works', () {
      final c1 = Calories(100);
      final c2 = Calories(50);
      final sum = c1 + c2;
      expect(sum.value, 150);
    });

    test('subtraction works', () {
      final c1 = Calories(100);
      final c2 = Calories(50);
      final diff = c1 - c2;
      expect(diff.value, 50);
    });

    test('subtraction throws on negative result', () {
      final c1 = Calories(50);
      final c2 = Calories(100);
      expect(() => c1 - c2, throwsA(isA<InvalidQuantityError>()));
    });

    test('comparison operators work', () {
      final c1 = Calories(100);
      final c2 = Calories(200);

      expect(c2 > c1, isTrue);
      expect(c1 < c2, isTrue);
      expect(c1 <= c1, isTrue);
    });

    test('equality works', () {
      final c1 = Calories(250);
      final c2 = Calories(250);
      final c3 = Calories(300);

      expect(c1, equals(c2));
      expect(c1, isNot(equals(c3)));
    });

    test('handles zero calories', () {
      final cal = Calories(0);
      expect(cal.value, 0);
    });
  });

  group('MacroGrams', () {
    test('creates from deci-grams', () {
      final macro = MacroGrams.fromDeciGrams(105);
      expect(macro.deciGrams, 105);
      expect(macro.toGrams(), 10.5);
    });

    test('creates from grams with rounding', () {
      final m1 = MacroGrams.fromGrams(10.5);
      expect(m1.deciGrams, 105);

      final m2 = MacroGrams.fromGrams(10.55);
      expect(m2.deciGrams, 106); // rounds to 0.1g

      final m3 = MacroGrams.fromGrams(10.54);
      expect(m3.deciGrams, 105);
    });

    test('rejects negative deci-grams', () {
      expect(
        () => MacroGrams.fromDeciGrams(-10),
        throwsA(isA<InvalidQuantityError>()),
      );
    });

    test('rejects negative grams', () {
      expect(
        () => MacroGrams.fromGrams(-5.0),
        throwsA(isA<InvalidQuantityError>()),
      );
    });

    test('toGrams returns correct precision', () {
      final macro = MacroGrams.fromDeciGrams(253);
      expect(macro.toGrams(), 25.3);
    });

    test('addition works', () {
      final m1 = MacroGrams.fromGrams(10.5);
      final m2 = MacroGrams.fromGrams(5.2);
      final sum = m1 + m2;
      expect(sum.toGrams(), closeTo(15.7, 0.01));
    });

    test('subtraction works', () {
      final m1 = MacroGrams.fromGrams(10.5);
      final m2 = MacroGrams.fromGrams(5.2);
      final diff = m1 - m2;
      expect(diff.toGrams(), closeTo(5.3, 0.01));
    });

    test('subtraction throws on negative result', () {
      final m1 = MacroGrams.fromGrams(5.0);
      final m2 = MacroGrams.fromGrams(10.0);
      expect(() => m1 - m2, throwsA(isA<InvalidQuantityError>()));
    });

    test('comparison operators work', () {
      final m1 = MacroGrams.fromGrams(10.0);
      final m2 = MacroGrams.fromGrams(20.0);

      expect(m2 > m1, isTrue);
      expect(m1 < m2, isTrue);
      expect(m1 >= m1, isTrue);
    });

    test('equality works', () {
      final m1 = MacroGrams.fromGrams(10.5);
      final m2 = MacroGrams.fromGrams(10.5);
      final m3 = MacroGrams.fromGrams(10.6);

      expect(m1, equals(m2));
      expect(m1, isNot(equals(m3)));
    });

    test('handles zero grams', () {
      final macro = MacroGrams.fromGrams(0.0);
      expect(macro.deciGrams, 0);
      expect(macro.toGrams(), 0.0);
    });

    test('handles large values', () {
      final macro = MacroGrams.fromGrams(200.5);
      expect(macro.deciGrams, 2005);
      expect(macro.toGrams(), 200.5);
    });
  });

  group('FoodQuantity', () {
    test('MassQuantity creates correctly', () {
      final mass = MassQuantity(150);
      expect(mass.grams, 150);
    });

    test('MassQuantity equality works', () {
      final m1 = MassQuantity(100);
      final m2 = MassQuantity(100);
      final m3 = MassQuantity(200);

      expect(m1, equals(m2));
      expect(m1, isNot(equals(m3)));
    });

    test('VolumeQuantity creates correctly', () {
      final vol = VolumeQuantity(250);
      expect(vol.milliliters, 250);
    });

    test('VolumeQuantity equality works', () {
      final v1 = VolumeQuantity(200);
      final v2 = VolumeQuantity(200);
      final v3 = VolumeQuantity(300);

      expect(v1, equals(v2));
      expect(v1, isNot(equals(v3)));
    });

    test('CountQuantity creates correctly', () {
      final count = CountQuantity(2.5, 'cups');
      expect(count.count, 2.5);
      expect(count.unit, 'cups');
    });

    test('CountQuantity equality works', () {
      final c1 = CountQuantity(2.0, 'pieces');
      final c2 = CountQuantity(2.0, 'pieces');
      final c3 = CountQuantity(3.0, 'pieces');
      final c4 = CountQuantity(2.0, 'servings');

      expect(c1, equals(c2));
      expect(c1, isNot(equals(c3)));
      expect(c1, isNot(equals(c4)));
    });

    test('different quantity types are not equal', () {
      final mass = MassQuantity(100);
      final vol = VolumeQuantity(100);
      final count = CountQuantity(100, 'grams');

      expect(mass, isNot(equals(vol)));
      expect(mass, isNot(equals(count)));
      expect(vol, isNot(equals(count)));
    });
  });
}
