import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import '../../sessions/data/database/app_database.dart';
import '../../sessions/domain/models/workout_session.dart';
import '../../sessions/domain/models/performed_exercise.dart';
import '../../sessions/domain/models/performed_set.dart';
import '../../programs/domain/models/program.dart';
import '../../programs/domain/models/program_day.dart';
import '../../programs/domain/models/planned_exercise.dart';
import '../../exercises/domain/models/custom_exercise.dart';
import '../../progress/domain/models/bodyweight_entry.dart';
import '../../../core/domain/value_objects/identifiers.dart';
import '../../../core/domain/value_objects/date_time.dart';
import '../../../core/domain/value_objects/weight.dart';
import '../../exercises/domain/models/equipment.dart';
import '../../exercises/domain/models/muscle_group.dart';

class DataRestoreService {
  final AppDatabase _db;
  final FirebaseFirestore _firestore;
  final String userId;

  DataRestoreService(this._db, this._firestore, this.userId);

  Future<void> restoreAllData() async {
    await Future.wait([
      _restoreWorkouts(),
      _restorePrograms(),
      _restoreCustomExercises(),
      _restoreBodyWeight(),
      _restoreProfile(),
    ]);
  }

  Future<void> _restoreWorkouts() async {
    final snapshot = await _firestore
        .collection('users/$userId/workouts')
        .get();

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        final workoutId = data['id'] as String;

        // Check if already exists locally
        final existing = await (_db.select(_db.workoutSessions)
              ..where((t) => t.id.equals(workoutId)))
            .getSingleOrNull();

        if (existing != null && existing.userId == userId) {
          continue; // Already have this workout
        }

        // Insert workout session
        await _db.into(_db.workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            id: workoutId,
            userId: Value(userId),
            sourceType: data['sourceType'] as String,
            startedAt: DateTime.parse(data['startedAt'] as String),
            finishedAt: Value(data['finishedAt'] != null
                ? DateTime.parse(data['finishedAt'] as String)
                : null),
            workoutDate: data['workoutDate'] as String,
            status: data['status'] as String,
            programId: Value(data['programId'] as String?),
            programDayId: Value(data['programDayId'] as String?),
            programSnapshot: Value(data['programSnapshot'] as String?),
            fulfilledScheduledDate: Value(data['fulfilledScheduledDate'] as String?),
            createdAt: DateTime.parse(data['createdAt'] as String),
            updatedAt: DateTime.parse(data['updatedAt'] as String),
          ),
          mode: InsertMode.insertOrIgnore,
        );

