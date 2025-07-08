import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';


import '../../../../controllers/Product/CategoryController.dart';
import '../../../../models/Category.dart';

class MenuVariant {
  File? image;
  String name = '';
  String price = '';
  String stock = '';

  MenuVariant({this.image});
}

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final CategoryController _categoryController = CategoryController();
  List<Category> _categories = [];
  Category? selectedCategory;
  
  File? _mainImage;
  final ImagePicker _picker = ImagePicker();

  List<MenuVariant> _variants = [];

  Future<void> _loadCategories() async {
    final categories = await _categoryController.loadCategories();
    setState(() {
      _categories = categories;
    });
  }


  

  Future<void> _pickMainImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (image != null) {
      setState(() => _mainImage = File(image.path));
    }
  }

  Future<void> _pickVariantImage(int index) async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (image != null) {
      setState(() => _variants[index].image = File(image.path));
    }
  }

  Widget _buildTextField(String hintText, {IconData? icon, Function(String)? onChanged, String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
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
                  ? DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover)
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

  Widget _buildVariantCard(int index) {
    final variant = _variants[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                _buildImageBox(
                  variant.image,
                  () => _pickVariantImage(index),
                  size: 60,
                  caption: "60x60",
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField("Nama Varian",
                          icon: Iconsax.edit,
                          initialValue: variant.name,
                          onChanged: (val) => variant.name = val),
                      _buildTextField("Harga Penambahan",
                          icon: Iconsax.money_2,
                          initialValue: variant.price,
                          onChanged: (val) => variant.price = val),
                      _buildTextField("Stock",
                          icon: Iconsax.archive,
                          initialValue: variant.stock,
                          onChanged: (val) => variant.stock = val),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _variants.removeAt(index));
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _variants.add(MenuVariant());
    _loadCategories();
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
          "Tambah Menu",
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

              const SizedBox(height: 20),
              _buildSectionTitle("Informasi Menu"),
              _buildTextField("Nama Menu", icon: Iconsax.coffee),
              _buildTextField("Harga Menu", icon: Iconsax.money),
              _buildTextField("Deskripsi Menu", icon: Iconsax.document),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  hint: const Text("Pilih Kategori"),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (Category? value) {
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
              _buildSectionTitle("Varian Menu"),

              ...List.generate(_variants.length, _buildVariantCard),

              TextButton.icon(
                onPressed: () {
                  setState(() => _variants.add(MenuVariant()));
                },
                icon: const Icon(Icons.add),
                label: const Text("Tambah Varian"),
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                     if (_variants.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Minimal harus ada 1 varian')),
                        );
                        return;
                      }

                      if (selectedCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pilih kategori terlebih dahulu')),
                        );
                        return;
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B1D0D),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child: const Text(
                    "Tambahkan Product",
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
