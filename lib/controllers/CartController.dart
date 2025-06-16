import 'dart:async';
import '../models/CartItem.dart';
import '../global.dart';

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
    final index = _items.indexWhere((i) => i.title == item.title);
    if (index != -1) {
      _items[index] = CartItem(
        title: _items[index].title,
        price: _items[index].price,
        imagePath: _items[index].imagePath,
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(CartItem(
        title: item.title,
        price: item.price,
        imagePath: item.imagePath,
        quantity: item.quantity,
      ));
    }
    _notify();
  }

  void removeFromCart(CartItem item) {
    final index = _items.indexWhere((i) => i.title == item.title);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        // Decrease quantity by 1
        _items[index] = CartItem(
          title: _items[index].title,
          price: _items[index].price,
          imagePath: _items[index].imagePath,
          quantity: _items[index].quantity - 1,
        );
      } else {
        // Remove item completely
        _items.removeAt(index);
      }
      _notify();
    }
  }

  void removeItemCompletely(String title) {
    _items.removeWhere((item) => item.title == title);
    _notify();
  }

  void updateItemQuantity(String title, int newQuantity) {
    final index = _items.indexWhere((i) => i.title == title);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = CartItem(
          title: _items[index].title,
          price: _items[index].price,
          imagePath: _items[index].imagePath,
          quantity: newQuantity,
        );
      }
      _notify();
    }
  }

  void clearCart() {
    _items.clear();
    _notify();
  }

  void dispose() {
    _cartStreamController.close();
  }
}