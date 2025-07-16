// DetailOrderPage.dart
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:typed_data';

import '../../../../models/CheckOut/Order.dart';
import '../../../../models/CheckOut/ItemProduct.dart';
import '../../../../models/Product/Pajak.dart';
import '../../../../services/Api/ImageHelper.dart';
import '../../../../services/Api/Product/ProductServices.dart';
import '../../../../controllers/Order/OrderController.dart'; // Sesuaikan path-nya
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

  String paymentMethod = 'qris';
  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    noteController.text = widget.order.catatan ?? '';
    _fetchPajak();
  }

  @override
  void dispose() {
    paymentAmountController.dispose();
    noteController.dispose();
    super.dispose();
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
      setState(() => isLoading = false);
    }
  }

  String formatDate(String utcString) {
    final dateTime = DateTime.parse(utcString).toLocal();
    final formatter = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.order.Item ?? [];
    final subtotal = pajak?.totalKeselurusan ?? 0;
    final tax = pajak?.nominalPotongan ?? 0;
    final total = subtotal;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Konfirmasi Pesanan"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(formatDate(widget.order.create_at))),
                  Center(child: Text(widget.order.nama_pemesan)),
                  const SizedBox(height: 16),
                  ...items.map((item) => _buildProductItem(item)).toList(),
                  const Divider(),
                  _orderSummary('Subtotal', subtotal - tax),
                  _orderSummary('Tax and Fees', tax),
                  const Divider(),
                  _orderSummary('Total', total, isTotal: true),
                  const SizedBox(height: 16),
                  _noteField(),
                  const SizedBox(height: 16),
                  const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                  _paymentMethodSelector(),
                  const SizedBox(height: 12),
                  _paymentAmountField(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: _bottomActions(total),
    );
  }

  Widget _bottomActions(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _bottomButton("Batalkan", Colors.red, () => _showDeleteDialog()),
          const SizedBox(width: 8),
          _bottomButton("Cetak Struk", Colors.orange, () => _printReceipt(total)),
          const SizedBox(width: 8),
          _bottomButton("Konfirmasi", Colors.green, () => _showConfirmationDialog(total)),
        ],
      ),
    );
  }
  void _showDeleteDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus Pesanan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Masukkan password admin untuk menghapus pesanan."),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Admin',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              final password = passwordController.text.trim();
              if (password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password tidak boleh kosong")),
                );
                return;
              }

              Navigator.pop(context); 

              await OrderController().deleteOrder(
                idCheckout: widget.order.id,
                password: password,
                context: context,
              );

              Navigator.pop(context, true); 
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildProductItem(ItemProduct item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          FutureBuilder<Uint8List?>(
            future: (item.image != null && item.image!.isNotEmpty)
                ? ImageHelper.loadImage(item.image!)
                : Future.value(null),
            builder: (context, snapshot) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: snapshot.hasData
                    ? Image.memory(snapshot.data!, width: 50, height: 50, fit: BoxFit.cover)
                    : Container(width: 50, height: 50, color: Colors.grey),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(item.nama_product)),
          Text('${item.qty}x', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _orderSummary(String label, num amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              )),
          Text(formatCurrency(amount),
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              )),
        ],
      ),
    );
  }

  Widget _noteField() {
    return TextField(
      controller: noteController,
      maxLines: 2,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Catatan customer dan nomor meja...',
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _paymentMethodSelector() {
    return Column(
      children: ['qris', 'tunai'].map((method) {
        return RadioListTile(
          value: method,
          groupValue: paymentMethod,
          onChanged: (val) => setState(() => paymentMethod = val!),
          title: Text(method),
        );
      }).toList(),
    );
  }

  Widget _paymentAmountField() {
    return TextField(
      controller: paymentAmountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Masukkan nominal pembayaran',
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }

  void _showConfirmationDialog(double total) async {
    final nominalStr = paymentAmountController.text.trim();
    final nominal = int.tryParse(nominalStr);

    if (nominal == null || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nominal pembayaran tidak valid")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text(
          'Yakin ingin mengkonfirmasi pembayaran sebesar ${formatCurrency(nominal)} dengan metode $paymentMethod?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
        ],
      ),
    );

    if (confirm == true) {
      await OrderController().confirmPayment(
        idCheckout: widget.order.id,
        methodPembayaran: paymentMethod,
        nominalPembayaran: nominal,
        context: context,
      );

      Navigator.pop(context, true);
    }
  }


  Future<void> _printReceipt(double total) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Royal Cafe & Resto', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Text('Tanggal: ${formatDate(widget.order.create_at)}'),
            pw.Text('Customer: ${widget.order.nama_pemesan}'),
            pw.SizedBox(height: 16),
            pw.Text('Pesanan:'),
            pw.SizedBox(height: 8),
            ...widget.order.Item!.map((item) => pw.Text('${item.qty}x ${item.nama_product}')),
            pw.Divider(),
            pw.Text('Total: Rp${formatCurrency(total)}'),
            pw.Text('Pembayaran: $paymentMethod'),
            pw.Text('Catatan: ${noteController.text}'),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }
}
