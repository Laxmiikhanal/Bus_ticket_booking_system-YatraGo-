import "package:dio/dio.dart";
import "package:bus_ticket_booking_system/core/network/dio_client.dart";
import "package:bus_ticket_booking_system/features/booking/data/models/booking_model.dart";

class BookingRemoteDataSource {
  final Dio _dio = DioClient.instance;

  Future<BookingModel> createBooking({
    required String busId,
    required String busName,
    required String from,
    required String to,
    required String departure,
    required List<String> selectedSeats,
    required String passengerName,
    required String passengerPhone,
    required String passengerEmail,
    required int totalPrice,
    required String paymentMethod,
  }) async {
    try {
      final res = await _dio.post("/bookings", data: {
        "busId": busId,
        "busName": busName,
        "from": from,
        "to": to,
        "departure": departure,
        "selectedSeats": selectedSeats,
        "passengerName": passengerName,
        "passengerPhone": passengerPhone,
        "passengerEmail": passengerEmail,
        "totalPrice": totalPrice,
        "paymentMethod": paymentMethod,
      });
      final body = res.data as Map<String, dynamic>;
      return BookingModel.fromJson((body["data"] as Map).cast<String, dynamic>());
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<List<BookingModel>> getMyBookings() async {
    try {
      final res = await _dio.get("/bookings/my");
      final body = res.data;
      final List list =
          (body is Map && body["data"] is List) ? body["data"] as List : const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<BookingModel> getBookingById(String bookingId) async {
    try {
      final res = await _dio.get("/bookings/$bookingId");
      final body = res.data as Map<String, dynamic>;
      return BookingModel.fromJson((body["data"] as Map).cast<String, dynamic>());
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _dio.patch("/bookings/$bookingId/cancel");
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
    final data = e.response?.data;
    if (data is Map && data["message"] != null) {
      return data["message"].toString();
    }
    final code = e.response?.statusCode;
    if (code == 401) {
      return "Your session has expired. Please log in again.";
    }
    if (code != null) {
      return "Server returned error $code.";
    }
    return "Something went wrong. Please try again.";
  }
}
