import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:bus_ticket_booking_system/features/booking/data/datasources/remote/booking_remote_datasource.dart";
import "package:bus_ticket_booking_system/features/booking/data/models/booking_model.dart";

final bookingDataSourceProvider = Provider<BookingRemoteDataSource>(
  (ref) => BookingRemoteDataSource(),
);

/// Fetches the current user's bookings. Call `ref.refresh(myBookingsProvider)`
/// or `ref.invalidate(myBookingsProvider)` after creating/cancelling a booking.
final myBookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final ds = ref.watch(bookingDataSourceProvider);
  return ds.getMyBookings();
});

class BookingNotifier extends StateNotifier<AsyncValue<BookingModel?>> {
  final BookingRemoteDataSource _ds;
  final Ref _ref;
  BookingNotifier(this._ds, this._ref) : super(const AsyncValue.data(null));

  Future<BookingModel?> createBooking({
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
    state = const AsyncValue.loading();
    try {
      final booking = await _ds.createBooking(
        busId: busId,
        busName: busName,
        from: from,
        to: to,
        departure: departure,
        selectedSeats: selectedSeats,
        passengerName: passengerName,
        passengerPhone: passengerPhone,
        passengerEmail: passengerEmail,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
      );
      state = AsyncValue.data(booking);
      return booking;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  /// Cancels a booking by its bookingId, then refreshes myBookingsProvider.
  /// Throws on failure so the caller can show an error message.
  Future<void> cancelBooking(String bookingId) async {
    await _ds.cancelBooking(bookingId);
    _ref.invalidate(myBookingsProvider);
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<BookingModel?>>(
  (ref) => BookingNotifier(ref.watch(bookingDataSourceProvider), ref),
);