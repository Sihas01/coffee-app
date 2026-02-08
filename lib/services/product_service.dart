import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  final String baseUrl = 'https://vambraced-unappreciably-bebe.ngrok-free.dev';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
