class Jurnal {
  String id;
  String createdAt;
  String retailId;
  String retailIdName;
  String photo;
  String latlong;
  List<JurnalDetail> detail;

  Jurnal({
    required this.id,
    required this.createdAt,
    required this.retailId,
    required this.retailIdName,
    required this.photo,
    required this.latlong,
    this.detail = const [],
  });

  get total {
    return detail.fold(0, (sum, item) => sum + (item.count * item.price));
  }

  factory Jurnal.fromMap(Map<String, dynamic> map) {
    return Jurnal(
      id: map['id'] ?? '',
      createdAt: map['created_at'] ?? '',
      retailId: map['retail_id'] ?? '',
      retailIdName: map['retail_id_name'] ?? '',
      photo: map['photo'] ?? '',
      latlong: map['latlong'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Jurnal(id: $id, createdAt: $createdAt, retailId: $retailId, retailIdName: $retailIdName, photo: $photo, latlong: $latlong)';
  }
}

class JurnalDetail {
  String id;
  String productId;
  String retailId;
  String productIdName;
  String retailIdName;
  int count;
  int price;
  JurnalDetail({
    required this.id,
    required this.productId,
    required this.retailId,
    required this.productIdName,
    required this.retailIdName,
    required this.count,
    required this.price,
  });

  factory JurnalDetail.fromMap(Map<String, dynamic> map) {
    return JurnalDetail(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      retailId: map['retail_id'] ?? '',
      productIdName: map['product_id_name'] ?? '',
      retailIdName: map['retail_id_name'] ?? '',
      count: int.parse(map['count'] ?? '0'),
      price: int.parse(map['price'] ?? '0'),
    );
  }

  @override
  String toString() {
    return 'JurnalDetail(id: $id, productId: $productId, retailId: $retailId, productIdName: $productIdName, retailIdName: $retailIdName, count: $count, price: $price)';
  }
}

extension StringFormatter on String {
  int toInt() {
    return int.parse(this);
  }
}
