import 'package:drift/drift.dart';
import '../../../../core/domain/value_objects/identifiers.dart';
import '../../../../core/domain/value_objects/date_time.dart';
import '../../../sessions/data/database/app_database.dart';
import '../../domain/models/bodyweight_entry.dart' as domain;

class DriftProgressRepository {
  final AppDatabase _db;
  final String userId;

  DriftProgressRepository(this._db, this.userId);

  Future<void> addBodyWeight({
    required RecordId id,
    required int weightGrams,
    required DateTime measuredAt,
    required LocalDate measuredDate,
    String? notes,
  }) async {
    await _db
        .into(_db.bodyWeightEntries)
        .insert(
          BodyWeightEntriesCompanion.insert(
            id: id.value,
            userId: Value(userId),
            weightGrams: weightGrams,
            measuredAt: measuredAt,
            measuredDate: measuredDate.toIso8601(),
            notes: Value(notes),
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> updateBodyWeight({
    required RecordId id,
    required int weightGrams,
    required DateTime measuredAt,
    required LocalDate measuredDate,
    String? notes,
  }) async {
    await (_db.update(
      _db.bodyWeightEntries,
    )..where((t) => t.id.equals(id.value) & t.userId.equals(userId))).write(
      BodyWeightEntriesCompanion(
        weightGrams: Value(weightGrams),
        measuredAt: Value(measuredAt),
        measuredDate: Value(measuredDate.toIso8601()),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deleteBodyWeight(RecordId id) async {
    await (_db.delete(
      _db.bodyWeightEntries,
    )..where((t) => t.id.equals(id.value) & t.userId.equals(userId))).go();
  }

  Future<List<domain.BodyWeightEntry>> getBodyWeightHistory({
    int limit = 100,
    DateTime? startDate,
  }) async {
    final query = _db.select(_db.bodyWeightEntries)
      ..where((t) => t.userId.equals(userId));

    if (startDate != null) {
      query.where((t) => t.measuredAt.isBiggerOrEqualValue(startDate));
    }

    query
      ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)])
      ..limit(limit);

    final rows = await query.get();
    return rows.map(_mapToBodyWeightEntry).toList();
  }

  Future<domain.BodyWeightEntry?> getLatestBodyWeight() async {
    final row =
        await (_db.select(_db.bodyWeightEntries)
              ..where((t) => t.userId.equals(userId))
              ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)])
              ..limit(1))
            .getSingleOrNull();

    return row == null ? null : _mapToBodyWeightEntry(row);
  }

  Future<void> setHeight(int heightCm, String userIdParam) async {
    final exists = await (_db.select(_db.userProfile)
          ..where((t) => t.userId.equals(userIdParam)))
        .getSingleOrNull();
    if (exists != null) {
      await (_db.update(_db.userProfile)
            ..where((t) => t.userId.equals(userIdParam)))
          .write(
        UserProfileCompanion(
          heightCm: Value(heightCm),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    } else {
      await _db.into(_db.userProfile).insert(
            UserProfileCompanion.insert(
              userId: userIdParam,
              heightCm: Value(heightCm),
              updatedAt: DateTime.now().toUtc(),
            ),
          );
    }
  }

  Future<int?> getHeight(String userIdParam) async {
    final row = await (_db.select(_db.userProfile)
          ..where((t) => t.userId.equals(userIdParam)))
        .getSingleOrNull();
    return row?.heightCm;
  }

  domain.BodyWeightEntry _mapToBodyWeightEntry(BodyWeightEntry row) {
    return domain.BodyWeightEntry(
      id: RecordId(row.id),
      weightGrams: row.weightGrams,
      measuredAt: row.measuredAt,
      measuredDate: LocalDate.parse(row.measuredDate),
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }
}
