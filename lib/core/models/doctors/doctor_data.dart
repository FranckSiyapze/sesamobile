

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/doctors/user.dart';

class DoctorData {
  final List<UserDoctor> doctors;
  final bool asData;
  final bool asError;
  DoctorData({
    required this.doctors,
    required this.asData,
    required this.asError,
  });

  DoctorData copyWith({
    List<UserDoctor>? doctors,
    bool? asData,
    bool? asError,
  }) {
    return DoctorData(
      doctors: doctors ?? this.doctors,
      asData: asData ?? this.asData,
      asError: asError ?? this.asError,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'doctors': doctors.map((x) => x.toMap()).toList()});
    result.addAll({'asData': asData});
    result.addAll({'asError': asError});
  
    return result;
  }

  factory DoctorData.fromMap(Map<String, dynamic> map) {
    return DoctorData(
      doctors: List<UserDoctor>.from(map['doctors']?.map((x) => UserDoctor.fromMap(x))),
      asData: map['asData'] ?? false,
      asError: map['asError'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorData.fromJson(String source) => DoctorData.fromMap(json.decode(source));

  @override
  String toString() => 'DoctorData(doctors: $doctors, asData: $asData, asError: $asError)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DoctorData &&
      listEquals(other.doctors, doctors) &&
      other.asData == asData &&
      other.asError == asError;
  }

  @override
  int get hashCode => doctors.hashCode ^ asData.hashCode ^ asError.hashCode;
  DoctorData.inital()
      : doctors = [],
        asError = false,
        asData = false;
}
