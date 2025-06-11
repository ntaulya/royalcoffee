import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/AuthController.dart';



import '../../services/ApiService.dart';
import '../../controllers/CartController.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';

// Hader
import '../layout/DashboardHeader.dart';
import '../layout/BottomNavBar.dart';
import '../layout/BannerWidget.dart';
import '../layout/CategoryTabs.dart';

// Masih Di Check 
import '../../screens/order/detail_pesanan.dart';
import '../../screens/order/pesanan_saya.dart';
import '../../screens/home/home-noncoffee.dart';
import '../../screens/home/home-snack.dart';
import '../../screens/home/home-food.dart';
import '../../screens/home/home-royal-glace.dart';
import '../../screens/home/home-fresh-juice.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardView();
}

class _DashboardView extends State<Dashboard> {
  final AuthController _authController = AuthController();
  final CartController _cartController = CartController();
  // final ApiService _apiService = ApiService();
  final List<String> categories = [
    "Coffee",
    "Non-Coffee",
    "Snack",
    "Food",
    "Royal Glace",
    "Fresh Juice",
  ];

  String selectedCategory = "Coffee";
  int _selectedBottomNavIndex = 0;

  // State untuk API data
  List<Product> coffeeProducts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCoffeeProducts();
  }

  // Method untuk load data dari API
  Future<void> _loadCoffeeProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Panggil API untuk get coffee products
      // final products = await _apiService.getAllProducts();

      setState(() {
        // coffeeProducts = products;
        isLoading = false;
      });


    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    }
  }

  // Method untuk refresh data
  Future<void> _refreshProducts() async {
    await _loadCoffeeProducts();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        if (_cartController.items.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Keranjang masih kosong')),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PesananSaya()))
              .then((_) {
            setState(() {
              _selectedBottomNavIndex = 0;
            });
          });
        }
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailPesanan()))
            .then((_) {
          setState(() {
            _selectedBottomNavIndex = 0;
          });
        });
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur notifikasi belum tersedia')),
        );
        setState(() {
          _selectedBottomNavIndex = 0;
        });
        break;
    }
  }

  void _onCategorySelected(String category) {

    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF2D9),
      body: SafeArea(
        child: Column(
          children: [
            // Belum Beres Hader
            DashboardHeader(
              cartController : _cartController,
              onCartTap: () => _onBottomNavTapped(1),
            ),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshProducts,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Search
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Search Coffee",
                            prefixIcon: const Icon(Iconsax.search_normal),
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
                            categories: categories,
                            selectedCategory: selectedCategory,
                            onCategorySelected: _onCategorySelected,
                      ),
                      
                      // Products Grid - DENGAN API DATA
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildProductsSection(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildProductsSection() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error memuat produk',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadCoffeeProducts,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (coffeeProducts.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.coffee_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada produk coffee',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: coffeeProducts.length,
      itemBuilder: (context, index) {
        final product = coffeeProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.imageUrl != null
                    ? Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.coffee,
                        size: 50, color: Colors.grey);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                        child: CircularProgressIndicator());
                  },
                )
                    : const Icon(Icons.coffee,
                    size: 50, color: Colors.grey),
              ),
            ),
          ),
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${product.name} ditambahkan ke keranjang'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4A0C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}