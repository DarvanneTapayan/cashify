class Product {
  final int id;
  final String name;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  // Factory to create Product from a map (e.g., from database)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int? ?? 0, // Default to 0 if null
      name: map['name'] as String? ?? 'Unknown', // Default to 'Unknown' if null
      price: (map['price'] as num?)?.toDouble() ?? 0.0, // Convert to double, default to 0.0
      stock: map['stock'] as int? ?? 0, // Default to 0 if null
    );
  }

  // Convert Product to a map (e.g., for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, stock: $stock)';
  }

  // Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.stock == stock;
  }

  // Override hashCode for equality
  @override
  int get hashCode => Object.hash(id, name, price, stock);
}