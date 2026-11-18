import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/features/progress/domain/models/bmi.dart';

void main() {
  group('BMI', () {
    test('calculates BMI correctly', () {
      final bmi = BMI.calculate(heightCm: 175, weightGrams: 70000);
      expect(bmi?.value, closeTo(22.86, 0.01));
    });

    test('returns null for invalid height', () {
      final bmi = BMI.calculate(heightCm: 0, weightGrams: 70000);
      expect(bmi, isNull);
    });

    test('categorizes underweight correctly', () {
      final bmi = BMI(17.5);
      expect(bmi.category, 'Underweight');
    });

    test('categorizes normal weight correctly', () {
      final bmi = BMI(22.0);
      expect(bmi.category, 'Normal');
    });

    test('categorizes overweight correctly', () {
      final bmi = BMI(27.0);
      expect(bmi.category, 'Overweight');
    });

    test('categorizes obese correctly', () {
      final bmi = BMI(32.0);
      expect(bmi.category, 'Obese');
    });
  });
}
