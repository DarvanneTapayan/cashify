import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/product_model.dart';
import 'transaction_provider.dart';

class InventoryProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Product> _products = [];

  List<Product> get products => _products;

  InventoryProvider() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    _products = await _dbService.getProducts();
    notifyListeners();
  }

  Future<void> refreshProducts() async { // New public method
    await _loadProducts();
  }

  Future<bool> addProduct(String name, double price, int stock, BuildContext context) async {
    if (_products.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      return false;
    }

    await _dbService.insertProduct(name, price, stock);
    await _loadProducts();
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    await transactionProvider.refreshProducts();
    return true;
  }

  Future<void> updateProduct(int id, String name, double price, int stock, BuildContext context) async {
    await _dbService.updateProduct(id, name, price, stock);
    await _loadProducts();
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    await transactionProvider.refreshProducts();
  }

  Future<void> deleteProduct(int id, BuildContext context) async {
    await _dbService.deleteProduct(id);
    await _loadProducts();
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    await transactionProvider.refreshProducts();
  }
}