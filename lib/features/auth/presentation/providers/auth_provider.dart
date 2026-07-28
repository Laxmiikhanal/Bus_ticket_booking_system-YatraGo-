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

  /// Registers a new account. Does NOT log the user in — the account is
  /// created, then the caller (RegisterPage) sends them to the Login screen
  /// so they sign in explicitly. Returns true on success, false on failure
  /// (check `state` for the error).
  Future<bool> register({
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
      // Still logged out — registration succeeded but no session exists yet.
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> logout() async {
    await _ds.logout();
    state = const AsyncValue.data(null);
  }

  /// Attempts to resume a session saved from a previous app launch.
  /// Returns the restored user, or null if there was nothing to restore.
  Future<AuthEntity?> restore() async {
    final user = await _ds.restoreSession();
    if (user != null) {
      state = AsyncValue.data(user);
    }
    return user;
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthEntity?>>(
  (ref) => AuthNotifier(ref.watch(authDataSourceProvider)),
);
