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
                    DropdownMenuItem(value: 'Daily', child: Text('Daily Sales')),
                    DropdownMenuItem(value: 'Weekly', child: Text('Weekly Sales')),
                    DropdownMenuItem(value: 'Monthly', child: Text('Monthly Sales')),
                    DropdownMenuItem(value: 'Top Selling', child: Text('Top Selling Products')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      reportProvider.setReportType(value);
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: reportProvider.selectedReport == 'Top Selling'
                          ? DataTable(
                              columns: const [
                                DataColumn(label: Text('Product')),
                                DataColumn(label: Text('Quantity Sold')),
                                DataColumn(label: Text('Total Sales')), // New column
                              ],
                              rows: reportProvider.topSellingProducts
                                  .map((p) => DataRow(cells: [
                                        DataCell(Text(p['name'])),
                                        DataCell(Text(p['quantity'].toString())),
                                        DataCell(Text('\$${p['total_sales'].toStringAsFixed(2)}')), // Display per product
                                      ]))
                                  .toList(),
                            )
                          : DataTable(
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Timestamp')),
                                DataColumn(label: Text('Total')),
                                DataColumn(label: Text('Payment')),
                              ],
                              rows: reportProvider.transactions
                                  .map((t) => DataRow(cells: [
                                        DataCell(Text(t.id.toString())),
                                        DataCell(Text(t.timestamp)),
                                        DataCell(Text(t.total.toStringAsFixed(2))),
                                        DataCell(Text(t.paymentMethod)),
                                      ]))
                                  .toList(),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Total Sales: \$${reportProvider.totalSales.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}