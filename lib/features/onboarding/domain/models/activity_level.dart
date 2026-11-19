enum ActivityLevel {
  sedentary('sedentary', 'Sedentary', 'Little to no exercise', 1.2),
  lightlyActive('lightly_active', 'Lightly Active', 'Light exercise 1-3 days/week', 1.375),
  moderatelyActive('moderately_active', 'Moderately Active', 'Moderate exercise 3-5 days/week', 1.55),
  veryActive('very_active', 'Very Active', 'Hard exercise 6-7 days/week', 1.725),
  extremelyActive('extremely_active', 'Extremely Active', 'Very hard exercise, physical job', 1.9);

  const ActivityLevel(this.value, this.label, this.description, this.multiplier);

  final String value;
  final String label;
  final String description;
  final double multiplier;

  static ActivityLevel? fromValue(String? value) {
    if (value == null) return null;
    return ActivityLevel.values.firstWhere(
      (a) => a.value == value,
      orElse: () => ActivityLevel.moderatelyActive,
    );
  }
}
