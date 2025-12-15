import '../config/api_config.dart';
import '../models/groupe.dart';
import 'api_service.dart';

class GroupeService {
  final ApiService _apiService = ApiService();

  Future<List<Groupe>> getAllGroupes({String? anneeScolaire, String? niveauId}) async {
    final queryParams = <String, dynamic>{};
    if (anneeScolaire != null) queryParams['anneeScolaire'] = anneeScolaire;
    if (niveauId != null) queryParams['niveauId'] = niveauId;

    final response = await _apiService.get(
      ApiConfig.groupesEndpoint,
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((json) => Groupe.fromJson(json))
        .toList();
  }

  Future<Groupe> getGroupeById(String id) async {
    final response = await _apiService.get('${ApiConfig.groupesEndpoint}/$id');
    return Groupe.fromJson(response.data);
  }

  Future<Groupe> createGroupe(Groupe groupe) async {
    final response = await _apiService.post(
      ApiConfig.groupesEndpoint,
      data: groupe.toJson(),
    );
    return Groupe.fromJson(response.data);
  }

  Future<Groupe> updateGroupe(String id, Groupe groupe) async {
    final response = await _apiService.put(
      '${ApiConfig.groupesEndpoint}/$id',
      data: groupe.toJson(),
    );
    return Groupe.fromJson(response.data);
  }

  Future<void> deleteGroupe(String id) async {
    await _apiService.delete('${ApiConfig.groupesEndpoint}/$id');
  }
}
