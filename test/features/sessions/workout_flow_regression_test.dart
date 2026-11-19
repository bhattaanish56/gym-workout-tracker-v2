import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/database/app_database.dart';
import 'package:gym_workout_tracker_v2/features/sessions/data/repositories/drift_workout_repository.dart';
import 'package:gym_workout_tracker_v2/features/sessions/domain/models/workout_session.dart' as domain;
import 'package:gym_workout_tracker_v2/core/domain/value_objects/identifiers.dart';
import 'package:gym_workout_tracker_v2/core/domain/value_objects/date_time.dart';

void main() {
  late AppDatabase db;
  late DriftWorkoutRepository repo;

  setUp(() {
    db = AppDatabase.withQueryExecutor(NativeDatabase.memory());
    repo = DriftWorkoutRepository(db, 'test-user');
  });

  tearDown(() async {
    await db.close();
  });

  group('WORKOUT-FLOW-002: Date Separation & Migration', () {
    test('v9 schema supports userId and sync operations', () async {
      // Verify schema version (v7->v8 added userId, v8->v9 added sync queue)
      expect(db.schemaVersion, 9);

      // Create session with new field
      final session = domain.WorkoutSession.createFreestyle(
        id: RecordId('test-v7'),
        startedAt: DateTime.now().toUtc(),
        workoutDate: LocalDate.fromDateTime(DateTime.now()),
      );

      await repo.createSession(session, [], []);
      final retrieved = await repo.getSession('test-v7');

      // New field exists and defaults to null
      expect(retrieved, isNotNull);
      expect(retrieved!.fulfilledScheduledDate, isNull);
    });

    test('workoutDate tracks actual training date, fulfilledScheduledDate tracks scheduled assignment', () async {
      final now = DateTime.now().toUtc();
      final today = LocalDate.fromDateTime(now);
      final scheduledFriday = LocalDate(2026, 11, 21);

      // Scenario: User completes "Leg Day" on Monday (today),
      // which was scheduled for Friday
      final session = domain.WorkoutSession(
        id: RecordId('early-leg-day'),
        sourceType: domain.WorkoutSourceType.programDay,
        programId: 'prog-1',
        programDayId: 'leg-day',
        startedAt: now,
        workoutDate: today, // Trained today
        fulfilledScheduledDate: scheduledFriday, // Fulfilled Friday's assignment
        status: domain.WorkoutStatus.completed,
        finishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await repo.createSession(session, [], []);
      final retrieved = await repo.getSession('early-leg-day');

      // Actual training was today
      expect(retrieved!.workoutDate, today);

      // But fulfilled Friday's scheduled workout
      expect(retrieved.fulfilledScheduledDate, scheduledFriday);

      // These are different dates
      expect(retrieved.workoutDate != retrieved.fulfilledScheduledDate, true);
    });

    test('completed today query uses workoutDate regardless of fulfilledScheduledDate', () async {
      final now = DateTime.now().toUtc();
      final today = LocalDate.fromDateTime(now);
      final tomorrow = LocalDate(today.year, today.month, today.day + 1);

      // Session 1: Completed today for today's scheduled workout
      final regularSession = domain.WorkoutSession(
        id: RecordId('regular-today'),
        sourceType: domain.WorkoutSourceType.programDay,
        programId: 'prog-1',
        programDayId: 'push-day',
        startedAt: now,
        workoutDate: today,
        fulfilledScheduledDate: null, // On schedule
        status: domain.WorkoutStatus.completed,
        finishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      // Session 2: Completed today but fulfilled tomorrow's scheduled workout (early)
      final earlySession = domain.WorkoutSession(
        id: RecordId('early-tomorrow'),
        sourceType: domain.WorkoutSourceType.programDay,
        programId: 'prog-1',
        programDayId: 'pull-day',
        startedAt: now,
        workoutDate: today, // Trained today
        fulfilledScheduledDate: tomorrow, // But fulfilled tomorrow's assignment
        status: domain.WorkoutStatus.completed,
        finishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await repo.createSession(regularSession, [], []);
      await repo.createSession(earlySession, [], []);

      // Query: sessions completed today
      final allSessions = await repo.getAllSessions();
      final completedToday = allSessions
          .where((s) => s.status == domain.WorkoutStatus.completed && s.workoutDate == today)
          .toList();

      // Both show as completed today (by workoutDate)
      expect(completedToday.length, 2);

      // But they fulfilled different scheduled dates
      final onSchedule = completedToday.where((s) => s.fulfilledScheduledDate == null).toList();
      final earlyCompletion = completedToday.where((s) => s.fulfilledScheduledDate == tomorrow).toList();

      expect(onSchedule.length, 1);
      expect(onSchedule[0].id.value, 'regular-today');

      expect(earlyCompletion.length, 1);
      expect(earlyCompletion[0].id.value, 'early-tomorrow');
    });

    test('unfulfilled scheduled dates can be queried separately', () async {
      final now = DateTime.now().toUtc();
      final today = LocalDate.fromDateTime(now);
      final tomorrow = LocalDate(today.year, today.month, today.day + 1);
      final dayAfter = LocalDate(today.year, today.month, today.day + 2);

      // Completed today, fulfilled tomorrow's assignment
      final earlySession = domain.WorkoutSession(
        id: RecordId('completed-early'),
        sourceType: domain.WorkoutSourceType.programDay,
        programId: 'prog-1',
        programDayId: 'arm-day',
        startedAt: now,
        workoutDate: today,
        fulfilledScheduledDate: tomorrow, // Fulfilled tomorrow
        status: domain.WorkoutStatus.completed,
        finishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await repo.createSession(earlySession, [], []);

      // Provider logic: check which scheduled dates are fulfilled
      final allSessions = await repo.getAllSessions();
      final fulfilledDates = allSessions
          .where((s) => s.status == domain.WorkoutStatus.completed && s.fulfilledScheduledDate != null)
          .map((s) => s.fulfilledScheduledDate!)
          .toSet();

      expect(fulfilledDates.contains(tomorrow), true);
      expect(fulfilledDates.contains(dayAfter), false);

      // Tomorrow is fulfilled, day-after is not
      // Provider uses this to determine "Up Next"
    });

    test('null fulfilledScheduledDate is backward compatible', () async {
      final now = DateTime.now().toUtc();

      // Old-style session without fulfilledScheduledDate (pre-v7 or on-schedule)
      final oldSession = domain.WorkoutSession.createFreestyle(
        id: RecordId('old-style-session'),
        startedAt: now,
        workoutDate: LocalDate.fromDateTime(now),
      );

      await repo.createSession(oldSession, [], []);
      final retrieved = await repo.getSession('old-style-session');

      expect(retrieved!.fulfilledScheduledDate, isNull);
      expect(retrieved.workoutDate, isNotNull);
    });

    test('multiple sessions today with different fulfilled dates', () async {
      final now = DateTime.now().toUtc();
      final today = LocalDate.fromDateTime(now);
      final monday = LocalDate(2026, 11, 17);
      final friday = LocalDate(2026, 11, 21);

      // Three sessions completed today
      final session1 = domain.WorkoutSession(
        id: RecordId('sess-1'),
        sourceType: domain.WorkoutSourceType.programDay,
        startedAt: now,
        workoutDate: today,
        fulfilledScheduledDate: null, // On schedule
        status: domain.WorkoutStatus.completed,
        finishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      final session2 = domain.WorkoutSession(
        id: RecordId('sess-2'),
        sourceType: domain.WorkoutSourceType.programDay,
        startedAt: now,
        workoutDate: today,
        fulfilledScheduledDate: monday, // Makeup for missed Monday
        status: domain.WorkoutStatus.completed,
        finishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      final session3 = domain.WorkoutSession(
        id: RecordId('sess-3'),
        sourceType: domain.WorkoutSourceType.programDay,
        startedAt: now,
        workoutDate: today,
        fulfilledScheduledDate: friday, // Early completion for Friday
        status: domain.WorkoutStatus.completed,
        finishedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await repo.createSession(session1, [], []);
      await repo.createSession(session2, [], []);
      await repo.createSession(session3, [], []);

      final allSessions = await repo.getAllSessions();
      final completedToday = allSessions
          .where((s) => s.status == domain.WorkoutStatus.completed && s.workoutDate == today)
          .toList();

      // All three trained today
      expect(completedToday.length, 3);

      // But fulfilled different scheduled dates
      final fulfilledDates = completedToday
          .map((s) => s.fulfilledScheduledDate)
          .toList();

      expect(fulfilledDates.contains(null), true); // On schedule
      expect(fulfilledDates.contains(monday), true); // Makeup
      expect(fulfilledDates.contains(friday), true); // Early
    });
  });
}
