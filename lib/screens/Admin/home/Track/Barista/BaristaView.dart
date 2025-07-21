import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../../controllers/Dapur/DapurController.dart';
import '../../../../../models/Dapur/DapurItem.dart';
import '../../../layout/CustomTopBar.dart';
import '../../../../../services/Api/ImageHelper.dart';

class BaristaView extends StatefulWidget {
  const BaristaView({super.key});

  @override
  State<BaristaView> createState() => _BaristaViewState();
}

class _BaristaViewState extends State<BaristaView> {
  final DapurController _controller = DapurController();
  final Map<String, Uint8List?> _imageCache = {};
  bool _isImageLoading = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
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
    setState(() => _isImageLoading = true);
    await _controller.fetchDapur();
    await _loadImages(_controller.dapurList);
    setState(() => _isImageLoading = false);
  }

  Future<void> _loadImages(List<DapurItem> items) async {
    _imageCache.clear();
    for (var item in items) {
      final cacheKey = "${item.idCheckout}_${item.idVarian}";
      final image = await ImageHelper.loadImage(item.imagePath);
      _imageCache[cacheKey] = image;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _controller.isLoading || _isImageLoading;
    final error = _controller.error;
    final dapurList = _controller.dapurList;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: const CustomTopBar(title: "Tampilan Khusus Barista"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : RefreshIndicator(
                  onRefresh: _fetchDataAndImages,
                  child: ListView.builder(
                    itemCount: dapurList.length,
                    itemBuilder: (context, index) {
                      final DapurItem order = dapurList[index];
                      final cacheKey = "${order.idCheckout}_${order.idVarian}";
                      final imageBytes = _imageCache[cacheKey];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF4B1D0D),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: imageBytes != null
                                      ? Image.memory(
                                          imageBytes,
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 64,
                                          height: 64,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image),
                                        ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.namaProduct,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${order.item} Item, ${order.namaPemesan}, ${order.namaVarian}",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "Status Pesanan : ${order.status}",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 6),
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
                                            child: Text("Pesanan ${index + 1}"),
                                          ),
                                          const SizedBox(width: 10),
                                          OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(color: Colors.grey),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            ),
                                            child: const Text("Sudah Beres", style: TextStyle(color: Colors.black87)),
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
