import 'package:flutter/material.dart';
import 'package:coffee_app/models/cart_item.dart';
import 'package:coffee_app/models/product_model.dart';
import 'package:coffee_app/services/product_service.dart';

class CartModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  /// ALL PRODUCTS FROM API
  List<Product> _allProducts = [];

  /// CART
  final List<CartItem> _cartItems = [];

  bool isLoading = false;
  String? errorMessage;

  CartModel() {
    loadProducts(); 
  }

  List<CartItem> get cartItems => _cartItems;

  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.category == 'featured').toList();

  List<Product> get newArrivals =>
      _allProducts.where((p) => p.category == 'new').toList();

  Future<void> loadProducts() async {
     print('LOAD PRODUCTS CALLED');
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _productService.fetchProducts();
      for (var p in _allProducts) {
        print(p.productName);
      }
    } catch (e) {
      errorMessage = 'Failed to load products';
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  bool addToCart(CartItem item) {
    final exists = _cartItems.any(
      (element) =>
          element.product.id == item.product.id &&
          element.cupSize == item.cupSize &&
          element.sugarCount == item.sugarCount,
    );

    if (!exists) {
      _cartItems.add(item);
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  double getTotalPrice() {
    return _cartItems.fold(0.0, (total, item) => total + item.product.price);
  }
}
