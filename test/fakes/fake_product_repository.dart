class FakeProductRepository {
  final List<String> _products = ['Rose Bouquet', 'Tulip Bouquet', 'Orchid'];

  Future<List<String>> getProducts() async => _products;

  Future<List<String>> searchProducts(String query) async {
    return _products
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}