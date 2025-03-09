import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/product_selection_widget.dart';
import '../widgets/cart_review_widget.dart';
import '../widgets/payment_processing_widget.dart';
import '../widgets/receipt_widget.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _cashController = TextEditingController();

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(child: ProductSelectionWidget()),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: CartReviewWidget()),
                  const SizedBox(height: 16.0),
                  // Cash on Hand Input
                  TextField(
                    controller: _cashController,
                    decoration: const InputDecoration(
                      labelText: 'Cash on Hand',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) {
                      setState(
                        () {},
                      ); // Trigger rebuild to update change display
                    },
                  ),
                  const SizedBox(height: 8.0),
                  // Change Display
                  Consumer<TransactionProvider>(
                    builder: (context, provider, child) {
                      double total = provider.total;
                      double cash =
                          double.tryParse(_cashController.text) ?? 0.0;
                      double change = cash - total;
                      return Text(
                        'Change: \₱${change.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16.0),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  PaymentProcessingWidget(
                    onComplete: () async {
                      final transactionDetails = await transactionProvider
                          .completeTransaction(context);
                      if (context.mounted &&
                          transactionDetails['transactionId'] != -1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transaction Completed'),
                          ),
                        );
                        showDialog(
                          context: context,
                          builder:
                              (_) => ReceiptWidget(
                                transactionDetails: transactionDetails,
                              ),
                        ).then((_) => Navigator.pop(context));
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
