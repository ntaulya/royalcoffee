import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import '../../../../models/Product/Product.dart';
import '../../../../services/Api/ImageHelper.dart';
import '../../../../controllers/Product/ProductController.dart';
import '../../layout/AdminCategoryTabs.dart';
import './AddMenu.dart';
import './EditMenu.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategoryId = '';
  Map<String, Uint8List?> _productImages = {};
  bool _isImageLoading = false;

  Future<void> _loadImages(List<Product> products) async {
    setState(() {
      _isImageLoading = true;
      _productImages.clear();
    });

    for (var product in products) {
      final image = await ImageHelper.loadImage(product.imageUrl);
      _productImages[product.id] = image;
    }

    setState(() {
      _isImageLoading = false;
    });
  }

  Widget _buildStatusButton(String text, Color color,
      {Color? textColor, VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMenuItem(Product product, ProductController controller) {
    final imageBytes = _productImages[product.id];
    final isActive = product.status.toLowerCase() == "aktif";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.brown.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    imageBytes,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.broken_image),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Harga ${product.price}K, Stok ${product.variants?.first.stock ?? 0}",
                  style: const TextStyle(fontSize: 13),
                ),
                if ((product.variants?.length ?? 0) > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.variants!
                          .asMap()
                          .entries
                          .skip(1)
                          .map((entry) {
                        final variant = entry.value;
                        return Text(
                          "- Varian Tambahan: ${variant.namaVarian} (+${variant.hargaTambahan}K), Stok ${variant.stock}",
                          style: const TextStyle(fontSize: 12),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusButton(
                      "⛔ Nonaktifkan",
                      isActive ? const Color(0xFF4B1D0D) : Colors.grey.shade300,
                      textColor: Colors.white,
                      onPressed: isActive
                          ? () async {
                              try {
                                await controller.toggleProductStatus(
                                  productId: product.id,
                                  currentStatus: product.status,
                                  categoryId: selectedCategoryId,
                                );
                                await _loadImages(controller.products);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} berhasil dinonaktifkan'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal mengubah status: $e')),
                                );
                              }
                            }
                          : null,
                    ),
                    const SizedBox(width: 6),
                    _buildStatusButton(
                      "✅ Aktif",
                      isActive ? Colors.grey.shade300 : const Color(0xFF4B1D0D),
                      textColor: Colors.white,
                      onPressed: isActive
                          ? null
                          : () async {
                              try {
                                await controller.toggleProductStatus(
                                  productId: product.id,
                                  currentStatus: product.status,
                                  categoryId: selectedCategoryId,
                                );
                                await _loadImages(controller.products);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} berhasil diaktifkan'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal mengubah status: $e')),
                                );
                              }
                            },
                    ),
                    const SizedBox(width: 6),
                    _buildStatusButton(
                      "✏️ Edit",
                      const Color(0xFF4B1D0D),
                      textColor: Colors.white,
                     onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditMenu(
                            product: product,
                            categoryId: selectedCategoryId,
                            )),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductController(), // <-- ini penting
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Atur Status Menu",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
        ),
        body: Consumer<ProductController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                AdminCategoryTabs(
                  selectedCategory: selectedCategoryId,
                  onInitialCategoryReady: (initialId) async {
                    setState(() => selectedCategoryId = initialId);
                    await controller.fetchProducts(categoryId: initialId);
                    await _loadImages(controller.products);
                  },
                  onCategorySelected: (newCategoryId) async {
                    setState(() => selectedCategoryId = newCategoryId);
                    await controller.fetchProducts(categoryId: newCategoryId);
                    await _loadImages(controller.products);
                  },
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (controller.isLoading || _isImageLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.errorMessage != null) {
                        return Center(child: Text(controller.errorMessage!));
                      }
                      if (controller.products.isEmpty) {
                        return const Center(child: Text("Tidak ada data menu."));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: controller.products.length,
                        itemBuilder: (context, index) =>
                            _buildMenuItem(controller.products[index], controller),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF844C29),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMenu()),
            );
          },
          child: const Icon(Icons.receipt_long_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
