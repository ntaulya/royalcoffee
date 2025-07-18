import 'package:flutter/material.dart';
import '../../../controllers/Product/ProductController.dart';
import '../../../models/Product/Product.dart';
import 'ProductCard.dart';
import '../home/DetailPesanan.dart';

class ProductSection extends StatelessWidget {
  final List<Product> products;
  final Function(Product)? onProductTap;
  final ProductController controller;
  final String selectedCategoryId;

  const ProductSection({
    Key? key, 
    required this.products,
    required this.controller,
    required this.selectedCategoryId,
    this.onProductTap,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
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
               detail = await controller.fetchProductDetail(
                  int.parse(selectedCategoryId),
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
            }
          );
        },
      ),
    );
  }
}
