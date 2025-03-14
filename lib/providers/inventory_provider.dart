import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../models/product_model.dart'; // Updated import
import 'transaction_provider.dart';

class InventoryProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Product> _products = [];
  bool _isLoading = false; // Added for loading state
  String? _errorMessage; // Added for error feedback

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  InventoryProvider() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _dbService.getProducts();
      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
      _isLoading = false;
      _products = []; // Reset on error
    }
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  Future<bool> addProduct(
      String name,
      double price,
      int stock, [
        BuildContext? context,
      ]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_products.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
        _errorMessage = 'Product with name "$name" already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _dbService.insertProduct(name, price, stock);
      await _loadProducts();

      if (context != null) {
        final transactionProvider = Provider.of<TransactionProvider>(
          context,
          listen: false,
        );
        await transactionProvider.refreshProducts();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      int id,
      String name,
      double price,
      int stock, [
        BuildContext? context,
      ]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dbService.updateProduct(id, name, price, stock);
      await _loadProducts();

      if (context != null) {
        final transactionProvider = Provider.of<TransactionProvider>(
          context,
          listen: false,
        );
        await transactionProvider.refreshProducts();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id, [BuildContext? context]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _dbService.deleteProduct(id);
      await _loadProducts();

      if (context != null) {
        final transactionProvider = Provider.of<TransactionProvider>(
          context,
          listen: false,
        );
        await transactionProvider.refreshProducts();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
