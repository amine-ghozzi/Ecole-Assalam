import 'package:flutter/foundation.dart';
import '../models/examen_passage.dart';
import '../services/examen_service.dart';

class ExamenProvider extends ChangeNotifier {
  final ExamenService _service = ExamenService();

  List<ExamenPassage> _examens = [];
  bool _isLoading = false;
  String? _error;

  List<ExamenPassage> get examens => _examens;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadExamens({String? statut, String? niveauSourceId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _examens = await _service.getAllExamens(
        statut: statut,
        niveauSourceId: niveauSourceId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createExamen(ExamenPassage examen) async {
    _error = null;
    try {
      final newExamen = await _service.createExamen(examen);
      _examens.add(newExamen);
      _examens.sort((a, b) => a.dateExamen.compareTo(b.dateExamen));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateExamen(String id, ExamenPassage examen) async {
    _error = null;
    try {
      final updatedExamen = await _service.updateExamen(id, examen);
      final index = _examens.indexWhere((e) => e.id == id);
      if (index != -1) {
        _examens[index] = updatedExamen;
        _examens.sort((a, b) => a.dateExamen.compareTo(b.dateExamen));
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExamen(String id) async {
    _error = null;
    try {
      await _service.deleteExamen(id);
      _examens.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
