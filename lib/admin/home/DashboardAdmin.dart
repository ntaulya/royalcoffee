import 'package:flutter/material.dart';
import 'package:royalcoffee/admin/layout/BottomNavBarAdmin.dart';
import 'package:royalcoffee/admin/screens/TrackOrder.dart';
import 'package:royalcoffee/admin/screens/Menu.dart';
import 'package:royalcoffee/admin/screens/Customer.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  int _selectedBottomNavIndex = 0; // index untuk Dashboard

  void _onTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Tetap di halaman Dashboard
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackOrder()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Menu()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Customer()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
      ),
      body: const Center(
        child: Text(
          'Ini Halaman Dashboard Admin',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          // Aksi tombol tambah menu
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Menu()),
          );
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
