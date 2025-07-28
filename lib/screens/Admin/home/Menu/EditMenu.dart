import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../controllers/Product/CategoryController.dart';
import '../../../../controllers/Product/ProductController.dart';
import '../../../../models/Category.dart';
import '../../../../models/Product/Product.dart';
class MenuVariant {
  File? image;
  String name = '', price = '', stock = '';
  MenuVariant({this.image});
}

class EditMenu extends StatefulWidget {
 
  final String productId;
  final String categoryId;

  const EditMenu({
    Key? key, 
    required this.categoryId,
    required this.productId,
  }) : super(key: key);
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  Product? _product;
  final _categoryController = CategoryController();
  final _productController = ProductController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  List<Category> _categories = [];
  Category? selectedCategory;
  File? _mainImage;
  List<MenuVariant> _variants = [MenuVariant()];

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    await _loadCategories();
    await _loadProduct();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  Future<void> _loadProduct() async {
    final product = await _productController.fetchProductDetail(
      int.parse(widget.categoryId),
      widget.productId,
    );

    if (product != null) {
      setState(() {
        _product = product;
        _nameController.text = product.name;
        _priceController.text = product.price;
        _descriptionController.text = product.description ?? '';

        if (_categories.isNotEmpty) {
          selectedCategory = _categories.firstWhere(
            (c) => c.id.toString() == widget.categoryId,
            orElse: () => _categories.first,
          );
        }

        _variants = product.variants.map((v) => MenuVariant()
          ..name = v.namaVarian ?? ''
          ..price = v.hargaTambahan.toString() ?? ''
          ..stock = v.stock.toString() ?? ''
        ).toList();
      });
    }
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryController.loadCategories();
    setState(() => _categories = categories);
  }

  Future<void> _pickImage({
    required Function(File file) onSelected,
    required String errorLabel,
  }) async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      final file = File(image.path);
      final mimeType = lookupMimeType(image.path);
      final isPng = mimeType == 'image/png';
      if (file.lengthSync() > 2 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kuran file anda : ${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB\n $errorLabel maksimal 2MB')));
      } else if (!isPng) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$errorLabel harus berupa file PNG')));
      } else {
        onSelected(file);
      }
    }
  }

  Widget _buildTextField(String hint, {IconData? icon, TextEditingController? controller, Function(String)? onChanged, String? initialValue}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );

  Widget _buildImageBox(File? image, VoidCallback onTap, {double size = 100, String? caption}) =>
    GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              image: image != null ? DecorationImage(image: FileImage(image), fit: BoxFit.cover) : null,
            ),
            child: image == null ? const Center(child: Icon(Icons.add_a_photo)) : null,
          ),
          if (caption != null) Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(caption, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );

  Widget _buildVariantCard(int index) {
    final v = _variants[index];
    final isFirst = index == 0;
    if (isFirst) v.price = '0';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isFirst) _buildImageBox(v.image, () => _pickImage(
              onSelected: (file) => setState(() => v.image = file),
              errorLabel: 'Varian ke-${index + 1}')),
            if (!isFirst) const SizedBox(width: 12),
            Expanded(child: Column(children: [
              _buildTextField("Nama Varian", icon: Iconsax.edit, initialValue: v.name, onChanged: (val) => v.name = val),
              if (!isFirst)
                _buildTextField("Harga Penambahan", icon: Iconsax.money_2, initialValue: v.price, onChanged: (val) => v.price = val),
              _buildTextField("Stock", icon: Iconsax.archive, initialValue: v.stock, onChanged: (val) => v.stock = val),
            ])),
            IconButton(onPressed: () => setState(() => _variants.removeAt(index)), icon: const Icon(Icons.delete, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _submitProduct() async {
    if (_variants.isEmpty || selectedCategory == null ||
        _nameController.text.isEmpty || _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty || _mainImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi semua data')));
      return;
    }

    if (!_mainImage!.path.toLowerCase().endsWith('.png')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gambar utama harus PNG')));
      return;
    }

    List<Map<String, dynamic>> variantList = [];
    for (int i = 0; i < _variants.length; i++) {
      final v = _variants[i];
      if (v.name.isEmpty || v.price.isEmpty || v.stock.isEmpty || (i > 0 && v.image == null)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lengkapi data varian ke-${i + 1}')));
        return;
      }
      variantList.add({
        "nama_varian": v.name,
        "harga_varian": int.parse(v.price),
        "stock_varian": int.parse(v.stock),
        "is_primary": i == 0,
        "image_varian": i == 0 ? _mainImage! : v.image!,
      });
    }

    await _productController.createProduct(
      namaProduct: _nameController.text,
      hargaProduct: _priceController.text,
      descriptionProduct: _descriptionController.text,
      kategoriId: selectedCategory!.id.toString(),
      varianProductList: variantList,
    );
    Navigator.pop(context, true); 
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.grey.shade50,
    appBar: AppBar(
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), color: Colors.black, onPressed: () => Navigator.pop(context,true)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text("Edit Menu", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      centerTitle: true,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildSectionTitle("Foto Menu Utama"),
          Center(child: _buildImageBox(_mainImage, () => _pickImage(onSelected: (f) => setState(() => _mainImage = f), errorLabel: 'Gambar utama'), size: 180, caption: "Ukuran ideal 1080 x 1080 px (PNG only)")),
          const SizedBox(height: 20),
          _buildSectionTitle("Informasi Menu"),
          _buildTextField("Nama Menu", icon: Iconsax.coffee, controller: _nameController),
          _buildTextField("Harga Menu", icon: Iconsax.money, controller: _priceController),
          _buildTextField("Deskripsi Menu", icon: Iconsax.document, controller: _descriptionController),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: DropdownButtonFormField<Category>(
              value: selectedCategory,
              hint: const Text("Pilih Kategori"),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (c) => setState(() => selectedCategory = c),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                prefixIcon: const Icon(Iconsax.category),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const Divider(thickness: 1.2),
          _buildSectionTitle("Varian Menu"),
          ...List.generate(_variants.length, _buildVariantCard),
          TextButton.icon(onPressed: () => setState(() => _variants.add(MenuVariant())), icon: const Icon(Icons.add), label: const Text("Tambah Varian")),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _submitProduct,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B1D0D), shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
              child: const Text("Tambahkan Product", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ]),
      ),
    ),
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}
