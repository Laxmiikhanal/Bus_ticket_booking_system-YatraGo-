import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String bookingId;
  final String busName;
  final String from;
  final String to;
  final String departure;
  final List<String> seats;
  final String passengerName;
  final String phone;
  final String paymentMethod;
  final int totalPrice;

  const BookingSummaryScreen({
    super.key,
    required this.bookingId,
    required this.busName,
    required this.from,
    required this.to,
    required this.departure,
    required this.seats,
    required this.passengerName,
    required this.phone,
    required this.paymentMethod,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              CircleAvatar(
                radius: 42,
                backgroundColor: Colors.green.shade100,
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 55,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Booking Confirmed!",
                style: AppTextStyles.h2,
              ),

              const SizedBox(height: 8),

              Text(
                "Your bus ticket has been booked successfully.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [

                    _row("Booking ID", bookingId),
                    _divider(),

                    _row("Passenger", passengerName),
                    _divider(),

                    _row("Phone", phone),
                    _divider(),

                    _row("Bus", busName),
                    _divider(),

                    _row("Route", "$from → $to"),
                    _divider(),

                    _row("Departure", departure),
                    _divider(),

                    _row("Seats", seats.join(", ")),
                    _divider(),

                    _row("Payment", paymentMethod),
                    _divider(),

                    _row(
                      "Amount",
                      "Rs $totalPrice",
                      valueColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: Text(
                    "Back to Home",
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Download ticket later
                  },
                  icon: const Icon(Icons.download),
                  label: const Text("Download Ticket"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 1),
      );

  Widget _row(
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textDark,
          ),
        ),
      ],
    );
  }
}