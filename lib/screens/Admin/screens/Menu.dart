import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royalcoffee/screens/Admin/layout/BottomNavBarAdmin.dart';
import 'package:royalcoffee/screens/Admin/screens/TrackOrder.dart';
import 'package:royalcoffee/screens/Admin/screens/Customer.dart';
import 'package:royalcoffee/controllers/product/ProductController.dart';
import 'package:royalcoffee/models/Product/Product.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedBottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProductController>(context, listen: false)
            .fetchProducts());
  }

  void _onTap(int index) {
    if (index == _selectedBottomNavIndex) return;

    setState(() {
      _selectedBottomNavIndex = index;
    });

   
  }

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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Atur Status Menu",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.products.isEmpty) {
            return const Center(child: Text("Tidak ada data menu."));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ListView.builder(
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(controller.products[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF844C29),
        onPressed: () {
          // Tambah menu
        },
        child: const Icon(Icons.receipt_long_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
