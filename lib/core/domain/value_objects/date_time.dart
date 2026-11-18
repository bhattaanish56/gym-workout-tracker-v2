import '../errors/domain_error.dart';

/// Local calendar date in YYYY-MM-DD format.
///
/// Immutable, validated, timezone-independent.
/// Historical dates remain stable across device timezone changes.
///
/// Year range 1900-2100 is an intentional application constraint
/// sufficient for fitness tracking use cases.
final class LocalDate {
  final int year;
  final int month;
  final int day;

  const LocalDate._(this.year, this.month, this.day);

  /// Creates a LocalDate from year, month, day.
  ///
  /// Throws [InvalidDateError] if date is invalid or out of range.
  factory LocalDate(int year, int month, int day) {
    if (year < 1900 || year > 2100) {
      throw InvalidDateError('Year must be between 1900 and 2100, got $year');
    }
    if (month < 1 || month > 12) {
      throw InvalidDateError('Month must be between 1 and 12, got $month');
    }

    final maxDay = _daysInMonth(year, month);
    if (day < 1 || day > maxDay) {
      throw InvalidDateError(
        'Day must be between 1 and $maxDay for $year-$month, got $day',
      );
    }

    return LocalDate._(year, month, day);
  }

  /// Parses YYYY-MM-DD string.
  ///
  /// Throws [InvalidDateError] if format is invalid.
  factory LocalDate.parse(String value) {
    final parts = value.split('-');
    if (parts.length != 3) {
      throw InvalidDateError('Expected YYYY-MM-DD format, got: $value');
    }

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) {
      throw InvalidDateError('Invalid numeric components in: $value');
    }

    return LocalDate(year, month, day);
  }

  /// Creates LocalDate from DateTime (uses local date components, ignores time).
  factory LocalDate.fromDateTime(DateTime dt) {
    return LocalDate(dt.year, dt.month, dt.day);
  }

  /// Returns YYYY-MM-DD string.
  String toIso8601() {
    return '${year.toString().padLeft(4, '0')}-'
        '${month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }

  static int _daysInMonth(int year, int month) {
    if (month == 2) {
      return _isLeapYear(year) ? 29 : 28;
    }
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      return 30;
    }
    return 31;
  }

  static bool _isLeapYear(int year) {
    if (year % 4 != 0) return false;
    if (year % 100 != 0) return true;
    return year % 400 == 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalDate &&
          year == other.year &&
          month == other.month &&
          day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso8601();
}

/// IANA time zone identifier (e.g., 'America/New_York', 'Asia/Kathmandu').
///
/// Does not validate against full IANA database.
/// Does not perform timezone conversions.
final class TimeZoneId {
  final String value;

  const TimeZoneId._(this.value);

  /// Creates a TimeZoneId from a validated identifier.
  ///
  /// Performs basic format validation only.
  /// Throws [InvalidDateError] if format is clearly invalid.
  factory TimeZoneId(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw const InvalidDateError('TimeZoneId cannot be empty');
    }
    // Basic sanity check: should contain at least one slash for region/city
    if (!trimmed.contains('/')) {
      throw InvalidDateError(
        'TimeZoneId should be in Region/City format, got: $trimmed',
      );
    }
    return TimeZoneId._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TimeZoneId && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// UTC timestamp helpers.
class UtcTimestamp {
  /// Returns current UTC timestamp.
  static DateTime now() => DateTime.now().toUtc();

  /// Ensures DateTime is in UTC.
  static DateTime toUtc(DateTime dt) => dt.toUtc();

  /// Parses ISO 8601 string to UTC DateTime.
  ///
  /// Throws [InvalidDateError] if parsing fails.
  static DateTime parse(String iso8601) {
    try {
      return DateTime.parse(iso8601).toUtc();
    } catch (e) {
      throw InvalidDateError('Invalid ISO 8601 timestamp: $iso8601');
    }
  }

  /// Serializes DateTime to ISO 8601 UTC string.
  static String toIso8601(DateTime dt) {
    return dt.toUtc().toIso8601String();
  }
}
