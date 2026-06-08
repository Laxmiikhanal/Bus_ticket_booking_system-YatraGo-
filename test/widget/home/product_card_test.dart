import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('product card shows name and price',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Card(
            child: Column(
              children: [
                Text('Rose Bouquet'),
                Text('Rs 2500'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Rose Bouquet'), findsOneWidget);
    expect(find.text('Rs 2500'), findsOneWidget);
  });

  testWidgets('product price appears', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: Text('Rs 2500')));
  expect(find.text('Rs 2500'), findsOneWidget);
});

testWidgets('add button appears', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: ElevatedButton(onPressed: null, child: Text('Add')),
    ),
  );

  expect(find.text('Add'), findsOneWidget);
});
}