import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptWidget extends StatelessWidget {
  final Map<String, dynamic> transactionDetails;

  const ReceiptWidget({required this.transactionDetails, super.key});

  Future<void> _generatePdf(BuildContext context) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Ukay-Ukay Receipt', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('Transaction ID: ${transactionDetails['transactionId']}'),
            pw.Text('Date: ${DateTime.now().toIso8601String()}'),
            pw.Text('Payment Method: ${transactionDetails['paymentMethod']}'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Product', 'Qty', 'Price'],
              data: (transactionDetails['cart'] as List<Map<String, dynamic>>)
                  .map((item) => [
                        item['product'].name,
                        item['quantity'].toString(),
                        item['product'].price.toString(),
                      ])
                  .toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Total: ${transactionDetails['total'].toStringAsFixed(2)}'),
          ],
        ),
      ),
    );

    await Printing.sharePdf(bytes: await doc.save(), filename: 'receipt_${transactionDetails['transactionId']}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Receipt'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: ${transactionDetails['transactionId']}'),
            Text('Date: ${DateTime.now().toIso8601String()}'),
            Text('Payment Method: ${transactionDetails['paymentMethod']}'),
            const SizedBox(height: 10),
            ...(transactionDetails['cart'] as List<Map<String, dynamic>>)
                .map((item) => Text('${item['product'].name} x${item['quantity']} - ${item['product'].price}')),
            const SizedBox(height: 10),
            Text('Total: ${transactionDetails['total'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _generatePdf(context),
          child: const Text('Save/Print'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}