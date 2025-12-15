import 'package:flutter/foundation.dart';
import '../models/groupe.dart';
import '../services/groupe_service.dart';

class GroupeProvider extends ChangeNotifier {
  final GroupeService _service = GroupeService();

  List<Groupe> _groupes = [];
  bool _isLoading = false;
  String? _error;

  List<Groupe> get groupes => _groupes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadGroupes({String? anneeScolaire, String? niveauId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _groupes = await _service.getAllGroupes(
        anneeScolaire: anneeScolaire,
        niveauId: niveauId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createGroupe(Groupe groupe) async {
    _error = null;
    try {
      final newGroupe = await _service.createGroupe(groupe);
      _groupes.add(newGroupe);
      _groupes.sort((a, b) => a.nom.compareTo(b.nom));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGroupe(String id, Groupe groupe) async {
    _error = null;
    try {
      final updatedGroupe = await _service.updateGroupe(id, groupe);
      final index = _groupes.indexWhere((g) => g.id == id);
      if (index != -1) {
        _groupes[index] = updatedGroupe;
        _groupes.sort((a, b) => a.nom.compareTo(b.nom));
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGroupe(String id) async {
    _error = null;
    try {
      await _service.deleteGroupe(id);
      _groupes.removeWhere((g) => g.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
