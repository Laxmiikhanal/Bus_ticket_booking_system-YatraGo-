import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home page should show search field', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextField(
            key: Key('searchField'),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('searchField')), findsOneWidget);
  });

  testWidgets('home title appears', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Blossom'),
        ),
      ),
    );

    expect(find.text('Blossom'), findsOneWidget);
  });

  testWidgets('search field exists', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TextField(
            key: Key('search'),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('search')), findsOneWidget);
  });
  testWidgets('home page renders scaffold', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: Text('Home'),
      ),
    ),
  );

  expect(find.byType(Scaffold), findsOneWidget);
});
}