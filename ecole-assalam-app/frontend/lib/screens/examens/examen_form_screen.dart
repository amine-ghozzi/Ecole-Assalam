import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/examen_passage.dart';
import '../../models/niveau.dart';
import '../../providers/examen_provider.dart';
import '../../providers/niveau_provider.dart';

class ExamenFormScreen extends StatefulWidget {
  final String? examenId;

  const ExamenFormScreen({super.key, this.examenId});

  @override
  State<ExamenFormScreen> createState() => _ExamenFormScreenState();
}

class _ExamenFormScreenState extends State<ExamenFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _niveauSourceId;
  String? _niveauDestinationId;
  DateTime? _dateExamen;
  DateTime? _dateLimiteInscription;
  StatutExamen _statut = StatutExamen.PLANIFIE;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NiveauProvider>().loadNiveaux();
      if (widget.examenId != null) {
        _loadExamen();
      }
    });
  }

  void _loadExamen() {
    final provider = context.read<ExamenProvider>();
    final examen = provider.examens.firstWhere((e) => e.id == widget.examenId);

    _niveauSourceId = examen.niveauSourceId;
    _niveauDestinationId = examen.niveauDestinationId;
    _dateExamen = examen.dateExamen;
    _dateLimiteInscription = examen.dateLimiteInscription;
    _statut = examen.statut;
    _descriptionController.text = examen.description ?? '';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isExamenDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isExamenDate
          ? (_dateExamen ?? DateTime.now())
          : (_dateLimiteInscription ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isExamenDate) {
          _dateExamen = picked;
        } else {
          _dateLimiteInscription = picked;
        }
      });
    }
  }

  Future<void> _saveExamen() async {
    if (!_formKey.currentState!.validate()) return;

    if (_niveauSourceId == null || _niveauDestinationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner les niveaux source et destination'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_dateExamen == null || _dateLimiteInscription == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner toutes les dates'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final examen = ExamenPassage(
      id: widget.examenId ?? '',
      niveauSourceId: _niveauSourceId!,
      niveauDestinationId: _niveauDestinationId!,
      dateExamen: _dateExamen!,
      dateLimiteInscription: _dateLimiteInscription!,
      statut: _statut,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<ExamenProvider>();
    final success = widget.examenId == null
        ? await provider.createExamen(examen)
        : await provider.updateExamen(widget.examenId!, examen);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.examenId == null
                  ? 'Examen créé avec succès'
                  : 'Examen mis à jour avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/examens');
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
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.examenId == null ? 'Nouvel Examen' : 'Modifier Examen',
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
              Consumer<NiveauProvider>(
                builder: (context, niveauProvider, child) {
                  return DropdownButtonFormField<String>(
                    value: _niveauSourceId,
                    decoration: const InputDecoration(
                      labelText: 'Niveau source *',
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
                      setState(() => _niveauSourceId = value);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<NiveauProvider>(
                builder: (context, niveauProvider, child) {
                  return DropdownButtonFormField<String>(
                    value: _niveauDestinationId,
                    decoration: const InputDecoration(
                      labelText: 'Niveau destination *',
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
                      setState(() => _niveauDestinationId = value);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date de l\'examen *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _dateExamen != null
                        ? dateFormat.format(_dateExamen!)
                        : 'Sélectionner une date',
                    style: TextStyle(
                      color: _dateExamen != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(false),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date limite d\'inscription *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                  child: Text(
                    _dateLimiteInscription != null
                        ? dateFormat.format(_dateLimiteInscription!)
                        : 'Sélectionner une date',
                    style: TextStyle(
                      color: _dateLimiteInscription != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<StatutExamen>(
                value: _statut,
                decoration: const InputDecoration(
                  labelText: 'Statut *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: StatutExamen.values.map((StatutExamen statut) {
                  return DropdownMenuItem<StatutExamen>(
                    value: statut,
                    child: Text(_getStatusText(statut.name)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _statut = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optionnel)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveExamen,
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
                        widget.examenId == null ? 'Créer' : 'Mettre à jour',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String statut) {
    switch (statut) {
      case 'PLANIFIE':
        return 'Planifié';
      case 'EN_COURS':
        return 'En cours';
      case 'TERMINE':
        return 'Terminé';
      case 'ANNULE':
        return 'Annulé';
      default:
        return statut;
    }
  }
}
