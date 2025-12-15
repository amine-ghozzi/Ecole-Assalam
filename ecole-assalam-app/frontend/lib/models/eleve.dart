import 'groupe.dart';

class Eleve {
  final String id;
  final String nom;
  final String prenom;
  final DateTime dateNaissance;
  final String? groupeId;
  final String? photo;
  final String? contactParent;
  final String? adresse;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Groupe? groupe;

  Eleve({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    this.groupeId,
    this.photo,
    this.contactParent,
    this.adresse,
    required this.createdAt,
    required this.updatedAt,
    this.groupe,
  });

  factory Eleve.fromJson(Map<String, dynamic> json) {
    return Eleve(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: DateTime.parse(json['dateNaissance']),
      groupeId: json['groupeId'],
      photo: json['photo'],
      contactParent: json['contactParent'],
      adresse: json['adresse'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      groupe: json['groupe'] != null ? Groupe.fromJson(json['groupe']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance.toIso8601String(),
      'groupeId': groupeId,
      'photo': photo,
      'contactParent': contactParent,
      'adresse': adresse,
    };
  }

  String get nomComplet => '$prenom $nom';
}
