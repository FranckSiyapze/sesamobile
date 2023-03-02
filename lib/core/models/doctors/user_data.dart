import 'dart:convert';

import 'package:sesa/core/models/doctors/carnet.dart';
import 'package:sesa/core/models/doctors/departement.dart';
import 'package:sesa/core/models/doctors/hospital.dart';
import 'package:sesa/core/models/doctors/speciality.dart';
import 'package:sesa/core/models/doctors/status.dart';
import 'package:sesa/core/models/doctors/user.dart';

class UserData {
  final UserDoctor user;
  final bool asData;
  final bool isError;
  UserData({
    required this.user,
    required this.asData,
    required this.isError,
  });

  UserData copyWith({
    UserDoctor? user,
    bool? asData,
    bool? isError,
  }) {
    return UserData(
      user: user ?? this.user,
      asData: asData ?? this.asData,
      isError: isError ?? this.isError,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'user': user.toMap()});
    result.addAll({'asData': asData});
    result.addAll({'isError': isError});

    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      user: UserDoctor.fromMap(map['user']),
      asData: map['asData'] ?? false,
      isError: map['isError'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserData(user: $user, asData: $asData, isError: $isError)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.user == user &&
        other.asData == asData &&
        other.isError == isError;
  }

  @override
  int get hashCode => user.hashCode ^ asData.hashCode ^ isError.hashCode;
  UserData.inital()
      : user = UserDoctor(
          userId: 0,
          username: "",
          email: "",
          firstName: "",
          lastName: "",
          birthdate: "",
          birthdatePlace: "",
          sexe: "",
          maritalStatus: "",
          nationality: "",
          tel1: "",
          tel2: "",
          emailVerify: false,
          phoneVerify: false,
          carnet: Carnet(code: "", createdAt: "", etat: false, parametres: []),
          imageUrl: "",
          department: Departement(
            name: "",
            description: "",
          ),
          speciality: Speciality(
            id: 0,
            name: "",
            description: "",
          ),
          isActive: false,
          hospitals: Hospital(
            id: 0,
            name: "",
            latitude: "",
            longitude: "",
            images: "",
            description: "",
          ),
          roles: [],
          abonnements: [],
          status: Status(name: "", statusId: 0, description: ""),
        ),
        isError = false,
        asData = false;
}
