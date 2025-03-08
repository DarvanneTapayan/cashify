import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/product_selection_widget.dart';
import '../widgets/cart_review_widget.dart';
import '../widgets/payment_processing_widget.dart';
import '../widgets/receipt_widget.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('New Transaction')),
      body: Row(
        children: [
          Expanded(child: ProductSelectionWidget()),
          Expanded(
            child: Column(
              children: [
                Expanded(child: CartReviewWidget()),
                PaymentProcessingWidget(
                  onComplete: () async {
                    final transactionDetails = await transactionProvider.completeTransaction();
                    if (context.mounted && transactionDetails['transactionId'] != -1) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction Completed')));
                      showDialog(
                        context: context,
                        builder: (_) => ReceiptWidget(transactionDetails: transactionDetails),
                      ).then((_) => Navigator.pop(context));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}