import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../admin/home/DashboardAdmin.dart';

class EditMenu extends StatelessWidget {
  Widget _buildTextField(String hintText, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildImageDummy() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587', // Es krim dummy
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSaveButton(VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4B1D0D),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: const Text("Save", style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B1D0D)),
          onPressed: () {
            Navigator.push(
              context,
                MaterialPageRoute(builder: (context) => DashboardAdmin()),
            );
          },
        ),
        title: const Text(
          "Menu Edit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B1D0D),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Detail Menu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildSaveButton(() {
                    // Simpan detail menu
                  }),
                ],
              ),
              const SizedBox(height: 10),
              _buildTextField("Nama Menu"),
              _buildTextField("Harga Menu"),
              _buildTextField("Deskripsi Menu"),
              _buildTextField("Kategori", icon: Iconsax.category),
              const SizedBox(height: 20),
              const Text("Edit Varian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildImageDummy(),
                  const SizedBox(width: 16),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
