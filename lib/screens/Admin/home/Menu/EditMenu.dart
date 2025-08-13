import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../../../services/Api/ImageHelper.dart';
import '../../../../controllers/Product/CategoryController.dart';
import '../../../../controllers/Product/ProductController.dart';
import '../../../../models/Category.dart';
import '../../../../models/Product/Product.dart';
import './widgets/ImageBoxWidget.dart';
import './widgets/FormTextField.dart';

class MenuVariant {
  String idVarian = '';
  File? image;
  Uint8List? networkImageBytes;
  String name = '', price = '', stock = '';
  MenuVariant({this.image});
}

class EditMenu extends StatefulWidget {
  final String productId;
  final String categoryId;
  const EditMenu({Key? key, required this.categoryId, required this.productId}) : super(key: key);
  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  Product? _product;
  Uint8List? _networkMainImageBytes;
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
  bool _isProductLoading = true;

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

  Future<void> _loadCategories() async {
    final categories = await _categoryController.loadCategories();
    setState(() => _categories = categories);
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isProductLoading = true;
      _mainImage = null;
      _networkMainImageBytes = null;
    });

    final product = await _productController.fetchProductDetail(
      int.parse(widget.categoryId),
      widget.productId,
    );

    if (product != null) {
      _product = product;
      _nameController.text = product.name;
      _priceController.text = product.price;
      _descriptionController.text = product.description ?? '';
      selectedCategory = _categories.firstWhere(
        (c) => c.id.toString() == product.categories,
        orElse: () => _categories.first,
      );

      _variants = [];
      for (final v in product.variants) {
        final variant = MenuVariant()
          ..idVarian = v.idVarian.toString()
          ..name = v.namaVarian ?? ''
          ..price = v.hargaTambahan.toString()
          ..stock = v.stock.toString();

        if (!v.isPrimary && v.imagePath.isNotEmpty) {
          final bytes = await ImageHelper.loadImage(v.imagePath);
          variant.networkImageBytes = bytes;
        }

        _variants.add(variant);
      }

      final primaryVariant = product.variants.firstWhere(
        (v) => v.isPrimary,
        orElse: () => product.variants.first,
      );

      if (primaryVariant.imagePath.isNotEmpty) {
        final bytes = await ImageHelper.loadImage(primaryVariant.imagePath);
        _networkMainImageBytes = bytes;
      }
    }

    setState(() => _isProductLoading = false);
  }

  Future<void> _pickImage({required Function(File file) onSelected, required String errorLabel}) async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image != null) {
      final file = File(image.path);
      final mimeType = lookupMimeType(image.path);
      final isPng = mimeType == 'image/png';

      if (file.lengthSync() > 2 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ukuran file ${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB\n$errorLabel maksimal 2MB')),
        );
      } else if (!isPng) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorLabel harus berupa file PNG')),
        );
      } else {
        onSelected(file);
      }
    }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris atas: Gambar dan input
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isFirst)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ImageBoxWidget(
                    image: v.image,
                    onTap: () => _pickImage(
                      onSelected: (file) => setState(() => v.image = file),
                      errorLabel: 'Varian ke-${index + 1}',
                    ),
                    networkImageBytes: v.networkImageBytes,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FormTextField(
                            hint: "Nama Varian",
                            icon: Iconsax.edit,
                            initialValue: v.name,
                            onChanged: (val) => v.name = val,
                          ),
                        ),
                        if (!isFirst)
                          IconButton(
                            onPressed: () => setState(() => _variants.removeAt(index)),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                      ],
                    ),
                    if (!isFirst)
                      FormTextField(
                        hint: "Harga Penambahan",
                        icon: Iconsax.money_2,
                        initialValue: v.price,
                        onChanged: (val) => v.price = val,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Stock + tombol tambah sejajar
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.archive, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Stock: ${v.stock}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showAddStockDialog(index),
                icon: const Icon(Icons.add_circle, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}





  void _showAddStockDialog(int index) {
    final v = _variants[index];
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Tambah Stok - Varian ke-${index + 1}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Jumlah tambahan stok',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final input = int.tryParse(controller.text);
              if (input != null && input > 0) {
                _productController.toggleAddStock(
                  productId: widget.productId,
                  varianId: v.idVarian, 
                  qty: input,
                ).then((_) {
                  setState(() {
                    final currentStock = int.tryParse(v.stock) ?? 0;
                    v.stock = (currentStock + input).toString();
                  });
                  Navigator.of(ctx).pop();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Masukkan jumlah yang valid')),
                );
              }
            },
            child: const Text('Tambah'),
          )
        ],
      ),
    );
  }


 void _submitProduct() async {
  if (_variants.isEmpty || selectedCategory == null ||
      _nameController.text.isEmpty || _priceController.text.isEmpty ||
      _descriptionController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi semua data')));
    return;
  }

  // Validasi format gambar utama jika diganti
  if (_mainImage != null && !_mainImage!.path.toLowerCase().endsWith('.png')) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gambar utama harus PNG')));
    return;
  }

  List<Map<String, dynamic>> variantList = [];
  for (int i = 0; i < _variants.length; i++) {
    final v = _variants[i];
    if (v.name.isEmpty || v.price.isEmpty || v.stock.isEmpty || (i > 0 && v.image == null && v.networkImageBytes == null)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lengkapi data varian ke-${i + 1}')));
      return;
    }
    variantList.add({
      'vairan_id' : v.idVarian,
      "nama_varian": v.name,
      "harga_varian": int.parse(v.price),
      "stock_varian": int.parse(v.stock),
      "is_primary": i == 0,
      "image_varian": v.image ?? null, // hanya kirim file jika ada gambar baru
    });
  }

  final success = await _productController.updateProduct(
    productId: widget.productId,
    namaProduct: _nameController.text,
    hargaProduct: _priceController.text,
    descriptionProduct: _descriptionController.text,
    kategoriId: selectedCategory!.id.toString(),
    varianProductList: variantList,
  );

  if (success) {
    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_productController.errorMessage ?? 'Gagal update produk')));
  }
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
    body: _isProductLoading ? const Center(child: CircularProgressIndicator()) : SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildSectionTitle("Foto Menu Utama"),
          Center(
            child: ImageBoxWidget(
              image: _mainImage,
              onTap: () => _pickImage(onSelected: (f) => setState(() => _mainImage = f), errorLabel: 'Gambar utama'),
              networkImageBytes: _networkMainImageBytes,
              size: 180,
              caption: "Ukuran ideal 1080 x 1080 px (PNG only)",
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("Informasi Menu"),
          FormTextField(hint: "Nama Menu", icon: Iconsax.coffee, controller: _nameController),
          FormTextField(hint: "Harga Menu", icon: Iconsax.money, controller: _priceController),
          FormTextField(hint: "Deskripsi Menu", icon: Iconsax.document, controller: _descriptionController),
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
              child: const Text("Update Product", style: TextStyle(fontSize: 16, color: Colors.white)),
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
