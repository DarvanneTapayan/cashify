import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/report_provider.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Reports'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ReportProvider>(
          builder: (context, reportProvider, child) {
            return Column(
              children: [
                DropdownButton<String>(
                  value: reportProvider.selectedReport,
                  items: const [
                    DropdownMenuItem(
                      value: 'Daily',
                      child: Text('Daily Sales'),
                    ),
                    DropdownMenuItem(
                      value: 'Weekly',
                      child: Text('Weekly Sales'),
                    ),
                    DropdownMenuItem(
                      value: 'Monthly',
                      child: Text('Monthly Sales'),
                    ),
                    DropdownMenuItem(
                      value: 'Top Selling',
                      child: Text('Top Selling Products'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      reportProvider.setReportType(value);
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child:
                  reportProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : reportProvider.errorMessage != null
                      ? Center(child: Text(reportProvider.errorMessage!))
                      : ListView.builder(
                    // Replaced DataTable with ListView
                    itemCount:
                    reportProvider.selectedReport == 'Top Selling'
                        ? reportProvider.topSellingProducts.length
                        : reportProvider.transactions.length,
                    itemBuilder: (context, index) {
                      if (reportProvider.selectedReport ==
                          'Top Selling') {
                        final product =
                        reportProvider.topSellingProducts[index];
                        return Card(
                          child: ListTile(
                            title: Text(product['name']),
                            subtitle: Text(
                              'Qty Sold: ${product['quantity']} | Total: \$${product['total_sales'].toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      } else {
                        final transaction =
                        reportProvider.transactions[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              'Transaction #${transaction.id}',
                            ),
                            subtitle: Text(
                              'Total: \$${transaction.total.toStringAsFixed(2)} | ${transaction.timestamp}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Total Sales: \$${reportProvider.totalSales.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
