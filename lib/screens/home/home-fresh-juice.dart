import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/AuthController.dart';
import '../../screens/home/Dashboard.dart';
import '../../screens/home/home-noncoffee.dart';
import '../../screens/home/home-food.dart';
import '../../screens/home/home-snack.dart';
import '../../screens/home/home-royal-glace.dart';

class HomeFreshJuice extends StatefulWidget {
  const HomeFreshJuice({super.key});

  @override
  State<HomeFreshJuice> createState() => _HomeFreshJuiceState();
}

class _HomeFreshJuiceState extends State<HomeFreshJuice> {
  final AuthController _controller = AuthController();

  String selectedCategory = "Fresh Juice";

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
              color: const Color(0xFF834D1E),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Royal Cafe",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                          hintText: "Search Fresh Juice",
                          prefixIcon: const Icon(Iconsax.search_normal),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),

                    // Promo Banner
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

                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              [
                                "Coffee",
                                "Non-Coffee",
                                "Snack",
                                "Food",
                                "Royal Glace",
                                "Fresh Juice",
                                "Ice Cream Panda",
                              ].map((e) {
                                final isSelected = selectedCategory == e;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = e;
                                        });

                                        // Navigasi sesuai kategori
                                        if (e == "Coffee") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const Dashboard(),
                                            ),
                                          );
                                        } else if (e == "Non-Coffee") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const HomeNonCoffee(),
                                            ),
                                          );
                                        } else if (e == "Snack") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const HomeSnack(),
                                            ),
                                          );
                                        } else if (e == "Food") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => const HomeFood(),
                                            ),
                                          );
                                        } else if (e == "Royal Glace") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const HomeRoyalGlace(),
                                            ),
                                          );
                                        } else if (e == "Fresh Juice") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const HomeFreshJuice(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color:
                                              isSelected
                                                  ? const Color(0xFF8B4A0C)
                                                  : Colors.grey.shade300,
                                          width: 1.5,
                                        ),
                                        labelStyle: TextStyle(
                                          color:
                                              isSelected
                                                  ? const Color(0xFF8B4A0C)
                                                  : Colors.black,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),

                    // Product Grid (Fixed height inside scroll view)
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
                            _buildProductCard(
                              "Juice Jeruk",
                              "Rp.20.000",
                              "assets/images/jus-jeruk.png",
                            ),
                            _buildProductCard(
                              "Juice Markisa",
                              "Rp. 24.000",
                              "assets/images/jus-markisa.png",
                            ),
                            _buildProductCard(
                              "Juice Alpukat",
                              "Rp. 27.000",
                              "assets/images/jus-alpukat.png",
                            ),
                            _buildProductCard(
                              "Es Kelapa Muda",
                              "Rp. 20.000",
                              "assets/images/es-kelapa-muda.png",
                            ),
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
        selectedItemColor: const Color(0xFF834D1E),
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(price),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Iconsax.shopping_bag,
                      color: Color(0xFF834D1E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
