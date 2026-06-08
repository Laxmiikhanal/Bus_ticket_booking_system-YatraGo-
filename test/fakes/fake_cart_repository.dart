class FakeCartRepository {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  void addItem(String item) {
    _items.add(item);
  }

  void removeItem(String item) {
    _items.remove(item);
  }

  void clearCart() {
    _items.clear();
  }
}