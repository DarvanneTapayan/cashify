import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            return Column(
              children: [
                SwitchListTile(
                  title: const Text('Accept Cash Payments'),
                  value: transactionProvider.cashEnabled,
                  onChanged: (value) {
                    transactionProvider.updateLocalSettings(value, transactionProvider.cardEnabled);
                  },
                ),
                SwitchListTile(
                  title: const Text('Accept Card Payments'),
                  value: transactionProvider.cardEnabled,
                  onChanged: (value) {
                    transactionProvider.updateLocalSettings(transactionProvider.cashEnabled, value);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    final dbService = DatabaseService();
                    await dbService.updateSettings(
                      transactionProvider.cashEnabled,
                      transactionProvider.cardEnabled,
                    );
                    await transactionProvider.refreshSettings();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Settings saved - Cash: ${transactionProvider.cashEnabled}, Card: ${transactionProvider.cardEnabled}',
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}