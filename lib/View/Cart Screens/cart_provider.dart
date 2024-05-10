import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:non_attending/View/Cart%20Screens/cart_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart with ChangeNotifier {
  List<Product> _products = [];
  int _totalPrice = 0;

  List<Product> get products => _products;
  int get totalPrice => _totalPrice; // Getter method for total price

  // Method to load products from SharedPreferences
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = prefs.getStringList('products');
    if (productList != null) {
      _products = productList.map((item) {
        final map = json.decode(item);
        return Product.fromMap(map);
      }).toList();
      _updateTotalPrice(); // Update total price when loading products
    }
  }

  // Method to remove a product from the cart
  Future<void> clearProduct(Product product) async {
    _products.remove(product);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final productList = _products.map((product) {
      return json.encode(product.toMap());
    }).toList();

    prefs.setStringList('products', productList);
    _updateTotalPrice(); // Update total price after removing product
  }

  // Method to add a product to the cart
  Future<void> addProduct(Product product) async {
    _products.add(product);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final productList = _products.map((product) {
      return json.encode(product.toMap());
    }).toList();

    prefs.setStringList('products', productList);
    _updateTotalPrice(); // Update total price after adding product
  }

  // Method to clear all products from the cart
  Future<void> clearAllProducts() async {
    _products.clear();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('products');
    _updateTotalPrice(); // Update total price after clearing all products
  }

  // Method to calculate the total price of all products in the cart
  void _updateTotalPrice() {
    _totalPrice = 0;
    for (var product in _products) {
      _totalPrice += int.parse(product.price);
    }
    notifyListeners();
  }
}
