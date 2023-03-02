import 'dart:convert';


class Status {
  final String name;
  final int statusId;
  final String description;
  Status({
    required this.name,
    required this.statusId,
    required this.description,
  });

  Status copyWith({
    String? name,
    int? statusId,
    String? description,
  }) {
    return Status(
      name: name ?? this.name,
      statusId: statusId ?? this.statusId,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'statusId': statusId});
    result.addAll({'description': description});
  
    return result;
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      name: map['name'] ?? '',
      statusId: map['statusId']?.toInt() ?? 0,
      description: map['description'] ?? '',
    );
  }

  

  String toJson() => json.encode(toMap());
  factory Status.fromJson(Map<String, dynamic> map) {
    return Status(
      name: map['name'] ?? '',
      statusId: map['statusId']?.toInt() ?? 0,
      description: map['description'] ?? '',
    );
  }


  @override
  String toString() => 'Status(name: $name, statusId: $statusId, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Status &&
      other.name == name &&
      other.statusId == statusId &&
      other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ statusId.hashCode ^ description.hashCode;
}
