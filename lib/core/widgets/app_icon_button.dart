import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onPressed;
  const AppIconButton({
    super.key,
    required this.icon,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(
        icon,
        size: 30.0,
        color: isEnabled ? Colors.white : Colors.white24,
      ),
    );
  }
}
