import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class PaymentProcessingWidget extends StatefulWidget {
  final VoidCallback onComplete;

  const PaymentProcessingWidget({super.key, required this.onComplete});

  @override
  _PaymentProcessingWidgetState createState() =>
      _PaymentProcessingWidgetState();
}

class _PaymentProcessingWidgetState extends State<PaymentProcessingWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final availableMethods = <String>[];
        if (transactionProvider.cashEnabled) availableMethods.add('Cash');
        if (transactionProvider.cardEnabled) availableMethods.add('Card');

        String? initialValue =
        availableMethods.isNotEmpty
            ? (availableMethods.contains(transactionProvider.paymentMethod)
            ? transactionProvider.paymentMethod
            : availableMethods.first)
            : null;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (availableMethods.isEmpty)
                const Text(
                  'No payment methods enabled',
                  style: TextStyle(color: Colors.red),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton<String>(
                    value: initialValue,
                    items:
                    availableMethods.map((method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        transactionProvider.setPaymentMethod(value);
                      }
                    },
                    underline: const SizedBox.shrink(),
                    isExpanded: true,
                  ),
                ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
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
                  ),
                  onPressed:
                  availableMethods.isEmpty || transactionProvider.isLoading
                      ? null
                      : widget.onComplete,
                  child:
                  transactionProvider.isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Complete Transaction',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
