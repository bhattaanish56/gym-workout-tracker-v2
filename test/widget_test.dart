import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gym_workout_tracker_v2/main.dart' as app;

double _contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byType(ProviderScope), findsOneWidget);

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Root theme is dark by default', (WidgetTester tester) async {
    app.main();
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

  testWidgets('Dark theme has sufficient text/primary contrast', (
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
    expect(
      _contrast(theme.colorScheme.onSurface, theme.colorScheme.inversePrimary),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets('Light theme has sufficient text/primary contrast', (
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
    expect(
      _contrast(theme.colorScheme.onSurface, theme.colorScheme.inversePrimary),
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

    final incrementButton = find.byIcon(Icons.add);
    expect(incrementButton, findsOneWidget);
    await tester.tap(incrementButton);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
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

    final incrementButton = find.byIcon(Icons.add);
    expect(incrementButton, findsOneWidget);
    await tester.tap(incrementButton);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
