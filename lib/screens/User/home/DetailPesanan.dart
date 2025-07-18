import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import '../../../services/Api/ImageHelper.dart'; 
import '../../../../controllers/CartController.dart';
import '../../../models/CartItem.dart';
import '../../../models/Product/Product.dart';
import '../../../models/Product/Variant.dart';
import './PesananSaya.dart';

class DetailPesanan extends StatefulWidget {
  final Product product;
  const DetailPesanan({super.key, required this.product});

  @override
  State<DetailPesanan> createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  final cartController = CartController();
  late PageController _pageController;
  Map<String, int> quantityPerVariant = {};
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _initializeQuantities();
    _startAutoScroll();
  }

  void _initializeQuantities() {
    for (var variant in widget.product.variants ?? []) {
      quantityPerVariant[variant.namaVarian] = 0;
    }
    if ((widget.product.variants?.isNotEmpty ?? false)) {
      quantityPerVariant[widget.product.variants!.first.namaVarian] = 1;
    }
  }

  int get totalItem => quantityPerVariant.values.fold(0, (a, b) => a + b);

  int get totalHarga {
    final hargaDasar = int.tryParse(widget.product.price) ?? 0;
    return (widget.product.variants ?? []).fold(0, (sum, variant) {
      final tambahan = int.tryParse(variant.hargaTambahan) ?? 0;
      final qty = quantityPerVariant[variant.namaVarian] ?? 0;
      return sum + (hargaDasar + tambahan) * qty;
    });
  }

  String formatRupiah(int value) {
    return 'Rp.${value.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.')}';
  }

  void _handleAddToCart() {
    final hargaDasar = int.tryParse(widget.product.price) ?? 0;
    for (var v in widget.product.variants ?? []) {
      final qty = quantityPerVariant[v.namaVarian] ?? 0;
      if (qty > 0) {
        final tambahan = int.tryParse(v.hargaTambahan) ?? 0;
        cartController.addToCart(CartItem(
          productId: widget.product.id.toString(),
          variantId: v.idVarian.toString(),    
          title: '${widget.product.name} - ${v.namaVarian}',
          price: (hargaDasar + tambahan).toString(),
          imagePath: v.imagePath,
          quantity: qty,
        ));
      }
    }
    Navigator.pop(context);
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || (widget.product.variants?.isEmpty ?? true)) return;
      final totalPages = widget.product.variants!.length;
      _currentPage = (_currentPage + 1) % totalPages;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  final variants = widget.product.variants ?? [];

  return Scaffold(
    backgroundColor: const Color(0xFF834D1E),
    body: SafeArea(
      child: Column(
        children: [
          // Header Back & Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Detail Pesanan',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Body Container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Nama Produk di Atas
                  Center(
                    child: Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ Carousel Gambar
                  if (variants.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: variants.length,
                        itemBuilder: (_, i) {
                          final v = variants[i];
                          final imageUrl = v.imagePath;

                          return FutureBuilder<Uint8List?>(
                            future: ImageHelper.loadImage(imageUrl),
                            builder: (context, snapshot) {
                              Widget imageWidget;

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                imageWidget = const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasData && snapshot.data != null) {
                                imageWidget = Image.memory(
                                  snapshot.data!,
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                imageWidget = Container(
                                  width: 180,
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 80),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: imageWidget,
                                      ),
                                      if (v.isPrimary)
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'Varian Utama',
                                              style: TextStyle(fontSize: 10, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  else
                    const Center(child: Icon(Icons.broken_image, size: 100)),

                  const SizedBox(height: 16),

                  // ✅ Deskripsi
                  Text(
                    widget.product.description ?? 'Tidak ada deskripsi.',
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),

                  const SizedBox(height: 20),

                  const Text('Varian', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  // ✅ List Varian
                  Expanded(
                    child: ListView(
                      children: variants.map((v) {
                        final hargaDasar = int.tryParse(widget.product.price) ?? 0;
                        final hargaTambahan = int.tryParse(v.hargaTambahan) ?? 0;
                        final stok = int.tryParse(v.stock) ?? 0;
                        final hargaTotal = hargaDasar + hargaTambahan;
                        final qty = quantityPerVariant[v.namaVarian] ?? 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: v.namaVarian.toLowerCase().contains("dingin")
                                ? const Color(0xFFFFF1C5)
                                : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${v.namaVarian}\n${formatRupiah(hargaTotal)}\nStok: $stok',
                                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: qty > 0
                                        ? () => setState(() => quantityPerVariant[v.namaVarian] = qty - 1)
                                        : null,
                                  ),
                                  Text('$qty'),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: qty < stok
                                        ? () => setState(() => quantityPerVariant[v.namaVarian] = qty + 1)
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ✅ Footer Total dan Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatRupiah(totalHarga), style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Total Item : $totalItem', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: totalItem > 0 ? _handleAddToCart : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4A0C),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Tambahkan ke dalam Keranjang',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
