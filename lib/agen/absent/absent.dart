class Absent {
  final String id;
  final String createdAt;
  Absent({
    required this.id,
    required this.createdAt,
  });

  factory Absent.fromMap(Map<String, dynamic> map) {
    return Absent(
      id: map['absen_id'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  @override
  String toString() => 'Absent(id: $id, createdAt: $createdAt)';
}
