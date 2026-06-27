import "package:dio/dio.dart";
import "package:bus_ticket_booking_system/core/network/dio_client.dart";
import "package:bus_ticket_booking_system/features/bus_list/data/models/bus_model.dart";

class BusListRemoteDataSource {
  final Dio _dio = DioClient.instance;

  Future<List<BusModel>> getBuses({
    required String from,
    required String to,
  }) async {
    try {
      final response = await _dio.get(
        "/buses",
        queryParameters: {
          if (from.isNotEmpty) "from": from,
          if (to.isNotEmpty) "to": to,
        },
      );

      final body = response.data;
      final List list = (body is Map && body["data"] is List)
          ? body["data"] as List
          : const [];

      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => BusModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  String _friendlyError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return "Cannot reach the server. Make sure the backend is running and you are using the right address (10.0.2.2 on the emulator).";
    }
    final code = e.response?.statusCode;
    if (code != null) {
      return "Server returned error $code.";
    }
    return "Something went wrong while loading buses.";
  }
}
