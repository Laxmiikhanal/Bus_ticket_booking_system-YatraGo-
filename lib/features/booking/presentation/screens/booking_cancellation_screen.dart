import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/booking/data/models/booking_model.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/providers/booking_provider.dart';

class BookingCancellationScreen extends ConsumerStatefulWidget {
  final BookingModel booking;

  const BookingCancellationScreen({super.key, required this.booking});

  @override
  ConsumerState<BookingCancellationScreen> createState() =>
      _BookingCancellationScreenState();
}

class _BookingCancellationScreenState
    extends ConsumerState<BookingCancellationScreen> {
  static const _reasons = [
    "Change of plans",
    "Found a better price",
    "Travel date changed",
    "Booked by mistake",
    "Other",
  ];

  String? _selectedReason;
  bool _isCancelling = false;

  Future<void> _confirmCancel() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select a reason"),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isCancelling = true);
    try {
      await ref.read(bookingProvider.notifier).cancelBooking(widget.booking.bookingId);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCancelling = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Cancel Booking"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.busName,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("${booking.from} → ${booking.to}", style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    Text(booking.departure, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    Text("Seats: ${booking.selectedSeats.join(", ")}",
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (booking.paymentStatus == "paid")
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Rs ${booking.totalPrice} will be refunded after cancellation.",
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              Text("Why are you cancelling?", style: AppTextStyles.label),
              const SizedBox(height: 12),
              ..._reasons.map((reason) => _reasonTile(reason)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _isCancelling ? null : _confirmCancel,
                  child: _isCancelling
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                      : Text("Confirm Cancellation",
                          style: AppTextStyles.buttonText.copyWith(fontSize: 15)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: _isCancelling ? null : () => Navigator.pop(context, false),
                  child: Text("Keep My Booking",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reasonTile(String reason) {
    final selected = _selectedReason == reason;
    return GestureDetector(
      onTap: () => setState(() => _selectedReason = reason),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              size: 20,
              color: selected ? AppColors.primary : AppColors.textLight,
            ),
            const SizedBox(width: 12),
            Text(reason, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}