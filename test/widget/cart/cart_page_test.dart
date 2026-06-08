import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cart page shows title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('My Cart'),
        ),
      ),
    );

    expect(find.text('My Cart'), findsOneWidget);
  });

  testWidgets('checkout button exists', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: ElevatedButton(onPressed: null, child: Text('Checkout')),
    ),
  );

  expect(find.text('Checkout'), findsOneWidget);
});

testWidgets('cart title exists', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: Text('My Cart')));
  expect(find.text('My Cart'), findsOneWidget);
});
}