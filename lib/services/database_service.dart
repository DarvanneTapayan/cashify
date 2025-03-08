import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product_model.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static sqflite.Database? _database;

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ukay_ukay.db');
    print('Database path: $path');
    return await sqflite.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Creating database tables...');
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            stock INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT,
            total REAL,
            payment_method TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE transaction_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            transaction_id INTEGER,
            product_id INTEGER,
            quantity INTEGER,
            price REAL,
            FOREIGN KEY (transaction_id) REFERENCES transactions(id),
            FOREIGN KEY (product_id) REFERENCES products(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cash_enabled INTEGER DEFAULT 1,
            card_enabled INTEGER DEFAULT 0
          )
        ''');
        await db.insert('users', {'username': 'admin', 'password': 'admin123'});
        await db.insert('products', {'name': 'Shirt', 'price': 50.0, 'stock': 10});
        await db.insert('products', {'name': 'Pants', 'price': 100.0, 'stock': 5});
        await db.insert('settings', {'cash_enabled': 1, 'card_enabled': 0});
        print('Database initialized with default data');
      },
    );
  }

  Future<List<Map<String, dynamic>>> login(String username, String password) async {
    final db = await database;
    return await db.query('users', where: 'username = ? AND password = ?', whereArgs: [username, password]);
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<void> insertProduct(String name, double price, int stock) async {
    final db = await database;
    await db.insert('products', {'name': name, 'price': price, 'stock': stock});
  }

  Future<void> updateProduct(int id, String name, double price, int stock) async {
    final db = await database;
    await db.update(
      'products',
      {'name': name, 'price': price, 'stock': stock},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateProductStock(int productId, int newStock) async {
    final db = await database;
    await db.update('products', {'stock': newStock}, where: 'id = ?', whereArgs: [productId]);
  }

  Future<int> insertTransaction(double total, String paymentMethod) async {
    final db = await database;
    return await db.insert('transactions', {
      'timestamp': DateTime.now().toIso8601String(),
      'total': total,
      'payment_method': paymentMethod,
    });
  }

  Future<void> insertTransactionItem(int transactionId, int productId, int quantity, double price) async {
    final db = await database;
    await db.insert('transaction_items', {
      'transaction_id': transactionId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    });
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions');
  }

  Future<List<Transaction>> getTransactionsByPeriod(DateTime start, DateTime end) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return maps.map((m) => Transaction.fromMap(m)).toList();
  }

  Future<List<Map<String, dynamic>>> getTopSellingProducts() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT p.name, SUM(ti.quantity) as quantity, SUM(ti.quantity * ti.price) as total_sales
      FROM transaction_items ti
      JOIN products p ON ti.product_id = p.id
      GROUP BY p.id, p.name
      ORDER BY quantity DESC
      LIMIT 5
    ''');
    print('Top Selling Products: $result');
    return result;
  }

  Future<Map<String, dynamic>> getSettings() async {
    final db = await database;
    try {
      final result = await db.query('settings', limit: 1);
      print('Fetched settings: $result');
      if (result.isEmpty) {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cash_enabled INTEGER DEFAULT 1,
            card_enabled INTEGER DEFAULT 0
          )
        ''');
        await db.insert('settings', {'cash_enabled': 1, 'card_enabled': 0});
        print('Created settings table and inserted default data');
        return {'cash_enabled': 1, 'card_enabled': 0};
      }
      return result.first;
    } catch (e) {
      print('Error fetching settings, creating table: $e');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS settings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cash_enabled INTEGER DEFAULT 1,
          card_enabled INTEGER DEFAULT 0
        )
      ''');
      await db.insert('settings', {'cash_enabled': 1, 'card_enabled': 0});
      print('Created settings table and inserted default data after error');
      return {'cash_enabled': 1, 'card_enabled': 0};
    }
  }

  Future<void> updateSettings(bool cashEnabled, bool cardEnabled) async {
    final db = await database;
    final existingSettings = await db.query('settings', limit: 1);
    final data = {'cash_enabled': cashEnabled ? 1 : 0, 'card_enabled': cardEnabled ? 1 : 0};
    if (existingSettings.isEmpty) {
      await db.insert('settings', data);
      print('Inserted settings: $data');
    } else {
      await db.update(
        'settings',
        data,
        where: 'id = ?',
        whereArgs: [existingSettings.first['id']],
      );
      print('Updated settings: $data');
    }
    final updatedSettings = await db.query('settings', limit: 1);
    print('Settings after update: $updatedSettings');
  }
}