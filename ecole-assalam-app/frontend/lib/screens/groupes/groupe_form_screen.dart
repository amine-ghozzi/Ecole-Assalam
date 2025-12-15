import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/groupe.dart';
import '../../models/niveau.dart';
import '../../providers/groupe_provider.dart';
import '../../providers/niveau_provider.dart';

class GroupeFormScreen extends StatefulWidget {
  final String? groupeId;

  const GroupeFormScreen({super.key, this.groupeId});

  @override
  State<GroupeFormScreen> createState() => _GroupeFormScreenState();
}

class _GroupeFormScreenState extends State<GroupeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _capaciteMaxController = TextEditingController(text: '30');
  final _anneeScolaireController = TextEditingController(
    text: '${DateTime.now().year}-${DateTime.now().year + 1}',
  );

  String? _selectedNiveauId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NiveauProvider>().loadNiveaux();
      if (widget.groupeId != null) {
        _loadGroupe();
      }
    });
  }

  void _loadGroupe() {
    final provider = context.read<GroupeProvider>();
    final groupe = provider.groupes.firstWhere((g) => g.id == widget.groupeId);

    _nomController.text = groupe.nom;
    _capaciteMaxController.text = groupe.capaciteMax.toString();
    _anneeScolaireController.text = groupe.anneeScolaire;
    _selectedNiveauId = groupe.niveauId;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _capaciteMaxController.dispose();
    _anneeScolaireController.dispose();
    super.dispose();
  }

  Future<void> _saveGroupe() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedNiveauId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un niveau'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final groupe = Groupe(
      id: widget.groupeId ?? '',
      nom: _nomController.text.trim(),
      niveauId: _selectedNiveauId!,
      capaciteMax: int.parse(_capaciteMaxController.text.trim()),
      anneeScolaire: _anneeScolaireController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<GroupeProvider>();
    final success = widget.groupeId == null
        ? await provider.createGroupe(groupe)
        : await provider.updateGroupe(widget.groupeId!, groupe);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.groupeId == null
                  ? 'Groupe créé avec succès'
                  : 'Groupe mis à jour avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/groupes');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Une erreur est survenue'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupeId == null ? 'Nouveau Groupe' : 'Modifier Groupe',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du groupe *',
                  hintText: 'Ex: CP-A, CE1-B...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.groups),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<NiveauProvider>(
                builder: (context, niveauProvider, child) {
                  return DropdownButtonFormField<String>(
                    value: _selectedNiveauId,
                    decoration: const InputDecoration(
                      labelText: 'Niveau *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: niveauProvider.niveaux.map((Niveau niveau) {
                      return DropdownMenuItem<String>(
                        value: niveau.id,
                        child: Text(niveau.nom),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedNiveauId = value);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner un niveau';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capaciteMaxController,
                decoration: const InputDecoration(
                  labelText: 'Capacité maximale *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La capacité est obligatoire';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anneeScolaireController,
                decoration: const InputDecoration(
                  labelText: 'Année scolaire *',
                  hintText: '2024-2025',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'L\'année scolaire est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveGroupe,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.groupeId == null ? 'Créer' : 'Mettre à jour',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
