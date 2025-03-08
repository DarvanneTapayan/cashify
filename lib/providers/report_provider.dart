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
    _loadReport();
  }

  Future<void> _loadReport() async {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedReport) {
      case 'Daily':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Weekly':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Monthly':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Top Selling':
        _topSellingProducts = await _dbService.getTopSellingProducts();
        notifyListeners();
        return;
      default:
        startDate = now;
    }

    _transactions = await _dbService.getTransactionsByPeriod(startDate, now);
    notifyListeners();
  }
}