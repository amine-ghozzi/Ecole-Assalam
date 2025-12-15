import 'package:flutter/foundation.dart';
import '../models/niveau.dart';
import '../services/niveau_service.dart';

class NiveauProvider extends ChangeNotifier {
  final NiveauService _service = NiveauService();

  List<Niveau> _niveaux = [];
  bool _isLoading = false;
  String? _error;

  List<Niveau> get niveaux => _niveaux;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNiveaux() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _niveaux = await _service.getAllNiveaux();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createNiveau(Niveau niveau) async {
    _error = null;
    try {
      final newNiveau = await _service.createNiveau(niveau);
      _niveaux.add(newNiveau);
      _niveaux.sort((a, b) => a.ordre.compareTo(b.ordre));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateNiveau(String id, Niveau niveau) async {
    _error = null;
    try {
      final updatedNiveau = await _service.updateNiveau(id, niveau);
      final index = _niveaux.indexWhere((n) => n.id == id);
      if (index != -1) {
        _niveaux[index] = updatedNiveau;
        _niveaux.sort((a, b) => a.ordre.compareTo(b.ordre));
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteNiveau(String id) async {
    _error = null;
    try {
      await _service.deleteNiveau(id);
      _niveaux.removeWhere((n) => n.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
