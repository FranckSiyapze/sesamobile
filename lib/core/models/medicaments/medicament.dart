import 'dart:convert';

class Medicament {
  final int id;
  final String decription;
  final String imageUrl;
  final double amount;
  final int quantite;
  final String createdAt;
  Medicament({
    required this.id,
    required this.decription,
    required this.imageUrl,
    required this.amount,
    required this.quantite,
    required this.createdAt,
  });

  Medicament copyWith({
    int? id,
    String? decription,
    String? imageUrl,
    double? amount,
    int? quantite,
    String? createdAt,
  }) {
    return Medicament(
      id: id ?? this.id,
      decription: decription ?? this.decription,
      imageUrl: imageUrl ?? this.imageUrl,
      amount: amount ?? this.amount,
      quantite: quantite ?? this.quantite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'decription': decription});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'amount': amount});
    result.addAll({'quantite': quantite});
    result.addAll({'createdAt': createdAt});

    return result;
  }

  factory Medicament.fromMap(Map<String, dynamic> map) {
    return Medicament(
      id: map['id']?.toInt() ?? 0,
      decription: map['decription'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      quantite: map['quantite']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  //factory Medicament.fromJson(String source) => Medicament.fromMap(json.decode(source));
  factory Medicament.fromJson(Map<String, dynamic> map) {
    return Medicament(
      id: map['id']?.toInt() ?? 0,
      decription: map['decription'] ?? '',
      amount: map['amount'] ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      quantite: map['quantite']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Medicament(id: $id, decription: $decription, imageUrl: $imageUrl, amount: $amount, quantite: $quantite, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Medicament &&
        other.id == id &&
        other.decription == decription &&
        other.imageUrl == imageUrl &&
        other.amount == amount &&
        other.quantite == quantite &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        decription.hashCode ^
        imageUrl.hashCode ^
        amount.hashCode ^
        quantite.hashCode ^
        createdAt.hashCode;
  }
}
