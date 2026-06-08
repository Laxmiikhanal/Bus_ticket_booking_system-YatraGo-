import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/home/presentation/screens/home_screen.dart';

class TicketConfirmedScreen extends StatelessWidget {
  final String busName;
  final String from;
  final String to;
  final String departure;
  final List<String> selectedSeats;
  final int totalPrice;
  final String bookingId;

  const TicketConfirmedScreen({
    super.key,
    required this.busName,
    required this.from,
    required this.to,
    required this.departure,
    required this.selectedSeats,
    required this.totalPrice,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Success icon
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 60),
              ),

              const SizedBox(height: 24),

              Text('Booking Confirmed!', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text('Your ticket has been booked successfully',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                  textAlign: TextAlign.center),

              const SizedBox(height: 32),

              // Ticket card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06), blurRadius: 16)],
                ),
                child: Column(
                  children: [
                    // Bus name + booking id
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(busName,
                            style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('✓ Confirmed',
                              style: AppTextStyles.label.copyWith(
                                  color: AppColors.primary, fontSize: 9)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.textLight),
                    const SizedBox(height: 16),

                    // Route
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(from, style: AppTextStyles.h3),
                          Text('Departure', style: AppTextStyles.bodySmall),
                        ]),
                        const Icon(Icons.arrow_forward_rounded,
                            color: AppColors.primary),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(to, style: AppTextStyles.h3),
                          Text('Destination', style: AppTextStyles.bodySmall),
                        ]),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.textLight, height: 1),
                    const SizedBox(height: 16),

                    _ticketRow('Departure', departure),
                    _ticketRow('Seats', selectedSeats.join(', ')),
                    _ticketRow('Booking ID', bookingId),
                    _ticketRow('Total Paid', 'Rs $totalPrice'),
                  ],
                ),
              ),

              const Spacer(),

              // Back to home
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (_) => false,
                  ),
                  child: Text('Back to Home',
                      style: AppTextStyles.buttonText.copyWith(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value, style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w700, color: AppColors.textDark)),
      ],
    ),
  );
}
