import './Variant.dart'; 

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String status;
  final String? description;
  final List<Variant>? variants;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.status,
    this.description,
    this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['nama_product'] ?? '',
      imageUrl: json['image_path'] ?? '',
      price: json['harga_product'] ?? '0',
      status: json['status_product'] ?? 'aktif',
      description: json['description'], // Bisa null
      variants: json['variants'] != null
          ? (json['variants'] as List)
              .map((v) => Variant.fromJson(v))
              .toList()
          : null,
    );
  }
}
