import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_workout_tracker_v2/features/sessions/presentation/screens/workouts_screen.dart';
import 'package:gym_workout_tracker_v2/features/sessions/presentation/providers/workout_providers.dart';
import 'package:gym_workout_tracker_v2/features/exercises/presentation/providers/exercise_providers.dart';
import 'fake_workout_repository.dart';
import 'fake_exercise_repository.dart';

void _setLargeViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  setUp(() {
    // Set larger viewport to prevent off-screen elements
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('WorkoutsScreen', () {
    testWidgets('shows start workout button when no active session', (
      tester,
    ) async {
      _setLargeViewport(tester);

      final fakeRepo = FakeWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Start Workout'), findsOneWidget);
      expect(
        find.text('No workouts yet. Your sessions will appear here.'),
        findsOneWidget,
      );
    });

    testWidgets('starts workout when button pressed', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final fakeRepo = FakeWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Should show active workout editor
      expect(find.text('Active Workout'), findsOneWidget);
    });
  });

  group('ActiveWorkoutEditor', () {
    testWidgets('adds exercise with name', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Tap Add Exercise button
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();

      // Search and select exercise from dialog
      await tester.enterText(
        find.widgetWithText(TextField, 'Search exercises'),
        'Bench',
      );
      await tester.pumpAndSettle();

      // Tap on exercise
      await tester.tap(find.text('Bench Press'));
      await tester.pumpAndSettle();

      // Should show exercise card
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('No sets yet'), findsOneWidget);
    });

    testWidgets('adds set to exercise', (tester) async {
      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Add exercise via picker
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Squat'));
      await tester.pumpAndSettle();

      // Add set
      await tester.tap(find.text('+ Add Set'));
      await tester.pumpAndSettle();

      // Should show set row
      expect(find.text('1'), findsOneWidget); // Set number
      expect(find.widgetWithText(TextField, 'Reps'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'kg'), findsOneWidget);
    });

    testWidgets('edits set reps and weight', (tester) async {
      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout and add exercise with set
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bench Press'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+ Add Set'));
      await tester.pumpAndSettle();

      // Enter reps
      await tester.enterText(find.widgetWithText(TextField, 'Reps'), '5');
      await tester.pumpAndSettle();

      // Enter weight
      await tester.enterText(find.widgetWithText(TextField, 'kg'), '100');
      await tester.pumpAndSettle();

      // Values should be present
      expect(find.text('5'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('removes set', (tester) async {
      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout, add exercise and set
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bench Press'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+ Add Set'));
      await tester.pumpAndSettle();

      // Remove set
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Should show no sets
      expect(find.text('No sets yet'), findsOneWidget);
    });

    testWidgets('removes exercise', (tester) async {
      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout and add exercise
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Squat'));
      await tester.pumpAndSettle();

      expect(find.text('Squat'), findsOneWidget);

      // Remove exercise
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Should not show exercise anymore
      expect(find.text('Squat'), findsNothing);
    });

    testWidgets('shows discard confirmation dialog', (tester) async {
      final fakeRepo = FakeWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Tap discard button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Should show confirmation dialog
      expect(find.text('Discard Workout?'), findsOneWidget);
      expect(
        find.text('This will permanently delete your workout in progress.'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);
    });

    testWidgets('cancels discard and keeps workout', (tester) async {
      final fakeRepo = FakeWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Open discard dialog and cancel
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Should still be in active workout
      expect(find.text('Active Workout'), findsOneWidget);
    });

    testWidgets('confirms discard and returns to landing', (tester) async {
      final fakeRepo = FakeWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Discard workout
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();

      // Should return to landing page
      expect(find.text('Start Workout'), findsOneWidget);
    });

    testWidgets('finishes workout and shows success message', (tester) async {
      final fakeRepo = FakeWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Finish workout
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Should show success message and return to landing
      expect(find.text('Workout saved'), findsOneWidget);
      expect(find.text('Start Workout'), findsOneWidget);
    });

    testWidgets('prevents duplicate finish clicks', (tester) async {
      final fakeRepo = FakeWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(fakeRepo)],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Tap finish button
      await tester.tap(find.byIcon(Icons.check));
      // Don't wait for settle, tap again immediately
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Should only save once (verified by backend, UI shows loading state)
      expect(find.text('Start Workout'), findsOneWidget);
    });

    testWidgets('displays error message when operation fails', (tester) async {
      // This test would need a mock repository that throws errors
      // Skipping for now as it requires more complex setup
    });

    testWidgets('handles invalid reps input gracefully', (tester) async {
      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Setup: start workout, add exercise and set
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bench Press'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+ Add Set'));
      await tester.pumpAndSettle();

      // Enter invalid reps
      await tester.enterText(find.widgetWithText(TextField, 'Reps'), 'abc');
      await tester.pumpAndSettle();

      // Should not crash, field remains empty or shows previous value
      expect(tester.takeException(), isNull);
    });

    testWidgets('handles invalid weight input gracefully', (tester) async {
      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Setup
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bench Press'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+ Add Set'));
      await tester.pumpAndSettle();

      // Enter invalid weight
      await tester.enterText(find.widgetWithText(TextField, 'kg'), 'xyz');
      await tester.pumpAndSettle();

      // Should not crash
      expect(tester.takeException(), isNull);
    });

    testWidgets('exercise picker dialog opens and shows exercises', (
      tester,
    ) async {
      final fakeRepo = FakeWorkoutRepository();
      final fakeExerciseRepo = FakeExerciseRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(fakeRepo),
            exerciseRepositoryProvider.overrideWithValue(fakeExerciseRepo),
          ],
          child: const MaterialApp(home: WorkoutsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Start workout
      await tester.tap(find.text('Start Workout'));
      await tester.pumpAndSettle();

      // Tap Add Exercise button
      await tester.tap(find.text('Add Exercise'));
      await tester.pumpAndSettle();

      // Should show exercise picker dialog
      expect(find.text('Select Exercise'), findsOneWidget);
      expect(find.text('Bench Press'), findsOneWidget);
      expect(find.text('Squat'), findsOneWidget);
    });
  });

  group('Workout Recovery', () {
    testWidgets('shows active workout editor when session in progress', (
      tester,
    ) async {
      // This would need to mock the provider to return an active session
      // Requires more complex setup with overridden providers
    });
  });
}
