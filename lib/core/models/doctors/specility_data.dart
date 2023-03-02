import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/doctors/speciality.dart';

class SpecialityData {
  final List<Speciality> specialitys;
  final bool asData;
  final bool asError;
  SpecialityData({
    required this.specialitys,
    required this.asData,
    required this.asError,
  });

  SpecialityData copyWith({
    List<Speciality>? specialitys,
    bool? asData,
    bool? asError,
  }) {
    return SpecialityData(
      specialitys: specialitys ?? this.specialitys,
      asData: asData ?? this.asData,
      asError: asError ?? this.asError,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'specialitys': specialitys.map((x) => x.toMap()).toList()});
    result.addAll({'asData': asData});
    result.addAll({'asError': asError});

    return result;
  }

  factory SpecialityData.fromMap(Map<String, dynamic> map) {
    return SpecialityData(
      specialitys: List<Speciality>.from(
          map['specialitys']?.map((x) => Speciality.fromMap(x))),
      asData: map['asData'] ?? false,
      asError: map['asError'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpecialityData.fromJson(String source) =>
      SpecialityData.fromMap(json.decode(source));

  @override
  String toString() =>
      'SpecialityData(specialitys: $specialitys, asData: $asData, asError: $asError)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SpecialityData &&
        listEquals(other.specialitys, specialitys) &&
        other.asData == asData &&
        other.asError == asError;
  }

  @override
  int get hashCode => specialitys.hashCode ^ asData.hashCode ^ asError.hashCode;
  SpecialityData.inital()
      : specialitys = [],
        asError = false,
        asData = true;
}
