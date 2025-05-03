import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eco_habits_tracker_new/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const EcoHabitsApp(
        showOnboarding: false,
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
