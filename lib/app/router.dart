import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_shell.dart';
import '../features/home/presentation/screens/home_screen.dart';
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
                  child: const SectionPage(
                    key: Key('page-workouts'),
                    title: 'Workouts',
                    emptyMessage:
                        'No workouts yet. Your sessions will appear here.',
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/exercises',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const SectionPage(
                    key: Key('page-exercises'),
                    title: 'Exercises',
                    emptyMessage:
                        'No exercises saved yet. Your library will appear here.',
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const SectionPage(
                    key: Key('page-progress'),
                    title: 'Progress',
                    emptyMessage:
                        'No training history yet. Completed sessions will appear here.',
                  ),
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
                  child: const SectionPage(
                    key: Key('page-nutrition'),
                    title: 'Nutrition',
                    emptyMessage:
                        'No meals recorded yet. Your meal history will appear here.',
                  ),
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
