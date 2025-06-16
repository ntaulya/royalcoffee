import 'package:flutter/material.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

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
    );
  }
}
