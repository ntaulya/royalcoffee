import 'package:flutter/material.dart';

import '../layout/BottomNavBarAdmin.dart';
import './Incoming/IncomingOrder.dart';
import './Track/TrackOrder.dart';
import './Menu/MenuScreen.dart';
import './Customer/Customer.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdmin();
}

class _DashboardAdmin extends State<DashboardAdmin> {
  int _selectedBottomNavIndex = 0;

  // Screens akan diload saat dipilih
  Widget? _incomingOrder;
  Widget? _trackOrder;
  Widget? _menuScreen;
  Widget? _customer;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return _incomingOrder ??= const IncomingOrder();
      case 1:
        return _trackOrder ??= const TrackOrder();
      case 2:
        return _menuScreen ??= const MenuScreen();
      case 3:
        return _customer ??= const Customer();
      default:
        return const Center(child: Text("Halaman tidak ditemukan"));
    }
  }

  void _onTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: _getScreen(_selectedBottomNavIndex),
      bottomNavigationBar: BottomNavBarAdmin(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onTap,
      ),
    );
  }
}
