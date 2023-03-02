import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/medicaments/medicament.dart';

class MedicamentData {
  final List<Medicament> medicaments;
  final bool asData;
  final bool asError;
  MedicamentData({
    required this.medicaments,
    required this.asData,
    required this.asError,
  });

  MedicamentData copyWith({
    List<Medicament>? medicaments,
    bool? asData,
    bool? asError,
  }) {
    return MedicamentData(
      medicaments: medicaments ?? this.medicaments,
      asData: asData ?? this.asData,
      asError: asError ?? this.asError,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'medicaments': medicaments.map((x) => x.toMap()).toList()});
    result.addAll({'asData': asData});
    result.addAll({'asError': asError});

    return result;
  }

  factory MedicamentData.fromMap(Map<String, dynamic> map) {
    return MedicamentData(
      medicaments: List<Medicament>.from(
          map['medicaments']?.map((x) => Medicament.fromMap(x))),
      asData: map['asData'] ?? false,
      asError: map['asError'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicamentData.fromJson(String source) =>
      MedicamentData.fromMap(json.decode(source));

  @override
  String toString() =>
      'MedicamentData(medicaments: $medicaments, asData: $asData, asError: $asError)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicamentData &&
        listEquals(other.medicaments, medicaments) &&
        other.asData == asData &&
        other.asError == asError;
  }

  @override
  int get hashCode => medicaments.hashCode ^ asData.hashCode ^ asError.hashCode;
  MedicamentData.inital()
      : medicaments = [],
        asError = false,
        asData = true;
}
