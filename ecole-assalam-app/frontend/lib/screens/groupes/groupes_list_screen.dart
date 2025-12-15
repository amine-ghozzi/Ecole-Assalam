import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/groupe_provider.dart';

class GroupesListScreen extends StatefulWidget {
  const GroupesListScreen({super.key});

  @override
  State<GroupesListScreen> createState() => _GroupesListScreenState();
}

class _GroupesListScreenState extends State<GroupesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupeProvider>().loadGroupes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groupes / Classes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GroupeProvider>(
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
                    onPressed: () => provider.loadGroupes(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (provider.groupes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.groups, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Aucun groupe trouvé'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/groupes/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un groupe'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.groupes.length,
            itemBuilder: (context, index) {
              final groupe = provider.groupes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.groups),
                  ),
                  title: Text(
                    groupe.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (groupe.niveau != null) Text('Niveau: ${groupe.niveau!.nom}'),
                      Text('${groupe.eleveCount ?? 0}/${groupe.capaciteMax} élèves'),
                      Text('Année: ${groupe.anneeScolaire}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => context.go('/groupes/${groupe.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, groupe.id),
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
        onPressed: () => context.go('/groupes/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce groupe?'),
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
      final success = await context.read<GroupeProvider>().deleteGroupe(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Groupe supprimé avec succès' : 'Erreur lors de la suppression',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
