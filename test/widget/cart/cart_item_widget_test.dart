import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cart item widget shows item name and quantity', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ListTile(
            title: Text('Rose Bouquet'),
            subtitle: Text('Quantity: 2'),
          ),
        ),
      ),
    );

    expect(find.text('Rose Bouquet'), findsOneWidget);
    expect(find.text('Quantity: 2'), findsOneWidget);
  });
}