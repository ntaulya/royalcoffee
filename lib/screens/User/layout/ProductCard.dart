import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../models/Product/Product.dart';
import '../../../services/Api/ImageHelper.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    this.onTap,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Uint8List? _imageBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final url = widget.product.imageUrl;
    if (url == null || url.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    final imageData = await ImageHelper.loadImage(url);
    setState(() {
      _imageBytes = imageData;
      _isLoading = false;
    });
  }

  String formatRupiah(String value) {
    // Jika mengandung rentang harga (~)
    if (value.contains('~')) {
      final parts = value.split('~');
      final start = int.tryParse(parts[0].trim());
      final end = int.tryParse(parts[1].trim());

      if (start != null && end != null) {
        return 'Rp.${_formatNumber(start)} ~ Rp.${_formatNumber(end)}';
      } else {
        return value; // fallback
      }
    }

    // Harga tunggal
    final number = int.tryParse(value.trim());
    if (number != null) {
      return 'Rp.${_formatNumber(number)}';
    }

    return value; // fallback jika format aneh
  }

  // Fungsi helper untuk memformat angka
  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }



  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.product.status == 'non_aktif';

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 150,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: isDisabled ? Colors.grey.shade100 : Colors.white,
          child: Opacity(
            opacity: isDisabled ? 0.6 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _imageBytes != null
                              ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                              : const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),

                // Info Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          formatRupiah(widget.product.price),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: widget.onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B4A0C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Detail', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
