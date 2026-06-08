import 'package:flutter_test/flutter_test.dart';

double calculateSubtotal(List<double> prices) {
  return prices.fold(0, (sum, item) => sum + item);
}

int calculateTotalItems(List<int> quantities) {
  return quantities.fold(0, (sum, item) => sum + item);
}

void main() {
  test('subtotal is calculated correctly', () {
    expect(calculateSubtotal([100, 200, 300]), 600);
  });

  test('empty subtotal is zero', () {
    expect(calculateSubtotal([]), 0);
  });

  test('total item count is calculated correctly', () {
    expect(calculateTotalItems([1, 2, 3]), 6);
  });

  test('single item subtotal works', () {
  expect(calculateSubtotal([500]), 500);
});
}