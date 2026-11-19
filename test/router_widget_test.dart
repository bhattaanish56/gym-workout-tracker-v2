import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_workout_tracker_v2/app/router.dart';
import 'package:gym_workout_tracker_v2/features/auth/domain/models/app_user.dart';
import 'package:gym_workout_tracker_v2/features/auth/presentation/providers/auth_providers.dart';
import 'package:gym_workout_tracker_v2/features/onboarding/presentation/providers/onboarding_providers.dart';

void main() {
  group('Router Widget Tests', () {
    testWidgets('Authenticated user with completed onboarding navigates to Home', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => MockAuthRepository(
            currentUser: const AppUser(
              uid: 'test-user',
              email: 'test@example.com',
              isAnonymous: false,
            ),
          )),
          hasCompletedOnboardingProvider.overrideWith((ref) => Future.value(true)),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: container.read(appRouterProvider),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show Home screen, not error
      expect(find.text('Page not found'), findsNothing);
      // Home screen should have navigation buttons or content
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Unauthenticated user navigates to Welcome', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => MockAuthRepository(currentUser: null)),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: container.read(appRouterProvider),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should redirect to welcome
      expect(find.text('Page not found'), findsNothing);
      expect(find.text('Gym Workout Tracker'), findsOneWidget);
    });

    testWidgets('Authenticated user without completed onboarding navigates to Onboarding', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) => MockAuthRepository(
            currentUser: const AppUser(
              uid: 'new-user',
              email: 'new@example.com',
              isAnonymous: false,
            ),
          )),
          hasCompletedOnboardingProvider.overrideWith((ref) => Future.value(false)),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: container.read(appRouterProvider),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show onboarding, not error
      expect(find.text('Page not found'), findsNothing);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}

class MockAuthRepository {
  final AppUser? currentUser;

  MockAuthRepository({this.currentUser});

  Stream<AppUser?> get authStateChanges => Stream.value(currentUser);
}
