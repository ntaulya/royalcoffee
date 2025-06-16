import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/CartController.dart';
import '../../models/CartItem.dart';


// Screen
import '../Auth/User/ProfilePage.dart';

class DashboardHeader extends StatelessWidget {
  final CartController cartController;
  final VoidCallback onCartTap;

  const DashboardHeader({
    super.key,
    required this.cartController,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF834D1E),
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
          Row(
            children: [
              StreamBuilder<List<CartItem>>(
                stream: cartController.cartItemsStream,
                builder: (context, snapshot) {
                  final itemCount = cartController.totalItemCount;
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: onCartTap,
                        icon: const Icon(Iconsax.shopping_cart, color: Colors.white),
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Image.asset('assets/icons/profile.png', height: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}