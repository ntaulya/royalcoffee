// history_screen.dart
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final Function(int) onItemSelected;
  const History({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final historyOrders = [
      {
        "orderId": "1234",
        "status": "Selesai",
        "date": "2024-05-10",
        "total": "Rp. 55.000",
        "items": ["Kopi Latte", "Roti Bakar"],
      },
      {
        "orderId": "1233",
        "status": "Dibatalkan",
        "date": "2024-05-09",
        "total": "Rp. 30.000",
        "items": ["Es Kopi Susu"],
      },
      {
        "orderId": "1232",
        "status": "Selesai",
        "date": "2024-05-08",
        "total": "Rp. 75.000",
        "items": ["Cappuccino", "Croissant"],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => onItemSelected(0), // balik ke dashboard
        ),
        title: const Text(
          "History Pesanan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: historyOrders.length,
        separatorBuilder: (_, __) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final order = historyOrders[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.brown.shade200,
              child: const Icon(Icons.history, color: Colors.white),
            ),
            title: Text(
              "Pesanan #${order['orderId']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Status: ${order['status']}\nTanggal: ${order['date']}",
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          );
        },
      ),
    );
  }
}
