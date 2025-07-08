import 'package:flutter/material.dart';


import '../layout/BottomNavBarAdmin.dart';


// Belum Selesai
import './Incoming/IncomingOrder.dart';
import './Track/TrackOrder.dart';
import './Menu/Menu.dart';
import './Customer/Customer.dart';



class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdmin();
}

class _DashboardAdmin extends State<DashboardAdmin> {
  int _selectedBottomNavIndex = 0;

  final List<Widget> _screens = const [
    IncomingOrder(), 
    TrackOrder(),
    Menu(),
    Customer(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedBottomNavIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBarAdmin(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onTap,
      ),
    );
  }
}
