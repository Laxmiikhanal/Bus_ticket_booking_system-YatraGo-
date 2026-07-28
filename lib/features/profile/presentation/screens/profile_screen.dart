import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:bus_ticket_booking_system/features/welcome/presentation/pages/welcome_screen.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/providers/booking_provider.dart';
import 'package:bus_ticket_booking_system/features/booking/presentation/screens/my_bookings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final bookingsAsync = ref.watch(myBookingsProvider);

    final tripCount = bookingsAsync.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: const BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
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
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: AppColors.white, size: 16),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text('Profile',
                            style: AppTextStyles.h3.copyWith(color: AppColors.white)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [AppColors.light, AppColors.primary]),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          (user?.fullName.isNotEmpty == true ? user!.fullName[0] : '?')
                              .toUpperCase(),
                          style: AppTextStyles.h1.copyWith(color: AppColors.white, fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(user?.fullName ?? 'Guest',
                        style: AppTextStyles.h3.copyWith(color: AppColors.white)),
                    const SizedBox(height: 2),
                    Text(user?.email ?? '',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.pale, fontSize: 12)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _statCard('$tripCount', 'Trips'),
                        const SizedBox(width: 10),
                        _statCard('4.9', 'Rating', icon: Icons.star_rounded),
                        const SizedBox(width: 10),
                        _statCard('Gold', 'Member', icon: Icons.emoji_events_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 4),
                      child: Text('ACCOUNT', style: AppTextStyles.label),
                    ),
                    _menuTile(
                      Icons.confirmation_number_rounded,
                      'My Bookings',
                      AppColors.primary,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
                      ),
                    ),
                    _menuTile(Icons.favorite_rounded, 'Saved Routes', Colors.redAccent, () {}),
                    _menuTile(
                        Icons.credit_card_rounded, 'Payment Methods', Colors.blueAccent, () {}),
                    _menuTile(
                        Icons.help_outline_rounded, 'Help & Support', Colors.orangeAccent, () {}),
                    _menuTile(Icons.logout_rounded, 'Log Out', AppColors.error, () async {
                      await ref.read(authProvider.notifier).logout();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                        (_) => false,
                      );
                    }),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 4),
                      child: Text('RECENT TRIPS', style: AppTextStyles.label),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10),
                        ],
                      ),
                      child: bookingsAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text('Could not load trips', style: AppTextStyles.bodySmall),
                        ),
                        data: (list) {
                          if (list.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text('No trips yet', style: AppTextStyles.bodySmall),
                            );
                          }
                          final recent = list.take(3).toList();
                          return Column(
                            children: [
                              for (int i = 0; i < recent.length; i++) ...[
                                _tripRow(recent[i]),
                                if (i != recent.length - 1)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(height: 1),
                                  ),
                              ],
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, {IconData? icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.orange, size: 15),
                  const SizedBox(width: 3),
                ],
                Text(
                  value,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.pale, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Text(label,
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _tripRow(dynamic booking) {
    final dateLabel = booking.createdAt != null
        ? DateFormat('d MMM yyyy').format(booking.createdAt)
        : booking.departure;
    final seat =
        (booking.selectedSeats as List).isNotEmpty ? booking.selectedSeats.first : '';
    final status = (booking.bookingStatus as String);
    final statusColor = status.toLowerCase() == 'cancelled'
        ? AppColors.error
        : status.toLowerCase() == 'completed'
            ? AppColors.info
            : AppColors.success;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.directions_bus_rounded, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${booking.from} → ${booking.to}',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                '$dateLabel${seat.isNotEmpty ? ' · Seat $seat' : ''}',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ),
      ],
    );
  }
}