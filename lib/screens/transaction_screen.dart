import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortOption = 'name_asc';

  @override
  void dispose() {
    _cashController.dispose();
    _searchController.dispose();
    ScaffoldMessenger.of(context).clearSnackBars();
    Provider.of<TransactionProvider>(context, listen: false).clearError();
    super.dispose();
  }

  List<Product> _sortProducts(List<Product> products) {
    switch (_sortOption) {
      case 'name_asc':
        return products..sort((a, b) => a.name.compareTo(b.name));
      case 'name_desc':
        return products..sort((a, b) => b.name.compareTo(a.name));
      case 'price_asc':
        return products..sort((a, b) => a.price.compareTo(b.price));
      case 'price_desc':
        return products..sort((a, b) => b.price.compareTo(a.price));
      case 'stock_asc':
        return products..sort((a, b) => a.stock.compareTo(b.stock));
      case 'stock_desc':
        return products..sort((a, b) => b.stock.compareTo(a.stock));
      default:
        return products;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Transaction', style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).primaryColor,
      ),
<<<<<<< HEAD
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
                      labelText: 'Cash Tendered',
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
                        'Change: ₱${change.toStringAsFixed(2)}',
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
=======
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());

          final searchedProducts =
          provider.products.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
          final sortedProducts = _sortProducts(searchedProducts);

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Theme.of(context).colorScheme.surface, // Lighter Base Dark
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search Products',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
>>>>>>> 59c35cba1cb26cb44edb6c73c2b035160d37d568
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                          onChanged: (value) => setState(() => _searchQuery = value),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _showSortOptions(context),
                              icon: const Icon(Icons.sort),
                              label: Text('Sort', style: Theme.of(context).textTheme.labelLarge),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          height: 300,
                          child: sortedProducts.isEmpty
                              ? Center(child: Text('No products match your search', style: Theme.of(context).textTheme.bodyMedium))
                              : ProductSelectionWidget(filteredProducts: sortedProducts),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Theme.of(context).colorScheme.surface, // Lighter Base Dark
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 200,
                      child: provider.cart.isEmpty
                          ? Center(child: Text('Cart is empty', style: Theme.of(context).textTheme.bodyMedium))
                          : CartReviewWidget(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Theme.of(context).colorScheme.surface, // Lighter Base Dark
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _cashController,
                          decoration: InputDecoration(
                            labelText: 'Cash Tendered',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) => setState(() {}),
                        ),
                        const SizedBox(height: 12.0),
                        Consumer<TransactionProvider>(
                          builder: (context, provider, child) {
                            double total = provider.total;
                            double cash = double.tryParse(_cashController.text) ?? 0.0;
                            double change = cash - total;
                            return Text(
                              'Change: ₱${change >= 0 ? change.toStringAsFixed(2) : 'Insufficient'}',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: change >= 0 ? const Color(0xFF2F5711) : const Color(0xFFA8200D),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: PaymentProcessingWidget(
                            onComplete: () async {
                              final transactionDetails = await provider.completeTransaction(context);
                              if (context.mounted && transactionDetails['transactionId'] != -1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Transaction Completed')),
                                );
                                showDialog(
                                  context: context,
                                  builder: (_) => ReceiptWidget(transactionDetails: transactionDetails),
                                ).then((_) => Navigator.pop(context));
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      provider.errorMessage ?? 'Transaction failed',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface, // Lighter Base Dark
        title: Text('Sort Products', style: Theme.of(context).textTheme.headlineMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Name (A-Z)', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                setState(() => _sortOption = 'name_asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Name (Z-A)', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                setState(() => _sortOption = 'name_desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Price (Low to High)', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                setState(() => _sortOption = 'price_asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Price (High to Low)', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                setState(() => _sortOption = 'price_desc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Stock (Low to High)', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                setState(() => _sortOption = 'stock_asc');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Stock (High to Low)', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {
                setState(() => _sortOption = 'stock_desc');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}