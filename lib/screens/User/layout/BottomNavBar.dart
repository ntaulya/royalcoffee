import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// Import semua screen tujuan di sini
import '../home/PesananSaya.dart';
import '../home/Dashboard.dart';
import '../home/CekProses.dart';
import '../home/History.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(context, Iconsax.home, "Home", 0, const Dashboard()),
              _buildNavItem(context, Iconsax.shopping_cart, "Order", 1, const CekProses()),
              _buildNavItem(
                context,
                Iconsax.wallet, // bisa ganti jadi icon lain misal Icons.history
                "History",
                2,
                HistoryScreen(
                  onItemSelected: (index) {
                    // kalau mau balik ke dashboard pakai replace biar nggak numpuk route
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Dashboard()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    Widget screen,
  ) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? const Color(0xFF8B4A0C) : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }
}
