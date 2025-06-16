import 'package:flutter/material.dart';

class IncomingOrder extends StatelessWidget {
  const IncomingOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Order'),
      ),
      body: const Center(
        child: Text(
          'Ini halaman Incoming Order',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
