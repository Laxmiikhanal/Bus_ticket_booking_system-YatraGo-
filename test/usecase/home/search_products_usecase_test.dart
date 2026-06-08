import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_product_repository.dart';

class SearchProductsUseCase {
  final FakeProductRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<String>> call(String query) {
    return repository.searchProducts(query);
  }
}

void main() {
  test('search products returns matching items', () async {
    final repo = FakeProductRepository();
    final usecase = SearchProductsUseCase(repo);

    final result = await usecase('rose');

    expect(result, ['Rose Bouquet']);
  });
}