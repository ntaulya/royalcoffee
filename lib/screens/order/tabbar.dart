// tabbar.dart
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onPressed;

  const TabButton({
    super.key,
    required this.label,
    required this.isActive,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.white : const Color(0xFF4D2C12),
        foregroundColor: isActive ? Colors.brown : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      child: Text(label),
    );
  }
}
