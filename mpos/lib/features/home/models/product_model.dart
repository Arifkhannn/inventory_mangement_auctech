class Product {
  final String barCode;
  final String name;
  final double price;
  int quantity;
   String? tax;
   String? category;
  bool? synced;

  Product({
    required this.barCode,
    required this.name,
    required this.price,
    required this.quantity,
     this.tax,
     this.category,
    this.synced,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barCode: json['barCode'] ?? '',
      name: json['name'] ?? '',
      price: _parsePrice(json['price']),
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      tax: json['tax'] ?? '',
      category: json['category'] ?? '',
      synced: json['synced'] ?? false,
    );
  }

  static double _parsePrice(String? rawPrice) {
    if (rawPrice == null) return 0.0;
    return double.tryParse(rawPrice.replaceAll(',', '.')) ?? 0.0;
  }

  double get total => price * quantity;

  Product copyWith({
    String? barCode,
    String? name,
    double? price,
    int? quantity,
    String? tax,
    String? category,
    bool? synced,
  }) {
    return Product(
      barCode: barCode ?? this.barCode,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      tax: tax ?? this.tax,
      category: category ?? this.category,
      synced: synced ?? this.synced,
    );
  }
}
