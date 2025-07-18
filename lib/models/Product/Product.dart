import './Variant.dart';
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final int stock;
  final String status;
  final String? description;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.status,
    required this.stock,
    this.description,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['nama_product'] ?? '',
      imageUrl: json['image_path'] ?? '',
      price: json['harga_product']?.toString() ?? '0',
      stock: json['stock'] ?? 0,
      status: json['status_product'] ?? 'aktif',
      description: json['description'],
      variants: (json['variants'] as List?)?.map((v) => Variant.fromJson(v)).toList() ?? [],
    );
  }
}
