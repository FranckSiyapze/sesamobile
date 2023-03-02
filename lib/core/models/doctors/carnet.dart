import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/doctors/parametre.dart';

class Carnet {
  final String code;
  final String createdAt;
  final bool etat;
  final List<Parameter> parametres;
  Carnet({
    required this.code,
    required this.createdAt,
    required this.etat,
    required this.parametres,
  });

  Carnet copyWith({
    String? code,
    String? createdAt,
    bool? etat,
    List<Parameter>? parametres,
  }) {
    return Carnet(
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      etat: etat ?? this.etat,
      parametres: parametres ?? this.parametres,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'code': code});
    result.addAll({'createdAt': createdAt});
    result.addAll({'etat': etat});
    result.addAll({'parametres': parametres.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Carnet.fromMap(Map<String, dynamic> map) {
    return Carnet(
      code: map['code'] ?? '',
      createdAt: map['createdAt'] ?? '',
      etat: map['etat'] ?? false,
      parametres: List<Parameter>.from(
          map['parametres']?.map((x) => Parameter.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Carnet.fromJson(Map<String, dynamic> map) {
    return Carnet(
      code: map['code'] ?? '',
      createdAt: map['createdAt'] ?? '',
      etat: map['etat'] ?? false,
      parametres: (map['parametres'] != null && map['parametres'] != [])
          ? List<Parameter>.from(
              map['parametres']?.map((x) => Parameter.fromJson(x)))
          : [],
    );
  }

  @override
  String toString() {
    return 'Carnet(code: $code, createdAt: $createdAt, etat: $etat, parametres: $parametres)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Carnet &&
        other.code == code &&
        other.createdAt == createdAt &&
        other.etat == etat &&
        listEquals(other.parametres, parametres);
  }

  @override
  int get hashCode {
    return code.hashCode ^
        createdAt.hashCode ^
        etat.hashCode ^
        parametres.hashCode;
  }
}
