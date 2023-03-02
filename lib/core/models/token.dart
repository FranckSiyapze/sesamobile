import 'dart:convert';

class TokenGenerate {
  final String? token;
  final String? channel;

  TokenGenerate({
    this.channel,
    this.token,
  });
  TokenGenerate copyWith({
    String? token,
    String? channel,
  }) {
    return TokenGenerate(
      token: token ?? this.token,
      channel: channel ?? this.channel,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'token': token});
    result.addAll({'channel': channel});
    return result;
  }

  factory TokenGenerate.fromMap(Map<String, dynamic> map) {
    return TokenGenerate(
      token: map['token'] ?? '',
      channel: map['uid'].toString(),
    );
  }
  String toJson() => json.encode(toMap());
  factory TokenGenerate.fromJson(Map<String, dynamic> _json) {
    return TokenGenerate(
      token: _json['token'],
      channel: _json['uid'].toString(),
    );
  }
  @override
  String toString() {
    return 'TokenGenerate(token: $token, channel: $channel,)';
  }

  TokenGenerate.inital()
      : token = "",
        channel = "";
}
