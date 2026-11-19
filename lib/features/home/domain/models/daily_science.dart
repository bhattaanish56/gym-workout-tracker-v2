/// Temporary presentation model for Daily Science card
/// TODO: Replace with actual science library backend
class DailyScience {
  final String category;
  final String muscleGroup;
  final String insight;
  final String? sourceUrl;

  const DailyScience({
    required this.category,
    required this.muscleGroup,
    required this.insight,
    this.sourceUrl,
  });

  // Sample insights for MVP (explicitly labeled as temporary)
  static const sample = DailyScience(
    category: 'Hypertrophy',
    muscleGroup: 'Calves',
    insight: 'Calves may grow more from training in a stretched (lengthened) position.',
    sourceUrl: null,
  );
}
