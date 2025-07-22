// import
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../controllers/Dapur/DapurController.dart';
import '../../../../../controllers/Waiters/WaitersController.dart';

import '../../../../../models/Dapur/DapurItem.dart';
import '../../../../../models/Waiter/WaiterItem.dart';
import '../../../../../models/StaffRole.dart';
import '../../../../../services/Api/ImageHelper.dart';
import '../../layout/CustomTopBar.dart';

class StaffOrderView extends StatefulWidget {
  final StaffRole role;

  const StaffOrderView({super.key, required this.role});

  @override
  State<StaffOrderView> createState() => _StaffOrderViewState();
}

class _StaffOrderViewState extends State<StaffOrderView> {
  late final bool isBarista;
  final Map<String, Uint8List?> _imageCache = {};
  bool _isImageLoading = false;
  Timer? _refreshTimer;

  late final DapurController _baristaController;
  late final WaitersController _waiterController;

  @override
  void initState() {
    super.initState();
    isBarista = widget.role == StaffRole.barista;
    _baristaController = DapurController();
    _waiterController = WaitersController();

    _startAutoReload();
    _fetchDataAndImages();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoReload() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchDataAndImages();
    });
  }

  Future<void> _fetchDataAndImages() async {
    if (!mounted) return;
    setState(() => _isImageLoading = true);

    if (isBarista) {
      await _baristaController.fetchDapur();
      await _loadImages<DapurItem>(_baristaController.dapurList);
    } else {
      await _waiterController.fetchDapur();
      await _loadImages<WaiterItem>(_waiterController.dapurList);
    }

    if (!mounted) return;
    setState(() => _isImageLoading = false);
  }

  Future<void> _loadImages<T>(List<T> items) async {
    _imageCache.clear();
    for (var item in items) {
      if (item is DapurItem || item is WaiterItem) {
        final cacheKey = "${(item as dynamic).idCheckout}_${(item as dynamic).idVarian}";
        final image = await ImageHelper.loadImage(item.imagePath);
        _imageCache[cacheKey] = image;
      }
    }
  }

  String formatTanggal(String tanggal) {
    try {
      final dateTime = DateTime.parse(tanggal).toLocal();
      final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return tanggal;
    }
  }

  Icon _getTipePemesananIcon(String tipe) {
    switch (tipe.toLowerCase()) {
      case 'dine_in':
        return const Icon(Icons.restaurant, color: Colors.green, size: 20);
      case 'take_away':
        return const Icon(Icons.shopping_bag, color: Colors.orange, size: 20);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = isBarista
        ? _baristaController.isLoading || _isImageLoading
        : _waiterController.isLoading || _isImageLoading;

    final error = isBarista ? _baristaController.error : _waiterController.error;
    final items = isBarista ? _baristaController.dapurList : _waiterController.dapurList;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: CustomTopBar(title: isBarista ? "Tampilan Khusus Barista" : "Tampilan Waiters"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : RefreshIndicator(
                  onRefresh: _fetchDataAndImages,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final order = items[index];
                      final dynamic item = order;
                      final cacheKey = "${item.idCheckout}_${item.idVarian}";
                      final imageBytes = _imageCache[cacheKey];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: const Color(0xFF4B1D0D),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: imageBytes != null
                                      ? Image.memory(imageBytes, width: 80, height: 100, fit: BoxFit.cover)
                                      : Container(
                                          width: 80,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image),
                                        ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${item.namaProduct} - ${item.namaVarian}",
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              _getTipePemesananIcon(item.tipePemesanan),
                                              const SizedBox(height: 4),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("${item.namaPemesan}", style: const TextStyle(fontSize: 13)),
                                                  const SizedBox(height: 2),
                                                  Text(formatTanggal(item.createAt), style: const TextStyle(fontSize: 13)),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Jumlah",
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "${item.item}",
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (!isBarista && item.pesan != null && item.pesan.isNotEmpty)
                                        Text(
                                          "Catatan: ${item.pesan}",
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                                        ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF4B1D0D),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            ),
                                            child: Text("Pesanan ${index + 1}", style: const TextStyle(color: Colors.white)),
                                          ),
                                          const SizedBox(width: 10),
                                          OutlinedButton(
                                            onPressed: index == 0
                                                ? () async {
                                                    if (isBarista) {
                                                      await _baristaController.updatePesananStatus(
                                                        item.idCheckout,
                                                        item.idVarian,
                                                      );
                                                    } else {
                                                      await _waiterController.updatePesananStatus(
                                                        item.idCheckout,
                                                        item.idVarian,
                                                      );
                                                    }
                                                    await _fetchDataAndImages();
                                                  }
                                                : null,
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Colors.grey),
                                              backgroundColor: index != 0 ? Colors.grey[300] : null,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            ),
                                            child: const Text(
                                              "Sudah Beres",
                                              style: TextStyle(color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(thickness: 0.7, indent: 16, endIndent: 16),
                        ],
                      );
                    },
                  ),
                ),
    );
  }
}
