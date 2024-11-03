import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF000C3B);
  static const Color secondary = Color(0xFF6200EE);
  static const Color background = Color(0xFFF6F6F6);
  static const Color scaffoldBackground = Color(0xFF000C3B);
  static const Color error = Color(0xFFB00020);
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
