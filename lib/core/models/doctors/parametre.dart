import 'dart:convert';

class Parameter {
  final int id;
  final double taille;
  final double poids;
  final double temperature;
  final double frequenceCardiaque;
  final double pouls;
  final double frequenceRespiratoire;
  final double saturationOxygene;
  final double perimetreBranchial;
  final bool etat;
  final String createdAt;
  Parameter({
    required this.id,
    required this.taille,
    required this.poids,
    required this.temperature,
    required this.frequenceCardiaque,
    required this.pouls,
    required this.frequenceRespiratoire,
    required this.saturationOxygene,
    required this.perimetreBranchial,
    required this.etat,
    required this.createdAt,
  });

  Parameter copyWith({
    int? id,
    double? taille,
    double? poids,
    double? temperature,
    double? frequenceCardiaque,
    double? pouls,
    double? frequenceRespiratoire,
    double? saturationOxygene,
    double? perimetreBranchial,
    bool? etat,
    String? createdAt,
  }) {
    return Parameter(
      id: id ?? this.id,
      taille: taille ?? this.taille,
      poids: poids ?? this.poids,
      temperature: temperature ?? this.temperature,
      frequenceCardiaque: frequenceCardiaque ?? this.frequenceCardiaque,
      pouls: pouls ?? this.pouls,
      frequenceRespiratoire:
          frequenceRespiratoire ?? this.frequenceRespiratoire,
      saturationOxygene: saturationOxygene ?? this.saturationOxygene,
      perimetreBranchial: perimetreBranchial ?? this.perimetreBranchial,
      etat: etat ?? this.etat,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'taille': taille});
    result.addAll({'poids': poids});
    result.addAll({'temperature': temperature});
    result.addAll({'frequenceCardiaque': frequenceCardiaque});
    result.addAll({'pouls': pouls});
    result.addAll({'frequenceRespiratoire': frequenceRespiratoire});
    result.addAll({'saturationOxygene': saturationOxygene});
    result.addAll({'perimetreBranchial': perimetreBranchial});
    result.addAll({'etat': etat});
    result.addAll({'createdAt': createdAt});

    return result;
  }

  factory Parameter.fromMap(Map<String, dynamic> map) {
    return Parameter(
      id: map['id']?.toInt() ?? 0,
      taille: map['taille']?.toDouble() ?? 0.0,
      poids: map['poids']?.toDouble() ?? 0.0,
      temperature: map['temperature']?.toDouble() ?? 0.0,
      frequenceCardiaque: map['frequenceCardiaque']?.toDouble() ?? 0.0,
      pouls: map['pouls']?.toDouble() ?? 0.0,
      frequenceRespiratoire: map['frequenceRespiratoire']?.toDouble() ?? 0.0,
      saturationOxygene: map['saturationOxygene']?.toDouble() ?? 0.0,
      perimetreBranchial: map['perimetreBranchial']?.toDouble() ?? 0.0,
      etat: map['etat'] ?? false,
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Parameter.fromJson(Map<String, dynamic> map) {
    return Parameter(
      id: map['id']?.toInt() ?? 0,
      taille: map['taille']?.toDouble() ?? 0.0,
      poids: map['poids']?.toDouble() ?? 0.0,
      temperature: map['temperature']?.toDouble() ?? 0.0,
      frequenceCardiaque: map['frequenceCardiaque']?.toDouble() ?? 0.0,
      pouls: map['pouls']?.toDouble() ?? 0.0,
      frequenceRespiratoire: map['frequenceRespiratoire']?.toDouble() ?? 0.0,
      saturationOxygene: map['saturationOxygene']?.toDouble() ?? 0.0,
      perimetreBranchial: map['perimetreBranchial']?.toDouble() ?? 0.0,
      etat: map['etat'] ?? false,
      createdAt: map['createdAt'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Parameter(id: $id, taille: $taille, poids: $poids, temperature: $temperature, frequenceCardiaque: $frequenceCardiaque, pouls: $pouls, frequenceRespiratoire: $frequenceRespiratoire, saturationOxygene: $saturationOxygene, perimetreBranchial: $perimetreBranchial, etat: $etat, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Parameter &&
        other.id == id &&
        other.taille == taille &&
        other.poids == poids &&
        other.temperature == temperature &&
        other.frequenceCardiaque == frequenceCardiaque &&
        other.pouls == pouls &&
        other.frequenceRespiratoire == frequenceRespiratoire &&
        other.saturationOxygene == saturationOxygene &&
        other.perimetreBranchial == perimetreBranchial &&
        other.etat == etat &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        taille.hashCode ^
        poids.hashCode ^
        temperature.hashCode ^
        frequenceCardiaque.hashCode ^
        pouls.hashCode ^
        frequenceRespiratoire.hashCode ^
        saturationOxygene.hashCode ^
        perimetreBranchial.hashCode ^
        etat.hashCode ^
        createdAt.hashCode;
  }
}
