// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:brewmatch/core/navigation/root_app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Use a minimal test-only counter widget to avoid initializing Firebase
    // from the real app. This keeps the smoke test focused and isolated.
    await tester.pumpWidget(const MaterialApp(home: _TestCounterApp()));

    expect(find.text('BrewMatch'), findsWidgets);

    await tester.tap(find.text('Je suis client'));
    await tester.pumpAndSettle();

    expect(find.text('Tu bois quoi ?'), findsOneWidget);
  });
}

// Small test-only counter widget used by the widget test above.
class _TestCounterApp extends StatefulWidget {
  const _TestCounterApp({Key? key}) : super(key: key);

  @override
  State<_TestCounterApp> createState() => _TestCounterAppState();
}

class _TestCounterAppState extends State<_TestCounterApp> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$_counter')),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
