import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/auth_controller.dart';
import '../../screens/home/home-noncoffee.dart';
import '../../screens/home/home-snack.dart';
import '../../screens/home/home-food.dart';

class HomeCoffee extends StatefulWidget {
  const HomeCoffee({super.key});

  @override
  State<HomeCoffee> createState() => _HomeCoffeeState();
}

class _HomeCoffeeState extends State<HomeCoffee> {
  final AuthController _controller = AuthController();
  String selectedCategory = "Coffee";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFCF2D9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFF8B4A0C),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Royal Cafe",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Home", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Image.asset('assets/icons/profile.png', height: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search Bar
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
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),

                    // Promo Banner
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 160, // Fixed height for safe sizing
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
                        child: Image.asset('assets/images/Banner.png',
                            fit: BoxFit.cover, width: double.infinity),
                      ),
                    ),

                    // Categories
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ["Coffee", "Non-Coffee", "Snack", "Food"]
                            .map((e) {
                          final isSelected = selectedCategory == e;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  selectedCategory = e;
                                });

                                if (e == "Non-Coffee") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeNonCoffee(),
                                    ),
                                  );
                                }

                              },
                              child: Chip(
                                label: Text(e),
                                backgroundColor: isSelected
                                    ? const Color(0xFF8B4A0C)
                                    : Colors.grey[200],
                                labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3 / 4,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildProductCard("Coffee Latte", "Rp.24.000",
                                "assets/images/coffee-latte.png"),
                            _buildProductCard("Cappuccino", "Rp. 27.000",
                                "assets/images/cappucino.png"),
                            _buildProductCard("Kopi Susu", "Rp. 23.000",
                                "assets/images/kopi-susu.png"),
                            _buildProductCard("Kopi Gula Aren", "Rp. 27.000",
                                "assets/images/kopi-susu-gula-aren.png"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF8B4A0C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Iconsax.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Iconsax.card), label: ''),
          BottomNavigationBarItem(icon: Icon(Iconsax.notification), label: ''),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String price, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(imagePath,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.shopping_bag,
                        color: Color(0xFF8B4A0C)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}