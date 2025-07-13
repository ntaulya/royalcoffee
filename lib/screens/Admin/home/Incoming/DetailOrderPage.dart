import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';

import '../../../../models/CheckOut/Order.dart';
import '../../../../models/CheckOut/ItemProduct.dart';
import '../../../../models/Product/Pajak.dart';
import '../../../../services/Api/ImageHelper.dart';
import '../../../../services/Api/Product/ProductServices.dart';
import '../../layout/formatCurrency.dart';

class DetailOrderPage extends StatefulWidget {
  final Order order;

  const DetailOrderPage({super.key, required this.order});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  Pajak? pajak;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPajak();
  }

  /// ✅ Format Waktu ke Zona Lokal (WIB/WITA/WIT Otomatis)
  String formatWaktuLokal(String utcString) {
    try {
      final utcTime = DateTime.parse(utcString).toUtc();
      final localTime = utcTime.toLocal();
      final formatted = DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(localTime);
      print(formatted);
      final offset = localTime.timeZoneOffset.inHours;
      final zona = switch (offset) {
        7 => 'WIB',
        8 => 'WITA',
        9 => 'WIT',
        _ => 'Zona Tidak Dikenal',
      };

      return '$formatted $zona';
    } catch (e) {
      return utcString;
    }
  }

  Future<void> _fetchPajak() async {
    final totalHarga = widget.order.Item?.fold<double>(
          0,
          (sum, item) => sum + item.harga_total,
        ) ??
        0.0;

    try {
      final result = await ProductServices().getCalculationPajak(
        totalBelanjaan: totalHarga.toInt(),
      );
      setState(() {
        pajak = result;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat pajak: $e")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.order.Item ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle("Informasi Pemesan"),
                Text("Nama: ${widget.order.nama_pemesan}"),
                Text("Email: ${widget.order.email ?? "-"}"),
                Text("Tipe Pemesanan: ${widget.order.tipe_pemesanan}"),
                Text("Waktu Pemesanan: ${formatWaktuLokal(widget.order.create_at)}"),
                if (widget.order.catatan != null && widget.order.catatan!.isNotEmpty)
                  Text("Catatan: ${widget.order.catatan}"),
                const SizedBox(height: 16),

                _buildSectionTitle("Produk Dipesan"),
                ...items.map((item) => _buildProductItem(item)).toList(),

                const SizedBox(height: 24),

                if (pajak != null) ...[
                  _buildSectionTitle("Ringkasan Pembayaran"),
                  _buildPriceRow(
                    "Subtotal",
                    formatCurrency(
                      pajak!.totalKeselurusan - pajak!.nominalPotongan,
                    ),
                  ),
                  _buildPriceRow(
                    "Pajak (${pajak!.persen.toStringAsFixed(2)}%)",
                    formatCurrency(pajak!.nominalPotongan),
                  ),
                  const Divider(thickness: 1),
                  _buildPriceRow(
                    "Total Setelah Pajak",
                    formatCurrency(pajak!.totalKeselurusan),
                    isBold: true,
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildProductItem(ItemProduct item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: FutureBuilder<Uint8List?>(
          future: (item.image != null && item.image!.isNotEmpty)
              ? ImageHelper.loadImage(item.image!)
              : Future.value(null),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 48,
                height: 48,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(
                  snapshot.data!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
            }
          },
        ),
        title: Text(item.nama_product, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Varian: ${item.nama_varian}\nQty: ${item.qty} x ${formatCurrency(item.harga_satuan)}',
        ),
        trailing: Text(
          formatCurrency(item.harga_total),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
