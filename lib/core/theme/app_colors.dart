import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF454545);
  static const Color secondary = Color(0xFF6200EE);
  static const Color background = Color(0xFFF6F6F6);
  static const Color onPrimary = Colors.white;
  static const Color scaffoldBackground = Color(0xFF6A6A6A);
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  static const Gradient gradient = LinearGradient(
      colors: [
        Color(0xFF2737CF),
        Color(0xFF6562FB),
      ],
      stops: [0.1, 0.9]
  );

  static final Gradient disabledGradient = LinearGradient(
      colors: [
        Colors.grey.shade400,
        Colors.grey.shade400,
      ],
      stops: [0.1, 0.9]
  );

}
