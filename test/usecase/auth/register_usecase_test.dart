import 'package:flutter_test/flutter_test.dart';
import '../../fakes/fake_auth_repository.dart';

class RegisterUseCase {
  final FakeAuthRepository repository;

  RegisterUseCase(this.repository);

  Future<bool> call(String email, String password) {
    return repository.register(email, password);
  }
}

void main() {
  test('register usecase returns true', () async {
    final repo = FakeAuthRepository();
    final usecase = RegisterUseCase(repo);

    final result = await usecase('new@example.com', '123456');

    expect(result, true);
  });

  test('register returns true with valid data', () async {
  final repo = FakeAuthRepository();
  final usecase = RegisterUseCase(repo);

  final result = await usecase('new@test.com', '123456');

  expect(result, true);
});
}