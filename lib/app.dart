import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/core/theme/app_theme.dart';
import 'package:bus_ticket_booking_system/features/welcome/presentation/pages/welcome_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YatraGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
