import 'package:flutter/material.dart';
import 'transaction_screen.dart';
import 'inventory_management_screen.dart';
import 'sales_report_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart'; // Add this import for logout

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ukay-Ukay Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMenuButton(
                context,
                title: 'New Transaction',
                icon: Icons.add_shopping_cart,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionScreen()),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildMenuButton(
                context,
                title: 'Inventory Management',
                icon: Icons.inventory,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InventoryManagementScreen()),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildMenuButton(
                context,
                title: 'Sales Reports',
                icon: Icons.bar_chart,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalesReportScreen()),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildMenuButton(
                context,
                title: 'Settings',
                icon: Icons.settings,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildMenuButton(
                context,
                title: 'Log Out',
                icon: Icons.logout,
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false, // Clear navigation stack
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24.0),
      label: Text(
        title,
        style: const TextStyle(fontSize: 18.0),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4.0,
      ),
    );
  }
}