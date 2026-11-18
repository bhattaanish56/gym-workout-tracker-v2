import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/sessions/presentation/screens/workouts_screen.dart';
import '../features/sessions/presentation/screens/workout_detail_screen.dart';
import '../features/exercises/presentation/screens/exercises_screen.dart';
import '../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../features/programs/presentation/screens/programs_screen.dart';
import '../features/programs/presentation/screens/program_detail_screen.dart';
import '../features/programs/presentation/screens/program_day_editor_screen.dart';
import '../features/programs/presentation/screens/program_builder_screen.dart';
import '../features/progress/presentation/screens/progress_screen.dart';
import '../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../shared/widgets/section_page.dart';

GoRouter createAppRouter({String initialLocation = '/home'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
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
                  child: HomeScreen(
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
                  child: const WorkoutsScreen(key: Key('page-workouts')),
                ),
                routes: [
                  GoRoute(
                    path: 'programs',
                    builder: (context, state) {
                      return const ProgramsScreen(key: Key('page-programs'));
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
    errorBuilder: (context, state) => Scaffold(
      body: PageFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(header: true, child: const Text('Page not found')),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter();
  ref.onDispose(router.dispose);
  return router;
});
