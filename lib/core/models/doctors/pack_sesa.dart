import 'dart:convert';

class PackSeSa {
  final int id;
  final String acronyme;
  final int price;
  final int duration;
  final String description;
  PackSeSa({
    required this.id,
    required this.acronyme,
    required this.price,
    required this.duration,
    required this.description,
  });

  PackSeSa copyWith({
    int? id,
    String? acronyme,
    int? price,
    int? duration,
    String? description,
  }) {
    return PackSeSa(
      id: id ?? this.id,
      acronyme: acronyme ?? this.acronyme,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'acronyme': acronyme});
    result.addAll({'price': price});
    result.addAll({'duration': duration});
    result.addAll({'description': description});

    return result;
  }

  factory PackSeSa.fromMap(Map<String, dynamic> map) {
    return PackSeSa(
      id: map['id']?.toInt() ?? 0,
      acronyme: map['acronyme'] ?? '',
      price: map['price']?.toInt() ?? 0,
      duration: map['duration']?.toInt() ?? 0,
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  //factory PackSeSa.fromJson(String source) => PackSeSa.fromMap(json.decode(source));
  factory PackSeSa.fromJson(Map<String, dynamic> map) {
    return PackSeSa(
      id: map['id']?.toInt() ?? 0,
      acronyme: map['acronyme'] ?? '',
      price: map['price']?.toInt() ?? 0,
      duration: map['duration']?.toInt() ?? 0,
      description: map['description'] ?? '',
    );
  }
  @override
  String toString() {
    return 'PackSeSa(id: $id, acronyme: $acronyme, price: $price, duration: $duration, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PackSeSa &&
        other.id == id &&
        other.acronyme == acronyme &&
        other.price == price &&
        other.duration == duration &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        acronyme.hashCode ^
        price.hashCode ^
        duration.hashCode ^
        description.hashCode;
  }
}
