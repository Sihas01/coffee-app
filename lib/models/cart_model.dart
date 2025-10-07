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
      imagePath: 'asset/images/icelatte.png',
      price: 1080.00,
      rating: 500,
      ratingAvg: 3.5,
    ),
    Product(
      productName: 'Mocha',
      imagePath: 'asset/images/mocha.png',
      price: 700.99,
      rating: 220,
      ratingAvg: 2.3,
    ),
  ];

  final List<Product> newArrivals = [
    Product(
      productName: 'Hot Chocolate',
      imagePath: 'asset/images/chocolate.png',
      price: 690.99,
      rating: 520,
      ratingAvg: 4,
    ),
    Product(
      productName: 'Affogato',
      imagePath: 'asset/images/Affogato.png',
      price: 1080.00,
      rating: 800,
      ratingAvg: 5,
    ),
    Product(
      productName: 'Macchiato',
      imagePath: 'asset/images/Macchiato.png',
      price: 1080.00,
      rating: 500,
      ratingAvg: 3.5,
    ),
    Product(
      productName: 'Iced Mocha',
      imagePath: 'asset/images/IcedMocha.png',
      price: 700.99,
      rating: 220,
      ratingAvg: 2.3,
    ),
  ];

  get products => productsList;

  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  bool addToCart(CartItem item) {
    final itemExists = cartItems.any(
      (element) =>
          element.product == item.product &&
          element.cupSize == item.cupSize &&
          element.sugarCount == item.sugarCount,
    );

    if (!itemExists) {
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
}
