import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: screenWidth * 0.5, // Border box takes 50% of screen width
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Consumer<TransactionProvider>(
              builder: (context, transactionProvider, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min, // Minimize column height
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SwitchListTile(
                      title: const Text('Accept Cash Payments'),
                      value: transactionProvider.cashEnabled,
                      onChanged: (value) {
                        transactionProvider.updateLocalSettings(
                          value,
                          transactionProvider.cardEnabled,
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      title: const Text('Accept Card Payments'),
                      value: transactionProvider.cardEnabled,
                      onChanged: (value) {
                        transactionProvider.updateLocalSettings(
                          transactionProvider.cashEnabled,
                          value,
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: screenWidth * 0.3, // Button width is 30% of screen
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
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
                            await transactionProvider.refreshSettings();
                            if (context.mounted) {
                              Navigator.pop(context); // Pop first
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Successfully saved'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error during settings save: $e');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error saving settings: $e'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
