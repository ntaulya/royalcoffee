import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ConfirmOrder extends StatefulWidget {
  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrder> {
  String paymentMethod = 'QRIS';
  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  int subtotal = 15000;
  int taxAndFees = 1500;

  List<Map<String, dynamic>> orderItems = [
    {
      'title': 'Ice Cream Vanilla',
      'imagePath':
          'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=200&h=200',
      'qty': 2
    },
    {
      'title': 'Ice Cream Chocolate',
      'imagePath':
          'https://images.unsplash.com/photo-1599785209798-896c923a07f8?w=200&h=200',
      'qty': 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    int total = subtotal + taxAndFees;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Konfirmasi Pesanan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    '29 Januari 2025, 01:20 PM',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  Text(
                    'AndiSyaifullah',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            ...orderItems.map((item) =>
                _orderItem(item['title'], item['imagePath'], item['qty'])),
            Divider(),
            _orderSummary('Subtotal', subtotal),
            _orderSummary('Tax and Fees', taxAndFees),
            Divider(),
            _orderSummary('Total', total, isTotal: true),
            SizedBox(height: 16),
            _noteField(),
            SizedBox(height: 12),
            Text(
              'Metode Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            _paymentMethodSelector(),
            SizedBox(height: 12),
            _paymentAmountField(),
            SizedBox(height: 80), // untuk memberi ruang dari tombol bawah
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Batal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Batalkan',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _printReceipt(subtotal + taxAndFees),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cetak Struk',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showOrderReceivedDialog(context, subtotal + taxAndFees);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Konfirmasi',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderItem(String title, String imagePath, int qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Placeholder(fallbackWidth: 50, fallbackHeight: 50),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text('$qty items',
              style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _orderSummary(String label, int amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
            'Rp${_formatNumber(amount)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: noteController,
        maxLines: 2,
        decoration: InputDecoration.collapsed(
          hintText: 'Catatan customer dan nomor meja...',
        ),
      ),
    );
  }

  Widget _paymentMethodSelector() {
    return Column(
      children: [
        RadioListTile(
          value: 'QRIS',
          groupValue: paymentMethod,
          onChanged: (val) {
            setState(() => paymentMethod = val as String);
          },
          title: Row(
            children: [
              Icon(Icons.qr_code, color: Colors.brown),
              SizedBox(width: 8),
              Text('QRIS'),
            ],
          ),
        ),
        RadioListTile(
          value: 'Tunai',
          groupValue: paymentMethod,
          onChanged: (val) {
            setState(() => paymentMethod = val as String);
          },
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.brown),
              SizedBox(width: 8),
              Text('Tunai'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentAmountField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: paymentAmountController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration.collapsed(
          hintMaxLines: 2,
          hintText: 'Masukan nominal pembayaran',
        ),
      ),
    );
  }

  void _showOrderReceivedDialog(BuildContext context, int total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pesanan Diterima'),
        content: Text(
            'Pesanan Anda sebesar Rp${_formatNumber(total)} telah diterima.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipt(int total) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Royal Cafe & Resto',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Tanggal: 29 Januari 2025, 01:20 PM'),
            pw.Text('Customer: AndiSyaifullah'),
            pw.SizedBox(height: 16),
            pw.Text('Pesanan:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            ...orderItems.map((item) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${item['qty']}x ${item['title']}'),
                    pw.Text('...'),
                  ],
                )),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal'),
                pw.Text('Rp${_formatNumber(subtotal)}'),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Tax and Fees'),
                pw.Text('Rp${_formatNumber(taxAndFees)}'),
              ],
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Rp${_formatNumber(total)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Text('Metode Pembayaran: $paymentMethod'),
            pw.Text('Catatan: ${noteController.text}'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  }
}
