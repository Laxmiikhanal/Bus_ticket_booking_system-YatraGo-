import "dart:convert";
import "package:dio/dio.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:bus_ticket_booking_system/core/network/dio_client.dart";
import "package:bus_ticket_booking_system/features/auth/domain/entities/auth_entity.dart";

class AuthRemoteDataSource {
  final Dio _dio = DioClient.instance;
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = "auth_token";
  static const _userKey = "auth_user";

  Future<AuthEntity> login({required String email, required String password}) async {
    try {
      final res = await _dio.post("/auth/login", data: {
        "email": email,
        "password": password,
      });
      final body = res.data;
      if (body is! Map || body["user"] == null) {
        throw Exception("Unexpected response from server. Please try again.");
      }
      final token = body["token"]?.toString();
      final userJson = (body["user"] as Map).cast<String, dynamic>();

      if (token != null) {
        await _storage.write(key: _tokenKey, value: token);
        await _storage.write(key: _userKey, value: jsonEncode(userJson));
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
      final body = res.data;
      if (body is! Map || body["user"] == null) {
        throw Exception("Unexpected response from server. Please try again.");
      }
      final userJson = (body["user"] as Map).cast<String, dynamic>();
      return AuthEntity.fromJson(userJson);
    } on DioException catch (e) {
      throw Exception(_msg(e));
    }
  }

  Future<String?> getStoredToken() => _storage.read(key: _tokenKey);

  /// Re-attaches a previously stored token/user on app startup.
  /// Returns null if there is no saved session.
  Future<AuthEntity?> restoreSession() async {
    final token = await _storage.read(key: _tokenKey);
    final userRaw = await _storage.read(key: _userKey);
    if (token == null || userRaw == null) return null;

    DioClient.setAuthToken(token);
    try {
      final userJson = (jsonDecode(userRaw) as Map).cast<String, dynamic>();
      return AuthEntity.fromJson(userJson, token: token);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
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
    final status = e.response?.statusCode;
    if (status != null && status >= 500) {
      return "Server error ($status). Check the backend logs.";
    }
    return "Something went wrong. Please try again.";
  }
}
