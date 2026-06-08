import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email) {
  return email.contains('@') && email.contains('.');
}

bool isValidPassword(String password) {
  return password.length >= 6;
}

void main() {
  test('valid email returns true', () {
    expect(isValidEmail('test@example.com'), true);
  });

  test('invalid email returns false', () {
    expect(isValidEmail('invalid-email'), false);
  });

  test('valid password returns true', () {
    expect(isValidPassword('123456'), true);
  });

  test('short password returns false', () {
    expect(isValidPassword('123'), false);
  });

  test('email with missing dot is invalid', () {
  expect(isValidEmail('test@example'), false);
});

test('password length exactly 6 is valid', () {
  expect(isValidPassword('123456'), true);
});
}