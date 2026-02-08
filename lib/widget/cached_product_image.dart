import 'dart:io';
import 'package:flutter/material.dart';
import 'package:coffee_app/models/product_model.dart';

class CachedProductImage extends StatelessWidget {
  final Product product;
  final BoxFit fit;
  final double? width;
  final double? height;

  const CachedProductImage({
    super.key,
    required this.product,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Try local file if available
    if (product.localImagePath != null) {
      final file = File(product.localImagePath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: fit,
          width: width,
          height: height,
        );
      }
    }

    // 2. Fallback to network or asset
    if (product.imagePath.startsWith('http')) {
      return Image.network(
        product.imagePath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 40);
        },
      );
    } else {
      return Image.asset(
        product.imagePath,
        fit: fit,
        width: width,
        height: height,
      );
    }
  }
}
