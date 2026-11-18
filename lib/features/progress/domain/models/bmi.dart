class BMI {
  final double value;

  const BMI(this.value);

  String get category {
    if (value < 18.5) return 'Underweight';
    if (value < 25) return 'Normal';
    if (value < 30) return 'Overweight';
    return 'Obese';
  }

  static BMI? calculate({required int heightCm, required int weightGrams}) {
    if (heightCm <= 0) return null;
    final heightM = heightCm / 100;
    final weightKg = weightGrams / 1000;
    final bmi = weightKg / (heightM * heightM);
    return BMI(bmi);
  }
}
