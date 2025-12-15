import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/eleve.dart';
import '../../models/groupe.dart';
import '../../providers/eleve_provider.dart';
import '../../providers/groupe_provider.dart';

class EleveFormScreen extends StatefulWidget {
  final String? eleveId;

  const EleveFormScreen({super.key, this.eleveId});

  @override
  State<EleveFormScreen> createState() => _EleveFormScreenState();
}

class _EleveFormScreenState extends State<EleveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _contactController = TextEditingController();
  final _adresseController = TextEditingController();

  DateTime? _dateNaissance;
  String? _selectedGroupeId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupeProvider>().loadGroupes();
      if (widget.eleveId != null) {
        _loadEleve();
      }
    });
  }

  void _loadEleve() {
    final provider = context.read<EleveProvider>();
    final eleve = provider.eleves.firstWhere((e) => e.id == widget.eleveId);

    _nomController.text = eleve.nom;
    _prenomController.text = eleve.prenom;
    _contactController.text = eleve.contactParent ?? '';
    _adresseController.text = eleve.adresse ?? '';
    _dateNaissance = eleve.dateNaissance;
    _selectedGroupeId = eleve.groupeId;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _contactController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateNaissance ?? DateTime(2015),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateNaissance = picked);
    }
  }

  Future<void> _saveEleve() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date de naissance'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final eleve = Eleve(
      id: widget.eleveId ?? '',
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      dateNaissance: _dateNaissance!,
      groupeId: _selectedGroupeId,
      contactParent: _contactController.text.trim().isEmpty
          ? null
          : _contactController.text.trim(),
      adresse: _adresseController.text.trim().isEmpty
          ? null
          : _adresseController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<EleveProvider>();
    final success = widget.eleveId == null
        ? await provider.createEleve(eleve)
        : await provider.updateEleve(widget.eleveId!, eleve);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.eleveId == null
                  ? 'Élève créé avec succès'
                  : 'Élève mis à jour avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/eleves');
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
          widget.eleveId == null ? 'Nouvel Élève' : 'Modifier Élève',
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
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le prénom est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _dateNaissance != null
                        ? '${_dateNaissance!.day}/${_dateNaissance!.month}/${_dateNaissance!.year}'
                        : 'Sélectionner une date',
                    style: TextStyle(
                      color: _dateNaissance != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<GroupeProvider>(
                builder: (context, groupeProvider, child) {
                  return DropdownButtonFormField<String>(
                    value: _selectedGroupeId,
                    decoration: const InputDecoration(
                      labelText: 'Groupe (optionnel)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.groups),
                    ),
                    items: groupeProvider.groupes.map((Groupe groupe) {
                      return DropdownMenuItem<String>(
                        value: groupe.id,
                        child: Text(groupe.nom),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedGroupeId = value);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact parent (optionnel)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(
                  labelText: 'Adresse (optionnel)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveEleve,
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
                        widget.eleveId == null ? 'Créer' : 'Mettre à jour',
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
