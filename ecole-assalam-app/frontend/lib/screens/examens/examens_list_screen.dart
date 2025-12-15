import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/examen_provider.dart';

class ExamensListScreen extends StatefulWidget {
  const ExamensListScreen({super.key});

  @override
  State<ExamensListScreen> createState() => _ExamensListScreenState();
}

class _ExamensListScreenState extends State<ExamensListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamenProvider>().loadExamens();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Examens de Passage'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ExamenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erreur: ${provider.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadExamens(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (provider.examens.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Aucun examen trouvé'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/examens/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un examen'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.examens.length,
            itemBuilder: (context, index) {
              final examen = provider.examens[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(examen.statut.name),
                    child: const Icon(Icons.assignment, color: Colors.white),
                  ),
                  title: Text(
                    examen.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${dateFormat.format(examen.dateExamen)}'),
                      Text('Inscription avant: ${dateFormat.format(examen.dateLimiteInscription)}'),
                      Text('Statut: ${_getStatusText(examen.statut.name)}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => context.go('/examens/${examen.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, examen.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/examens/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'PLANIFIE':
        return Colors.blue;
      case 'EN_COURS':
        return Colors.orange;
      case 'TERMINE':
        return Colors.green;
      case 'ANNULE':
        return Colors.red;
      default:
        return Colors.grey;
    }
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

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet examen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context.read<ExamenProvider>().deleteExamen(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Examen supprimé avec succès' : 'Erreur lors de la suppression',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
