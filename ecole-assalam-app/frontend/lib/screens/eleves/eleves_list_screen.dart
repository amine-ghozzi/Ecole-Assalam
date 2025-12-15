import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/eleve_provider.dart';

class ElevesListScreen extends StatefulWidget {
  const ElevesListScreen({super.key});

  @override
  State<ElevesListScreen> createState() => _ElevesListScreenState();
}

class _ElevesListScreenState extends State<ElevesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EleveProvider>().loadEleves();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Élèves'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<EleveProvider>(
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
                    onPressed: () => provider.loadEleves(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (provider.eleves.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Aucun élève trouvé'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/eleves/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un élève'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.eleves.length,
            itemBuilder: (context, index) {
              final eleve = provider.eleves[index];
              final dateFormat = DateFormat('dd/MM/yyyy');

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      eleve.prenom[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    eleve.nomComplet,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Né(e) le: ${dateFormat.format(eleve.dateNaissance)}'),
                      if (eleve.groupe != null)
                        Text('Groupe: ${eleve.groupe!.nom}'),
                      if (eleve.contactParent != null)
                        Text('Contact: ${eleve.contactParent}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => context.go('/eleves/${eleve.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, eleve.id),
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
        onPressed: () => context.go('/eleves/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet élève?'),
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
      final success = await context.read<EleveProvider>().deleteEleve(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Élève supprimé avec succès' : 'Erreur lors de la suppression',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
