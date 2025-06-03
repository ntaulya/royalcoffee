class CartItem {
  final String title;
  final String price;
  final String imagePath;
  final int quantity;

  CartItem({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.quantity,
  });


  // Method untuk mendapatkan harga sebagai double
  double get priceAsDouble {
    String priceStr = price.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(priceStr) ?? 0.0;
  }

  // Method untuk mendapatkan total harga berdasarkan quantity
  double get totalPrice => priceAsDouble * quantity;

  // Method untuk copy dengan quantity yang berbeda
  CartItem copyWith({
    String? title,
    String? price,
    String? imagePath,
    int? quantity,
  }) {
    return CartItem(
      title: title ?? this.title,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.title == title;
  }

  @override
  int get hashCode => title.hashCode;
}
