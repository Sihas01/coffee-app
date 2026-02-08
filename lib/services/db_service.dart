import 'dart:async';
import 'package:coffee_app/models/user_model.dart';
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
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE products(id TEXT PRIMARY KEY, productName TEXT, imagePath TEXT, localImagePath TEXT, price REAL, rating INTEGER, ratingAvg REAL, category TEXT, description TEXT)',
        );
        await db.execute(
          'CREATE TABLE user_profile(id TEXT PRIMARY KEY, username TEXT, email TEXT, profile_image TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE user_profile(id TEXT PRIMARY KEY, username TEXT, email TEXT, profile_image TEXT)',
          );
        }
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

  // User Profile Methods
  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await database;
    await db.insert(
      'user_profile',
      {
        'id': profile.id,
        'username': profile.username,
        'email': profile.email,
        'profile_image': profile.profileImage,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProfile?> getCachedUserProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_profile', limit: 1);
    
    if (maps.isNotEmpty) {
      return UserProfile.fromJson(maps.first);
    }
    return null;
  }

  Future<void> clearUserProfile() async {
    final db = await database;
    await db.delete('user_profile');
  }
}
