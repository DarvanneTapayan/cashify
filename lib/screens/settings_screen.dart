import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Accept Cash Payments'),
                  value: transactionProvider.cashEnabled,
                  onChanged: (value) {
                    transactionProvider.updateLocalSettings(value, transactionProvider.cardEnabled);
                  },
                ),
                const SizedBox(height: 16.0),
                SwitchListTile(
                  title: const Text('Accept Card Payments'),
                  value: transactionProvider.cardEnabled,
                  onChanged: (value) {
                    transactionProvider.updateLocalSettings(transactionProvider.cashEnabled, value);
                  },
                ),
                const SizedBox(height: 16.0),
                Builder(
                  builder: (BuildContext buttonContext) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        elevation: 4.0,
                      ),
                      onPressed: () async {
                        print('Save button pressed');
                        final dbService = DatabaseService();
                        try {
                          await dbService.updateSettings(
                            transactionProvider.cashEnabled,
                            transactionProvider.cardEnabled,
                          );
                          print('Settings updated in database');
                          ScaffoldMessenger.of(buttonContext).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully saved'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          await Future.delayed(const Duration(seconds: 2));
                          await transactionProvider.refreshSettings(); // Moved after SnackBar
                          if (buttonContext.mounted) {
                            Navigator.pop(buttonContext);
                          }
                        } catch (e) {
                          print('Error during settings save: $e');
                          if (buttonContext.mounted) {
                            ScaffoldMessenger.of(buttonContext).showSnackBar(
                              SnackBar(content: Text('Error saving settings: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('Save', style: TextStyle(fontSize: 16.0)),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}