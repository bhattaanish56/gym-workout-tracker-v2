import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Workout sessions table.
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()(); // Owner of this record
  TextColumn get sourceType => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get workoutDate => text()();
  TextColumn get status => text()();
  TextColumn get programId => text().nullable()();
  TextColumn get programDayId => text().nullable()();
  TextColumn get programSnapshot => text().nullable()();
  TextColumn get fulfilledScheduledDate => text().nullable()(); // YYYY-MM-DD for early completion
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Performed exercises table.
class PerformedExercises extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get orderIndex => integer()();
  TextColumn get snapshotJson => text()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Performed sets table.
class PerformedSets extends Table {
  TextColumn get id => text()();
  TextColumn get performedExerciseId =>
      text().references(PerformedExercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get orderIndex => integer()();
  TextColumn get setType => text()();
  IntColumn get loadGrams => integer().nullable()();
  IntColumn get reps => integer().nullable()();
  BoolColumn get completed => boolean()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Custom exercises table.
class CustomExercises extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()(); // Owner of this record
  TextColumn get name => text()();
  TextColumn get equipment => text()();
  TextColumn get primaryMuscle => text()();
  TextColumn get instructions => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Programs table.
class Programs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()(); // Owner of this record
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get scheduleMode => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Program days table.
class ProgramDays extends Table {
  TextColumn get id => text()();
  TextColumn get programId =>
      text().references(Programs, #id, onDelete: KeyAction.cascade)();
  IntColumn get orderIndex => integer()();
  TextColumn get name => text()();
  TextColumn get targetDescription => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Planned exercises table.
class PlannedExercises extends Table {
  TextColumn get id => text()();
  TextColumn get programDayId =>
      text().references(ProgramDays, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text()();
  IntColumn get orderIndex => integer()();
  IntColumn get targetSets => integer().nullable()();
  IntColumn get targetRepsMin => integer().nullable()();
  IntColumn get targetRepsMax => integer().nullable()();
  IntColumn get targetLoadGrams => integer().nullable()();
  IntColumn get restSeconds => integer().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Rotation states table.
class RotationStates extends Table {
  TextColumn get programId =>
      text().references(Programs, #id, onDelete: KeyAction.cascade)();
  IntColumn get nextDayIndex => integer()();
  TextColumn get lastCompletionEventId => text().nullable()();

  @override
  Set<Column> get primaryKey => {programId};
}

/// Weekday assignments table for fixed-weekly schedules.
class WeekdayAssignments extends Table {
  TextColumn get id => text()();
  TextColumn get programId =>
      text().references(Programs, #id, onDelete: KeyAction.cascade)();
  IntColumn get weekday => integer()();
  TextColumn get assignmentType => text()();
  TextColumn get programDayId => text().nullable().references(
    ProgramDays,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {programId, weekday},
  ];
}

/// Body weight entries table.
class BodyWeightEntries extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()(); // Owner of this record
  IntColumn get weightGrams => integer()();
  DateTimeColumn get measuredAt => dateTime()();
  TextColumn get measuredDate => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User profile table.
class UserProfile extends Table {
  TextColumn get userId => text()(); // Profile belongs to this user
  IntColumn get heightCm => integer().nullable()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get gender => text().nullable()(); // Optional
  IntColumn get currentWeightGrams => integer().nullable()();
  IntColumn get goalWeightGrams => integer().nullable()();
  TextColumn get fitnessGoal => text().nullable()(); // 'gain_muscle', 'lose_fat', 'maintain', 'improve_strength'
  TextColumn get experienceLevel => text().nullable()(); // 'beginner', 'intermediate', 'advanced'
  TextColumn get activityLevel => text().nullable()(); // 'sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active'
  IntColumn get workoutDaysPerWeek => integer().nullable()();
  TextColumn get trainingLocation => text().nullable()(); // 'gym', 'home', 'both'
  TextColumn get equipment => text().nullable()(); // Comma-separated
  BoolColumn get hasCompletedOnboarding => boolean().withDefault(const Constant(false))();
  IntColumn get maintenanceCalories => integer().nullable()();
  IntColumn get targetCalories => integer().nullable()();
  IntColumn get targetProteinGrams => integer().nullable()();
  DateTimeColumn get onboardingCompletedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Foods table for nutrition tracking.
class Foods extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()(); // null for bundled foods, userId for custom
  TextColumn get name => text()();
  TextColumn get source => text()(); // 'usda', 'off', 'custom'
  TextColumn get brandName => text().nullable()();
  TextColumn get sourceId => text().nullable()(); // USDA FDC ID or OFF barcode
  RealColumn get caloriesPer100g => real()();
  RealColumn get proteinPer100g => real()();
  RealColumn get carbsPer100g => real()();
  RealColumn get fatPer100g => real()();
  RealColumn get fiberPer100g => real().nullable()();
  RealColumn get sugarPer100g => real().nullable()();
  TextColumn get servingUnit => text()();
  RealColumn get servingSizeGrams => real()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Meal entries table.
class MealEntries extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get mealType => text()(); // 'breakfast', 'lunch', 'dinner', 'snack'
  TextColumn get foodId => text().references(Foods, #id)();
  TextColumn get foodSnapshot => text()(); // JSON snapshot of food at log time
  RealColumn get servings => real()();
  RealColumn get calories => real()(); // Calculated at log time
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sync operations queue.
class SyncOperations extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()(); // Owner of this sync operation
  TextColumn get collection => text()();
  TextColumn get recordId => text()();
  TextColumn get operationType => text()();
  TextColumn get data => text().nullable()(); // JSON-encoded data
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get attemptedAt => dateTime().nullable()();
  IntColumn get retryCount => integer()();
  TextColumn get error => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    WorkoutSessions,
    PerformedExercises,
    PerformedSets,
    CustomExercises,
    Programs,
    ProgramDays,
    PlannedExercises,
    RotationStates,
    WeekdayAssignments,
    BodyWeightEntries,
    UserProfile,
    Foods,
    MealEntries,
    SyncOperations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.withQueryExecutor(super.e);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // v1 -> v2: Add custom exercises
        if (from <= 1 && to >= 2) {
          await m.createTable(customExercises);
        }
        // v2 -> v3: Add programs and workout sessions columns
        if (from <= 2 && to >= 3) {
          await m.createTable(programs);
          await m.createTable(programDays);
          await m.createTable(plannedExercises);
          await m.createTable(rotationStates);
          await m.addColumn(workoutSessions, workoutSessions.programId);
          await m.addColumn(workoutSessions, workoutSessions.programDayId);
          await m.addColumn(workoutSessions, workoutSessions.programSnapshot);
        }
        // v3 -> v4: Add body weight and user profile
        if (from <= 3 && to >= 4) {
          await m.createTable(bodyWeightEntries);
          await m.createTable(userProfile);
        }
        // v4 -> v5: Previously added weekday to program_days (deprecated in v6)
        // v5 -> v6: Create weekday_assignments table
        if (from <= 5 && to >= 6) {
          await m.createTable(weekdayAssignments);
        }
        // v6 -> v7: Add fulfilledScheduledDate to WorkoutSessions (idempotent)
        if (from <= 6 && to >= 7) {
          try {
            await m.addColumn(workoutSessions, workoutSessions.fulfilledScheduledDate);
          } catch (e) {
            // Column already exists - safe to continue
            if (!e.toString().contains('duplicate column')) {
              rethrow;
            }
          }
        }
        // v7 -> v8: Add userId columns for multi-user support
        if (from <= 7 && to >= 8) {
          try {
            await m.addColumn(workoutSessions, workoutSessions.userId);
            await m.addColumn(programs, programs.userId);
            await m.addColumn(customExercises, customExercises.userId);
            await m.addColumn(bodyWeightEntries, bodyWeightEntries.userId);
            // UserProfile: recreate with userId as primary key
            await m.deleteTable('user_profile');
            await m.createTable(userProfile);
          } catch (e) {
            if (!e.toString().contains('duplicate column')) {
              rethrow;
            }
          }
        }
        // v8 -> v9: Add sync operations queue
        if (from <= 8 && to >= 9) {
          await m.createTable(syncOperations);
        }
        // v9 -> v10: Add onboarding fields to UserProfile
        if (from <= 9 && to >= 10) {
          try {
            await m.addColumn(userProfile, userProfile.dateOfBirth);
            await m.addColumn(userProfile, userProfile.gender);
            await m.addColumn(userProfile, userProfile.currentWeightGrams);
            await m.addColumn(userProfile, userProfile.goalWeightGrams);
            await m.addColumn(userProfile, userProfile.fitnessGoal);
            await m.addColumn(userProfile, userProfile.experienceLevel);
            await m.addColumn(userProfile, userProfile.activityLevel);
            await m.addColumn(userProfile, userProfile.workoutDaysPerWeek);
            await m.addColumn(userProfile, userProfile.trainingLocation);
            await m.addColumn(userProfile, userProfile.equipment);
            await m.addColumn(userProfile, userProfile.hasCompletedOnboarding);
            await m.addColumn(userProfile, userProfile.maintenanceCalories);
            await m.addColumn(userProfile, userProfile.targetCalories);
            await m.addColumn(userProfile, userProfile.targetProteinGrams);
            await m.addColumn(userProfile, userProfile.onboardingCompletedAt);
          } catch (e) {
            if (!e.toString().contains('duplicate column')) {
              rethrow;
            }
          }
        }
        // v10 -> v11: Add nutrition tracking tables
        if (from <= 10 && to >= 11) {
          await m.createTable(foods);
          await m.createTable(mealEntries);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'workout_tracker',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
