import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/cart_controller.dart';

class PesananBerjalan extends StatefulWidget {
  const PesananBerjalan({super.key});

  @override
  State<PesananBerjalan> createState() => _PesananBerjalanState();
}

class _PesananBerjalanState extends State<PesananBerjalan> {
  final cartController = CartController();

  @override
  Widget build(BuildContext context) {
    final cartItems = cartController.items;

    return Scaffold(
      backgroundColor: const Color(0xFF834D1E),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Pesanan Berjalan',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListView.separated(
                  itemCount: cartItems.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return buildOrderCard(item, index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF8B4A0C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: ''),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Iconsax.shopping_cart),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('2', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                )
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Iconsax.card), label: ''),
          BottomNavigationBarItem(icon: Icon(Iconsax.notification), label: ''),
        ],
      ),
    );
  }

  Widget buildOrderCard(dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text(
                  '29 Januari 2025, 01:20 PM',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text('${item.quantity} items', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                SizedBox(
                  width: 160,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tampilkan detail atau struk
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4D2C12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(index % 2 == 0 ? 'Tampilkan Detail!' : 'Tampilkan Struk'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
