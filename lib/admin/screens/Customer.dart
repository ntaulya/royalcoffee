import 'package:flutter/material.dart';

class Customer extends StatelessWidget {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer")),
      body: const Center(
        child: Text("Ini halaman Customer"),
      ),
    );
  }
}
