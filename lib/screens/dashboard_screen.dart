import 'package:flutter/material.dart';
import 'transaction_screen.dart';
import 'inventory_management_screen.dart';
import 'sales_report_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ukay-Ukay Dashboard'),
        backgroundColor: Colors.blue, // Consistent theme color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // Outer padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch buttons to uniform width
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
              const SizedBox(height: 16.0), // Spacing between buttons
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
        backgroundColor: Colors.blue, // Button color
        foregroundColor: Colors.white, // Text/icon color
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Internal padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        elevation: 4.0, // Slight shadow for depth
      ),
    );
  }
}