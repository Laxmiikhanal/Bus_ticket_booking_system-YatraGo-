import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_cart_repository.dart';

class AddToCartUseCase {
  final FakeCartRepository repository;

  AddToCartUseCase(this.repository);

  void call(String item) {
    repository.addItem(item);
  }
}

void main() {
  test('add to cart adds item', () {
    final repo = FakeCartRepository();
    final usecase = AddToCartUseCase(repo);

    usecase('Rose');

    expect(repo.items.contains('Rose'), true);
  });
}