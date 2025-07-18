import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../../models/CheckOut/Order.dart';
import '../../../layout/formatCurrency.dart';

String formatDate(String utcString) {
  final dateTime = DateTime.parse(utcString).toLocal();
  final formatter = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');
  return formatter.format(dateTime);
}

Future<pw.Document> generateReceiptPdf(Order order, double total, String method, String note) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Royal Cafe & Resto', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          pw.SizedBox(height: 10),
          pw.Text('Tanggal: ${formatDate(order.create_at)}'),
          pw.Text('Customer: ${order.nama_pemesan + order.nama_varian}'),
          pw.SizedBox(height: 16),
          pw.Text('Pesanan:'),
          pw.SizedBox(height: 8),
          ...order.Item!.map((item) => pw.Text('${item.qty}x ${item.nama_product}')),
          pw.Divider(),
          pw.Text('Total: Rp${formatCurrency(total)}'),
          pw.Text('Pembayaran: $method'),
          pw.Text('Catatan: $note'),
        ],
      ),
    ),
  );
  return pdf;
}
