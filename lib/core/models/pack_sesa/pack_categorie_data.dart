import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/pack_sesa/pack_categorie.dart';

class PackCategorieData {
  final List<PackCategorie> packCategories;
  final bool asData;
  final bool asError;
  PackCategorieData({
    required this.packCategories,
    required this.asData,
    required this.asError,
  });

  PackCategorieData copyWith({
    List<PackCategorie>? packCategories,
    bool? asData,
    bool? asError,
  }) {
    return PackCategorieData(
      packCategories: packCategories ?? this.packCategories,
      asData: asData ?? this.asData,
      asError: asError ?? this.asError,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll(
        {'packCategories': packCategories.map((x) => x.toMap()).toList()});
    result.addAll({'asData': asData});
    result.addAll({'asError': asError});

    return result;
  }

  factory PackCategorieData.fromMap(Map<String, dynamic> map) {
    return PackCategorieData(
      packCategories: List<PackCategorie>.from(
          map['packCategories']?.map((x) => PackCategorie.fromMap(x))),
      asData: map['asData'] ?? false,
      asError: map['asError'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PackCategorieData.fromJson(String source) =>
      PackCategorieData.fromMap(json.decode(source));

  @override
  String toString() =>
      'PackCategorieData(packCategories: $packCategories, asData: $asData, asError: $asError)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PackCategorieData &&
        listEquals(other.packCategories, packCategories) &&
        other.asData == asData &&
        other.asError == asError;
  }

  @override
  int get hashCode =>
      packCategories.hashCode ^ asData.hashCode ^ asError.hashCode;
  PackCategorieData.inital()
      : packCategories = [],
        asError = false,
        asData = false;
}
