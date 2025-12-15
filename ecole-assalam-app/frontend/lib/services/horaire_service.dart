import '../config/api_config.dart';
import '../models/horaire.dart';
import 'api_service.dart';

class HoraireService {
  final ApiService _apiService = ApiService();

  Future<List<Horaire>> getAllHoraires({String? groupeId}) async {
    final queryParams = <String, dynamic>{};
    if (groupeId != null) queryParams['groupeId'] = groupeId;

    final response = await _apiService.get(
      ApiConfig.horairesEndpoint,
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((json) => Horaire.fromJson(json))
        .toList();
  }

  Future<Horaire> getHoraireById(String id) async {
    final response = await _apiService.get('${ApiConfig.horairesEndpoint}/$id');
    return Horaire.fromJson(response.data);
  }

  Future<Horaire> createHoraire(Horaire horaire) async {
    final response = await _apiService.post(
      ApiConfig.horairesEndpoint,
      data: horaire.toJson(),
    );
    return Horaire.fromJson(response.data);
  }

  Future<Horaire> updateHoraire(String id, Horaire horaire) async {
    final response = await _apiService.put(
      '${ApiConfig.horairesEndpoint}/$id',
      data: horaire.toJson(),
    );
    return Horaire.fromJson(response.data);
  }

  Future<void> deleteHoraire(String id) async {
    await _apiService.delete('${ApiConfig.horairesEndpoint}/$id');
  }
}
