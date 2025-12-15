import 'package:flutter/foundation.dart';
import '../models/horaire.dart';
import '../services/horaire_service.dart';

class HoraireProvider extends ChangeNotifier {
  final HoraireService _service = HoraireService();

  List<Horaire> _horaires = [];
  bool _isLoading = false;
  String? _error;

  List<Horaire> get horaires => _horaires;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHoraires({String? groupeId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _horaires = await _service.getAllHoraires(groupeId: groupeId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createHoraire(Horaire horaire) async {
    _error = null;
    try {
      final newHoraire = await _service.createHoraire(horaire);
      _horaires.add(newHoraire);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateHoraire(String id, Horaire horaire) async {
    _error = null;
    try {
      final updatedHoraire = await _service.updateHoraire(id, horaire);
      final index = _horaires.indexWhere((h) => h.id == id);
      if (index != -1) {
        _horaires[index] = updatedHoraire;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteHoraire(String id) async {
    _error = null;
    try {
      await _service.deleteHoraire(id);
      _horaires.removeWhere((h) => h.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
