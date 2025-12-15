import 'package:flutter/foundation.dart';
import '../models/eleve.dart';
import '../services/eleve_service.dart';

class EleveProvider extends ChangeNotifier {
  final EleveService _service = EleveService();

  List<Eleve> _eleves = [];
  bool _isLoading = false;
  String? _error;

  List<Eleve> get eleves => _eleves;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEleves({String? groupeId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _eleves = await _service.getAllEleves(groupeId: groupeId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEleve(Eleve eleve) async {
    _error = null;
    try {
      final newEleve = await _service.createEleve(eleve);
      _eleves.add(newEleve);
      _eleves.sort((a, b) {
        final nomCmp = a.nom.compareTo(b.nom);
        return nomCmp != 0 ? nomCmp : a.prenom.compareTo(b.prenom);
      });
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEleve(String id, Eleve eleve) async {
    _error = null;
    try {
      final updatedEleve = await _service.updateEleve(id, eleve);
      final index = _eleves.indexWhere((e) => e.id == id);
      if (index != -1) {
        _eleves[index] = updatedEleve;
        _eleves.sort((a, b) {
          final nomCmp = a.nom.compareTo(b.nom);
          return nomCmp != 0 ? nomCmp : a.prenom.compareTo(b.prenom);
        });
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEleve(String id) async {
    _error = null;
    try {
      await _service.deleteEleve(id);
      _eleves.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
