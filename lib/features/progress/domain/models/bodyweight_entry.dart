import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/value_objects/date_time.dart';

class BodyWeightEntry {
  final RecordId id;
  final int weightGrams;
  final DateTime measuredAt;
  final LocalDate measuredDate;
  final String? notes;
  final DateTime createdAt;

  const BodyWeightEntry({
    required this.id,
    required this.weightGrams,
    required this.measuredAt,
    required this.measuredDate,
    this.notes,
    required this.createdAt,
  });

  double get weightKg => weightGrams / 1000;
}
