class FakeAuthRepository {
  Future<bool> login(String email, String password) async => true;

  Future<bool> register(String email, String password) async => true;
}