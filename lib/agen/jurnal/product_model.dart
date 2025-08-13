class Product {
  final String id;
  final String name;
  final int pricePurchase;
  final int priceSale;
  final int priceAgen;
  final int priceSale2;
  final int priceSale3;
  final int priceMinSale2;
  final int priceMinSale3;

  Product({
    required this.id,
    required this.name,
    required this.pricePurchase,
    required this.priceSale,
    required this.priceAgen,
    required this.priceSale2,
    required this.priceSale3,
    required this.priceMinSale2,
    required this.priceMinSale3,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      pricePurchase: int.tryParse(map['price_purchase']) ?? 0,
      priceSale: int.tryParse(map['price_sale']) ?? 0,
      priceAgen: int.tryParse(map['price_agen'] ?? '0') ?? 0,
      priceSale2: int.tryParse(map['price_sale2'] ?? '0') ?? 0,
      priceSale3: int.tryParse(map['price_sale3'] ?? '0') ?? 0,
      priceMinSale2: int.tryParse(map['price_sale_min2'] ?? '0') ?? 0,
      priceMinSale3: int.tryParse(map['price_sale_min3'] ?? '0') ?? 0,
    );
  }

  @override
  String toString() {
    return 'Product(name: $name, pricePurchase: $pricePurchase, priceSale: $priceSale, priceAgen: $priceAgen)';
  }
}
