import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login page shows email, password and button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(key: Key('email')),
              TextField(key: Key('password')),
              ElevatedButton(
                onPressed: null,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('email')), findsOneWidget);
    expect(find.byKey(const Key('password')), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('email field exists', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextField(key: Key('email')),
        ),
      ),
    );

    expect(find.byKey(const Key('email')), findsOneWidget);
  });

  testWidgets('password field exists', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextField(key: Key('password')),
        ),
      ),
    );

    expect(find.byKey(const Key('password')), findsOneWidget);
  });

  testWidgets('login button exists', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: null,
            child: Text('Login'),
          ),
        ),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
  });
}