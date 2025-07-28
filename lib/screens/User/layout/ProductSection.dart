import 'package:flutter/material.dart';
import '../../../controllers/Product/ProductController.dart';
import '../../../models/Product/Product.dart';
import 'ProductCard.dart';
import '../home/DetailPesanan.dart';

class ProductSection extends StatefulWidget {
  final ProductController controller;
  final String selectedCategoryId;

  const ProductSection({
    Key? key,
    required this.controller,
    required this.selectedCategoryId,
  }) : super(key: key);

  @override
  State<ProductSection> createState() => _ProductSectionState();
}

class _ProductSectionState extends State<ProductSection> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.fetchInitialProducts();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !widget.controller.isLoadingMore &&
        widget.controller.hasMore) {
      widget.controller.fetchMoreProducts(categoryId: widget.selectedCategoryId);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final products = widget.controller.products;

        if (products.isEmpty && !widget.controller.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.coffee_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada produk tersedia',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
          itemCount: products.length + (widget.controller.isLoadingMore ? 1 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            if (index >= products.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = products[index];
            return ProductCard(
              product: product,
              onAddToCart: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} ditambahkan ke keranjang')),
                );
              },
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                Product? detail;
                try {
                  detail = await widget.controller.fetchProductDetail(
                    int.parse(widget.selectedCategoryId),
                    product.id.toString(),
                  );
                } catch (e) {
                  debugPrint('Error fetching product detail: $e');
                }

                Navigator.pop(context);

                if (detail != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPesanan(product: detail!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal memuat detail produk')),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
