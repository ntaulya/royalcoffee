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

  @override
  void initState() {
    super.initState();
    _productController = ProductController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productController.fetchInitialProducts(); // Initial load
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    _productController.fetchInitialProducts(
      categoryId: category,
      searchQuery: _searchController.text,
    );
  }

  void _onSearchSubmitted(String value) {
    _productController.fetchInitialProducts(
      categoryId: _selectedCategory,
      searchQuery: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF7A491F),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFFFCF2D9),
        body: Stack(
          children: [
            Column(
              children: [
                // Header
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

                // Main Content
                Expanded(
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        // Search
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
                          onInitialCategoryReady: (categoryId) {
                            setState(() {
                              _selectedCategory = categoryId;
                            });

                            _productController.fetchInitialProducts(
                              categoryId: categoryId,
                              searchQuery: _searchController.text,
                            );
                          },
                        ),

                        // Product Grid (with its own scroll controller)
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await _productController.fetchInitialProducts(
                                categoryId: _selectedCategory,
                                searchQuery: _searchController.text,
                              );
                            },
                            child: _productController.errorMessage != null
                                ? Center(
                                    child: Text(
                                      'Gagal memuat produk:\n${_productController.errorMessage}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ProductSection(
                                    controller: _productController,
                                    selectedCategoryId: _selectedCategory,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            BottomNavBar(selectedIndex: 0),
          ],
        ),
      ),
    );
  }
}
