import 'package:flutter_test/flutter_test.dart';

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

void main() {
  test('product object should store correct values', () {
    final product = Product(name: 'Rose Bouquet', price: 2500);

    expect(product.name, 'Rose Bouquet');
    expect(product.price, 2500);
  });
}