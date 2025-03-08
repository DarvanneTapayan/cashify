import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';

class InventoryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Stock')),
        ],
        rows: inventoryProvider.products
            .map((p) => DataRow(cells: [
                  DataCell(Text(p.name)),
                  DataCell(Text(p.price.toStringAsFixed(2))),
                  DataCell(Text(p.stock.toString())),
                ]))
            .toList(),
      ),
    );
  }
}