        // Insert exercises and sets
        final exercises = data['exercises'] as List<dynamic>?;
        if (exercises != null) {
          for (final exData in exercises) {
            final exMap = exData as Map<String, dynamic>;
            await _db.into(_db.performedExercises).insert(
              PerformedExercisesCompanion.insert(
                id: exMap['id'] as String,
                sessionId: workoutId,
                orderIndex: exMap['orderIndex'] as int,
                snapshotJson: jsonEncode(exMap['snapshot']),
                notes: Value(exMap['notes'] as String?),
              ),
              mode: InsertMode.insertOrIgnore,
            );

            final sets = exMap['sets'] as List<dynamic>?;
            if (sets != null) {
              for (final setData in sets) {
                final setMap = setData as Map<String, dynamic>;
                await _db.into(_db.performedSets).insert(
                  PerformedSetsCompanion.insert(
                    id: setMap['id'] as String,
                    performedExerciseId: exMap['id'] as String,
                    orderIndex: setMap['orderIndex'] as int,
                    setType: setMap['setType'] as String,
                    loadGrams: Value(setMap['loadGrams'] as int?),
                    reps: Value(setMap['reps'] as int?),
                    completed: setMap['completed'] as bool,
                    notes: Value(setMap['notes'] as String?),
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
              }
            }
          }
        }
      } catch (e) {
        // Skip malformed workout
        continue;
      }
    }
  }

  Future<void> _restorePrograms() async {
    final snapshot = await _firestore
        .collection('users/$userId/programs')
        .get();

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        final programId = data['id'] as String;

        // Check if already exists locally
        final existing = await (_db.select(_db.programs)
              ..where((t) => t.id.equals(programId)))
            .getSingleOrNull();

        if (existing != null && existing.userId == userId) {
          continue; // Already have this program
        }

        // Insert program
        await _db.into(_db.programs).insert(
          ProgramsCompanion.insert(
            id: programId,
            userId: Value(userId),
            name: data['name'] as String,
            description: Value(data['description'] as String?),
            scheduleMode: data['scheduleMode'] as String,
            status: data['status'] as String,
            createdAt: DateTime.parse(data['createdAt'] as String),
            updatedAt: DateTime.parse(data['updatedAt'] as String),
          ),
          mode: InsertMode.insertOrIgnore,
        );

        // Insert days and exercises
        final days = data['days'] as List<dynamic>?;
        if (days != null) {
          for (final dayData in days) {
            final dayMap = dayData as Map<String, dynamic>;
            await _db.into(_db.programDays).insert(
              ProgramDaysCompanion.insert(
                id: dayMap['id'] as String,
                programId: programId,
                orderIndex: dayMap['orderIndex'] as int,
                name: dayMap['name'] as String,
                targetDescription: Value(dayMap['targetDescription'] as String?),
              ),
              mode: InsertMode.insertOrIgnore,
            );

            final exercises = dayMap['exercises'] as List<dynamic>?;
            if (exercises != null) {
              for (final exData in exercises) {
                final exMap = exData as Map<String, dynamic>;
                await _db.into(_db.plannedExercises).insert(
                  PlannedExercisesCompanion.insert(
                    id: exMap['id'] as String,
                    programDayId: dayMap['id'] as String,
                    exerciseId: exMap['exerciseId'] as String,
                    orderIndex: exMap['orderIndex'] as int,
                    targetSets: Value(exMap['targetSets'] as int?),
                    targetRepsMin: Value(exMap['targetRepsMin'] as int?),
                    targetRepsMax: Value(exMap['targetRepsMax'] as int?),
                    targetLoadGrams: Value(exMap['targetLoadGrams'] as int?),
                    restSeconds: Value(exMap['restSeconds'] as int?),
                    notes: Value(exMap['notes'] as String?),
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
              }
            }
          }
        }
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _restoreCustomExercises() async {
    final snapshot = await _firestore
        .collection('users/$userId/custom_exercises')
        .get();

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        await _db.into(_db.customExercises).insert(
          CustomExercisesCompanion.insert(
            id: data['id'] as String,
            userId: Value(userId),
            name: data['name'] as String,
            equipment: data['equipment'] as String,
            primaryMuscle: data['primaryMuscle'] as String,
            instructions: Value(data['instructions'] as String?),
            createdAt: DateTime.parse(data['createdAt'] as String),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _restoreBodyWeight() async {
    final snapshot = await _firestore
        .collection('users/$userId/bodyweight')
        .get();

    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        await _db.into(_db.bodyWeightEntries).insert(
          BodyWeightEntriesCompanion.insert(
            id: data['id'] as String,
            userId: Value(userId),
            weightGrams: data['weightGrams'] as int,
            measuredAt: DateTime.parse(data['measuredAt'] as String),
            measuredDate: data['measuredDate'] as String,
            notes: Value(data['notes'] as String?),
            createdAt: DateTime.parse(data['createdAt'] as String),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      } catch (e) {
        continue;
      }
    }
  }

  Future<void> _restoreProfile() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) return;

      final data = doc.data()!;
      final heightCm = data['heightCm'] as int?;

      if (heightCm != null) {
        await _db.into(_db.userProfile).insert(
          UserProfileCompanion.insert(
            userId: userId,
            heightCm: Value(heightCm),
            updatedAt: DateTime.now().toUtc(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    } catch (e) {
      // Profile not found or error
    }
  }
}
