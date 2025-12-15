import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/niveau.dart';
import '../../providers/niveau_provider.dart';

class NiveauFormScreen extends StatefulWidget {
  final String? niveauId;

  const NiveauFormScreen({super.key, this.niveauId});

  @override
  State<NiveauFormScreen> createState() => _NiveauFormScreenState();
}

class _NiveauFormScreenState extends State<NiveauFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ordreController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.niveauId != null) {
      _loadNiveau();
    }
  }

  void _loadNiveau() {
    final provider = context.read<NiveauProvider>();
    final niveau = provider.niveaux.firstWhere((n) => n.id == widget.niveauId);

    _nomController.text = niveau.nom;
    _descriptionController.text = niveau.description ?? '';
    _ordreController.text = niveau.ordre.toString();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _ordreController.dispose();
    super.dispose();
  }

  Future<void> _saveNiveau() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final niveau = Niveau(
      id: widget.niveauId ?? '',
      nom: _nomController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      ordre: int.parse(_ordreController.text.trim()),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<NiveauProvider>();
    final success = widget.niveauId == null
        ? await provider.createNiveau(niveau)
        : await provider.updateNiveau(widget.niveauId!, niveau);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.niveauId == null
                  ? 'Niveau créé avec succès'
                  : 'Niveau mis à jour avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/niveaux');
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
          widget.niveauId == null ? 'Nouveau Niveau' : 'Modifier Niveau',
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
                  labelText: 'Nom du niveau *',
                  hintText: 'Ex: CP, CE1, CE2...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ordreController,
                decoration: const InputDecoration(
                  labelText: 'Ordre *',
                  hintText: '1, 2, 3...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'L\'ordre est obligatoire';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optionnel)',
                  hintText: 'Description du niveau',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveNiveau,
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
                        widget.niveauId == null ? 'Créer' : 'Mettre à jour',
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
