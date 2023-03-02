import 'dart:convert';

class Speciality {
  final int id;
  final String name;
  final String description;
  Speciality({
    required this.id,
    required this.name,
    required this.description,
  });

  Speciality copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return Speciality(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'description': description});

    return result;
  }

  factory Speciality.fromMap(Map<String, dynamic> map) {
    return Speciality(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  //factory Speciality.fromJson(String source) => Speciality.fromMap(json.decode(source));
  factory Speciality.fromJson(Map<String, dynamic> map) {
    return Speciality(
      name: map['name'] ?? '',
      id: map['id'] ?? 0,
      description: map['description'] ?? '',
    );
  }
  @override
  String toString() =>
      'Speciality(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Speciality &&
        other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}
