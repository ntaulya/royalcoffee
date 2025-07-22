import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:intl/intl.dart';

import '../../../controllers/CartController.dart';
import '../../../services/Api/ImageHelper.dart';
import '../../../services/Api/Product/ProductServices.dart';
import '../../../services/Api/Product/CheckOrderService.dart';
import '../../../models/CartItem.dart';
import '../../../models/Product/Pajak.dart';
import './PesananBerhasilDiProses.dart';

class PesananSaya extends StatefulWidget {
  const PesananSaya({Key? key}) : super(key: key);

  @override
  State<PesananSaya> createState() => _PesananSayaState();
}

class _PesananSayaState extends State<PesananSaya> {
  final cartController = CartController();
  final ProductServices productService = ProductServices();
  final CheckOrderService checkoutService = CheckOrderService();
  late final StreamSubscription _cartSubscription;

  Pajak? pajak;
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    _cartSubscription = cartController.cartItemsStream.listen((_) {
      calculateTax();
    });
    calculateTax();
  }

  @override
  void dispose() {
    _cartSubscription.cancel();
    super.dispose();
  }

  Future<void> calculateTax() async {
    final items = cartController.items;
    double newSubtotal = items.fold(0, (sum, item) => sum + item.totalPrice);
    if (newSubtotal == 0) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    if (newSubtotal == subtotal) return;

    try {
      final pajakResponse = await productService.getCalculationPajak(
        totalBelanjaan: newSubtotal.toInt(),
      );
      if (!mounted) return;
      setState(() {
        subtotal = newSubtotal;
        pajak = pajakResponse;
      });
    } catch (e) {
    }
  }

  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

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
        initialData: cartController.items,
        builder: (context, snapshot) {
          final cartItems = snapshot.data ?? [];

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
              buildSummary(),
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
          FutureBuilder<Uint8List?>(
            future: ImageHelper.loadImage(item.imagePath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(snapshot.data!, width: 60, height: 60, fit: BoxFit.cover),
                );
              } else {
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(Icons.broken_image, color: Colors.grey),
                );
              }
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text(formatRupiah(double.tryParse(item.price) ?? 0), style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (item.quantity > 1) {
                    cartController.updateItemQuantity(item.productId, item.variantId, item.quantity - 1);
                  } else {
                    cartController.removeFromCart(item);
                  }
                },
              ),
              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  cartController.updateItemQuantity(item.productId, item.variantId, item.quantity + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummary() {
    if (pajak == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.brown[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          buildSummaryRow('Subtotal', subtotal),
          buildSummaryRow('Pajak (${pajak!.persen.toStringAsFixed(2)}%)', pajak!.nominalPotongan),
          const Divider(thickness: 1),
          buildSummaryRow('Total', pajak!.totalKeselurusan, isBold: true),
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
          Text(formatRupiah(amount), style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget buildPaymentSection() {
    String? selectedTipePemesanan;
    final TextEditingController notesController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: selectedTipePemesanan,
                decoration: const InputDecoration(
                  labelText: 'Tipe Pemesanan',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'take_away',
                    child: Text('Take Away'),
                  ),
                  DropdownMenuItem(
                    value: 'dine_in',
                    child: Text('Dine In'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTipePemesanan = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: selectedTipePemesanan == null
                    ? null
                    : () async {
                        try {
                          await checkoutService.checkoutOrder(
                            tipePemesanan: selectedTipePemesanan!,
                            notes: notesController.text.trim(),
                            products: cartController.items,
                          );

                          if (!context.mounted) return;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => PesananBerhasilDiProses(),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal melakukan pembayaran: $e')),
                          );
                        }
                      },
                icon: const Icon(Icons.payment),
                label: const Text('Bayar Sekarang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
