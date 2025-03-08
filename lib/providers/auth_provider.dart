import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String username, String password) async {
    final dbService = DatabaseService();
    final result = await dbService.login(username, password);
    if (result.isNotEmpty) {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}