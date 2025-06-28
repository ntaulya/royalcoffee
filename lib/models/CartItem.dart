class CartItem {
  final String productId;
  final String variantId;
  final String title;
  final String price;
  final String imagePath;
  final int quantity;

  CartItem({
    required this.productId,
    required this.variantId,
    required this.title,
    required this.price,
    required this.imagePath,
    required this.quantity,
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
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      title: title ?? this.title,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
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
