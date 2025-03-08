import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class PaymentProcessingWidget extends StatefulWidget {
  final VoidCallback onComplete;
  const PaymentProcessingWidget({required this.onComplete, super.key});

  @override
  _PaymentProcessingWidgetState createState() => _PaymentProcessingWidgetState();
}

class _PaymentProcessingWidgetState extends State<PaymentProcessingWidget> {
  String _paymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: _paymentMethod,
            items: [
              if (transactionProvider.cashEnabled) const DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              if (transactionProvider.cardEnabled) const DropdownMenuItem(value: 'Card', child: Text('Card')),
            ],
            onChanged: (value) => setState(() => _paymentMethod = value!),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: transactionProvider.cart.isEmpty
                ? null
                : () {
                    transactionProvider.setPaymentMethod(_paymentMethod);
                    widget.onComplete();
                  },
            child: const Text('Complete Transaction', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}