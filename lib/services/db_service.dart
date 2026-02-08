import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:coffee_app/models/product_model.dart';

class DbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'coffee_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id TEXT PRIMARY KEY, productName TEXT, imagePath TEXT, localImagePath TEXT, price REAL, rating INTEGER, ratingAvg REAL, category TEXT, description TEXT)',
        );
      },

    );
  }

  Future<void> saveProducts(List<Product> products) async {
    final db = await database;
    final batch = db.batch();
    
    // Clear old data to avoid duplicates/stale data
    batch.delete('products');
    
    for (var product in products) {
      batch.insert('products', product.toMap());
    }
    
    await batch.commit(noResult: true);
  }

  Future<List<Product>> getCachedProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }
}
