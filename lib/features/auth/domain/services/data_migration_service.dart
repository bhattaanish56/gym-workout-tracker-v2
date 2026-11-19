import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import '../../../sessions/data/database/app_database.dart';

/// Service to detect and migrate guest data to authenticated user accounts.
class DataMigrationService {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;

  DataMigrationService(this._db, this._firestore);

  /// Check if local guest data exists (records with null userId).
  Future<GuestDataStatus> checkGuestData() async {
    final guestSessions = await (_db.select(_db.workoutSessions)
          ..where((t) => t.userId.isNull()))
        .get();
    final guestPrograms =
        await (_db.select(_db.programs)..where((t) => t.userId.isNull()))
            .get();
    final guestExercises = await (_db.select(_db.customExercises)
          ..where((t) => t.userId.isNull()))
        .get();
    final guestBodyWeight = await (_db.select(_db.bodyWeightEntries)
          ..where((t) => t.userId.isNull()))
        .get();

    final hasGuestData = guestSessions.isNotEmpty ||
        guestPrograms.isNotEmpty ||
        guestExercises.isNotEmpty ||
        guestBodyWeight.isNotEmpty;

    return GuestDataStatus(
      hasGuestData: hasGuestData,
      sessionCount: guestSessions.length,
      programCount: guestPrograms.length,
      exerciseCount: guestExercises.length,
      bodyWeightCount: guestBodyWeight.length,
    );
  }

  /// Check if cloud data exists for the given user.
  Future<bool> hasCloudData(String userId) async {
    try {
      final sessions = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workoutSessions')
          .limit(1)
          .get();
      return sessions.docs.isNotEmpty;
    } catch (e) {
      // Network error or Firestore not initialized - assume no cloud data
      return false;
    }
  }

