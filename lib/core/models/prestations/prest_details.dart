import 'dart:convert';

class PrestDetails {
  final int id;
  final String nom;
  final int price;
  PrestDetails({
    required this.id,
    required this.nom,
    required this.price,
  });

  PrestDetails copyWith({
    int? id,
    String? nom,
    int? price,
  }) {
    return PrestDetails(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'nom': nom});
    result.addAll({'price': price});

    return result;
  }

  factory PrestDetails.fromMap(Map<String, dynamic> map) {
    return PrestDetails(
      id: map['id']?.toInt() ?? 0,
      nom: map['nom'] ?? '',
      price: map['price']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrestDetails.fromJson(Map<String, dynamic> map) {
    return PrestDetails(
      id: map['id']?.toInt() ?? 0,
      nom: map['nom'] ?? '',
      price: map['price']?.toInt() ?? 0,
    );
  }
  @override
  String toString() => 'PrestDetails(id: $id, nom: $nom, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrestDetails &&
        other.id == id &&
        other.nom == nom &&
        other.price == price;
  }

  @override
  int get hashCode => id.hashCode ^ nom.hashCode ^ price.hashCode;
}
