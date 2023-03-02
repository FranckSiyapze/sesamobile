import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/prestations/prestation.dart';

class PrestationData {
  final List<Prestation> prestations;
  final bool asData;
  final bool asError;
  PrestationData({
    required this.prestations,
    required this.asData,
    required this.asError,
  });

  PrestationData copyWith({
    List<Prestation>? prestations,
    bool? asData,
    bool? asError,
  }) {
    return PrestationData(
      prestations: prestations ?? this.prestations,
      asData: asData ?? this.asData,
      asError: asError ?? this.asError,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'prestations': prestations.map((x) => x.toMap()).toList()});
    result.addAll({'asData': asData});
    result.addAll({'asError': asError});

    return result;
  }

  factory PrestationData.fromMap(Map<String, dynamic> map) {
    return PrestationData(
      prestations: List<Prestation>.from(
          map['prestations']?.map((x) => Prestation.fromMap(x))),
      asData: map['asData'] ?? false,
      asError: map['asError'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrestationData.fromJson(String source) =>
      PrestationData.fromMap(json.decode(source));

  @override
  String toString() =>
      'PrestationData(prestations: $prestations, asData: $asData, asError: $asError)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrestationData &&
        listEquals(other.prestations, prestations) &&
        other.asData == asData &&
        other.asError == asError;
  }

  @override
  int get hashCode => prestations.hashCode ^ asData.hashCode ^ asError.hashCode;
  PrestationData.inital()
      : prestations = [],
        asError = false,
        asData = true;
}
