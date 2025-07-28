import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import '../../../../models/Product/Product.dart';
import '../../../../services/Api/ImageHelper.dart';
import '../../../../controllers/Product/ProductController.dart';
import '../../layout/AdminCategoryTabs.dart';
import './AddMenu.dart';
import './EditMenu.dart';
import '../../layout/CustomTopBar.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ProductController controller = ProductController();
  final ScrollController _scrollController = ScrollController();
  String selectedCategoryId = '';
  Map<String, Uint8List?> _productImages = {};
  bool _isImageLoading = false;
  bool _isLoadingMore = false;
  double _savedScrollOffset = 0.0;
  bool _shouldRestoreScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        !controller.isLoading &&
        !controller.isEndReached) {
      setState(() => _isLoadingMore = true);

      final previousLength = controller.products.length;
      await controller.fetchMoreProducts(categoryId: selectedCategoryId);
      final newProducts = controller.products.sublist(previousLength);

      await _loadImages(newProducts, append: true);

      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadImages(List<Product> products, {bool append = false}) async {
    setState(() {
      _isImageLoading = true;
      if (!append) _productImages.clear();
    });

    for (var product in products) {
      final image = await ImageHelper.loadImage(product.imageUrl);
      _productImages[product.id] = image;
    }

    setState(() {
      _isImageLoading = false;
    });
  }

  String getPrimaryVariantStock(Product product) => product.stock.toString();

  String formatRupiah(String value) {
    if (value.contains('~')) {
      final parts = value.split('~');
      final start = int.tryParse(parts[0].trim());
      final end = int.tryParse(parts[1].trim());
      if (start != null && end != null) {
        return 'Rp.${_formatNumber(start)} ~ Rp.${_formatNumber(end)}';
      }
      return value;
    }

    final number = int.tryParse(value.trim());
    return number != null ? 'Rp.${_formatNumber(number)}' : value;
  }

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
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
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  "Harga ${formatRupiah(product.price)}, Stok ${getPrimaryVariantStock(product)}",
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
                          MaterialPageRoute(
                            builder: (context) => EditMenu(categoryId: selectedCategoryId,productId: product.id),
                          ),
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
      create: (_) => controller,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: const CustomTopBar(title: "Atur Status Menu"),
        body: Consumer<ProductController>(
          builder: (context, controller, _) {
            return Column(
              children: [
                AdminCategoryTabs(
                  selectedCategory: selectedCategoryId,
                  onInitialCategoryReady: (initialId) async {
                    setState(() => selectedCategoryId = initialId);
                    await controller.fetchInitialProducts(categoryId: initialId);
                    await _loadImages(controller.products);
                    _savedScrollOffset = 0.0;
                    _shouldRestoreScroll = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await Future.delayed(const Duration(milliseconds: 50));
                      if (_shouldRestoreScroll && _scrollController.hasClients) {
                        _scrollController.jumpTo(_savedScrollOffset);
                        _shouldRestoreScroll = false;
                      }
                    });
                  },
                  onCategorySelected: (newCategoryId) async {
                    _savedScrollOffset = _scrollController.hasClients
                        ? _scrollController.offset
                        : 0.0;
                    setState(() => selectedCategoryId = newCategoryId);
                    await controller.fetchInitialProducts(categoryId: newCategoryId);
                    await _loadImages(controller.products);
                    _shouldRestoreScroll = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await Future.delayed(const Duration(milliseconds: 50));
                      if (_shouldRestoreScroll && _scrollController.hasClients) {
                        _scrollController.jumpTo(_savedScrollOffset);
                        _shouldRestoreScroll = false;
                      }
                    });
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
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: controller.products.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < controller.products.length) {
                            return _buildMenuItem(controller.products[index], controller);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
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
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMenu()),
            );
            if (result == true) {
              _savedScrollOffset = _scrollController.hasClients
                  ? _scrollController.offset
                  : 0.0;
              await controller.fetchInitialProducts(categoryId: selectedCategoryId);
              await _loadImages(controller.products);
              _shouldRestoreScroll = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await Future.delayed(const Duration(milliseconds: 50));
                if (_shouldRestoreScroll && _scrollController.hasClients) {
                  _scrollController.jumpTo(_savedScrollOffset);
                  _shouldRestoreScroll = false;
                }
              });
            }
          },
          child: const Icon(Icons.receipt_long_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
