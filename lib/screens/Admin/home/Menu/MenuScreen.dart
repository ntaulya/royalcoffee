import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/Product/Product.dart';
import '../../../../controllers/Product/ProductController.dart';

import './AddMenu.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Widget _buildStatusButton(String text, Color color,
      {Color? textColor, VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
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

  Widget _buildMenuItem(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.brown.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text("${product.price}K, Stok ${product.variants?.first.stock ?? 0}",
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusButton(
                        product.status.toLowerCase() == "aktif"
                            ? "Aktif"
                            : "Non-Aktif",
                        product.status.toLowerCase() == "aktif"
                            ? Colors.green.shade200
                            : Colors.grey.shade300,
                        textColor: Colors.brown.shade700),
                    const SizedBox(width: 6),
                    _buildStatusButton("Aktifkan", const Color(0xFF4B1D0D)),
                    const SizedBox(width: 6),
                    _buildStatusButton("Edit", const Color(0xFF4B1D0D)),
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
      create: (_) => ProductController()..fetchProducts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Atur Status Menu",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
        ),
        body: Consumer<ProductController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
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
                  _buildMenuItem(controller.products[index]),
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
