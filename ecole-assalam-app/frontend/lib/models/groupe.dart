import 'niveau.dart';

class Groupe {
  final String id;
  final String nom;
  final String niveauId;
  final int capaciteMax;
  final String anneeScolaire;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Niveau? niveau;
  final int? eleveCount;

  Groupe({
    required this.id,
    required this.nom,
    required this.niveauId,
    required this.capaciteMax,
    required this.anneeScolaire,
    required this.createdAt,
    required this.updatedAt,
    this.niveau,
    this.eleveCount,
  });

  factory Groupe.fromJson(Map<String, dynamic> json) {
    return Groupe(
      id: json['id'],
      nom: json['nom'],
      niveauId: json['niveauId'],
      capaciteMax: json['capaciteMax'],
      anneeScolaire: json['anneeScolaire'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      niveau: json['niveau'] != null ? Niveau.fromJson(json['niveau']) : null,
      eleveCount: json['_count']?['eleves'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'niveauId': niveauId,
      'capaciteMax': capaciteMax,
      'anneeScolaire': anneeScolaire,
    };
  }
}
