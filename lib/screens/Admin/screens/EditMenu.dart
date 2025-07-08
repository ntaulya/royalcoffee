import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  String? selectedCategory;
  File? _mainImage;
  List<File> _variantImages = [];

  final List<String> categoryOptions = [
    'Coffee',
    'Non-Coffee',
    'Snack',
    'Food',
    'Royal Glace',
    'Ice Cream Panda',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMainImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (image != null) {
      setState(() {
        _mainImage = File(image.path);
      });
    }
  }

  Future<void> _pickVariantImages() async {
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 85);
    if (images != null && images.isNotEmpty) {
      setState(() {
        _variantImages.addAll(images.map((xfile) => File(xfile.path)));
      });
    }
  }

  Widget _buildImageBox(File? imageFile, VoidCallback onTap,
      {double size = 100, String? caption}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile), fit: BoxFit.cover)
                  : null,
            ),
            child: imageFile == null
                ? const Center(child: Icon(Icons.add_a_photo, size: 24))
                : null,
          ),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                caption,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Edit Menu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Foto Menu Utama"),
              Center(
                child: _buildImageBox(
                  _mainImage,
                  _pickMainImage,
                  size: 180,
                  caption: "Ukuran ideal 1080 x 1080 px",
                ),
              ),

              const SizedBox(height: 12),
              _buildSectionTitle("Foto Varian"),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._variantImages.map(
                    (file) =>
                        _buildImageBox(file, () {}, size: 60, caption: "60x60"),
                  ),
                  _buildImageBox(null, _pickVariantImages,
                      size: 60, caption: "Tambah"),
                ],
              ),

              const SizedBox(height: 20),
              _buildSectionTitle("Informasi Menu"),
              _buildTextField("Nama Menu", icon: Iconsax.coffee),
              _buildTextField("Harga Menu", icon: Iconsax.money),
              _buildTextField("Deskripsi Menu", icon: Iconsax.document),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: const Text("Pilih Kategori"),
                  items: categoryOptions.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    prefixIcon: const Icon(Iconsax.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const Divider(thickness: 1.2),
              _buildSectionTitle("Informasi Varian"),
              _buildTextField("Varian (misal: Size)", icon: Iconsax.box),
              _buildTextField("Nama Varian", icon: Iconsax.edit),
              _buildTextField("Harga Penambahan", icon: Iconsax.money_2),
              _buildTextField("Stock Varian", icon: Iconsax.archive),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Menu berhasil disimpan!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B1D0D),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
