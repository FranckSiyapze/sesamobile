import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sesa/core/models/doctors/abonnement.dart';
import 'package:sesa/core/models/doctors/carnet.dart';
import 'package:sesa/core/models/doctors/departement.dart';
import 'package:sesa/core/models/doctors/hospital.dart';
import 'package:sesa/core/models/doctors/role.dart';
import 'package:sesa/core/models/doctors/speciality.dart';
import 'package:sesa/core/models/doctors/status.dart';

class UserDoctor {
  final int userId;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String birthdatePlace;
  final String sexe;
  final String maritalStatus;
  final String nationality;
  final String tel1;
  final String tel2;
  final bool emailVerify;
  final bool phoneVerify;
  final String imageUrl;
  final Speciality speciality;
  final bool isActive;
  final Departement department;
  final Hospital hospitals;
  final List<Role> roles;
  final List<Abonnement> abonnements;
  final Status status;
  final Carnet carnet;
  UserDoctor({
    required this.userId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.birthdatePlace,
    required this.sexe,
    required this.maritalStatus,
    required this.nationality,
    required this.tel1,
    required this.tel2,
    required this.emailVerify,
    required this.phoneVerify,
    required this.imageUrl,
    required this.department,
    required this.speciality,
    required this.isActive,
    required this.hospitals,
    required this.roles,
    required this.abonnements,
    required this.status,
    required this.carnet,
  });

