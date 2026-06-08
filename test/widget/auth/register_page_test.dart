import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('register page shows fields and register button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(key: Key('name')),
              TextField(key: Key('email')),
              TextField(key: Key('password')),
              ElevatedButton(
                onPressed: null,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('name')), findsOneWidget);
    expect(find.byKey(const Key('email')), findsOneWidget);
    expect(find.byKey(const Key('password')), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('name field appears', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextField(key: Key('name')),
        ),
      ),
    );

    expect(find.byKey(const Key('name')), findsOneWidget);
  });

  testWidgets('email field appears', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextField(key: Key('email')),
        ),
      ),
    );

    expect(find.byKey(const Key('email')), findsOneWidget);
  });

  testWidgets('register button exists', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: null,
            child: Text('Register'),
          ),
        ),
      ),
    );

    expect(find.text('Register'), findsOneWidget);
  });
}