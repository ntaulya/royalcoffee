import 'package:flutter/material.dart';
import '../../../models/CheckOut/Order.dart';

class OrdersPage extends StatelessWidget {
  final List<Order> orders;

  const OrdersPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text("Order #${order.id}"),
              subtitle: Text("Tipe: ${order.tipe_pemesanan}"),
              children: order.Item?.map((item) {
                    return ListTile(
                      leading: Image.network(
                        item.image,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image),
                      ),
                      title: Text(item.nama_product),
                      subtitle: Text(
                          "Varian: ${item.nama_varian}\nQty: ${item.qty} x Rp ${item.harga_satuan}"),
                      trailing: Text("Rp ${item.harga_total}"),
                    );
                  }).toList() ??
                  [],
            ),
          );
        },
      ),
    );
  }
}
