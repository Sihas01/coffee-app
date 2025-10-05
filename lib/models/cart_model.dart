import 'package:coffee_app/models/cart_item.dart';
import 'package:coffee_app/models/product_model.dart';
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Product> productsList = [
    Product(
      productName: 'Espresso',
      imagePath: 'asset/images/cappuccino.png',
      price: 690.99,
      rating: 520,
      ratingAvg: 4,
    ),
    Product(
      productName: 'Cappuccino',
      imagePath: 'asset/images/cappuccinoTwo.png',
      price: 1080.00,
      rating: 800,
      ratingAvg: 5,
    ),
    Product(
      productName: 'Ice Latte',
      imagePath: 'asset/images/cappuccino.png',
      price: 1080.00,
      rating: 500,
      ratingAvg: 3.5,
    ),
    Product(
      productName: 'Mocha',
      imagePath: 'asset/images/cappuccino.png',
      price: 700.99,
      rating: 220,
      ratingAvg: 2.3,
    ),
  ];

  get products => productsList;

  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(CartItem item){
    _cartItems.remove(item);
    notifyListeners();
  }
}
