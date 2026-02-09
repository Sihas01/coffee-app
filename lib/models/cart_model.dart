import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:coffee_app/models/cart_item.dart';
import 'package:coffee_app/models/product_model.dart';
import 'package:coffee_app/services/product_service.dart';
import 'package:coffee_app/services/db_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class CartModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final DbService _dbService = DbService();

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
      // Check connectivity first
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.contains(ConnectivityResult.none);

      if (!isOffline) {
        // Online: Fetch from API and cache to DB
        _allProducts = await _productService.fetchProducts();
        await _dbService.saveProducts(_allProducts);
        print('Products fetched from API and cached.');
        
        // Start downloading images in background
        _downloadImages();
      } else {
        // Offline: Fetch from local DB
        _allProducts = await _dbService.getCachedProducts();
        print('Offline: Products loaded from local DB.');
      }
    } catch (e) {
      // Fallback: If API fails, try local DB before giving up
      print('API Fetch failed, trying local cache: $e');
      try {
        _allProducts = await _dbService.getCachedProducts();
      } catch (dbError) {
        errorMessage = 'Failed to load products';
        debugPrint(dbError.toString());
      }
    }

    if (_allProducts.isEmpty && errorMessage == null) {
      errorMessage = 'No products found';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _downloadImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'product_images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    bool updatedAny = false;
    for (int i = 0; i < _allProducts.length; i++) {
      final product = _allProducts[i];
      
      // Skip if already has local path or it's not a remote image
      if (product.localImagePath != null || !product.imagePath.startsWith('http')) {
        continue;
      }

      try {
        final fileName = '${product.id}${p.extension(product.imagePath)}';
        if (fileName.isEmpty || fileName.contains('?')) {
          // Handle cases where extension might be messy
          final simpleName = '${product.id}.png';
          final localPath = p.join(imagesDir.path, simpleName);
          final response = await http.get(Uri.parse(product.imagePath));
          await File(localPath).writeAsBytes(response.bodyBytes);
          _allProducts[i] = product.copyWith(localImagePath: localPath);
          updatedAny = true;
        } else {
          final localPath = p.join(imagesDir.path, fileName);
          final response = await http.get(Uri.parse(product.imagePath));
          await File(localPath).writeAsBytes(response.bodyBytes);
          _allProducts[i] = product.copyWith(localImagePath: localPath);
          updatedAny = true;
        }
      } catch (e) {
        print('Error downloading image for ${product.productName}: $e');
      }
    }

    if (updatedAny) {
      await _dbService.saveProducts(_allProducts);
      notifyListeners();
    }
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
