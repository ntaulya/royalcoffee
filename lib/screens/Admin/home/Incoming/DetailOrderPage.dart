import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../models/CheckOut/Order.dart';
import '../../../../models/CheckOut/ItemProduct.dart';
import '../../../../models/Product/Pajak.dart';
import '../../../../services/Api/Product/ProductServices.dart';
import '../../../../controllers/Order/OrderController.dart';
import '../../layout/formatCurrency.dart';

import './component/buildProductItem.dart';
import './component/orderSummary.dart';
import './component/ReceiptPrinter.dart';

class DetailOrderPage extends StatefulWidget {
  final Order order;
  const DetailOrderPage({super.key, required this.order});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  Pajak? pajak;
  bool isLoading = true;

  String paymentMethod = 'QRIS';
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
    final totalHarga =
        widget.order.Item?.fold<double>(
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat pajak: $e")));
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text(formatDate(widget.order.create_at))),
                    Center(child: Text(widget.order.nama_pemesan)),
                    Center(
                      child: Text(
                        widget.order.tipe_pemesanan == "take_away"
                            ? "Take Away"
                            : "Dine In",
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...items
                        .map(
                          (item) => buildProductItem(
                            item,
                            () => _confirmDeleteItem(item),
                          ),
                        )
                        .toList(),
                    const Divider(),
                    orderSummary('Subtotal', subtotal - tax),
                    orderSummary('Tax and Fees', tax),
                    const Divider(),
                    orderSummary('Total', total, isTotal: true),
                    const SizedBox(height: 16),
                    _noteField(),
                    const SizedBox(height: 16),
                    const Text(
                      "Metode Pembayaran",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
    const kBrownColor = Color(0xFF834D1E);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kBrownColor,
                side: const BorderSide(color: kBrownColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _showDeleteDialog,
              child: const Text(
                "Batalkan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kBrownColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _showConfirmationDialog(total),
              child: const Text(
                "Konfirmasi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void _showDeleteDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  final password = passwordController.text.trim();
                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password tidak boleh kosong"),
                      ),
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

  void _confirmDeleteItem(ItemProduct item) async {
    final isLastItem =
        widget.order.Item != null && widget.order.Item!.length == 1;

    if (isLastItem) {
      final TextEditingController passwordController = TextEditingController();
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Konfirmasi Hapus Pesanan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Item ini adalah item terakhir.\nMasukkan password admin untuk membatalkan pesanan.",
                  ),
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
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    if (passwordController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password tidak boleh kosong"),
                        ),
                      );
                    } else {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('Hapus Pesanan'),
                ),
              ],
            ),
      );

      if (confirm == true) {
        await OrderController().deleteOrder(
          idCheckout: widget.order.id,
          password: passwordController.text.trim(),
          context: context,
        );
        Navigator.pop(context, true);
      }
    } else {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Hapus Item'),
              content: Text('Yakin ingin menghapus ${item.nama_product}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Hapus'),
                ),
              ],
            ),
      );

      if (confirm == true) {
        await OrderController().deleteItemFromOrder(
          idCheckout: widget.order.id,
          idProduct: item.product_id.toString(),
          idVarian: item.varian_id.toString(),
          context: context,
        );

        setState(() {
          widget.order.Item?.removeWhere(
            (i) =>
                i.product_id == item.product_id &&
                i.varian_id == item.varian_id,
          );
        });

        await _fetchPajak();
      }
    }
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
      children:
          ['QRIS', 'Tunai'].map((method) {
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
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
      builder:
          (_) => AlertDialog(
            title: const Text('Konfirmasi Pembayaran'),
            content: Text(
              'Yakin ingin mengkonfirmasi pembayaran sebesar ${formatCurrency(nominal)} dengan metode $paymentMethod?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ya'),
              ),
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

      final printConfirm = await showDialog<bool>(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Cetak Struk'),
              content: const Text('Apakah Anda ingin mencetak struk?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Tidak'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ya'),
                ),
              ],
            ),
      );

      if (printConfirm == true) {
        try {
          await _printReceipt(total, nominal);
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Gagal mencetak struk")));
        }
      }

      Navigator.pop(context, true);
    }
  }

  Future<void> _printReceipt(double total, int nominalDibayar) async {
    final pdf = await generateReceiptPdf(
      widget.order,
      total,
      paymentMethod,
      noteController.text,
      nominalDibayar,
    );
    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }
}
