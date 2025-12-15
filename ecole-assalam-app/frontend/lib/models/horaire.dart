import 'groupe.dart';

class Horaire {
  final String id;
  final String groupeId;
  final List<String> joursSemaine;
  final String heureEntree;
  final String heureSortie;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Groupe? groupe;

  Horaire({
    required this.id,
    required this.groupeId,
    required this.joursSemaine,
    required this.heureEntree,
    required this.heureSortie,
    required this.createdAt,
    required this.updatedAt,
    this.groupe,
  });

  factory Horaire.fromJson(Map<String, dynamic> json) {
    return Horaire(
      id: json['id'],
      groupeId: json['groupeId'],
      joursSemaine: List<String>.from(json['joursSemaine']),
      heureEntree: json['heureEntree'],
      heureSortie: json['heureSortie'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      groupe: json['groupe'] != null ? Groupe.fromJson(json['groupe']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupeId': groupeId,
      'joursSemaine': joursSemaine,
      'heureEntree': heureEntree,
      'heureSortie': heureSortie,
    };
  }
}
