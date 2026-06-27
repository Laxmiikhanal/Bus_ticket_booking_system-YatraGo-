import "package:bus_ticket_booking_system/features/auth/domain/entities/auth_entity.dart";

abstract class AuthRepository {
  Future<AuthEntity> login({required String email, required String password});

  Future<AuthEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<AuthEntity?> getCurrentUser();

  Future<void> logout();
}
