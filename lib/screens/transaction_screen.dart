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
  void initState() {
    super.initState();
    // Optionally initialize or fetch data here if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      if (provider.products.isEmpty) {
        print('TransactionProvider has no products'); // Debug log
      }
    });
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          // Check if the provider has data
          if (provider.products.isEmpty && provider.cartItems.isEmpty) {
            return const Center(
              child: Text(
                'No products or cart items available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Product Selection Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: provider.products.isEmpty
                      ? const Center(child: Text('No products to display'))
                      : const ProductSelectionWidget(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Cart Review Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: provider.cartItems.isEmpty
                      ? const Center(child: Text('Cart is empty'))
                      : const CartReviewWidget(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Payment Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cash on Hand Input
                      TextField(
                        controller: _cashController,
                        decoration: InputDecoration(
                          labelText: 'Cash on Hand',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 18),
                        onChanged: (value) => setState(() {}),
                      ),
                      const SizedBox(height: 12.0),

                      // Change Display
                      Consumer<TransactionProvider>(
                        builder: (context, provider, child) {
                          double total = provider.total;
                          double cash = double.tryParse(_cashController.text) ?? 0.0;
                          double change = cash - total;
                          return Text(
                            'Change: ₱${change >= 0 ? change.toStringAsFixed(2) : 'Insufficient'}',
                            style: TextStyle(
                              fontSize: 18,
                              color: change >= 0 ? Colors.green : Colors.red,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Payment Processing Button
                      SizedBox(
                        width: double.infinity,
                        child: PaymentProcessingWidget(
                          onComplete: () async {
                            final transactionDetails = await transactionProvider.completeTransaction(context);
                            if (context.mounted && transactionDetails['transactionId'] != -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Transaction Completed')),
                              );
                              showDialog(
                                context: context,
                                builder: (_) => ReceiptWidget(transactionDetails: transactionDetails),
                              ).then((_) => Navigator.pop(context));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}