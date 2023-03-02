import 'dart:convert';

class User {
  final String email;
  final String name;
  final String photoName;
  User({
    required this.email,
    required this.name,
    required this.photoName,
  });

  User copyWith({
    String? email,
    String? name,
    String? photoName,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      photoName: photoName ?? this.photoName,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'photoName': photoName});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoName: map['photoName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() =>
      'User(email: $email, name: $name, photoName: $photoName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.email == email &&
        other.name == name &&
        other.photoName == photoName;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ photoName.hashCode;
}
