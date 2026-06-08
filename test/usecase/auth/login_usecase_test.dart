import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_auth_repository.dart';

class LoginUseCase {
  final FakeAuthRepository repository;

  LoginUseCase(this.repository);

  Future<bool> call(String email, String password) {
    return repository.login(email, password);
  }
}

void main() {
  test('login usecase should return true when login succeeds', () async {
    final repo = FakeAuthRepository();
    final usecase = LoginUseCase(repo);

    final result = await usecase('test@test.com', '123456');

    expect(result, true);
  });

  test('login returns true with valid credentials', () async {
  final repo = FakeAuthRepository();
  final usecase = LoginUseCase(repo);

  final result = await usecase('user@test.com', '123456');

  expect(result, true);
});
}