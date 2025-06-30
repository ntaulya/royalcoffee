import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import '../../../admin/home/DashboardAdmin.dart';

class EditMenu extends StatefulWidget {
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  String? selectedCategory;
  File? selectedImage;

  final List<String> categoryOptions = [
    'Coffee',
    'Non-Coffee',
    'Snack',
    'Drink',
    'Royal Glace',
    'Ice Cream Panda',
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: selectedImage != null
              ? Image.file(
                  selectedImage!,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

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

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          prefixIcon: Icon(Iconsax.category),
          hintText: "Pilih Kategori",
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: categoryOptions.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
          });
        },
      ),
    );
  }

  Widget _buildSaveButton(VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4B1D0D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text("Save", style: TextStyle(color: Colors.white)),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              const SizedBox(height: 20),

              // 🟤 Detail Menu Tetap di Atas
              const Text(
                "Detail Menu",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildTextField("Nama Menu"),
              _buildTextField("Harga Menu"),
              _buildTextField("Deskripsi Menu"),
              _buildCategoryDropdown(),

              const SizedBox(height: 20),
              const Text("Edit Varian",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField("Varian"),
              _buildTextField("Nama Varian"),
              _buildTextField("Harga"),
              _buildTextField("Stock"),

              const SizedBox(height: 30),

              // ✅ Save Button Full Width di Bawah
              _buildSaveButton(() {
                // Simpan detail menu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu berhasil disimpan!')),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
