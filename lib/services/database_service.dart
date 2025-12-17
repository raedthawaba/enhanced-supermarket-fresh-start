import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:supermarket_app/utils/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI loader for web and desktop platforms
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS || kIsWeb) {
      // Initialize FFI loader
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> init() async {
    await database;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        profile_image TEXT,
        role TEXT NOT NULL DEFAULT 'customer',
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        last_login_at TEXT
      )
    ''');

    // Create products table
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        old_price REAL,
        image_url TEXT NOT NULL,
        images TEXT,
        unit TEXT NOT NULL DEFAULT 'قطعة',
        stock_quantity REAL NOT NULL DEFAULT 0,
        min_stock_level REAL NOT NULL DEFAULT 5,
        is_available INTEGER NOT NULL DEFAULT 1,
        is_organic INTEGER NOT NULL DEFAULT 0,
        is_discounted INTEGER NOT NULL DEFAULT 0,
        discount_percentage REAL,
        barcode TEXT,
        brand TEXT,
        weight REAL NOT NULL DEFAULT 0,
        weight_unit TEXT NOT NULL DEFAULT 'جرام',
        tags TEXT,
        rating REAL NOT NULL DEFAULT 0,
        review_count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        expiry_date TEXT,
        is_featured INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create orders table
    await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        status TEXT NOT NULL,
        subtotal REAL NOT NULL,
        discount_amount REAL NOT NULL DEFAULT 0,
        delivery_fee REAL NOT NULL DEFAULT 0,
        tax REAL NOT NULL,
        total_amount REAL NOT NULL,
        applied_coupon TEXT,
        delivery_address TEXT NOT NULL,
        delivery_instructions TEXT,
        payment_method TEXT NOT NULL,
        payment_status TEXT NOT NULL,
        payment_id TEXT,
        delivery_person_id TEXT,
        order_date TEXT NOT NULL,
        estimated_delivery_date TEXT,
        delivered_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        notes TEXT
      )
    ''');

    // Create order_items table
    await db.execute('''
      CREATE TABLE order_items(
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products(id)
      )
    ''');

    // Create cart table
    await db.execute('''
      CREATE TABLE cart(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        added_at TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
      )
    ''');

    // Create favorites table
    await db.execute('''
      CREATE TABLE favorites(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        added_at TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id),
        UNIQUE(user_id, product_id)
      )
    ''');

    // Create notifications table
    await db.execute('''
      CREATE TABLE notifications(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        timestamp TEXT NOT NULL,
        data TEXT
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_products_category ON products(category)');
    await db.execute('CREATE INDEX idx_products_price ON products(price)');
    await db.execute('CREATE INDEX idx_products_featured ON products(is_featured)');
    await db.execute('CREATE INDEX idx_orders_user_id ON orders(user_id)');
    await db.execute('CREATE INDEX idx_orders_status ON orders(status)');
    await db.execute('CREATE INDEX idx_orders_date ON orders(created_at)');
    await db.execute('CREATE INDEX idx_cart_user_id ON cart(user_id)');
    await db.execute('CREATE INDEX idx_favorites_user_id ON favorites(user_id)');
    await db.execute('CREATE INDEX idx_notifications_user_id ON notifications(user_id)');
    await db.execute('CREATE INDEX idx_notifications_read ON notifications(is_read)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    // For now, just recreate tables
    if (oldVersion < newVersion) {
      // Drop all tables
      await db.execute('DROP TABLE IF EXISTS notifications');
      await db.execute('DROP TABLE IF EXISTS favorites');
      await db.execute('DROP TABLE IF EXISTS cart');
      await db.execute('DROP TABLE IF EXISTS order_items');
      await db.execute('DROP TABLE IF EXISTS orders');
      await db.execute('DROP TABLE IF EXISTS products');
      await db.execute('DROP TABLE IF EXISTS users');
      
      // Recreate tables
      await _onCreate(db, newVersion);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
    await db.delete('products');
    await db.delete('orders');
    await db.delete('order_items');
    await db.delete('cart');
    await db.delete('favorites');
    await db.delete('notifications');
  }

  Future<int> getDatabaseSize() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    final file = await File(path).exists();
    
    if (file) {
      final fileStat = await File(path).stat();
      return fileStat.size;
    }
    
    return 0;
  }
}