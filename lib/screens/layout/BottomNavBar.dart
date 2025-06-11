import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFF8B4A0C),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Iconsax.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Iconsax.wallet), label: "Payment"),
        BottomNavigationBarItem(icon: Icon(Iconsax.notification), label: "Notifications"),
      ],
    );
  }
}