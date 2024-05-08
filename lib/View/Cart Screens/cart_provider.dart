import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:non_attending/View/Cart%20Screens/cart_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = prefs.getStringList('products');
    if (productList != null) {
      _products = productList.map((item) {
        final map = json.decode(item);
        return Product.fromMap(map);
      }).toList();
    }
  }

  Future<void> clearProduct(Product product) async {
    _products.remove(product);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final productList = _products.map((product) {
      return json.encode(product.toMap());
    }).toList();

    prefs.setStringList('products', productList);
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final productList = _products.map((product) {
      return json.encode(product.toMap());
    }).toList();

    prefs.setStringList('products', productList);
  }

  Future<void> clearAllProducts() async {
    _products.clear();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('products');
  }

 
}
