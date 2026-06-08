import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textDark);
  static const TextStyle h2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark);
  static const TextStyle h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark);
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDark);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textGrey);
  static const TextStyle label = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textGrey, letterSpacing: 1.5);
  static const TextStyle buttonText = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.white);
  static const TextStyle price = TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.darkGreen);
}
