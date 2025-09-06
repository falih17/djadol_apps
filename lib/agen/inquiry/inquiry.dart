class Inquiry {
  String id;
  String description;
  String agenId;
  String status;
  String createdAt;

  Inquiry({
    required this.id,
    required this.description,
    required this.agenId,
    required this.status,
    required this.createdAt,
  });

  factory Inquiry.fromMap(Map<String, dynamic> map) {
    return Inquiry(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      agenId: map['agen_id'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Inquiry(id: $id, description: $description, agenId: $agenId, status: $status, createdAt: $createdAt)';
  }
}

class InquiryDetail {
  String id;
  String productId;
  String productName;
  int count;
  InquiryDetail({
    required this.id,
    required this.productId,
    required this.productName,
    required this.count,
  });

  factory InquiryDetail.fromMap(Map<String, dynamic> map) {
    return InquiryDetail(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      productName: map['product_name'] ?? '',
      count: int.tryParse(map['count']) ?? 0,
    );
  }

  @override
  String toString() {
    return 'InquiryDetail(id: $id, productId: $productId, productName: $productName, count: $count)';
  }
}
