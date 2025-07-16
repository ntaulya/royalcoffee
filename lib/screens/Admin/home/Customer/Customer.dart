import 'package:flutter/material.dart';
import '../../layout/BottomNavBarAdmin.dart';


import '../../layout/CustomTopBar.dart';

import '../../../../controllers/User/UserController.dart';
import '../../../../models/User/User.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    await _userController.getAllUsers(context: context);
    setState(() {}); 
  }

  Widget _buildCustomerItem(int index, User user) {
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
              "${index + 1}",
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.namaLengkap,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4B1D0D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.email}, ${user.phone}',
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
  void dispose() {
    _userController.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _userController.isLoading;
    final users = _userController.users;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: const CustomTopBar(title: "Data Pelanggan"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Belum ada data pelanggan"))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildCustomerItem(index, users[index]);
                  },
                ),
    );
  }
}
