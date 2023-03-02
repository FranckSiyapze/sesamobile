import 'dart:convert';

class Hospital {
  final int id;
  final String name;
  final String latitude;
  final String longitude;
  final String images;
  final String description;
  Hospital({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.description,
  });

  Hospital copyWith({
    int? id,
    String? name,
    String? latitude,
    String? longitude,
    String? images,
    String? description,
  }) {
    return Hospital(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      images: images ?? this.images,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});
    result.addAll({'images': images});
    result.addAll({'description': description});
  
    return result;
  }

  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      images: map['images'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Hospital.fromJson(Map<String, dynamic> map) {
    return Hospital(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      images: map['images'] ?? '',
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Hospital(id: $id, name: $name, latitude: $latitude, longitude: $longitude, images: $images, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Hospital &&
      other.id == id &&
      other.name == name &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.images == images &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      images.hashCode ^
      description.hashCode;
  }

}
