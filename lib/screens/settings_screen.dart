import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _cashEnabled;
  late bool _cardEnabled;

  @override
  void initState() {
    super.initState();
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    _cashEnabled = transactionProvider.cashEnabled;
    _cardEnabled = transactionProvider.cardEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Accept Cash Payments'),
              value: _cashEnabled,
              onChanged: (value) => setState(() => _cashEnabled = value),
            ),
            SwitchListTile(
              title: const Text('Accept Card Payments'),
              value: _cardEnabled,
              onChanged: (value) => setState(() => _cardEnabled = value),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                final dbService = DatabaseService();
                await dbService.updateSettings(_cashEnabled, _cardEnabled);
                await transactionProvider.refreshSettings(); // Use public method
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}