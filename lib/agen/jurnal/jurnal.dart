class Jurnal {
  String id;
  String productId;
  String retailId;
  String productIdName;
  String retailIdName;
  String count;
  String price;
  Jurnal({
    required this.id,
    required this.productId,
    required this.retailId,
    required this.productIdName,
    required this.retailIdName,
    required this.count,
    required this.price,
  });

  factory Jurnal.fromMap(Map<String, dynamic> map) {
    return Jurnal(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      retailId: map['retail_id'] ?? '',
      productIdName: map['product_id_name'] ?? '',
      retailIdName: map['retail_id_name'] ?? '',
      count: map['count'] ?? '',
      price: map['price'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Jurnal(id: $id, productId: $productId, retailId: $retailId, productIdName: $productIdName, retailIdName: $retailIdName, count: $count, price: $price)';
  }
}
