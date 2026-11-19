import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/date_time.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/database/app_database.dart';
import 'package:gym_workout_tracker_v2/features/progress/data/repositories/drift_progress_repository.dart';

void main() {
  late AppDatabase db;
  late DriftProgressRepository repo;

  setUp(() {
    db = AppDatabase.withQueryExecutor(NativeDatabase.memory());
    repo = DriftProgressRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('DriftProgressRepository', () {
    test('adds body weight entry', () async {
      final id = RecordId('test-id');
      final now = DateTime.now();
      final date = LocalDate.fromDateTime(now);

      await repo.addBodyWeight(
        id: id,
        weightGrams: 70000,
        measuredAt: now,
        measuredDate: date,
        notes: 'Test note',
      );

      final entries = await repo.getBodyWeightHistory();
      expect(entries.length, 1);
      expect(entries[0].weightGrams, 70000);
      expect(entries[0].notes, 'Test note');
    });

    test('gets latest body weight', () async {
      final date1 = DateTime(2026, 11, 1);
      final date2 = DateTime(2026, 11, 15);

      await repo.addBodyWeight(
        id: RecordId('id1'),
        weightGrams: 70000,
        measuredAt: date1,
        measuredDate: LocalDate.fromDateTime(date1),
      );

      await repo.addBodyWeight(
        id: RecordId('id2'),
        weightGrams: 72000,
        measuredAt: date2,
        measuredDate: LocalDate.fromDateTime(date2),
      );

      final latest = await repo.getLatestBodyWeight();
      expect(latest?.weightGrams, 72000);
    });

    test('sets and gets height', () async {
      const userId = 'test-user';
      await repo.setHeight(175, userId);
      final height = await repo.getHeight(userId);
      expect(height, 175);
    });

    test('updates height', () async {
      const userId = 'test-user';
      await repo.setHeight(175, userId);
      await repo.setHeight(180, userId);
      final height = await repo.getHeight(userId);
      expect(height, 180);
    });

    test('deletes body weight entry', () async {
      final id = RecordId('test-id');
      await repo.addBodyWeight(
        id: id,
        weightGrams: 70000,
        measuredAt: DateTime.now(),
        measuredDate: LocalDate.fromDateTime(DateTime.now()),
      );

      await repo.deleteBodyWeight(id);
      final entries = await repo.getBodyWeightHistory();
      expect(entries.length, 0);
    });
  });
}
