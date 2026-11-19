enum ExperienceLevel {
  beginner('beginner', 'Beginner', 'New to resistance training or less than 1 year'),
  intermediate('intermediate', 'Intermediate', '1-3 years of consistent training'),
  advanced('advanced', 'Advanced', '3+ years of structured training');

  const ExperienceLevel(this.value, this.label, this.description);

  final String value;
  final String label;
  final String description;

  static ExperienceLevel? fromValue(String? value) {
    if (value == null) return null;
    return ExperienceLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ExperienceLevel.beginner,
    );
  }
}
