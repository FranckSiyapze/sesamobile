import 'dart:convert';

class MobileConfig {
  final String long;
  final String lat;
  MobileConfig({
    required this.long,
    required this.lat,
  });

  MobileConfig copyWith({
    String? long,
    String? lat,
  }) {
    return MobileConfig(
      long: long ?? this.long,
      lat: lat ?? this.lat,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'long': long});
    result.addAll({'lat': lat});

    return result;
  }

  factory MobileConfig.fromMap(Map<String, dynamic> map) {
    return MobileConfig(
      long: map['long'] ?? '',
      lat: map['lat'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MobileConfig.fromJson(String source) =>
      MobileConfig.fromMap(json.decode(source));

  @override
  String toString() => 'MobileConfig(long: $long, lat: $lat)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MobileConfig && other.long == long && other.lat == lat;
  }

  @override
  int get hashCode => long.hashCode ^ lat.hashCode;
}
