import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/prestations/prest_details.dart';

class PrestDetailsData {
  final List<PrestDetails> prestDetails;
  final bool asData;
  final bool asError;
  PrestDetailsData({
    required this.prestDetails,
    required this.asData,
    required this.asError,
  });

  PrestDetailsData copyWith({
    List<PrestDetails>? prestDetails,
    bool? asData,
    bool? asError,
  }) {
    return PrestDetailsData(
      prestDetails: prestDetails ?? this.prestDetails,
      asData: asData ?? this.asData,
      asError: asError ?? this.asError,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result
        .addAll({'prestDetails': prestDetails.map((x) => x.toMap()).toList()});
    result.addAll({'asData': asData});
    result.addAll({'asError': asError});

    return result;
  }

  factory PrestDetailsData.fromMap(Map<String, dynamic> map) {
    return PrestDetailsData(
      prestDetails: List<PrestDetails>.from(
          map['prestDetails']?.map((x) => PrestDetails.fromMap(x))),
      asData: map['asData'] ?? false,
      asError: map['asError'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrestDetailsData.fromJson(String source) =>
      PrestDetailsData.fromMap(json.decode(source));

  @override
  String toString() =>
      'PrestDetailsData(prestDetails: $prestDetails, asData: $asData, asError: $asError)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PrestDetailsData &&
        listEquals(other.prestDetails, prestDetails) &&
        other.asData == asData &&
        other.asError == asError;
  }

  @override
  int get hashCode =>
      prestDetails.hashCode ^ asData.hashCode ^ asError.hashCode;
  PrestDetailsData.inital()
      : prestDetails = [],
        asError = false,
        asData = true;
}
