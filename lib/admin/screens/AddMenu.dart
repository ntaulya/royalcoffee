import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddMenu extends StatelessWidget {
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
        'https://images.unsplash.com/photo-1578985545062-69928b1d9587', // es krim dummy
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4B1D0D),
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back_ios_new),
                  SizedBox(width: 12),
                  Text("Tambah Menu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              _buildTextField("Nama Menu"),
              _buildTextField("Harga Menu"),
              _buildTextField("Deskripsi Menu"),
              _buildTextField("Kategori", icon: Iconsax.category),
              SizedBox(height: 10),
              Center(child: _buildButton("Tambah Foto Utama", () {})),
              SizedBox(height: 10),
              Center(child: _buildImageDummy()),
              SizedBox(height: 20),
              _buildTextField("Varian"),
              _buildTextField("Nama Varian"),
              _buildTextField("Harga Penambahan"),
              _buildTextField("Stock Varian"),
              SizedBox(height: 10),
              Center(child: _buildButton("Tambah Foto Varian", () {})),
              SizedBox(height: 10),
              Center(child: _buildImageDummy()),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Simpan data
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B1D0D),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text("Selesai", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
