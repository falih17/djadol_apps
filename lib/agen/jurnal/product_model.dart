class Product {
  final String id;
  final String name;
  final int pricePurchase;
  final int priceSale;
  final int priceAgen;

  Product({
    required this.id,
    required this.name,
    required this.pricePurchase,
    required this.priceSale,
    required this.priceAgen,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      pricePurchase: int.tryParse(map['price_purchase']) ?? 0,
      priceSale: int.tryParse(map['price_sale']) ?? 0,
      priceAgen: int.tryParse(map['price_agen']) ?? 0,
    );
  }

  @override
  String toString() {
    return 'Product(name: $name, pricePurchase: $pricePurchase, priceSale: $priceSale, priceAgen: $priceAgen)';
  }
}
