import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/booking/data/models/booking_model.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/providers/booking_provider.dart';

class MyTicketsScreen extends ConsumerWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('My Bookings', style: AppTextStyles.h3.copyWith(color: AppColors.white)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ref.invalidate(myBookingsProvider),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.refresh_rounded, color: AppColors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: bookingsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textLight),
                        const SizedBox(height: 12),
                        Text(
                          err.toString().replaceFirst('Exception: ', ''),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          onPressed: () => ref.invalidate(myBookingsProvider),
                          child: const Text('Retry', style: TextStyle(color: AppColors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.textLight),
                          const SizedBox(height: 12),
                          Text('No bookings yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey)),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: bookings.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _ticketCard(bookings[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard(BookingModel booking) {
    final cancelled = booking.bookingStatus == 'cancelled';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(booking.busName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (cancelled ? AppColors.error : AppColors.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  cancelled ? 'Cancelled' : 'Confirmed',
                  style: AppTextStyles.label.copyWith(color: cancelled ? AppColors.error : AppColors.primary, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${booking.from} → ${booking.to}  •  ${booking.departure}', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Text('Booking ID: ${booking.bookingId}', style: AppTextStyles.bodySmall.copyWith(fontSize: 11, color: AppColors.textGrey)),
          const SizedBox(height: 8),
          const Divider(color: AppColors.textLight, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Seats: ${booking.selectedSeats.join(', ')}', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
              Text('Rs ${booking.totalPrice}', style: AppTextStyles.price.copyWith(fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}
