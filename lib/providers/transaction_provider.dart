import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/product_model.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Product> _products = [];
  List<Map<String, dynamic>> _cart = [];
  double _total = 0.0;
  String _paymentMethod = 'Cash';
  bool _cashEnabled = true;
  bool _cardEnabled = false;

  List<Product> get products => _products;
  List<Map<String, dynamic>> get cart => _cart;
  double get total => _total;
  bool get cashEnabled => _cashEnabled;
  bool get cardEnabled => _cardEnabled;
  String get paymentMethod => _paymentMethod;

  TransactionProvider() {
    _loadProducts();
    _loadSettings();
  }

  Future<void> _loadProducts() async {
    _products = await _dbService.getProducts();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    final settings = await _dbService.getSettings();
    _cashEnabled = settings['cash_enabled'] == 1;
    _cardEnabled = settings['card_enabled'] == 1;
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  Future<void> refreshSettings() async {
    await _loadSettings();
  }

  bool addToCart(Product product, int quantity) {
    final existingItemIndex = _cart.indexWhere((item) => item['product'].id == product.id);
    final currentQuantity = existingItemIndex >= 0 ? _cart[existingItemIndex]['quantity'] : 0;
    final totalRequestedQuantity = currentQuantity + quantity;

    if (totalRequestedQuantity > product.stock) {
      return false; // Stock exceeded
    }

    if (existingItemIndex >= 0) {
      _cart[existingItemIndex]['quantity'] = totalRequestedQuantity;
    } else {
      _cart.add({'product': product, 'quantity': quantity});
    }
    _total += product.price * quantity;
    notifyListeners();
    return true; // Success
  }

  void removeFromCart(int index) {
    final item = _cart[index];
    _total -= item['product'].price * item['quantity'];
    _cart.removeAt(index);
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future<Map<String, dynamic>> completeTransaction() async {
    if (_cart.isEmpty) return {'transactionId': -1, 'total': 0.0, 'cart': [], 'paymentMethod': _paymentMethod};

    final transactionId = await _dbService.insertTransaction(_total, _paymentMethod);
    for (var item in _cart) {
      await _dbService.insertTransactionItem(
        transactionId,
        item['product'].id,
        item['quantity'],
        item['product'].price,
      );
      await _dbService.updateProductStock(
        item['product'].id,
        item['product'].stock - item['quantity'],
      );
    }

    final transactionDetails = {
      'transactionId': transactionId,
      'total': _total,
      'cart': List<Map<String, dynamic>>.from(_cart),
      'paymentMethod': _paymentMethod,
    };

    _cart.clear();
    _total = 0.0;
    await _loadProducts();

    return transactionDetails;
  }
}