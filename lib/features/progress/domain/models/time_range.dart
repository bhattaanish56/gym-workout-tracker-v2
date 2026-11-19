enum TimeRange {
  week,
  month,
  threeMonths,
  allTime;

  String get label {
    switch (this) {
      case TimeRange.week:
        return 'This Week';
      case TimeRange.month:
        return 'This Month';
      case TimeRange.threeMonths:
        return '3 Months';
      case TimeRange.allTime:
        return 'All Time';
    }
  }

  DateTime? getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case TimeRange.week:
        return now.subtract(Duration(days: now.weekday - 1));
      case TimeRange.month:
        return DateTime(now.year, now.month, 1);
      case TimeRange.threeMonths:
        return DateTime(now.year, now.month - 3, now.day);
      case TimeRange.allTime:
        return null;
    }
  }
}
