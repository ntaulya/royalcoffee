import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../../models/CheckOut/Order.dart';
import '../../../layout/formatCurrency.dart';

String formatDate(String utcString) {
  final dateTime = DateTime.parse(utcString).toLocal();
  final formatter = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');
  return formatter.format(dateTime);
}

Future<pw.Document> generateReceiptPdf(
  Order order, 
  double total, 
  String method, 
  String note,
  int nominalDibayar,
) async {
  final pdf = pw.Document();
  final kembalian = nominalDibayar - total;

  // Load Banner.png dari assets
  final Uint8List logoBytes = await rootBundle
      .load('assets/images/royalcafetext.png')
      .then((data) => data.buffer.asUint8List());
  final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

  pdf.addPage(
    pw.Page(
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Image(logoImage, width: 120), // logo di kiri atas
          pw.SizedBox(height: 10),
          pw.Text('Tanggal: ${formatDate(order.create_at)}'),
          pw.Text('Customer: ${order.nama_pemesan}'),
          pw.SizedBox(height: 16),
          pw.Text('Pesanan:'),
          pw.SizedBox(height: 8),
          ...order.Item!.map((item) => pw.Text(
              '${item.qty}x ${item.nama_product + " - " + item.nama_varian}')),
          pw.Divider(),
          pw.Text('Total: ${formatCurrency(total)}'),
          pw.Text(
              'Pembayaran: ${formatCurrency(nominalDibayar)} ($method)'),
          pw.Text(
              'Kembalian: ${formatCurrency(kembalian > 0 ? kembalian : 0)}'),
          pw.Text('Catatan: $note'),
        ],
      ),
    ),
  );
  return pdf;
}
