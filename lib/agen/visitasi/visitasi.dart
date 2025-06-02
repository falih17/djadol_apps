class Jurnal {
  String id;
  String createdAt;
  String retailId;
  String retailIdName;
  String photo;
  String latlong;
  String isNew;
  String totalPrice;

  Jurnal({
    required this.id,
    required this.createdAt,
    required this.retailId,
    required this.retailIdName,
    required this.photo,
    required this.latlong,
    required this.isNew,
    required this.totalPrice,
  });

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
    return 'Jurnal(id: $id, createdAt: $createdAt, retailId: $retailId, retailIdName: $retailIdName, photo: $photo, latlong: $latlong, isNew: $isNew, totalPrice: $totalPrice)';
  }
}

extension StringFormatter on String {
  int toInt() {
    return int.parse(this);
  }
}
