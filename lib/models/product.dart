class Product {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.category,
  });

  // Factory constructor untuk parsing dari JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'] ?? json['imageUrl'],
      category: json['category'] ?? 1,
    );
  }

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'category': category,
    };
  }

  // CopyWith method untuk updating
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? category,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category)';
  }
}