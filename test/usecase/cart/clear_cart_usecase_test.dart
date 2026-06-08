import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_cart_repository.dart';

class ClearCartUseCase {
  final FakeCartRepository repository;

  ClearCartUseCase(this.repository);

  void call() {
    repository.clearCart();
  }
}

void main() {
  test('clear cart empties all items', () {
    final repo = FakeCartRepository();
    repo.addItem('Rose');
    repo.addItem('Tulip');
    final usecase = ClearCartUseCase(repo);

    usecase();

    expect(repo.items.isEmpty, true);
  });
}