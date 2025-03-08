import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/report_provider.dart';

class ReportDisplayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    if (reportProvider.selectedReport == 'Top Selling') {
      return ListView.builder(
        itemCount: reportProvider.topSellingProducts.length,
        itemBuilder: (context, index) {
          final product = reportProvider.topSellingProducts[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text('Sold: ${product['quantity']}'),
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: reportProvider.transactions.length,
        itemBuilder: (context, index) {
          final transaction = reportProvider.transactions[index];
          return ListTile(
            title: Text('Transaction #${transaction.id}'),
            subtitle: Text('Total: ${transaction.total} | ${transaction.timestamp}'),
          );
        },
      );
    }
  }
}