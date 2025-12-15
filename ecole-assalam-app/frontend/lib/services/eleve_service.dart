import '../config/api_config.dart';
import '../models/eleve.dart';
import 'api_service.dart';

class EleveService {
  final ApiService _apiService = ApiService();

  Future<List<Eleve>> getAllEleves({String? groupeId}) async {
    final queryParams = <String, dynamic>{};
    if (groupeId != null) queryParams['groupeId'] = groupeId;

    final response = await _apiService.get(
      ApiConfig.elevesEndpoint,
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((json) => Eleve.fromJson(json))
        .toList();
  }

  Future<Eleve> getEleveById(String id) async {
    final response = await _apiService.get('${ApiConfig.elevesEndpoint}/$id');
    return Eleve.fromJson(response.data);
  }

  Future<Eleve> createEleve(Eleve eleve) async {
    final response = await _apiService.post(
      ApiConfig.elevesEndpoint,
      data: eleve.toJson(),
    );
    return Eleve.fromJson(response.data);
  }

  Future<Eleve> updateEleve(String id, Eleve eleve) async {
    final response = await _apiService.put(
      '${ApiConfig.elevesEndpoint}/$id',
      data: eleve.toJson(),
    );
    return Eleve.fromJson(response.data);
  }

  Future<void> deleteEleve(String id) async {
    await _apiService.delete('${ApiConfig.elevesEndpoint}/$id');
  }
}
