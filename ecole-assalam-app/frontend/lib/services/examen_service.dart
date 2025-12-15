import '../config/api_config.dart';
import '../models/examen_passage.dart';
import 'api_service.dart';

class ExamenService {
  final ApiService _apiService = ApiService();

  Future<List<ExamenPassage>> getAllExamens({
    String? statut,
    String? niveauSourceId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (statut != null) queryParams['statut'] = statut;
    if (niveauSourceId != null) queryParams['niveauSourceId'] = niveauSourceId;

    final response = await _apiService.get(
      ApiConfig.examensEndpoint,
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((json) => ExamenPassage.fromJson(json))
        .toList();
  }

  Future<ExamenPassage> getExamenById(String id) async {
    final response = await _apiService.get('${ApiConfig.examensEndpoint}/$id');
    return ExamenPassage.fromJson(response.data);
  }

  Future<ExamenPassage> createExamen(ExamenPassage examen) async {
    final response = await _apiService.post(
      ApiConfig.examensEndpoint,
      data: examen.toJson(),
    );
    return ExamenPassage.fromJson(response.data);
  }

  Future<ExamenPassage> updateExamen(String id, ExamenPassage examen) async {
    final response = await _apiService.put(
      '${ApiConfig.examensEndpoint}/$id',
      data: examen.toJson(),
    );
    return ExamenPassage.fromJson(response.data);
  }

  Future<void> deleteExamen(String id) async {
    await _apiService.delete('${ApiConfig.examensEndpoint}/$id');
  }
}
