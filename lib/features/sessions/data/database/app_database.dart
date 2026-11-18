import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Workout sessions table.
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get sourceType => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  TextColumn get workoutDate => text()();
  TextColumn get status => text()();
  TextColumn get programId => text().nullable()();
  TextColumn get programDayId => text().nullable()();
  TextColumn get programSnapshot => text().nullable()();
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
  IntColumn get heightCm => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.withQueryExecutor(super.e);

  @override
  int get schemaVersion => 6;

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
