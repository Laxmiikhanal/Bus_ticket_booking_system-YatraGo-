import 'package:flutter_test/flutter_test.dart';

class CartState {
  final Map<String, int> items = {};

  void addItem(String item) {
    items[item] = (items[item] ?? 0) + 1;
  }

  void removeItem(String item) {
    if (!items.containsKey(item)) return;
    if (items[item] == 1) {
      items.remove(item);
    } else {
      items[item] = items[item]! - 1;
    }
  }

  void clearCart() {
    items.clear();
  }
}

void main() {
  test('add item inserts new item', () {
    final cart = CartState();
    cart.addItem('Rose');
    expect(cart.items['Rose'], 1);
  });

  test('add same item increases quantity', () {
    final cart = CartState();
    cart.addItem('Rose');
    cart.addItem('Rose');
    expect(cart.items['Rose'], 2);
  });

  test('remove item decreases quantity', () {
    final cart = CartState();
    cart.addItem('Rose');
    cart.addItem('Rose');
    cart.removeItem('Rose');
    expect(cart.items['Rose'], 1);
  });

  test('remove last item deletes it', () {
    final cart = CartState();
    cart.addItem('Rose');
    cart.removeItem('Rose');
    expect(cart.items.containsKey('Rose'), false);
  });

  test('clear cart removes everything', () {
    final cart = CartState();
    cart.addItem('Rose');
    cart.addItem('Tulip');
    cart.clearCart();
    expect(cart.items.isEmpty, true);
  });
}