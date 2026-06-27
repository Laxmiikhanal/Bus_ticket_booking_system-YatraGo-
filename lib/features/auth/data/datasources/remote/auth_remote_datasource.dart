import "package:dio/dio.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:bus_ticket_booking_system/core/network/dio_client.dart";
import "package:bus_ticket_booking_system/features/auth/domain/entities/auth_entity.dart";

class AuthRemoteDataSource {
  final Dio _dio = DioClient.instance;
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = "auth_token";

  Future<AuthEntity> login({required String email, required String password}) async {
    try {
      final res = await _dio.post("/auth/login", data: {
        "email": email,
        "password": password,
      });
      final body = res.data as Map<String, dynamic>;
      final token = body["token"]?.toString();
      final userJson = (body["user"] as Map).cast<String, dynamic>();

      if (token != null) {
        await _storage.write(key: _tokenKey, value: token);
        DioClient.setAuthToken(token);
      }
      return AuthEntity.fromJson(userJson, token: token);
    } on DioException catch (e) {
      throw Exception(_msg(e));
    }
  }

  Future<AuthEntity> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post("/auth/register", data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      });
      final body = res.data as Map<String, dynamic>;
      final userJson = (body["user"] as Map).cast<String, dynamic>();
      // Register does NOT return a token, so we log in right after.
      return AuthEntity.fromJson(userJson);
    } on DioException catch (e) {
      throw Exception(_msg(e));
    }
  }

  Future<String?> getStoredToken() => _storage.read(key: _tokenKey);

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    DioClient.clearAuthToken();
  }

  String _msg(DioException e) {
    final data = e.response?.data;
    if (data is Map && data["message"] != null) {
      return data["message"].toString();
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return "Cannot reach server. Is the backend running?";
    }
    return "Something went wrong. Please try again.";
  }
}
