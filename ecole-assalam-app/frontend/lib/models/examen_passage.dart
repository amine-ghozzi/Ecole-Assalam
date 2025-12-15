import 'niveau.dart';

enum StatutExamen {
  PLANIFIE,
  EN_COURS,
  TERMINE,
  ANNULE,
}

class ExamenPassage {
  final String id;
  final String niveauSourceId;
  final String niveauDestinationId;
  final DateTime dateExamen;
  final DateTime dateLimiteInscription;
  final StatutExamen statut;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Niveau? niveauSource;
  final Niveau? niveauDestination;

  ExamenPassage({
    required this.id,
    required this.niveauSourceId,
    required this.niveauDestinationId,
    required this.dateExamen,
    required this.dateLimiteInscription,
    required this.statut,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.niveauSource,
    this.niveauDestination,
  });

  factory ExamenPassage.fromJson(Map<String, dynamic> json) {
    return ExamenPassage(
      id: json['id'],
      niveauSourceId: json['niveauSourceId'],
      niveauDestinationId: json['niveauDestinationId'],
      dateExamen: DateTime.parse(json['dateExamen']),
      dateLimiteInscription: DateTime.parse(json['dateLimiteInscription']),
      statut: StatutExamen.values.firstWhere(
        (e) => e.name == json['statut'],
        orElse: () => StatutExamen.PLANIFIE,
      ),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      niveauSource: json['niveauSource'] != null
          ? Niveau.fromJson(json['niveauSource'])
          : null,
      niveauDestination: json['niveauDestination'] != null
          ? Niveau.fromJson(json['niveauDestination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niveauSourceId': niveauSourceId,
      'niveauDestinationId': niveauDestinationId,
      'dateExamen': dateExamen.toIso8601String(),
      'dateLimiteInscription': dateLimiteInscription.toIso8601String(),
      'statut': statut.name,
      'description': description,
    };
  }

  String get titre {
    if (niveauSource != null && niveauDestination != null) {
      return '${niveauSource!.nom} → ${niveauDestination!.nom}';
    }
    return 'Examen de passage';
  }
}
