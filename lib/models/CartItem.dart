class CartItem {
  final String productId;
  final String variantId;
  final String title;
  final String price;
  final String imagePath;
  final int quantity;
  final int stock;

  CartItem({
    required this.productId,
    required this.variantId,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.quantity,
    required this.stock,
  });

  double get priceAsDouble {
    String priceStr = price.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(priceStr) ?? 0.0;
  }

  double get totalPrice => priceAsDouble * quantity;

  CartItem copyWith({
    String? productId,
    String? variantId,
    String? title,
    String? price,
    String? imagePath,
    int? quantity,
    int? stock,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      title: title ?? this.title,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
      stock: stock ?? this.stock,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.productId == productId &&
        other.variantId == variantId;
  }

  @override
  int get hashCode => Object.hash(productId, variantId);
}
