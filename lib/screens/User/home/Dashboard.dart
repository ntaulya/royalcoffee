import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/CartController.dart';
import '../../../controllers/Product/ProductController.dart';

// Header & Layout
import '../layout/DashboardHeader.dart';
import '../layout/BottomNavBar.dart';
import '../layout/BannerWidget.dart';
import '../layout/CategoryTabs.dart';
import '../layout/ProductSection.dart';

// Views
import './PesananSaya.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardView();
}

class _DashboardView extends State<Dashboard> {
  final CartController _cartController = CartController();
  late ProductController _productController;
  final TextEditingController _searchController = TextEditingController();

  int _selectedBottomNavIndex = 0;
  String _selectedCategory = "";
  bool _isLoadingProduct = false;

  @override
  void initState() {
    super.initState();
    _productController = ProductController();
  }

  void _fetchProducts({String? categoryId, String? searchQuery}) async {
    if (!mounted) return;
    setState(() => _isLoadingProduct = true);

    await _productController.fetchProducts(
      categoryId: categoryId ?? _selectedCategory,
      searchQuery: searchQuery ?? _searchController.text,
    );

    setState(() => _isLoadingProduct = false);
  }

  void _onCategorySelected(String category) async {
    if (!mounted) return;
    setState(() {
      _selectedCategory = category;
      _isLoadingProduct = true;
    });

    await _productController.fetchProducts(
      categoryId: category,
      searchQuery: _searchController.text,
    );

    setState(() => _isLoadingProduct = false);
  }

  void _onSearchSubmitted(String value) {
    _fetchProducts(searchQuery: value);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF7A491F), // warna cokelat header
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFFFCF2D9), // krem
        body: Stack(
          children: [
            Column(
              children: [
                // ✅ Header dipindahkan ke luar SafeArea
                DashboardHeader(
                  cartController: _cartController,
                  onCartTap: () {
                    if (_cartController.items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Keranjang masih kosong')),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PesananSaya()),
                      ).then((_) {
                        setState(() => _selectedBottomNavIndex = 0);
                      });
                    }
                  },
                ),

                // ✅ Konten dibungkus SafeArea dengan top: false
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Search Bar
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: _onSearchSubmitted,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Search Coffee",
                                prefixIcon: IconButton(
                                  icon: const Icon(Iconsax.search_normal),
                                  onPressed: () => _onSearchSubmitted(_searchController.text),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          // Banner
                          BannerWidget(imagePath: 'assets/images/Banner.png'),

                          // Category Tabs
                          CategoryTabs(
                            selectedCategory: _selectedCategory,
                            onCategorySelected: _onCategorySelected,
                            onInitialCategoryReady: (categoryId) async {
                              if (!mounted) return;
                              setState(() {
                                _selectedCategory = categoryId;
                                _isLoadingProduct = true;
                              });

                              await _productController.fetchProducts(
                                categoryId: categoryId,
                                searchQuery: _searchController.text,
                              );

                              setState(() => _isLoadingProduct = false);
                            },
                          ),
                          // Product Section
                          _isLoadingProduct
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(),
                                )
                              : ProductSection(
                                  products: _productController.products,
                                  controller: _productController,
                                  selectedCategoryId: _selectedCategory,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Navigation
            BottomNavBar(selectedIndex: 0),
          ],
        ),
      ),
    );
  }
}
