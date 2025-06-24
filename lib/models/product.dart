class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String status;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['nama_product'] ?? '',
      imageUrl: json['image_path'],
      price: json['harga_product'] ?? '0',
      status: json['status_product'] ?? 'aktif',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_product': name,
      'image_path': imageUrl,
      'harga_product': price,
      'status_product': status,
    };
  }
}
