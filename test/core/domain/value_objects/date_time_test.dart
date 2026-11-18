import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/errors/domain_error.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/date_time.dart';

void main() {
  group('LocalDate', () {
    test('creates valid date', () {
      final date = LocalDate(2024, 3, 15);
      expect(date.year, 2024);
      expect(date.month, 3);
      expect(date.day, 15);
    });

    test('parses YYYY-MM-DD correctly', () {
      final date = LocalDate.parse('2024-03-15');
      expect(date.year, 2024);
      expect(date.month, 3);
      expect(date.day, 15);
    });

    test('validates leap year February 29', () {
      expect(() => LocalDate(2024, 2, 29), returnsNormally);
      expect(() => LocalDate(2023, 2, 29), throwsA(isA<InvalidDateError>()));
      expect(() => LocalDate(2000, 2, 29), returnsNormally);
      expect(() => LocalDate(1900, 2, 29), throwsA(isA<InvalidDateError>()));
    });

    test('validates month boundaries', () {
      expect(() => LocalDate(2024, 0, 1), throwsA(isA<InvalidDateError>()));
      expect(() => LocalDate(2024, 13, 1), throwsA(isA<InvalidDateError>()));
    });

    test('validates day boundaries', () {
      expect(() => LocalDate(2024, 1, 0), throwsA(isA<InvalidDateError>()));
      expect(() => LocalDate(2024, 1, 32), throwsA(isA<InvalidDateError>()));
      expect(() => LocalDate(2024, 4, 31), throwsA(isA<InvalidDateError>()));
    });

    test('validates year range', () {
      expect(() => LocalDate(1899, 1, 1), throwsA(isA<InvalidDateError>()));
      expect(() => LocalDate(2101, 1, 1), throwsA(isA<InvalidDateError>()));
      expect(() => LocalDate(1900, 1, 1), returnsNormally);
      expect(() => LocalDate(2100, 12, 31), returnsNormally);
    });

    test('toIso8601 formats correctly', () {
      expect(LocalDate(2024, 3, 5).toIso8601(), '2024-03-05');
      expect(LocalDate(2024, 12, 31).toIso8601(), '2024-12-31');
    });

    test('fromDateTime extracts date components', () {
      final dt = DateTime.utc(2024, 3, 15, 10, 30, 45);
      final date = LocalDate.fromDateTime(dt);

      expect(date.year, 2024);
      expect(date.month, 3);
      expect(date.day, 15);
    });

    test('equality works', () {
      final d1 = LocalDate(2024, 3, 15);
      final d2 = LocalDate(2024, 3, 15);
      final d3 = LocalDate(2024, 3, 16);

      expect(d1, equals(d2));
      expect(d1, isNot(equals(d3)));
    });

    test('throws on invalid parse format', () {
      expect(
        () => LocalDate.parse('2024/03/15'),
        throwsA(isA<InvalidDateError>()),
      );
      expect(() => LocalDate.parse('2024-3-15'), returnsNormally);
      expect(
        () => LocalDate.parse('invalid'),
        throwsA(isA<InvalidDateError>()),
      );
    });
  });

  group('TimeZoneId', () {
    test('creates valid timezone', () {
      final tz = TimeZoneId('America/New_York');
      expect(tz.value, 'America/New_York');
    });

    test('validates format requires slash', () {
      expect(() => TimeZoneId('UTC'), throwsA(isA<InvalidDateError>()));
      expect(() => TimeZoneId('America/New_York'), returnsNormally);
    });

    test('throws on empty', () {
      expect(() => TimeZoneId(''), throwsA(isA<InvalidDateError>()));
    });

    test('equality works', () {
      final tz1 = TimeZoneId('Asia/Tokyo');
      final tz2 = TimeZoneId('Asia/Tokyo');
      final tz3 = TimeZoneId('Europe/London');

      expect(tz1, equals(tz2));
      expect(tz1, isNot(equals(tz3)));
    });
  });

  group('UtcTimestamp', () {
    test('now returns UTC', () {
      final now = UtcTimestamp.now();
      expect(now.isUtc, isTrue);
    });

    test('toUtc converts to UTC', () {
      final local = DateTime(2024, 3, 15, 10, 30);
      final utc = UtcTimestamp.toUtc(local);
      expect(utc.isUtc, isTrue);
    });

    test('parse handles ISO 8601', () {
      final dt = UtcTimestamp.parse('2024-03-15T10:30:00Z');
      expect(dt.isUtc, isTrue);
      expect(dt.year, 2024);
      expect(dt.month, 3);
      expect(dt.day, 15);
    });

    test('toIso8601 serializes correctly', () {
      final dt = DateTime.utc(2024, 3, 15, 10, 30, 45);
      final iso = UtcTimestamp.toIso8601(dt);
      expect(iso, contains('2024-03-15'));
      expect(iso, contains('10:30:45'));
    });

    test('parse throws on invalid format', () {
      expect(
        () => UtcTimestamp.parse('invalid'),
        throwsA(isA<InvalidDateError>()),
      );
    });
  });
}
