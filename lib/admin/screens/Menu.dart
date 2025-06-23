import 'package:flutter/material.dart';
import 'package:royalcoffee/admin/layout/BottomNavBarAdmin.dart';
import 'package:royalcoffee/admin/screens/IncomingOrder.dart';
import 'package:royalcoffee/admin/screens/TrackOrder.dart';
import 'package:royalcoffee/admin/screens/Customer.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedBottomNavIndex = 2; // index halaman Menu

  void _onTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IncomingOrder()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TrackOrder()),
        );
        break;
      case 2:
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Customer()),
        );
        break;
    }
  }

  Widget _buildMenuItem({
    required String imageUrl,
    required String title,
    required String priceStock,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    priceStock,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.brown.shade200),
                        ),
                        child: const Text(
                          "Non-Aktif",
                          style: TextStyle(color: Colors.brown),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.power_settings_new),
                        color: Colors.brown,
                        tooltip: "Aktifkan",
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        color: Colors.brown.shade900,
                        tooltip: "Edit",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Atur Status Menu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView(
          children: [
            _buildMenuItem(
              imageUrl:
                  'https://cdn-icons-png.flaticon.com/512/2722/2722127.png',
              title: 'Ice Cream Vanilla',
              priceStock: '15K, Stok 20',
            ),
            _buildMenuItem(
              imageUrl:
                  'https://cdn-icons-png.flaticon.com/512/2722/2722127.png',
              title: 'Ice Cream Cokelat',
              priceStock: '17K, Stok 15',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          // Tambah menu
        },
        child: const Icon(Icons.receipt_long_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavBarAdmin(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onTap,
      ),
    );
  }
}
