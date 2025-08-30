class Jurnal {
  String id;
  String createdAt;
  String retailId;
  String retailIdName;
  String photo;
  String latlong;
  String isNew;
  String totalPrice;
  List<JurnalDetail> detail;

  Jurnal({
    required this.id,
    required this.createdAt,
    required this.retailId,
    required this.retailIdName,
    required this.photo,
    required this.latlong,
    required this.isNew,
    required this.totalPrice,
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
      isNew: map['is_new'] ?? '',
      totalPrice: map['total_price'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Jurnal(id: $id, createdAt: $createdAt, retailId: $retailId, retailIdName: $retailIdName, photo: $photo, latlong: $latlong, isNew: $isNew, totalPrice: $totalPrice, detail: $detail)';
  }
}

class JurnalDetail {
  String id;
  String productId;
  String retailId;
  String productName;
  String retailIdName;
  String picture;
  int count;
  int price;
  int subtotal;
  JurnalDetail({
    required this.id,
    required this.productId,
    required this.retailId,
    required this.productName,
    required this.retailIdName,
    required this.count,
    required this.price,
    required this.subtotal,
    this.picture = '',
  });

  factory JurnalDetail.fromMap(Map<String, dynamic> map) {
    return JurnalDetail(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      retailId: map['retail_id'] ?? '',
      productName: map['product_name'] ?? '',
      retailIdName: map['retail_id_name'] ?? '',
      count: int.parse(map['count'] ?? '0'),
      price: int.parse(map['price'] ?? '0'),
      subtotal: int.parse(map['subtotal'] ?? '0'),
      picture: map['picture'] ?? '',
    );
  }

  @override
  String toString() {
    return 'JurnalDetail(id: $id, productId: $productId, retailId: $retailId, productName: $productName, retailIdName: $retailIdName, count: $count, price: $price)';
  }
}

extension StringFormatter on String {
  int toInt() {
    return int.parse(this);
  }
}
