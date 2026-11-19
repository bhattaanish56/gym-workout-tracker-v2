import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import '../features/home/presentation/screens/home_screen_redesign.dart';
import '../features/sessions/presentation/screens/workouts_hub_screen.dart';
import '../features/sessions/presentation/screens/workout_detail_screen.dart';
import '../features/sessions/presentation/screens/workout_history_screen.dart';
import '../features/exercises/presentation/screens/exercises_screen.dart';
import '../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../features/programs/presentation/screens/programs_screen.dart';
import '../features/programs/presentation/screens/program_detail_screen.dart';
import '../features/programs/presentation/screens/program_day_editor_screen.dart';
import '../features/programs/presentation/screens/program_builder_screen.dart';
import '../features/progress/presentation/screens/progress_screen.dart';
import '../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/onboarding/presentation/screens/onboarding_coordinator_screen.dart';
import '../features/onboarding/presentation/screens/fitness_settings_screen.dart';
import '../features/onboarding/presentation/providers/onboarding_providers.dart';
import '../shared/widgets/section_page.dart';
import '../core/debug/auth_diagnostics.dart';

GoRouter createAppRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      if (kDebugMode) {
        debugPrint('=== REDIRECT START ===');
        debugPrint('InitialLocation (config): /home');
        debugPrint('State.uri: ${state.uri}');
        debugPrint('State.matchedLocation: ${state.matchedLocation}');
        debugPrint('State.fullPath: ${state.fullPath}');
      }

      final user = ref.read(authRepositoryProvider).currentUser;
      final isAuthenticated = user != null;
      final isAuthRoute = state.matchedLocation.startsWith('/welcome') ||
          state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot-password');
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      if (kDebugMode) {
        AuthDiagnostics.logAuthState(
          'Router redirect check',
          uid: user?.uid,
          email: user?.email,
          displayName: user?.displayName,
          isAnonymous: user?.isAnonymous,
        );
        debugPrint('isAuthenticated: $isAuthenticated');
        debugPrint('isAuthRoute: $isAuthRoute');
        debugPrint('isOnboardingRoute: $isOnboardingRoute');
      }

      if (!isAuthenticated && !isAuthRoute) {
        if (kDebugMode) debugPrint('REDIRECT DECISION: /welcome (not authenticated)');
        return '/welcome';
      }

      if (isAuthenticated && isAuthRoute) {
        // Check onboarding completion after auth success using provider
        final hasCompletedResult = ref.read(hasCompletedOnboardingProvider);
        final shouldRedirect = hasCompletedResult.maybeWhen(
          data: (completed) => !completed,
          orElse: () => false, // Allow navigation while loading
        );
        if (kDebugMode) {
          debugPrint('Onboarding status (from auth route): $hasCompletedResult');
          debugPrint('shouldRedirect to onboarding: $shouldRedirect');
        }
        if (shouldRedirect) {
          if (kDebugMode) debugPrint('REDIRECT DECISION: /onboarding');
          return '/onboarding';
        }
        // Don't return /home - let it fall through to navigate naturally
        if (kDebugMode) debugPrint('REDIRECT DECISION: null (authenticated, onboarding complete)');
        return null;
      }

      // Check onboarding for authenticated users navigating to non-auth, non-onboarding routes
      if (isAuthenticated && !isOnboardingRoute && !isAuthRoute) {
        final hasCompletedResult = ref.read(hasCompletedOnboardingProvider);
        final shouldRedirectToOnboarding = hasCompletedResult.maybeWhen(
          data: (completed) => !completed,
          orElse: () => false, // Don't block navigation while loading
        );

        if (kDebugMode) {
          debugPrint('Onboarding status (from app route): $hasCompletedResult');
          debugPrint('shouldRedirectToOnboarding: $shouldRedirectToOnboarding');
        }

        if (shouldRedirectToOnboarding) {
          if (kDebugMode) debugPrint('REDIRECT DECISION: /onboarding');
          return '/onboarding';
        }
      }

      if (kDebugMode) debugPrint('REDIRECT DECISION: null (no redirect needed)');
      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authRepositoryProvider).authStateChanges,
    ),
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingCoordinatorScreen(),
      ),
      GoRoute(
        path: '/fitness-settings',
        builder: (context, state) => const FitnessSettingsScreen(),
      ),
      GoRoute(path: '/', redirect: (context, state) => '/home'),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: HomeScreenRedesign(
                    key: const Key('page-home'),
                    onViewWorkouts: () => context.go('/workouts'),
                    onBrowseExercises: () => context.go('/exercises'),
                    onViewProgress: () => context.go('/progress'),
                    onOpenNutrition: () => context.go('/nutrition'),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/workouts',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const WorkoutsHubScreen(key: Key('page-workouts')),
                ),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) {
                      return const WorkoutHistoryScreen();
                    },
                  ),
                  GoRoute(
                    path: 'programs',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                        key: state.pageKey,
                        child: const ProgramsScreen(key: Key('page-programs')),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder: (context, state) {
                          return const ProgramBuilderScreen();
                        },
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return ProgramDetailScreen(programId: id);
                        },
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (context, state) {
                              final id = state.pathParameters['id']!;
                              return ProgramBuilderScreen(programId: id);
                            },
                          ),
                          GoRoute(
                            path: 'days/:dayId',
                            builder: (context, state) {
                              final programId = state.pathParameters['id']!;
                              final dayId = state.pathParameters['dayId']!;
                              return ProgramDayEditorScreen(
                                programId: programId,
                                dayId: dayId,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return WorkoutDetailScreen(sessionId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/exercises',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ExercisesScreen(key: Key('page-exercises')),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final exercise = state.extra;
                      return ExerciseDetailScreen(exercise: exercise);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ProgressScreen(key: Key('page-progress')),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/nutrition',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const NutritionScreen(key: Key('page-nutrition')),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      if (kDebugMode) {
        debugPrint('=== GOROUTER ERROR ===');
        debugPrint('Error: ${state.error}');
        debugPrint('Uri: ${state.uri}');
        debugPrint('MatchedLocation: ${state.matchedLocation}');
        debugPrint('FullPath: ${state.fullPath}');
        debugPrint('PathParameters: ${state.pathParameters}');
        debugPrint('======================');
      }
      return Scaffold(
        body: PageFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(header: true, child: const Text('Page not found')),
              const SizedBox(height: 8),
              if (kDebugMode) ...[
                Text('Error: ${state.error}'),
                Text('Uri: ${state.uri}'),
                Text('MatchedLocation: ${state.matchedLocation}'),
                const SizedBox(height: 8),
              ],
              FilledButton(
                onPressed: () => context.go('/home'),
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter(ref);
  ref.onDispose(router.dispose);
  return router;
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