  /// Import guest data to user account. Non-destructive - keeps guest records.
  Future<ImportResult> importGuestData(String userId) async {
    int imported = 0;
    int skipped = 0;
    final errors = <String>[];

    try {
      // Import custom exercises
      final guestExercises = await (_db.select(_db.customExercises)
            ..where((t) => t.userId.isNull()))
          .get();
      for (final ex in guestExercises) {
        try {
          // Check for duplicate by name
          final existing = await _firestore
              .collection('users')
              .doc(userId)
              .collection('customExercises')
              .where('name', isEqualTo: ex.name)
              .limit(1)
              .get();

          if (existing.docs.isEmpty) {
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('customExercises')
                .doc(ex.id)
                .set({
              'name': ex.name,
              'equipment': ex.equipment,
              'primaryMuscle': ex.primaryMuscle,
              'instructions': ex.instructions,
              'createdAt': ex.createdAt.toIso8601String(),
            });
            imported++;
          } else {
            skipped++;
          }
        } catch (e) {
          errors.add('Exercise ${ex.name}: $e');
        }
      }

      // Import programs
      final guestPrograms =
          await (_db.select(_db.programs)..where((t) => t.userId.isNull()))
              .get();
      for (final prog in guestPrograms) {
        try {
          // Get program days and planned exercises
          final days = await (_db.select(_db.programDays)
                ..where((t) => t.programId.equals(prog.id)))
              .get();
          final dayData = <Map<String, dynamic>>[];

          for (final day in days) {
            final exercises = await (_db.select(_db.plannedExercises)
                  ..where((t) => t.programDayId.equals(day.id)))
                .get();
            dayData.add({
              'id': day.id,
              'orderIndex': day.orderIndex,
              'name': day.name,
              'targetDescription': day.targetDescription,
              'exercises': exercises.map((e) => {
                'id': e.id,
                'exerciseId': e.exerciseId,
                'orderIndex': e.orderIndex,
                'targetSets': e.targetSets,
                'targetRepsMin': e.targetRepsMin,
                'targetRepsMax': e.targetRepsMax,
                'targetLoadGrams': e.targetLoadGrams,
                'restSeconds': e.restSeconds,
                'notes': e.notes,
              }).toList(),
            });
          }

          await _firestore
              .collection('users')
              .doc(userId)
              .collection('programs')
              .doc(prog.id)
              .set({
            'name': prog.name,
            'description': prog.description,
            'scheduleMode': prog.scheduleMode,
            'status': prog.status,
            'createdAt': prog.createdAt.toIso8601String(),
            'updatedAt': prog.updatedAt.toIso8601String(),
            'days': dayData,
          });
          imported++;
        } catch (e) {
          errors.add('Program ${prog.name}: $e');
        }
      }

      // Import workout sessions
      final guestSessions = await (_db.select(_db.workoutSessions)
            ..where((t) => t.userId.isNull()))
          .get();
      for (final session in guestSessions) {
        try {
          final exercises = await (_db.select(_db.performedExercises)
                ..where((t) => t.sessionId.equals(session.id)))
              .get();
          final exerciseData = <Map<String, dynamic>>[];

          for (final ex in exercises) {
            final sets = await (_db.select(_db.performedSets)
                  ..where((t) => t.performedExerciseId.equals(ex.id)))
                .get();
            exerciseData.add({
              'id': ex.id,
              'orderIndex': ex.orderIndex,
              'snapshotJson': ex.snapshotJson,
              'notes': ex.notes,
              'sets': sets.map((s) => {
                'id': s.id,
                'orderIndex': s.orderIndex,
                'setType': s.setType,
                'loadGrams': s.loadGrams,
                'reps': s.reps,
                'completed': s.completed,
                'notes': s.notes,
              }).toList(),
            });
          }

          await _firestore
              .collection('users')
              .doc(userId)
              .collection('workoutSessions')
              .doc(session.id)
              .set({
            'sourceType': session.sourceType,
            'startedAt': session.startedAt.toIso8601String(),
            'finishedAt': session.finishedAt?.toIso8601String(),
            'workoutDate': session.workoutDate,
            'status': session.status,
            'programId': session.programId,
            'programDayId': session.programDayId,
            'programSnapshot': session.programSnapshot,
            'fulfilledScheduledDate': session.fulfilledScheduledDate,
            'createdAt': session.createdAt.toIso8601String(),
            'updatedAt': session.updatedAt.toIso8601String(),
            'exercises': exerciseData,
          });
          imported++;
        } catch (e) {
          errors.add('Session ${session.id}: $e');
        }
      }

      // Import body weight entries
      final guestBodyWeight = await (_db.select(_db.bodyWeightEntries)
            ..where((t) => t.userId.isNull()))
          .get();
      for (final entry in guestBodyWeight) {
        try {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('bodyWeightEntries')
              .doc(entry.id)
              .set({
            'weightGrams': entry.weightGrams,
            'measuredAt': entry.measuredAt.toIso8601String(),
            'measuredDate': entry.measuredDate,
            'notes': entry.notes,
            'createdAt': entry.createdAt.toIso8601String(),
          });
          imported++;
        } catch (e) {
          errors.add('Body weight ${entry.id}: $e');
        }
      }

      return ImportResult(
        success: errors.isEmpty,
        imported: imported,
        skipped: skipped,
        errors: errors,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        imported: imported,
        skipped: skipped,
        errors: [...errors, 'Fatal: $e'],
      );
    }
  }

  /// Mark guest records as imported by setting their userId.
  Future<void> markGuestDataAsImported(String userId) async {
    await _db.transaction(() async {
      await (_db.update(_db.workoutSessions)
            ..where((t) => t.userId.isNull()))
          .write(WorkoutSessionsCompanion(userId: Value(userId)));
      await (_db.update(_db.programs)..where((t) => t.userId.isNull()))
          .write(ProgramsCompanion(userId: Value(userId)));
      await (_db.update(_db.customExercises)..where((t) => t.userId.isNull()))
          .write(CustomExercisesCompanion(userId: Value(userId)));
      await (_db.update(_db.bodyWeightEntries)
            ..where((t) => t.userId.isNull()))
          .write(BodyWeightEntriesCompanion(userId: Value(userId)));
    });
  }
}

class GuestDataStatus {
  final bool hasGuestData;
  final int sessionCount;
  final int programCount;
  final int exerciseCount;
  final int bodyWeightCount;

  GuestDataStatus({
    required this.hasGuestData,
    required this.sessionCount,
    required this.programCount,
    required this.exerciseCount,
    required this.bodyWeightCount,
  });

  int get totalCount =>
      sessionCount + programCount + exerciseCount + bodyWeightCount;
}

class ImportResult {
  final bool success;
  final int imported;
  final int skipped;
  final List<String> errors;

  ImportResult({
    required this.success,
    required this.imported,
    required this.skipped,
    required this.errors,
  });
}
