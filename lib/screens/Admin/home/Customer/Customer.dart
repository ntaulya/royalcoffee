import 'package:flutter/material.dart';
import 'package:royalcoffee/screens/Admin/layout/BottomNavBarAdmin.dart';
import 'package:royalcoffee/screens/Admin/screens/TrackOrder.dart';
import 'package:royalcoffee/screens/Admin/screens/Customer.dart';
import 'package:royalcoffee/screens/Admin/screens/Menu.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  int _selectedBottomNavIndex = 3; // aktif di index ke-3 (Customer)

  void _onTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

    
  }

  Widget _buildCustomerItem(int index, String name, String emailPhone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.brown, width: 0.8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.brown,
            child: Text(
              "$index",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B1D0D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  emailPhone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          "Data Pelanggan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 100), // Tambah padding bottom untuk space dari bottom nav
              children: [
                _buildCustomerItem(
                  1,
                  "Muhammad Andi Syaifullah",
                  "andisyaifullah@gmail.com, 082216458858",
                ),
                // Tambah customer lain di sini
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 16, bottom: 100), // Adjust margin bottom agar tidak tertutup bottom nav
        child: FloatingActionButton(
          onPressed: () {
            // Aksi tambah pelanggan
          },
          backgroundColor: const Color(0xFF844C29),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.group, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
    );
  }
}