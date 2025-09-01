import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

import '../../../models/LogHistoryDetail.dart';
import '../../Admin/layout/formatCurrency.dart';
import '../../../../controllers/HistoryController.dart';
import '../../../services/Api/ImageHelper.dart'; // ✅ tambahkan ini

class HistoryPage extends StatefulWidget {
  final String idCheckout; // cukup kirim ID checkout

  const HistoryPage({super.key, required this.idCheckout});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isLoading = true;
  List<LogHistoryDetail> orders = [];

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final details = await HistoryController().getDetailHistory(
        id: widget.idCheckout,
      );
      if (mounted) {
        setState(() {
          orders = details;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal ambil detail: $e")),
        );
      }
    }
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy, HH:mm');
    return formatter.format(date.toLocal());
  }

  Widget orderSummary(String label, num value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          formatCurrency(value.toDouble()),
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (orders.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Data detail kosong")),
      );
    }

    final order = orders.first;
    final items = order.itemProduct ?? [];

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.hargaTambahan,
    );
    final tax = (subtotal * 0.1);
    final total = subtotal + tax;
    final nominalDibayar = order.nominalPembayaran;
    final kembalian = nominalDibayar - total;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(formatDate(order.createdAt))),
            Center(child: Text(order.namaLengkap ?? "-")),
            Center(
              child: Text(
                (order.tipePemesanan ?? "") == "take_away"
                    ? "Take Away"
                    : "Dine In",
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Loop semua item product dengan gambar via ImageHelper
            ...items.map((item) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: item.imagePath.isNotEmpty
                      ? FutureBuilder<Uint8List?>(
                          future: ImageHelper.loadImage(item.imagePath),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  snapshot.data!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return const Icon(Icons.broken_image, size: 40);
                            }
                          },
                        )
                      : const Icon(Icons.image, size: 40),
                  title: Text(item.namaVarian ?? "-"),
                  subtitle: Text("Qty: ${item.qty ?? 1}"),
                  trailing: Text(
                    formatCurrency(item.hargaTambahan),
                  ),
                ),
              );
            }),

            const Divider(),
            orderSummary('Subtotal', subtotal),
            orderSummary('Tax and Fees', tax),
            const Divider(),
            orderSummary('Total', total, isTotal: true),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Metode Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(order.tipePembayaran ?? "-"),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Uang Dibayar"),
                Text(formatCurrency(nominalDibayar.toDouble())),
              ],
            ),

            if (kembalian > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Kembalian"),
                  Text(formatCurrency(kembalian.toDouble())),
                ],
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