  UserDoctor copyWith({
    int? userId,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? birthdate,
    String? birthdatePlace,
    String? sexe,
    String? maritalStatus,
    String? nationality,
    String? tel1,
    String? tel2,
    bool? emailVerify,
    bool? phoneVerify,
    String? imageUrl,
    Departement? department,
    Speciality? speciality,
    bool? isActive,
    Hospital? hospitals,
    List<Role>? roles,
    List<Abonnement>? abonnements,
    Status? status,
    Carnet? carnet,
  }) {
    return UserDoctor(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      birthdatePlace: birthdatePlace ?? this.birthdatePlace,
      sexe: sexe ?? this.sexe,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      nationality: nationality ?? this.nationality,
      tel1: tel1 ?? this.tel1,
      tel2: tel2 ?? this.tel2,
      emailVerify: emailVerify ?? this.emailVerify,
      phoneVerify: phoneVerify ?? this.phoneVerify,
      imageUrl: imageUrl ?? this.imageUrl,
      department: department ?? this.department,
      speciality: speciality ?? this.speciality,
      isActive: isActive ?? this.isActive,
      hospitals: hospitals ?? this.hospitals,
      roles: roles ?? this.roles,
      abonnements: abonnements ?? this.abonnements,
      status: status ?? this.status,
      carnet: carnet ?? this.carnet,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userId': userId});
    result.addAll({'username': username});
    result.addAll({'email': email});
    result.addAll({'firstName': firstName});
    result.addAll({'lastName': lastName});
    result.addAll({'birthdate': birthdate});
    result.addAll({'birthdatePlace': birthdatePlace});
    result.addAll({'sexe': sexe});
    result.addAll({'maritalStatus': maritalStatus});
    result.addAll({'nationality': nationality});
    result.addAll({'tel1': tel1});
    result.addAll({'tel2': tel2});
    result.addAll({'emailVerify': emailVerify});
    result.addAll({'phoneVerify': phoneVerify});
    result.addAll({'imageUrl': imageUrl});
    result.addAll({'department': department});
    result.addAll({'speciality': speciality.toMap()});
    result.addAll({'isActive': isActive});
    result.addAll({'hospitals': hospitals.toMap()});
    result.addAll({'roles': roles.map((x) => x.toMap()).toList()});
    result.addAll({'abonnements': abonnements.map((x) => x.toMap()).toList()});
    result.addAll({'status': status.toMap()});
    result.addAll({'carnet': carnet.toMap()});

    return result;
  }

  factory UserDoctor.fromMap(Map<String, dynamic> map) {
    return UserDoctor(
      userId: map['userId']?.toInt() ?? 0,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      birthdate: map['birthdate'] ?? '',
      birthdatePlace: map['birthdatePlace'] ?? '',
      sexe: map['sexe'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
      nationality: map['nationality'] ?? '',
      tel1: map['tel1'] ?? '',
      tel2: map['tel2'] ?? '',
      emailVerify: map['emailVerify'] ?? false,
      phoneVerify: map['phoneVerify'] ?? false,
      imageUrl: map['imageUrl'] ?? '',
      department: Departement.fromMap(map['department']),
      speciality: Speciality.fromMap(map['speciality']),
      isActive: map['isActive'] ?? false,
      hospitals: Hospital.fromMap(map['hospitals']),
      roles: List<Role>.from(map['roles']?.map((x) => Role.fromMap(x))),
      abonnements: List<Abonnement>.from(
          map['abonnements']?.map((x) => Abonnement.fromMap(x))),
      status: Status.fromMap(map['status']),
      carnet: Carnet.fromMap(map['carnet']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDoctor.fromJson(Map<String, dynamic> map) {
    return UserDoctor(
      userId: map['userId']?.toInt() ?? 0,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      birthdate: map['birthdate'] ?? '',
      birthdatePlace: map['birthdatePlace'] ?? '',
      sexe: map['sexe'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
      nationality: map['nationality'] ?? '',
      carnet: (map['carnet'] != null)
          ? Carnet.fromJson(map['carnet'])
          : Carnet(code: "", createdAt: "", etat: false, parametres: []),
      tel1: map['tel1'] ?? '',
      tel2: map['tel2'] ?? '',
      emailVerify: map['emailVerify'] ?? false,
      phoneVerify: map['phoneVerify'] ?? false,
      imageUrl: map['imageUrl'] ?? '',
      department: (map['department'] != null && map['department'] != null)
          ? Departement.fromJson(map['department'])
          : Departement(
              name: "",
              description: "",
            ),
      speciality: (map['speciality'] != null && map['speciality'] != null)
          ? Speciality.fromJson(map['speciality'])
          : Speciality(
              id: 0,
              name: "",
              description: "",
            ),
      isActive: map['isActive'] ?? false,
      hospitals: (map['hospitals'] != null && map['hospitals'] != null)
          ? Hospital.fromJson(map['hospitals'])
          : Hospital(
              id: 0,
              name: "",
              latitude: "",
              longitude: "",
              images: "",
              description: "",
            ),
      roles: (map['roles'] != [] && map['roles'] != null)
          ? List<Role>.from(map['roles']?.map((x) => Role.fromJson(x)))
          : [],
      abonnements: (map['abonnements'] != [] && map['abonnements'] != null)
          ? List<Abonnement>.from(
              map['abonnements']?.map((x) => Abonnement.fromJson(x)))
          : [],
      status: Status.fromJson(map['status']),
    );
  }

  @override
  String toString() {
    return 'UserDoctor(userId: $userId, username: $username, email: $email, firstName: $firstName, lastName: $lastName, birthdate: $birthdate, birthdatePlace: $birthdatePlace, sexe: $sexe, maritalStatus: $maritalStatus, nationality: $nationality, tel1: $tel1, tel2: $tel2, emailVerify: $emailVerify, phoneVerify: $phoneVerify, imageUrl: $imageUrl, department: $department, speciality: $speciality, isActive: $isActive, hospitals: $hospitals, roles: $roles, abonnements: $abonnements, status: $status, carnet: $carnet)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserDoctor &&
        other.userId == userId &&
        other.username == username &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.birthdate == birthdate &&
        other.birthdatePlace == birthdatePlace &&
        other.sexe == sexe &&
        other.maritalStatus == maritalStatus &&
        other.nationality == nationality &&
        other.tel1 == tel1 &&
        other.tel2 == tel2 &&
        other.emailVerify == emailVerify &&
        other.phoneVerify == phoneVerify &&
        other.imageUrl == imageUrl &&
        other.department == department &&
        other.speciality == speciality &&
        other.isActive == isActive &&
        other.hospitals == hospitals &&
        listEquals(other.roles, roles) &&
        listEquals(other.abonnements, abonnements) &&
        other.status == status &&
        other.carnet == carnet;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        username.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        birthdate.hashCode ^
        birthdatePlace.hashCode ^
        sexe.hashCode ^
        maritalStatus.hashCode ^
        nationality.hashCode ^
        tel1.hashCode ^
        tel2.hashCode ^
        emailVerify.hashCode ^
        phoneVerify.hashCode ^
        imageUrl.hashCode ^
        department.hashCode ^
        speciality.hashCode ^
        isActive.hashCode ^
        hospitals.hashCode ^
        roles.hashCode ^
        abonnements.hashCode ^
        status.hashCode ^
        carnet.hashCode;
  }
}
