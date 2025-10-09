import 'package:coffee_app/models/product_model.dart';

class CartItem {
  final Product product;
  final String cupSize;
  final int sugarCount;

  CartItem({
    required this.product,
    required this.cupSize,
    required this.sugarCount,
  });
}
