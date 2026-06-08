import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_product_repository.dart';

class GetProductsUseCase {
  final FakeProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<String>> call() {
    return repository.getProducts();
  }
}

void main() {
  test('get products returns product list', () async {
    final repo = FakeProductRepository();
    final usecase = GetProductsUseCase(repo);

    final result = await usecase();

    expect(result.isNotEmpty, true);
  });

  test('get products returns non empty list', () async {
    final repo = FakeProductRepository();
    final usecase = GetProductsUseCase(repo);

    final result = await usecase();

    expect(result.isNotEmpty, true);
  });
}