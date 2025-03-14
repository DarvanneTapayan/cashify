import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Keep for desktop support
import 'screens/login_screen.dart'; // Ensure this path matches your project structure
import 'providers/auth_provider.dart'; // Authentication state management
import 'providers/transaction_provider.dart'; // Transaction state management
import 'providers/inventory_provider.dart'; // Inventory state management
import 'providers/report_provider.dart'; // Sales report state management

void main() {
  // Initialize the database factory only for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    databaseFactory = databaseFactoryFfi; // Enables SQLite FFI for desktop
  }
  // On Android, sqflite works natively, so no additional setup is needed

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
      title: 'Ukay-Ukay Cashier', // Shortened for mobile
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Enable Material 3 for modern Android design
        scaffoldBackgroundColor: Colors.grey[100], // Light background for mobile
        appBarTheme: const AppBarTheme(
          elevation: 2, // Slight shadow for depth
          centerTitle: true, // Center app bar titles
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}