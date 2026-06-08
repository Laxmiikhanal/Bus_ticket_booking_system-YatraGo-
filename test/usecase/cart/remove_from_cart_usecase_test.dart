import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_cart_repository.dart';

class RemoveFromCartUseCase {
  final FakeCartRepository repository;

  RemoveFromCartUseCase(this.repository);

  void call(String item) {
    repository.removeItem(item);
  }
}

void main() {
  test('remove from cart removes item', () {
    final repo = FakeCartRepository();
    repo.addItem('Rose');
    final usecase = RemoveFromCartUseCase(repo);

    usecase('Rose');

    expect(repo.items.contains('Rose'), false);
  });
}