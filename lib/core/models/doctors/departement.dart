class Departement {
  final String name;
  final String description;
  Departement({
    required this.name,
    required this.description,
  });

  Departement copyWith({
    String? name,
    String? description,
  }) {
    return Departement(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'description': description});

    return result;
  }

  factory Departement.fromMap(Map<String, dynamic> map) {
    return Departement(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  //String toJson() => json.encode(toMap());

  //factory Departement.fromJson(String source) => Departement.fromMap(json.decode(source));
  factory Departement.fromJson(Map<String, dynamic> map) {
    return Departement(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }
  @override
  String toString() => 'Departement( name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Departement &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode;
}
