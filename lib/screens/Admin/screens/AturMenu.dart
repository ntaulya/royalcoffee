import 'package:flutter/material.dart';
import 'package:royalcoffee/screens/Admin/layout/BottomNavBarAdmin.dart';
import 'package:intl/intl.dart';

class AturMenu extends StatefulWidget {
  const AturMenu({super.key});

  @override
  State<AturMenu> createState() => _AturMenuState();
}

class _AturMenuState extends State<AturMenu> {
  int _selectedIndex = 2;

  // Format Rupiah
  String formatRupiah(int number) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(number);
  }

  // Dummy data
  List<Map<String, dynamic>> menuList = [
    {
      "name": "Ice Cream Vanilla",
      "price": 15000,
      "stock": 20,
      "isActive": false,
      "imageUrl": "https://i.imgur.com/7GLW0Yt.png",
    },
    {
      "name": "Ice Cream Coklat",
      "price": 17000,
      "stock": 10,
      "isActive": true,
      "imageUrl": "https://i.imgur.com/7GLW0Yt.png",
    },
  ];

  Widget _buildMenuCard(int index) {
    final menu = menuList[index];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  menu["imageUrl"],
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCC6B2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            formatRupiah(menu["price"]),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4B1D0D),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                "Stok ${menu["stock"]}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          menu["isActive"] ? "Aktif" : "Non-Aktif",
                          style: TextStyle(
                            color: menu["isActive"] ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Switch(
                          value: menu["isActive"],
                          activeColor: const Color(0xFF4B1D0D),
                          inactiveThumbColor: Colors.grey,
                          onChanged: (value) {
                            setState(() {
                              menuList[index]["isActive"] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigasi ke halaman edit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B1D0D),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Edit", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        const Divider(thickness: 0.7, indent: 16, endIndent: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text("Atur Status Menu", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (context, index) => _buildMenuCard(index),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B4A0C),
        onPressed: () {
          // TODO: Tambah menu baru
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavBarAdmin(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // TODO: Navigasi sesuai index
          });
        },
      ),
    );
  }
}
