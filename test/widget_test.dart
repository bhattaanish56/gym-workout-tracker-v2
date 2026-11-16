import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gym_workout_tracker_v2/main.dart' as app;

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
}
