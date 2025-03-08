import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/login_screen.dart'; // Ensure this path matches your project structure
import 'providers/auth_provider.dart'; // Authentication state management
import 'providers/transaction_provider.dart'; // Transaction state management
import 'providers/inventory_provider.dart'; // Inventory state management
import 'providers/report_provider.dart'; // Sales report state management

void main() {
  // Initialize the database factory for desktop platforms (Windows, Linux, macOS)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    databaseFactory = databaseFactoryFfi; // Enables SQLite FFI for desktop
  }

  // Start the Flutter app with provider setup
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Manages login/logout state
        ChangeNotifierProvider(create: (_) => TransactionProvider()), // Manages transaction data
        ChangeNotifierProvider(create: (_) => InventoryProvider()), // Manages inventory data
        ChangeNotifierProvider(create: (_) => ReportProvider()), // Manages sales report data
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ukay-Ukay Cashiering App', // App title
      theme: ThemeData(
        primarySwatch: Colors.blue, // Default theme with blue primary color
        useMaterial3: false, // Ensures compatibility with older Flutter versions if needed
      ),
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}