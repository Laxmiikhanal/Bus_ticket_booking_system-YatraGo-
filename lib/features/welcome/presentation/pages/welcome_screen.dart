import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';
import 'package:bus_ticket_booking_system/core/theme/app_text_styles.dart';
import 'package:bus_ticket_booking_system/features/auth/presentation/pages/login_page.dart';
import 'package:bus_ticket_booking_system/features/auth/presentation/pages/register_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Bus Icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.light, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  size: 48,
                  color: AppColors.white,
                ),
              ),

              const SizedBox(height: 28),

              // Brand name
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.pale, AppColors.orange],
                ).createShader(bounds),
                child: Text(
                  'YatraGo',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Nepal Bus Booking',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.55),
                  letterSpacing: 1.5,
                  fontSize: 12,
                ),
              ),

              const Spacer(flex: 2),

              // Features row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _featureChip('🎟️', 'Easy Booking'),
                  const SizedBox(width: 12),
                  _featureChip('💺', 'Pick Seats'),
                  const SizedBox(width: 12),
                  _featureChip('📱', 'E-Ticket'),
                ],
              ),

              const SizedBox(height: 36),

              // Get Started button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()));
                  },
                  child: Text(
                    'Get Started',
                    style: AppTextStyles.buttonText.copyWith(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.pale,
                    side: BorderSide(
                      color: AppColors.white.withValues(alpha: 0.25),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                  },
                  child: Text(
                    'I already have an account',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.pale,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}