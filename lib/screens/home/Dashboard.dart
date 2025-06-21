import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/CartController.dart';

// Header & Layout
import '../layout/DashboardHeader.dart';
import '../layout/BottomNavBar.dart';
import '../layout/BannerWidget.dart';
import '../layout/CategoryTabs.dart';

// Views
import '../order/PesananSaya.dart';
import '../order/DetailPesanan.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardView();
}

class _DashboardView extends State<Dashboard> {
  final CartController _cartController = CartController();

  int _selectedBottomNavIndex = 0;
  String _selectedCategory = "Coffee";

  @override
  void initState() {
    super.initState();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
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
            MaterialPageRoute(builder: (context) => const PesananSaya()),
          ).then((_) {
            setState(() {
              _selectedBottomNavIndex = 0;
            });
          });
        }
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailPesanan()),
        ).then((_) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFFCF2D9),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                DashboardHeader(
                  cartController: _cartController,
                  onCartTap: () => _onBottomNavTapped(1),
                ),

                // Content
                Expanded(
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
                          selectedCategory: _selectedCategory,
                          onCategorySelected: _onCategorySelected,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating BottomNavBar
          BottomNavBar(
            selectedIndex: _selectedBottomNavIndex,
            onTap: _onBottomNavTapped,
          ),
        ],
      ),
    );
  }
}
