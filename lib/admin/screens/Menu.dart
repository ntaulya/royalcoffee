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
    return Column(
      children: [
        Row(
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(priceStock),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.brown),
                          color: Colors.white,
                        ),
                        child: const Text("Non-Aktif",
                            style: TextStyle(color: Colors.brown)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Aktifkan"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Edit"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(thickness: 1, color: Colors.brown),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF5F5F7F8),
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
              title: 'Ice Cream Vanilla',
              priceStock: '15K, Stok 20',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {},
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
