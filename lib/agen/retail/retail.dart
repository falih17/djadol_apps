// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Retail {
  String id;
  String name;
  String address;
  String picture;

  Retail({
    required this.id,
    required this.name,
    required this.address,
    required this.picture,
  });

  factory Retail.fromMap(Map<String, dynamic> map) {
    return Retail(
      id: (map['id'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      address: (map['address'] ?? '') as String,
      picture: (map['picture'] ?? '') as String,
    );
  }

  Retail copyWith({
    String? id,
    String? name,
    String? address,
    String? picture,
  }) {
    return Retail(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'picture': picture,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Retail(id: $id, name: $name, address: $address, picture: $picture)';
  }

  @override
  bool operator ==(covariant Retail other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.address == address &&
        other.picture == picture;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ address.hashCode ^ picture.hashCode;
  }
}
