import 'package:flutter/material.dart';
import '../../../controllers/cart_controller.dart';
import '../../../models/cart_item.dart';
import '../../screens/order/pesanan_saya.dart';

class DetailPesanan extends StatefulWidget {
  final CartItem? initialItem; // Add parameter for initial item
  
  const DetailPesanan({super.key, this.initialItem});

  @override
  State<DetailPesanan> createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  final cartController = CartController();

  int qtyHangat = 0; // Start with 0
  int qtyDingin = 0; // Start with 0

  final int hargaHangat = 24000;
  final int hargaDingin = 27000;

  @override
  void initState() {
    super.initState();
    _loadExistingQuantities();
  }

  void _loadExistingQuantities() {
    // Check existing cart items and set quantities
    final existingHangat = cartController.items.firstWhere(
      (item) => item.title == 'Latte Hangat',
      orElse: () => CartItem(title: '', price: '', imagePath: '', quantity: 0),
    );
    
    final existingDingin = cartController.items.firstWhere(
      (item) => item.title == 'Latte Dingin',
      orElse: () => CartItem(title: '', price: '', imagePath: '', quantity: 0),
    );

    setState(() {
      qtyHangat = existingHangat.quantity;
      qtyDingin = existingDingin.quantity;
      
      // If no existing items, set minimum 1 for one variant
      if (qtyHangat == 0 && qtyDingin == 0) {
        qtyHangat = 1; // Default to 1 hangat
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItem = qtyHangat + qtyDingin;
    int totalHarga = (qtyHangat * hargaHangat) + (qtyDingin * hargaDingin);

    return Scaffold(
      backgroundColor: const Color(0xFF834D1E),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Detail Pesanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Konten Putih
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Produk
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/coffee-latte.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Deskripsi Produk
                    const Text(
                      'Minuman kopi yang lembut dan creamy, terbuat dari perpaduan espresso berkualitas dan susu steamed yang hangat. '
                      'Disajikan dengan sentuhan seni latte art berbentuk daun di atas permukaannya, menambah daya tarik visual dan cita rasa yang elegan. '
                      'Cocok dinikmati kapan saja, baik untuk memulai hari maupun menemani waktu santai.',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Varian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Varian Hangat
                    buildVarianTile(
                      label: 'Hangat',
                      price: hargaHangat,
                      quantity: qtyHangat,
                      onAdd: () => setState(() => qtyHangat++),
                      onRemove: () {
                        if (qtyHangat > 0) setState(() => qtyHangat--);
                      },
                      backgroundColor: const Color(0xFFF2F2F2),
                    ),

                    const SizedBox(height: 10),

                    // Varian Dingin
                    buildVarianTile(
                      label: 'Dingin',
                      price: hargaDingin,
                      quantity: qtyDingin,
                      onAdd: () => setState(() => qtyDingin++),
                      onRemove: () {
                        if (qtyDingin > 0) setState(() => qtyDingin--);
                      },
                      backgroundColor: const Color(0xFFFFF1C5),
                    ),

                    const Spacer(),

                    // Footer: Harga total dan tombol
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rp.${totalHarga.toString().replaceAllMapped(RegExp(r'(\d{3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total Item : $totalItem',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          ElevatedButton(
                            onPressed: totalItem > 0 ? () {
                              _updateCartItems();
                              
                              // Navigasi ke halaman PesananSaya
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PesananSaya(),
                                ),
                              );
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B4A0C),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Lanjutkan ke Pembayaran',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateCartItems() {
    // Remove existing latte items first
    cartController.removeItemCompletely('Latte Hangat');
    cartController.removeItemCompletely('Latte Dingin');

    // Add items with correct quantities
    if (qtyHangat > 0) {
      cartController.addToCart(
        CartItem(
          title: 'Latte Hangat',
          price: hargaHangat.toString(),
          imagePath: 'assets/images/coffee-latte.png',
          quantity: qtyHangat,
        ),
      );
    }

    if (qtyDingin > 0) {
      cartController.addToCart(
        CartItem(
          title: 'Latte Dingin',
          price: hargaDingin.toString(),
          imagePath: 'assets/images/coffee-latte.png',
          quantity: qtyDingin,
        ),
      );
    }
  }

  Widget buildVarianTile({
    required String label,
    required int price,
    required int quantity,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label\nRp.${price ~/ 1000}.000',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$quantity'),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}