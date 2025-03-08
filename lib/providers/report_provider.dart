import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/transaction_model.dart';

class ReportProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Transaction> _transactions = [];
  List<Map<String, dynamic>> _topSellingProducts = [];
  String _selectedReport = 'Daily';

  List<Transaction> get transactions => _transactions;
  List<Map<String, dynamic>> get topSellingProducts => _topSellingProducts;
  String get selectedReport => _selectedReport;
  double get totalSales => _transactions.fold(0.0, (sum, t) => sum + t.total);

  ReportProvider() {
    _loadReport();
  }

  void setReportType(String type) {
    _selectedReport = type;
    _loadReport(); // Ensure data reloads when type changes
  }

  Future<void> _loadReport() async {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedReport) {
      case 'Daily':
        startDate = DateTime(now.year, now.month, now.day);
        _transactions = await _dbService.getTransactionsByPeriod(startDate, now);
        _topSellingProducts = []; // Clear top selling for non-top-selling views
        break;
      case 'Weekly':
        startDate = now.subtract(Duration(days: now.weekday - 1)); // Start of week (Monday)
        _transactions = await _dbService.getTransactionsByPeriod(startDate, now);
        _topSellingProducts = [];
        break;
      case 'Monthly':
        startDate = DateTime(now.year, now.month, 1); // Start of month
        _transactions = await _dbService.getTransactionsByPeriod(startDate, now);
        _topSellingProducts = [];
        break;
      case 'Top Selling':
        _topSellingProducts = await _dbService.getTopSellingProducts();
        _transactions = []; // Clear transactions for top-selling view
        break;
      default:
        startDate = now;
        _transactions = await _dbService.getTransactionsByPeriod(startDate, now);
        _topSellingProducts = [];
    }

    notifyListeners(); // Ensure UI updates after data load
  }
}