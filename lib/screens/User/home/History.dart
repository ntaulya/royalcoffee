import 'package:flutter/material.dart';
import '../../../models/CheckOut/Order.dart';
import '../../../services/Api/Product/CheckOrderService.dart';
import '../home/OrderDetailPage.dart';

class History extends StatelessWidget {
  final Function(int) onItemSelected;
  final CheckOrderService _orderService = CheckOrderService();

  History({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => onItemSelected(0),
        ),
        title: const Text(
          "History Pesanan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: _orderService.getOrder(), // ambil data dari API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text("Belum ada pesanan."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.brown.shade200,
                  child: const Icon(Icons.history, color: Colors.white),
                ),
                title: Text(
                  "Pesanan #${order.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Nama: ${order.nama_pemesan}\n"
                  "Tipe: ${order.tipe_pemesanan}\n"
                  "Tanggal: ${order.create_at}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                       builder: (_) => OrdersPage(orders: [order]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
