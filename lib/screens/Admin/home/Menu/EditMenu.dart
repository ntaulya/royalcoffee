import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../../../controllers/Product/CategoryController.dart';
import '../../../../models/Category.dart';
import '../../../../models/Product/Product.dart';

class MenuVariant {
  File? image;
  String name;
  String price;
  String stock;

  MenuVariant({this.image, this.name = '', this.price = '', this.stock = ''});
}

class EditMenu extends StatefulWidget {
  final Product product;
  final String categoryId;

  const EditMenu({super.key, required this.product, required this.categoryId});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final _categoryController = CategoryController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  List<Category> _categories = [];
  Category? selectedCategory;
  File? _mainImage;
  List<MenuVariant> _variants = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price;
    _descriptionController.text = widget.product.description ?? '';
    print(widget.product.description);

    _categories = await _categoryController.loadCategories();
    selectedCategory = _categories.firstWhere(
      (c) => c.id == widget.categoryId,
      orElse: () => _categories.first,
    );

    _variants = widget.product.variants?.map((v) {
      File? imageFile;
      if (v.imagePath.isNotEmpty) {
        final file = File(v.imagePath);
        if (file.existsSync()) {
          imageFile = file;
        }
      }
      return MenuVariant(
        name: v.namaVarian,
        price: v.hargaTambahan,
        stock: v.stock,
        image: imageFile,
      );
    }).toList() ?? [MenuVariant()];
  
    setState(() {});
  }

  Future<void> _pickImage({
    required Function(File file) onSelected,
    required String errorLabel,
  }) async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      final file = File(image.path);
      final mimeType = lookupMimeType(image.path);
      if (file.lengthSync() > 2 * 1024 * 1024) {
        _showMessage('$errorLabel maksimal 2MB');
      } else if (mimeType != 'image/png') {
        _showMessage('$errorLabel harus PNG');
      } else {
        onSelected(file);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField(
    String hint, {
    IconData? icon,
    TextEditingController? controller,
    Function(String)? onChanged,
    String? initialValue,
  }) {
    return Padding(
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildImageBox(File? image, VoidCallback onTap, {double size = 100, String? caption}) {
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
              image: image != null ? DecorationImage(image: FileImage(image), fit: BoxFit.cover) : null,
            ),
            child: image == null ? const Center(child: Icon(Icons.add_a_photo)) : null,
          ),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(caption, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
        ],
      ),
    );
  }

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
            if (!isFirst)
              _buildImageBox(v.image, () => _pickImage(
                onSelected: (file) => setState(() => v.image = file),
                errorLabel: 'Varian ke-${index + 1}',
              )),
            if (!isFirst) const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  _buildTextField("Nama Varian", icon: Iconsax.edit, initialValue: v.name, onChanged: (val) => v.name = val),
                  if (!isFirst)
                    _buildTextField("Harga Tambahan", icon: Iconsax.money_2, initialValue: v.price, onChanged: (val) => v.price = val),
                  _buildTextField("Stock", icon: Iconsax.archive, initialValue: v.stock, onChanged: (val) => v.stock = val),
                ],
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _variants.removeAt(index)),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProduct() {
    if (_variants.isEmpty || selectedCategory == null ||
        _nameController.text.isEmpty || _priceController.text.isEmpty || _descriptionController.text.isEmpty) {
      _showMessage('Lengkapi semua data');
      return;
    }

    final List<Map<String, dynamic>> variantList = [];
    for (int i = 0; i < _variants.length; i++) {
      final v = _variants[i];
      if (v.name.isEmpty || v.price.isEmpty || v.stock.isEmpty) {
        _showMessage('Lengkapi data varian ke-${i + 1}');
        return;
      }

      variantList.add({
        "nama_varian": v.name,
        "harga_varian": int.tryParse(v.price) ?? 0,
        "stock_varian": int.tryParse(v.stock) ?? 0,
        "is_primary": i == 0 ? 1 : 0,
        "image_varian": v.image?.path,
      });
    }

    final data = {
      "productId": widget.product.id,
      "namaProduct": _nameController.text,
      "hargaProduct": _priceController.text,
      "descriptionProduct": _descriptionController.text,
      "kategoriId": selectedCategory!.id,
      "varianProductList": variantList,
      "mainImage": _mainImage?.path,
    };

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Preview Data Produk"),
        content: SingleChildScrollView(
          child: Text(data.toString()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")),
        ],
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
        title: const Text("Edit Menu", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                  () => _pickImage(
                    onSelected: (f) => setState(() => _mainImage = f),
                    errorLabel: 'Gambar utama',
                  ),
                  size: 180,
                  caption: "Ukuran ideal 1080 x 1080 px (PNG only)",
                ),
              ),
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
              TextButton.icon(
                onPressed: () => setState(() => _variants.add(MenuVariant())),
                icon: const Icon(Icons.add),
                label: const Text("Tambah Varian"),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B1D0D),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: const Text("Simpan Perubahan", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}
