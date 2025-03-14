import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/transaction_model.dart'; // Updated import

class ReportProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Transaction> _transactions = [];
  List<Map<String, dynamic>> _topSellingProducts = [];
  String _selectedReport = 'Daily';
  bool _isLoading = false; // Added for loading state
  String? _errorMessage; // Added for error feedback

  List<Transaction> get transactions => _transactions;
  List<Map<String, dynamic>> get topSellingProducts => _topSellingProducts;
  String get selectedReport => _selectedReport;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalSales {
    if (_selectedReport == 'Top Selling') {
      return _topSellingProducts.fold(
        0.0,
            (sum, p) => sum + (p['total_sales'] as double),
      );
    } else {
      return _transactions.fold(0.0, (sum, t) => sum + t.total);
    }
  }

  ReportProvider() {
    _loadReport();
  }

  void setReportType(String type) {
    _selectedReport = type;
    _loadReport();
  }

  Future<void> _loadReport() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      DateTime startDate;

      switch (_selectedReport) {
        case 'Daily':
          startDate = DateTime(now.year, now.month, now.day);
          _transactions = await _dbService.getTransactionsByPeriod(
            startDate,
            now,
          );
          _topSellingProducts = [];
          break;
        case 'Weekly':
          startDate = now.subtract(Duration(days: now.weekday - 1));
          _transactions = await _dbService.getTransactionsByPeriod(
            startDate,
            now,
          );
          _topSellingProducts = [];
          break;
        case 'Monthly':
          startDate = DateTime(now.year, now.month, 1);
          _transactions = await _dbService.getTransactionsByPeriod(
            startDate,
            now,
          );
          _topSellingProducts = [];
          break;
        case 'Top Selling':
          _topSellingProducts = await _dbService.getTopSellingProducts();
          _transactions = [];
          break;
        default:
          startDate = now;
          _transactions = await _dbService.getTransactionsByPeriod(
            startDate,
            now,
          );
          _topSellingProducts = [];
      }

      _isLoading = false;
    } catch (e) {
      _errorMessage = 'Failed to load report: $e';
      _isLoading = false;
      _transactions = [];
      _topSellingProducts = [];
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
