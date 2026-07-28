import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';

import 'package:bus_ticket_booking_system/features/booking/data/models/booking_model.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/providers/booking_provider.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/screens/booking_cancellation_screen.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(myBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Bookings"),
      ),
      body: bookings.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),

        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "No bookings yet",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(myBookingsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (_, index) {
                final booking = list[index];

                return _BookingCard(booking: booking);
              },
            ),
          );
        },
      ),
    );
  }
}

class _BookingCard extends ConsumerStatefulWidget {
  final BookingModel booking;

  const _BookingCard({
    required this.booking,
  });

  @override
  ConsumerState<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends ConsumerState<_BookingCard> {
  Future<void> _confirmCancel() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BookingCancellationScreen(booking: widget.booking),
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Booking cancelled"),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final isCancelled = booking.bookingStatus.toLowerCase() == "cancelled";
    final statusColor = isCancelled ? AppColors.error : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 12,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        booking.busName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        booking.bookingId,
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    booking.bookingStatus.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            _row("Route",
                "${booking.from} → ${booking.to}"),

            _row(
              "Departure",
              booking.departure,
            ),

            _row(
              "Passenger",
              booking.passengerName,
            ),

            _row(
              "Seats",
              booking.selectedSeats.join(", "),
            ),

            _row(
              "Payment",
              booking.paymentMethod.toUpperCase(),
            ),

            _row(
              "Amount",
              "Rs ${booking.totalPrice}",
            ),

            if (isCancelled && booking.refundStatus != "not_applicable")
              _row(
                "Refund",
                booking.refundStatus == "processed" ? "Processed" : "Pending",
              ),

            if (booking.createdAt != null)

              _row(
                "Booked On",
                DateFormat(
                  "dd MMM yyyy • hh:mm a",
                ).format(
                  booking.createdAt!,
                ),
              ),

            if (!isCancelled) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error.withValues(alpha: .4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _confirmCancel,
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text("Cancel Booking"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String left, String right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [

          SizedBox(
            width: 95,
            child: Text(
              left,
              style: AppTextStyles.bodySmall,
            ),
          ),

          Expanded(
            child: Text(
              right,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}