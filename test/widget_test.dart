import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gym_workout_tracker_v2/main.dart' as app;
import 'package:gym_workout_tracker_v2/app/router.dart';

double _contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}

void _setViewport(WidgetTester tester, Size size, {double scale = 1}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

void main() {
  testWidgets('App bootstraps with ProviderScope and Home screen', (
    WidgetTester tester,
  ) async {
    _setViewport(tester, const Size(375, 812));
    app.main();
    await tester.pumpAndSettle();

    expect(find.byType(ProviderScope), findsOneWidget);
    expect(find.text('Gym Workout Tracker'), findsOneWidget);
    expect(find.text('View workouts'), findsOneWidget);
  });

  testWidgets(
    'Navigation switches all five sections and selected destinations',
    (tester) async {
      _setViewport(tester, const Size(375, 812));
      await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
      await tester.pumpAndSettle();
      final router = ProviderScope.containerOf(
        tester.element(find.byType(app.MyApp)),
        listen: false,
      ).read(appRouterProvider);
      const sections = [
        'home',
        'workouts',
        'exercises',
        'progress',
        'nutrition',
      ];
      for (var index = 0; index < sections.length; index++) {
        final section = sections[index];
        await tester.tap(find.byKey(Key('nav-$section')));
        await tester.pumpAndSettle();
        expect(find.byKey(Key('page-$section')), findsOneWidget);
        expect(
          tester
              .widget<NavigationBar>(find.byKey(const Key('nav-bar')))
              .selectedIndex,
          index,
        );
        expect(router.routeInformationProvider.value.uri.path, '/$section');
      }
    },
  );

  testWidgets('Deep link to /exercises route', (WidgetTester tester) async {
    final router = createAppRouter(initialLocation: '/exercises');
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appRouterProvider.overrideWithValue(router)],
        child: const app.MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('page-exercises')), findsOneWidget);
    expect(
      find.text('No exercises saved yet. Your library will appear here.'),
      findsOneWidget,
    );
  });

  testWidgets('Unknown route recovers to Home', (WidgetTester tester) async {
    final router = createAppRouter(initialLocation: '/unknown');
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appRouterProvider.overrideWithValue(router)],
        child: const app.MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Page not found'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Gym Workout Tracker'), findsOneWidget);
  });

  testWidgets('Compact layout shows NavigationBar', (
    WidgetTester tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('nav-bar')), findsOneWidget);
    expect(find.byKey(const Key('nav-rail')), findsNothing);
  });

  testWidgets('Wide layout shows NavigationRail', (WidgetTester tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('nav-bar')), findsNothing);
    expect(find.byKey(const Key('nav-rail')), findsOneWidget);
  });

  testWidgets('Root theme is dark by default', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    final theme = Theme.of(context);
    expect(theme.brightness, Brightness.dark);
  });

  testWidgets('App supports explicit light mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: app.MyApp(themeMode: ThemeMode.light)),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    final theme = Theme.of(context);
    expect(theme.brightness, Brightness.light);
  });

  testWidgets('System brightness changes in ThemeMode.system', (
    WidgetTester tester,
  ) async {
    final binding = TestWidgetsFlutterBinding.instance;

    addTearDown(() {
      binding.platformDispatcher.clearPlatformBrightnessTestValue();
    });

    binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

    await tester.pumpWidget(
      const ProviderScope(child: app.MyApp(themeMode: ThemeMode.system)),
    );
    await tester.pumpAndSettle();

    var context = tester.element(find.byType(Scaffold).first);
    var theme = Theme.of(context);
    expect(theme.brightness, Brightness.dark);

    binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();

    context = tester.element(find.byType(Scaffold).first);
    theme = Theme.of(context);
    expect(theme.brightness, Brightness.light);
  });

  testWidgets('Dark theme has sufficient text contrast', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: app.MyApp(themeMode: ThemeMode.dark)),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    final theme = Theme.of(context);
    expect(
      _contrast(
        theme.textTheme.bodyMedium!.color!,
        theme.scaffoldBackgroundColor,
      ),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrast(theme.colorScheme.onPrimary, theme.colorScheme.primary),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets('Light theme has sufficient text contrast', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: app.MyApp(themeMode: ThemeMode.light)),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    final theme = Theme.of(context);
    expect(
      _contrast(
        theme.textTheme.bodyMedium!.color!,
        theme.scaffoldBackgroundColor,
      ),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrast(theme.colorScheme.onPrimary, theme.colorScheme.primary),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets('Portrait viewport at 2x scale without overflow', (
    WidgetTester tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;

    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();

    expect(
      MediaQuery.textScalerOf(
        tester.element(find.byType(Scaffold).first),
      ).scale(10),
      20,
    );
    expect(tester.takeException(), isNull);

    final workoutsNav = find.byKey(const Key('nav-workouts'));
    expect(workoutsNav, findsOneWidget);
    await tester.tap(workoutsNav);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-workouts')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Landscape viewport at 2x scale without overflow', (
    WidgetTester tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    tester.view.physicalSize = const Size(812, 375);
    tester.view.devicePixelRatio = 1.0;
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;

    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();

    expect(
      MediaQuery.textScalerOf(
        tester.element(find.byType(Scaffold).first),
      ).scale(10),
      20,
    );
    expect(tester.takeException(), isNull);

    expect(find.byKey(const Key('nav-bar')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-workouts')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('page-workouts')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Root path redirects to Home', (tester) async {
    final router = createAppRouter(initialLocation: '/');
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appRouterProvider.overrideWithValue(router)],
        child: const app.MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-home')), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/home');
  });

  testWidgets('Home action opens Workouts', (tester) async {
    _setViewport(tester, const Size(375, 812));
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View workouts'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-workouts')), findsOneWidget);
    expect(
      tester
          .widget<NavigationBar>(find.byKey(const Key('nav-bar')))
          .selectedIndex,
      1,
    );
  });

  testWidgets('Extended desktop rail remains operable', (tester) async {
    _setViewport(tester, const Size(1280, 800));
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();
    final rail = find.byKey(const Key('nav-rail'));
    expect(tester.widget<NavigationRail>(rail).extended, isTrue);
    await tester.tap(
      find.descendant(of: rail, matching: find.text('Nutrition')).last,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page-nutrition')), findsOneWidget);
    expect(tester.widget<NavigationRail>(rail).selectedIndex, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home scroll position survives section switching', (
    tester,
  ) async {
    _setViewport(tester, const Size(375, 480), scale: 2);
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();
    final page = find.byKey(const Key('page-home'));
    final view = find.descendant(
      of: page,
      matching: find.byType(SingleChildScrollView),
    );
    await tester.drag(view, const Offset(0, -120));
    await tester.pumpAndSettle();
    final scrollable = find
        .descendant(of: page, matching: find.byType(Scrollable))
        .first;
    final offset = tester.state<ScrollableState>(scrollable).position.pixels;
    expect(offset, greaterThan(0));
    await tester.tap(find.byKey(const Key('nav-workouts')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-home')));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScrollableState>(scrollable).position.pixels,
      closeTo(offset, 0.5),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home ListTile shortcuts navigate to correct sections', (
    tester,
  ) async {
    _setViewport(tester, const Size(375, 812));
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();
    final router = ProviderScope.containerOf(
      tester.element(find.byType(app.MyApp)),
      listen: false,
    ).read(appRouterProvider);
    final page = find.byKey(const Key('page-home'));
    final shortcuts = [
      ('Exercises', '/exercises', 2),
      ('Progress', '/progress', 3),
      ('Nutrition', '/nutrition', 4),
    ];
    for (final (title, route, index) in shortcuts) {
      final tile = find.descendant(
        of: page,
        matching: find.widgetWithText(ListTile, title),
      );
      await tester.ensureVisible(tile);
      await tester.pumpAndSettle();
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('page-${route.substring(1)}')), findsOneWidget);
      expect(
        tester
            .widget<NavigationBar>(find.byKey(const Key('nav-bar')))
            .selectedIndex,
        index,
      );
      expect(router.routeInformationProvider.value.uri.path, route);
      await tester.tap(find.byKey(const Key('nav-home')));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('Navigation persists across responsive breakpoints', (
    tester,
  ) async {
    _setViewport(tester, const Size(375, 812));
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();
    final router = ProviderScope.containerOf(
      tester.element(find.byType(app.MyApp)),
      listen: false,
    ).read(appRouterProvider);
    await tester.tap(find.byKey(const Key('nav-nutrition')));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/nutrition');
    tester.view.physicalSize = const Size(800, 600);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('nav-rail')), findsOneWidget);
    expect(
      tester.widget<NavigationRail>(find.byKey(const Key('nav-rail'))).extended,
      isFalse,
    );
    expect(
      tester
          .widget<NavigationRail>(find.byKey(const Key('nav-rail')))
          .selectedIndex,
      4,
    );
    expect(find.byKey(const Key('page-nutrition')), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/nutrition');
    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();
    expect(
      tester.widget<NavigationRail>(find.byKey(const Key('nav-rail'))).extended,
      isTrue,
    );
    expect(
      tester
          .widget<NavigationRail>(find.byKey(const Key('nav-rail')))
          .selectedIndex,
      4,
    );
    expect(find.byKey(const Key('page-nutrition')), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/nutrition');
    tester.view.physicalSize = const Size(812, 375);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('nav-bar')), findsOneWidget);
    expect(
      tester
          .widget<NavigationBar>(find.byKey(const Key('nav-bar')))
          .selectedIndex,
      4,
    );
    expect(find.byKey(const Key('page-nutrition')), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/nutrition');
  });

  testWidgets('Enter activates a focused desktop navigation destination', (
    tester,
  ) async {
    _setViewport(tester, const Size(800, 600));
    await tester.pumpWidget(const ProviderScope(child: app.MyApp()));
    await tester.pumpAndSettle();
    final router = ProviderScope.containerOf(
      tester.element(find.byType(app.MyApp)),
      listen: false,
    ).read(appRouterProvider);
    expect(router.routeInformationProvider.value.uri.path, '/home');
    final destination = find.descendant(
      of: find.byKey(const Key('nav-rail')),
      matching: find.text('Nutrition'),
    );
    final focus = Focus.of(tester.element(destination));
    focus.requestFocus();
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/nutrition');
    expect(find.byKey(const Key('page-nutrition')), findsOneWidget);
    expect(
      tester
          .widget<NavigationRail>(find.byKey(const Key('nav-rail')))
          .selectedIndex,
      4,
    );
  });
}
