enum Equipment {
  barbell('Barbell'),
  dumbbell('Dumbbell'),
  bodyweight('Bodyweight'),
  machine('Machine'),
  cable('Cable'),
  kettlebell('Kettlebell'),
  band('Band'),
  other('Other');

  final String label;
  const Equipment(this.label);

  String toJson() => name;

  static Equipment fromJson(String value) {
    return Equipment.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Equipment.other,
    );
  }
}
