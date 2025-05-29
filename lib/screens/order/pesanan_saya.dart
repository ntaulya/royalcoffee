import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_item.dart';

class PesananSaya extends StatefulWidget {
  const PesananSaya({super.key});

  @override
  State<PesananSaya> createState() => _PesananSayaState();
}

class _PesananSayaState extends State<PesananSaya> {
  final CartController cartController = CartController();
  String paymentMethod = 'Take Away';
  int selectedTabIndex = 0; // 0 for Keranjang, 1 for Struk
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF834D1E),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Pesanan Saya',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Tab Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTabButton('Keranjang', 0),
                const SizedBox(width: 10),
                buildTabButton('Struk', 1),
              ],
            ),

            const SizedBox(height: 16),

            // Main Container
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: selectedTabIndex == 0 
                    ? buildKeranjangTab() 
                    : buildStrukTab(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF8B4A0C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Shopping cart selected
        onTap: (index) {
          // Handle navigation based on index
          switch (index) {
            case 0:
              // Navigate to Home
              break;
            case 1:
              // Already on cart page
              break;
            case 2:
              // Navigate to Card/Payment
              break;
            case 3:
              // Navigate to Notifications
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Iconsax.card), label: 'Payment'),
          BottomNavigationBarItem(icon: Icon(Iconsax.notification), label: 'Notifications'),
        ],
      ),
    );
  }

  Widget buildTabButton(String title, int index) {
    bool isActive = selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF834D1E) : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildKeranjangTab() {
    return StreamBuilder<List<CartItem>>(
      stream: cartController.cartItemsStream,
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Trigger rebuild
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Get cart items or empty list if null
        final cartItems = snapshot.data ?? [];

        // Empty cart state
        if (cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.shopping_cart,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Keranjang kosong',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mulai tambahkan makanan ke keranjang',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Calculate totals
        int subtotal = 0;
        for (var item in cartItems) {
          final priceInt = int.tryParse(item.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          subtotal += priceInt * item.quantity;
        }

        int tax = (subtotal * 0.1).toInt();
        int total = subtotal + tax;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Cart Items
              ...cartItems.map((item) => buildOrderItem(item)),
              
              // Divider
              const Divider(thickness: 1, height: 32),
              
              // Price Breakdown
              buildTotalRow('Subtotal', subtotal),
              buildTotalRow('Tax and Fees', tax),
              const Divider(thickness: 1),
              buildTotalRow('Total', total, bold: true),
              
              const SizedBox(height: 16),
              
              // Notes Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1C5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tulis Nomor Meja dan Catatan Pesanan Disini!',
                    hintStyle: TextStyle(color: Colors.brown),
                  ),
                  style: const TextStyle(color: Colors.brown),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Payment Method Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih Metode Pembayaran:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Take Away',
                      groupValue: paymentMethod,
                      title: const Text('Take Away'),
                      subtitle: const Text('Ambil pesanan di tempat'),
                      onChanged: (value) => setState(() => paymentMethod = value!),
                      activeColor: const Color(0xFF834D1E),
                    ),
                    const Divider(),
                    RadioListTile<String>(
                      value: 'Dine In',
                      groupValue: paymentMethod,
                      title: const Text('Dine In'),
                      subtitle: const Text('Makan di tempat'),
                      onChanged: (value) => setState(() => paymentMethod = value!),
                      activeColor: const Color(0xFF834D1E),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: cartItems.isNotEmpty ? () => _confirmOrder(total) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF834D1E),
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Konfirmasi Pembayaran - ${_formatCurrency(total)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget buildStrukTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.document_text,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Belum ada struk',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Struk akan muncul setelah pembayaran dikonfirmasi',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildOrderItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Item Image Placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Iconsax.coffee,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          
          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.price,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          Row(
            children: [
              IconButton(
                onPressed: () => _decreaseQuantity(item),
                icon: const Icon(Icons.remove_circle_outline),
                color: const Color(0xFF834D1E),
              ),
              Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () => _increaseQuantity(item),
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF834D1E),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTotalRow(String label, int amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
              color: bold ? const Color(0xFF834D1E) : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  void _increaseQuantity(CartItem item) {
    cartController.removeFromCart(item.id, item.quantity + 1);
  }

  void _decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      cartController.removeFromCart(item.id, item.quantity - 1);
    } else {
      cartController.removeFromCart(item.id);
    }
  }

  void _confirmOrder(int total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Pesanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: ${_formatCurrency(total)}'),
              Text('Metode: $paymentMethod'),
              if (notesController.text.isNotEmpty)
                Text('Catatan: ${notesController.text}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan berhasil dikonfirmasi!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Clear cart after confirmation
                cartController.clearCart();
                notesController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF834D1E),
              ),
              child: const Text(
                'Konfirmasi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}