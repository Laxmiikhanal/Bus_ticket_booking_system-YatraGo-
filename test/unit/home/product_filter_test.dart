import 'package:flutter_test/flutter_test.dart';

List<String> filterProducts(List<String> products, String query) {
  return products
      .where((p) => p.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

void main() {
  test('search should return matching products', () {
    final result = filterProducts(
      ['Rose', 'Tulip', 'Orchid'],
      'ro',
    );

    expect(result, ['Rose']);
  });

  test('search is case insensitive', () {
  final result = filterProducts(['Rose', 'Tulip'], 'RO');
  expect(result, ['Rose']);
});
}