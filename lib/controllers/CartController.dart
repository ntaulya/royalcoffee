import 'dart:async';
import '../models/CartItem.dart';

class CartController {
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  final List<CartItem> _items = [];
  final StreamController<List<CartItem>> _cartStreamController = StreamController<List<CartItem>>.broadcast();

  Stream<List<CartItem>> get cartItemsStream => _cartStreamController.stream;
  List<CartItem> get items => List.unmodifiable(_items);
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void _notify() {
    _cartStreamController.sink.add(List.unmodifiable(_items));
  }

  void addToCart(CartItem item) {
    final index = _items.indexWhere((i) =>
        i.productId == item.productId && i.variantId == item.variantId);

    if (index != -1) {
      // Tambah quantity jika item sudah ada
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }

    _notify();
  }

  void updateItemQuantity(String productId, String variantId, int newQuantity) {
    final index = _items.indexWhere((i) =>
        i.productId == productId && i.variantId == variantId);

    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
      }
      _notify();
    }
  }

  void removeFromCart(CartItem item) {
    final index = _items.indexWhere((i) =>
        i.productId == item.productId && i.variantId == item.variantId);

    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      _notify();
    }
  }

  void removeItemCompletely(String productId, String variantId) {
    _items.removeWhere((item) =>
        item.productId == productId && item.variantId == variantId);
    _notify();
  }

  void clearCart() {
    _items.clear();
    _notify();
  }

  void dispose() {
    _cartStreamController.close();
  }
}
