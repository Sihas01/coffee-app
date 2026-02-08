class Product {
  final String id;
  final String productName;
  final String imagePath;
  final double price;
  final int rating;
  final double ratingAvg;
  final String category;
  final String description;

  final String? localImagePath;

  Product({
    required this.id,
    required this.productName,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.ratingAvg,
    required this.category,
    required this.description,
    this.localImagePath,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'imagePath': imagePath,
      'price': price,
      'rating': rating,
      'ratingAvg': ratingAvg,
      'category': category,
      'description': description,
      'localImagePath': localImagePath,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      productName: map['productName'] ?? 'Unknown',
      imagePath: map['imagePath'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      rating: map['rating'] ?? 0,
      ratingAvg: (map['ratingAvg'] ?? 0).toDouble(),
      category: map['category'] ?? 'unknown',
      description: map['description'] ?? '',
      localImagePath: map['localImagePath'],
    );
  }

  Product copyWith({String? localImagePath}) {
    return Product(
      id: id,
      productName: productName,
      imagePath: imagePath,
      price: price,
      rating: rating,
      ratingAvg: ratingAvg,
      category: category,
      description: description,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }
}


