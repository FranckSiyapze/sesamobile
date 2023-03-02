import 'dart:convert';


class AppConfig {
  final String BASE_API_URL;
  AppConfig({
    required this.BASE_API_URL,
  });

  AppConfig copyWith({
    String? BASE_API_URL,
  }) {
    return AppConfig(
      BASE_API_URL: BASE_API_URL ?? this.BASE_API_URL,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'BASE_API_URL': BASE_API_URL});
  
    return result;
  }

  factory AppConfig.fromMap(Map<String, dynamic> map) {
    return AppConfig(
      BASE_API_URL: map['BASE_API_URL'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  //factory AppConfig.fromJson(String source) => AppConfig.fromMap(json.decode(source));
  factory AppConfig.fromJson(Map<String, dynamic> map) {
    return AppConfig(
      BASE_API_URL: map['BASE_API_URL'] ?? '',
    );
  }

  @override
  String toString() => 'AppConfig(BASE_API_URL: $BASE_API_URL)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppConfig &&
      other.BASE_API_URL == BASE_API_URL;
  }

  @override
  int get hashCode => BASE_API_URL.hashCode;
}
