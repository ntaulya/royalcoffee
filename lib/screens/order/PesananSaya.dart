import 'package:flutter/material.dart';
import '../../controllers/CartController.dart';
import '../../models/cart_item.dart';

class PesananSaya extends StatefulWidget {
  const PesananSaya({Key? key}) : super(key: key);

  @override
  State<PesananSaya> createState() => _PesananSayaState();
}

class _PesananSayaState extends State<PesananSaya> {
  final cartController = CartController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: cartController.cartItemsStream,
        builder: (context, snapshot) {
          final cartItems = snapshot.data ?? [];

          double subtotal = cartItems.fold(
            0,
            (sum, item) => sum + (double.tryParse(item.price) ?? 0) * item.quantity,
          );
          double tax = subtotal * 0.1;
          double total = subtotal + tax;

          return Column(
            children: [
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(child: Text('Keranjang kosong'))
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return buildOrderItem(item);
                        },
                      ),
              ),
              buildSummary(subtotal, tax, total),
              buildPaymentSection(),
            ],
          );
        },
      ),
    );
  }

  Widget buildOrderItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.shade200),
      ),
      child: Row(
        children: [
          Image.asset(item.imagePath, width: 60, height: 60, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Rp ${item.price}', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (item.quantity > 1) {
                    cartController.updateItemQuantity(item.title, item.quantity - 1);
                  } else {
                    cartController.removeFromCart(item);
                  }
                },
              ),
              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  cartController.updateItemQuantity(item.title, item.quantity + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummary(double subtotal, double tax, double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.brown[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          buildSummaryRow('Subtotal', subtotal),
          buildSummaryRow('Pajak (10%)', tax),
          const Divider(thickness: 1),
          buildSummaryRow('Total', total, isBold: true),
        ],
      ),
    );
  }

  Widget buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text('Rp ${amount.toStringAsFixed(0)}', style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget buildPaymentSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          // Tambahkan logika pembayaran di sini
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Pembayaran Berhasil'),
              content: const Text('Terima kasih telah melakukan pembayaran.'),
              actions: [
                TextButton(
                  onPressed: () {
                    cartController.clearCart();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.payment),
        label: const Text('Bayar Sekarang'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}
