import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/errors/domain_error.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';

void main() {
  group('RecordId', () {
    test('creates valid RecordId from non-empty string', () {
      final id = RecordId('abc-123');
      expect(id.value, 'abc-123');
    });

    test('trims whitespace', () {
      final id = RecordId('  abc-123  ');
      expect(id.value, 'abc-123');
    });

    test('throws on empty string', () {
      expect(() => RecordId(''), throwsA(isA<InvalidIdentifierError>()));
    });

    test('throws on whitespace-only string', () {
      expect(() => RecordId('   '), throwsA(isA<InvalidIdentifierError>()));
    });

    test('equality works', () {
      final id1 = RecordId('abc');
      final id2 = RecordId('abc');
      final id3 = RecordId('xyz');

      expect(id1, equals(id2));
      expect(id1, isNot(equals(id3)));
    });

    test('hashCode consistent', () {
      final id1 = RecordId('abc');
      final id2 = RecordId('abc');

      expect(id1.hashCode, equals(id2.hashCode));
    });

    test('toString returns value', () {
      final id = RecordId('test-id');
      expect(id.toString(), 'test-id');
    });
  });

  group('UserId', () {
    test('creates valid UserId from non-empty string', () {
      final id = UserId('user-123');
      expect(id.value, 'user-123');
    });

    test('trims whitespace', () {
      final id = UserId('  user-123  ');
      expect(id.value, 'user-123');
    });

    test('throws on empty string', () {
      expect(() => UserId(''), throwsA(isA<InvalidIdentifierError>()));
    });

    test('equality works', () {
      final id1 = UserId('u1');
      final id2 = UserId('u1');
      final id3 = UserId('u2');

      expect(id1, equals(id2));
      expect(id1, isNot(equals(id3)));
    });
  });

  group('OperationId', () {
    test('creates valid OperationId from non-empty string', () {
      final id = OperationId('op-456');
      expect(id.value, 'op-456');
    });

    test('throws on empty string', () {
      expect(() => OperationId(''), throwsA(isA<InvalidIdentifierError>()));
    });

    test('equality works', () {
      final id1 = OperationId('op1');
      final id2 = OperationId('op1');
      final id3 = OperationId('op2');

      expect(id1, equals(id2));
      expect(id1, isNot(equals(id3)));
    });
  });
}
