import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class ProductSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return ListView.builder(
      itemCount: transactionProvider.products.length,
      itemBuilder: (context, index) {
        final product = transactionProvider.products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('Price: ${product.price} | Stock: ${product.stock}'),
          trailing: ElevatedButton(
            onPressed: product.stock > 0
                ? () => transactionProvider.addToCart(product)
                : null,
            child: const Text('Add'),
          ),
        );
      },
    );
  }
}