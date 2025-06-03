import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';
import '../../screens/order/detail_pesanan.dart';
import '../../screens/order/pesanan_saya.dart';
import '../../screens/home/home-noncoffee.dart';
import '../../screens/home/home-snack.dart';
import '../../screens/home/home-food.dart';
import '../../screens/home/home-royal-glace.dart';
import '../../screens/home/home-fresh-juice.dart';

class HomeCoffee extends StatefulWidget {
  const HomeCoffee({super.key});

  @override
  State<HomeCoffee> createState() => _HomeCoffeeState();
}

class _HomeCoffeeState extends State<HomeCoffee> {
  final AuthController _authController = AuthController();
  final CartController _cartController = CartController();

  String selectedCategory = "Coffee";
  int _selectedBottomNavIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        if (_cartController.items.isEmpty) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailPesanan()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PesananSaya()));
        }
        break;
      case 2:
        // TODO: Navigate to payment
        break;
      case 3:
        // TODO: Navigate to notifications
        break;
    }
  }

  void _onCategorySelected(String category) {
    if (category == selectedCategory) return;

    setState(() {
      selectedCategory = category;
    });

    switch (category) {
      case "Non-Coffee":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeNonCoffee()));
        break;
      case "Snack":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeSnack()));
        break;
      case "Food":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeFood()));
        break;
      case "Royal Glace":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeRoyalGlace()));
        break;
      case "Fresh Juice":
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeFreshJuice()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF2D9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF834D1E),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Royal Cafe", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Home", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Image.asset('assets/icons/profile.png', height: 40),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE9F7EF), Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/Banner.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),

                    // Category Tabs
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            "Coffee",
                            "Non-Coffee",
                            "Snack",
                            "Food",
                            "Royal Glace",
                            "Fresh Juice",
                          ].map((category) {
                            final isSelected = selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => _onCategorySelected(category),
                                child: Chip(
                                  label: Text(category),
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: isSelected ? const Color(0xFF8B4A0C) : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // TODO: Add product grid here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTapped,
        selectedItemColor: const Color(0xFF8B4A0C),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Iconsax.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Iconsax.wallet), label: "Payment"),
          BottomNavigationBarItem(icon: Icon(Iconsax.notification), label: "Notifications"),
        ],
      ),
    );
  }
}
