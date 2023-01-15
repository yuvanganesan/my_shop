import 'package:flutter/material.dart';

class Cart {
  final String id;
  final String title;
  final double price;
  int quantity;

  Cart({this.id, this.price, this.quantity, this.title});
}

class CartItem with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get getItem {
    return {..._items};
  }

  double get totalAmount {
    var total = 0.0;
    _items
        .forEach((_, cartItem) => total += cartItem.quantity * cartItem.price);
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingProduct) => Cart(
              id: existingProduct.id,
              price: existingProduct.price,
              title: existingProduct.title,
              quantity: existingProduct.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => Cart(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              quantity: 1));
    }
    notifyListeners();
  }

  int itemCount() {
    return _items.length;
    //notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId].quantity > 1) {
      _items[productId].quantity--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
