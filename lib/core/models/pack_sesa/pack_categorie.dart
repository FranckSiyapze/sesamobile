import 'dart:convert';

class PackCategorie {
  final String nom;
  final int id;
  PackCategorie({
    required this.nom,
    required this.id,
  });

  PackCategorie copyWith({
    String? nom,
    int? id,
  }) {
    return PackCategorie(
      nom: nom ?? this.nom,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'nom': nom});
    result.addAll({'id': id});

    return result;
  }

  factory PackCategorie.fromMap(Map<String, dynamic> map) {
    return PackCategorie(
      nom: map['nom'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PackCategorie.fromJson(Map<String, dynamic> map) {
    return PackCategorie(
      nom: map['nom'] ?? '',
      id: map['id']?.toInt() ?? 0,
    );
  }
  @override
  String toString() => 'PackCategorie(nom: $nom, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PackCategorie && other.nom == nom && other.id == id;
  }

  @override
  int get hashCode => nom.hashCode ^ id.hashCode;
}
