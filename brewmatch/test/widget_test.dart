// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:brewmatch/core/navigation/root_app.dart';

void main() {
  testWidgets('navigates from login to client flow', (WidgetTester tester) async {
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();

    expect(find.text('BrewMatch'), findsWidgets);

    await tester.tap(find.text('Je suis client'));
    await tester.pumpAndSettle();

    expect(find.text('Tu bois quoi ?'), findsOneWidget);
  });
}
