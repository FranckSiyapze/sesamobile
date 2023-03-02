import 'dart:convert';

class Prestation {
  final int id;
  final String nom;
  Prestation({
    required this.id,
    required this.nom,
  });

  Prestation copyWith({
    int? id,
    String? nom,
  }) {
    return Prestation(
      id: id ?? this.id,
      nom: nom ?? this.nom,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'nom': nom});

    return result;
  }

  factory Prestation.fromMap(Map<String, dynamic> map) {
    return Prestation(
      id: map['id']?.toInt() ?? 0,
      nom: map['nom'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory Prestation.fromJson(Map<String, dynamic> map) {
    return Prestation(
      id: map['id']?.toInt() ?? 0,
      nom: map['nom'] ?? '',
    );
  }
  @override
  String toString() => 'Prestation(id: $id, nom: $nom)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prestation && other.id == id && other.nom == nom;
  }

  @override
  int get hashCode => id.hashCode ^ nom.hashCode;
}
