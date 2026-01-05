import 'package:flutter/material.dart';
import '../data/models/cart_item.dart';
import '../data/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; 

  List<CartItem> get items => _items.values.toList();

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get total =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  bool contains(Product product) => _items.containsKey(product.id);

  void add(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void increment(Product product) {
    if (!_items.containsKey(product.id)) return;
    _items[product.id]!.quantity++;
    notifyListeners();
  }

  void decrement(Product product) {
    if (!_items.containsKey(product.id)) return;

    final item = _items[product.id]!;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
