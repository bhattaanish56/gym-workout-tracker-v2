enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  arms('Arms'),
  legs('Legs'),
  core('Core'),
  fullBody('Full Body');

  final String label;
  const MuscleGroup(this.label);

  String toJson() => name;

  static MuscleGroup fromJson(String value) {
    return MuscleGroup.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MuscleGroup.fullBody,
    );
  }
}
