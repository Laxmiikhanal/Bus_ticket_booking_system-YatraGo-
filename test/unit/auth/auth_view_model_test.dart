import 'package:flutter_test/flutter_test.dart';

class AuthViewModel {
  bool isLoading = false;
  bool isSuccess = false;
  String? error;

  void loginSuccess() {
    isLoading = false;
    isSuccess = true;
    error = null;
  }

  void loginError(String message) {
    isLoading = false;
    isSuccess = false;
    error = message;
  }

  void setLoading() {
    isLoading = true;
  }
}

void main() {
  test('setLoading sets loading to true', () {
    final vm = AuthViewModel();
    vm.setLoading();
    expect(vm.isLoading, true);
  });

  test('loginSuccess sets success state', () {
    final vm = AuthViewModel();
    vm.loginSuccess();
    expect(vm.isSuccess, true);
    expect(vm.error, null);
  });

  test('loginError sets error state', () {
    final vm = AuthViewModel();
    vm.loginError('Login failed');
    expect(vm.isSuccess, false);
    expect(vm.error, 'Login failed');
  });
}