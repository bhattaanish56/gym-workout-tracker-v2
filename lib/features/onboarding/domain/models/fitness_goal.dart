enum FitnessGoal {
  gainMuscle('gain_muscle', 'Build Muscle', 'Increase muscle mass and strength'),
  loseFat('lose_fat', 'Lose Fat', 'Reduce body fat while maintaining muscle'),
  maintain('maintain', 'Maintain', 'Maintain current physique and fitness'),
  improveStrength('improve_strength', 'Get Stronger', 'Focus on strength gains');

  const FitnessGoal(this.value, this.label, this.description);

  final String value;
  final String label;
  final String description;

  static FitnessGoal? fromValue(String? value) {
    if (value == null) return null;
    return FitnessGoal.values.firstWhere(
      (g) => g.value == value,
      orElse: () => FitnessGoal.maintain,
    );
  }
}
