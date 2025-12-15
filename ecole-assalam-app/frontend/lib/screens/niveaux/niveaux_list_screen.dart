import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/niveau_provider.dart';

class NiveauxListScreen extends StatefulWidget {
  const NiveauxListScreen({super.key});

  @override
  State<NiveauxListScreen> createState() => _NiveauxListScreenState();
}

class _NiveauxListScreenState extends State<NiveauxListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NiveauProvider>().loadNiveaux();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Niveaux Scolaires'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<NiveauProvider>(
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
                  Text(
                    'Erreur: ${provider.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadNiveaux(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (provider.niveaux.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Aucun niveau trouvé'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/niveaux/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un niveau'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.niveaux.length,
            itemBuilder: (context, index) {
              final niveau = provider.niveaux[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      niveau.ordre.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    niveau.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: niveau.description != null
                      ? Text(niveau.description!)
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => context.go('/niveaux/${niveau.id}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, niveau.id),
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
        onPressed: () => context.go('/niveaux/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce niveau?'),
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
      final success = await context.read<NiveauProvider>().deleteNiveau(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Niveau supprimé avec succès' : 'Erreur lors de la suppression',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
