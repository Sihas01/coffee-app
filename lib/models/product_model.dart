class Product {
  final String id;
  final String productName;
  final String imagePath;
  final double price;
  final int rating;
  final double ratingAvg;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.productName,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.ratingAvg,
    required this.category,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '', 
      productName: json['productName'] ?? 'Unknown',
      imagePath: json['imagePath'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: json['rating'] ?? 0,
      ratingAvg: (json['ratingAvg'] ?? 0).toDouble(),
      category: json['category'] ?? 'unknown',
      description: json['description'] ?? '',
    );
  }
}
