import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final useRail = width >= 720 && height >= 480;
        final extendedRail = width >= 1200;

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (useRail)
                  NavigationRail(
                    key: const Key('nav-rail'),
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      );
                    },
                    extended: extendedRail,
                    labelType: extendedRail
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.fitness_center_outlined),
                        selectedIcon: Icon(Icons.fitness_center),
                        label: Text('Workouts'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.list_outlined),
                        selectedIcon: Icon(Icons.list),
                        label: Text('Exercises'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.trending_up_outlined),
                        selectedIcon: Icon(Icons.trending_up),
                        label: Text('Progress'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.restaurant_outlined),
                        selectedIcon: Icon(Icons.restaurant),
                        label: Text('Nutrition'),
                      ),
                    ],
                  ),
                if (useRail) const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
          ),
          bottomNavigationBar: useRail
              ? null
              : NavigationBar(
                  key: const Key('nav-bar'),
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                      key: Key('nav-home'),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.fitness_center_outlined),
                      selectedIcon: Icon(Icons.fitness_center),
                      label: 'Workouts',
                      key: Key('nav-workouts'),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.list_outlined),
                      selectedIcon: Icon(Icons.list),
                      label: 'Exercises',
                      key: Key('nav-exercises'),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.trending_up_outlined),
                      selectedIcon: Icon(Icons.trending_up),
                      label: 'Progress',
                      key: Key('nav-progress'),
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.restaurant_outlined),
                      selectedIcon: Icon(Icons.restaurant),
                      label: 'Nutrition',
                      key: Key('nav-nutrition'),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
