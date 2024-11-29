import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:food_order_app/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Box<CartItem> cartBox = Hive.box<CartItem>('cart');

  List<CartItem> get items => cartBox.values.toList();

  void addItem(CartItem item) {
    cartBox.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    item.delete();
    notifyListeners();
  }

  void clearCart() {
    cartBox.clear();
    notifyListeners();
  }
}
