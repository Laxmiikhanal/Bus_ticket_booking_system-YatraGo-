import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:bus_ticket_booking_system/features/auth/data/datasources/remote/auth_remote_datasource.dart";
import "package:bus_ticket_booking_system/features/auth/domain/entities/auth_entity.dart";

final authDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(),
);

/// Holds the currently logged-in user (null = logged out).
class AuthNotifier extends StateNotifier<AsyncValue<AuthEntity?>> {
  final AuthRemoteDataSource _ds;
  AuthNotifier(this._ds) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ds.login(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Register, then immediately log in to get a token.
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _ds.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      final user = await _ds.login(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await _ds.logout();
    state = const AsyncValue.data(null);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthEntity?>>(
  (ref) => AuthNotifier(ref.watch(authDataSourceProvider)),
);
