import 'dart:convert';

import 'package:sesa/core/models/doctors/hospital.dart';
import 'package:sesa/core/models/doctors/pack_sesa.dart';

class Abonnement {
  final int id;
  final double amount;
  final String startDate;
  final String endDate;
  final String createdAt;
  final bool etat;
  final PackSeSa packSesa;
  final Hospital hospitals;
  Abonnement({
    required this.id,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.etat,
    required this.packSesa,
    required this.hospitals,
  });

  Abonnement copyWith({
    int? id,
    double? amount,
    String? startDate,
    String? endDate,
    String? createdAt,
    bool? etat,
    PackSeSa? packSesa,
    Hospital? hospitals,
  }) {
    return Abonnement(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      etat: etat ?? this.etat,
      packSesa: packSesa ?? this.packSesa,
      hospitals: hospitals ?? this.hospitals,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'amount': amount});
    result.addAll({'startDate': startDate});
    result.addAll({'endDate': endDate});
    result.addAll({'createdAt': createdAt});
    result.addAll({'etat': etat});
    result.addAll({'packSesa': packSesa.toMap()});
    result.addAll({'hospitals': hospitals.toMap()});

    return result;
  }

  factory Abonnement.fromMap(Map<String, dynamic> map) {
    return Abonnement(
      id: map['id']?.toInt() ?? 0,
      amount: map['amount']?.toDouble() ?? 0.0,
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      createdAt: map['createdAt'] ?? '',
      etat: map['etat'] ?? false,
      packSesa: PackSeSa.fromMap(map['packSesa']),
      hospitals: Hospital.fromMap(map['hospitals']),
    );
  }

  String toJson() => json.encode(toMap());

  //factory Abonnement.fromJson(String source) => Abonnement.fromMap(json.decode(source));
  factory Abonnement.fromJson(Map<String, dynamic> map) {
    return Abonnement(
      id: map['id']?.toInt() ?? 0,
      amount: map['amount']?.toDouble() ?? 0.0,
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      createdAt: map['createdAt'] ?? '',
      etat: map['etat'] ?? false,
      packSesa: PackSeSa.fromJson(map['packSesa']),
      hospitals: Hospital.fromJson(map['hospitals']),
    );
  }

  @override
  String toString() {
    return 'Abonnement(id: $id, amount: $amount, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, etat: $etat, packSesa: $packSesa, hospitals: $hospitals)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Abonnement &&
        other.id == id &&
        other.amount == amount &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.createdAt == createdAt &&
        other.etat == etat &&
        other.packSesa == packSesa &&
        other.hospitals == hospitals;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        createdAt.hashCode ^
        etat.hashCode ^
        packSesa.hashCode ^
        hospitals.hashCode;
  }
}
