import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class ProductSelectionWidget extends StatefulWidget {
  const ProductSelectionWidget({super.key}); // Added const constructor

  @override
  _ProductSelectionWidgetState createState() => _ProductSelectionWidgetState();
}

class _ProductSelectionWidgetState extends State<ProductSelectionWidget> {
  String _searchQuery = '';
  final Map<int, TextEditingController> _quantityControllers = {};

  @override
  void dispose() {
    _quantityControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        final filteredProducts = transactionProvider.products
            .where((product) => product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search Products',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            // Product List
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  _quantityControllers.putIfAbsent(
                    product.hashCode,
                        () => TextEditingController(),
                  );
                  final quantityController = _quantityControllers[product.hashCode]!;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Product Info
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Price: ₱${product.price.toStringAsFixed(2)} | Stock: ${product.stock}',
                                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          // Quantity Input and Add Button
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Qty',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  color: Colors.blue,
                                  iconSize: 28,
                                  onPressed: () => _addToCart(transactionProvider, product, quantityController, context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(
      TransactionProvider provider,
      dynamic product,
      TextEditingController controller,
      BuildContext context,
      ) {
    final quantity = int.tryParse(controller.text) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity')),
      );
    } else {
      final success = provider.addToCart(product, quantity);
      if (success) {
        controller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot add $quantity ${product.name}(s). Only ${product.stock} in stock.'),
          ),
        );
      }
    }
  }
}