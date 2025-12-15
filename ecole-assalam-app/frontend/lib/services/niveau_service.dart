import '../config/api_config.dart';
import '../models/niveau.dart';
import 'api_service.dart';

class NiveauService {
  final ApiService _apiService = ApiService();

  Future<List<Niveau>> getAllNiveaux() async {
    final response = await _apiService.get(ApiConfig.niveauxEndpoint);
    return (response.data as List)
        .map((json) => Niveau.fromJson(json))
        .toList();
  }

  Future<Niveau> getNiveauById(String id) async {
    final response = await _apiService.get('${ApiConfig.niveauxEndpoint}/$id');
    return Niveau.fromJson(response.data);
  }

  Future<Niveau> createNiveau(Niveau niveau) async {
    final response = await _apiService.post(
      ApiConfig.niveauxEndpoint,
      data: niveau.toJson(),
    );
    return Niveau.fromJson(response.data);
  }

  Future<Niveau> updateNiveau(String id, Niveau niveau) async {
    final response = await _apiService.put(
      '${ApiConfig.niveauxEndpoint}/$id',
      data: niveau.toJson(),
    );
    return Niveau.fromJson(response.data);
  }

  Future<void> deleteNiveau(String id) async {
    await _apiService.delete('${ApiConfig.niveauxEndpoint}/$id');
  }
}
