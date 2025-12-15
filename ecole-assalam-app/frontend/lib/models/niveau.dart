class Niveau {
  final String id;
  final String nom;
  final String? description;
  final int ordre;
  final DateTime createdAt;
  final DateTime updatedAt;

  Niveau({
    required this.id,
    required this.nom,
    this.description,
    required this.ordre,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Niveau.fromJson(Map<String, dynamic> json) {
    return Niveau(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      ordre: json['ordre'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'description': description,
      'ordre': ordre,
    };
  }
}
